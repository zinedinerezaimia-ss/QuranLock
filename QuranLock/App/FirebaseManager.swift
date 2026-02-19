import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import AuthenticationServices
import CryptoKit

// MARK: - Firestore Post Model
struct FirebasePost: Identifiable {
    var id: String
    var authorId: String
    var authorName: String
    var content: String
    var type: String
    var surahName: String?
    var timestamp: Date
    var likes: Int
    var likedBy: [String]
    var replyCount: Int

    init(id: String, data: [String: Any]) {
        self.id = id
        self.authorId = data["authorId"] as? String ?? ""
        self.authorName = data["authorName"] as? String ?? "Anonyme"
        self.content = data["content"] as? String ?? ""
        self.type = data["type"] as? String ?? "discussion"
        self.surahName = data["surahName"] as? String
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
        self.likes = data["likes"] as? Int ?? 0
        self.likedBy = data["likedBy"] as? [String] ?? []
        self.replyCount = data["replyCount"] as? Int ?? 0
    }
}

struct FirebaseReply: Identifiable {
    var id: String
    var authorId: String
    var authorName: String
    var content: String
    var timestamp: Date

    init(id: String, data: [String: Any]) {
        self.id = id
        self.authorId = data["authorId"] as? String ?? ""
        self.authorName = data["authorName"] as? String ?? "Anonyme"
        self.content = data["content"] as? String ?? ""
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
    }
}

// MARK: - Firebase Manager (Singleton)
class FirebaseManager: NSObject, ObservableObject {
    static let shared = FirebaseManager()

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var currentNonce: String?

    @Published var posts: [FirebasePost] = []
    @Published var isLoading = false
    @Published var currentUser: User? = nil
    @Published var currentUserName: String = ""
    @Published var isSignedIn = false
    @Published var authError: String? = nil

    override init() {
        super.init()
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isSignedIn = user != nil
                if let uid = user?.uid {
                    self?.fetchUserProfile(uid: uid)
                }
            }
        }
    }

    // MARK: - Sign In with Apple

    func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func signOut() {
        listener?.remove()
        try? Auth.auth().signOut()
        DispatchQueue.main.async {
            self.isSignedIn = false
            self.currentUser = nil
            self.currentUserName = ""
            self.posts = []
        }
    }

    // MARK: - Fetch Posts (real-time listener)

    func listenToPosts(filter: String = "all") {
        listener?.remove()
        isLoading = true

        var query: Query = db.collection("posts")
            .order(by: "timestamp", descending: true)
            .limit(to: 50)

        if filter != "all" {
            query = db.collection("posts")
                .whereField("type", isEqualTo: filter)
                .order(by: "timestamp", descending: true)
                .limit(to: 50)
        }

        listener = query.addSnapshotListener { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print("Firestore error: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                self?.posts = documents.map {
                    FirebasePost(id: $0.documentID, data: $0.data())
                }
            }
        }
    }

    // MARK: - Create Post

    func createPost(content: String, type: String, surahName: String?, completion: @escaping (Bool) -> Void) {
        guard let uid = currentUser?.uid else { completion(false); return }

        var data: [String: Any] = [
            "authorId": uid,
            "authorName": currentUserName.isEmpty ? "Anonyme" : currentUserName,
            "content": content,
            "type": type,
            "timestamp": FieldValue.serverTimestamp(),
            "likes": 0,
            "likedBy": [],
            "replyCount": 0
        ]
        if let surah = surahName, !surah.isEmpty {
            data["surahName"] = surah
        }

        db.collection("posts").addDocument(data: data) { error in
            DispatchQueue.main.async { completion(error == nil) }
        }
    }

    // MARK: - Like / Unlike Post

    func toggleLike(postId: String) {
        guard let uid = currentUser?.uid else { return }
        let ref = db.collection("posts").document(postId)

        db.runTransaction({ transaction, _ -> Any? in
            guard let snap = try? transaction.getDocument(ref),
                  var likedBy = snap.data()?["likedBy"] as? [String],
                  let likes = snap.data()?["likes"] as? Int else { return nil }

            if likedBy.contains(uid) {
                likedBy.removeAll { $0 == uid }
                transaction.updateData(["likes": max(0, likes - 1), "likedBy": likedBy], forDocument: ref)
            } else {
                likedBy.append(uid)
                transaction.updateData(["likes": likes + 1, "likedBy": likedBy], forDocument: ref)
            }
            return nil
        }, completion: { _, _ in })
    }

    func isLikedByMe(_ post: FirebasePost) -> Bool {
        guard let uid = currentUser?.uid else { return false }
        return post.likedBy.contains(uid)
    }

    // MARK: - Replies

    func fetchReplies(postId: String, completion: @escaping ([FirebaseReply]) -> Void) {
        db.collection("posts").document(postId).collection("replies")
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, _ in
                let replies = snapshot?.documents.map {
                    FirebaseReply(id: $0.documentID, data: $0.data())
                } ?? []
                DispatchQueue.main.async { completion(replies) }
            }
    }

    func addReply(postId: String, content: String, completion: @escaping (Bool) -> Void) {
        guard let uid = currentUser?.uid else { completion(false); return }

        let replyData: [String: Any] = [
            "authorId": uid,
            "authorName": currentUserName.isEmpty ? "Anonyme" : currentUserName,
            "content": content,
            "timestamp": FieldValue.serverTimestamp()
        ]

        let batch = db.batch()
        let replyRef = db.collection("posts").document(postId).collection("replies").document()
        batch.setData(replyData, forDocument: replyRef)
        let postRef = db.collection("posts").document(postId)
        batch.updateData(["replyCount": FieldValue.increment(Int64(1))], forDocument: postRef)

        batch.commit { error in
            DispatchQueue.main.async { completion(error == nil) }
        }
    }

    // MARK: - User Profile

    func saveUserName(_ name: String) {
        guard let uid = currentUser?.uid else { return }
        currentUserName = name
        db.collection("users").document(uid).setData(
            ["name": name, "updatedAt": FieldValue.serverTimestamp()],
            merge: true
        )
    }

    private func fetchUserProfile(uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] snap, _ in
            if let name = snap?.data()?["name"] as? String {
                DispatchQueue.main.async { self?.currentUserName = name }
            }
        }
    }

    // MARK: - Apple Sign In Helpers

    private func randomNonceString(length: Int = 32) -> String {
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length
        while remaining > 0 {
            (0..<16).map { _ -> UInt8 in
                var b: UInt8 = 0
                SecRandomCopyBytes(kSecRandomDefault, 1, &b)
                return b
            }.forEach { b in
                guard remaining > 0 else { return }
                if b < charset.count { result.append(charset[Int(b)]); remaining -= 1 }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        SHA256.hash(data: Data(input.utf8)).compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Apple Auth Delegate
extension FirebaseManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let cred = authorization.credential as? ASAuthorizationAppleIDCredential,
            let nonce = currentNonce,
            let tokenData = cred.identityToken,
            let token = String(data: tokenData, encoding: .utf8)
        else {
            authError = "Impossible de récupérer les identifiants Apple."
            return
        }

        let firebaseCred = OAuthProvider.appleCredential(withIDToken: token, rawNonce: nonce, fullName: cred.fullName)

        Auth.auth().signIn(with: firebaseCred) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async { self?.authError = error.localizedDescription }
                return
            }
            guard let uid = result?.user.uid else { return }
            let fullName = [cred.fullName?.givenName, cred.fullName?.familyName]
                .compactMap { $0 }.joined(separator: " ")
            if !fullName.isEmpty {
                DispatchQueue.main.async {
                    self?.currentUserName = fullName
                    self?.saveUserName(fullName)
                }
            } else {
                self?.fetchUserProfile(uid: uid)
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        DispatchQueue.main.async { self.authError = error.localizedDescription }
    }
}

extension FirebaseManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}
