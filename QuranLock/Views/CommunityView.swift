import SwiftUI

// MARK: - Community View
struct CommunityView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var firebase = FirebaseManager.shared
    @Environment(\.dismiss) var dismiss

    @State private var selectedFilter: String = "all"
    @State private var showNewPost = false
    @State private var showNamePicker = false

    var filters: [(key: String, label: String)] {
        [
            ("all", L.lang == .arabic ? "الكل 🌍" : "Tout 🌍"),
            ("reflection", L.reflections),
            ("question", L.questions),
            ("discussion", L.discussions),
            ("recitation", L.recitations)
        ]
    }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()

                if !firebase.isSignedIn {
                    signInPrompt
                } else {
                    mainFeed
                }
            }
            .navigationTitle("🤝 \(L.community)")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
            .sheet(isPresented: $showNewPost) {
                NewPostView(firebase: firebase)
                    .environmentObject(appState)
            }
            .sheet(isPresented: $showNamePicker) {
                NamePickerView(firebase: firebase)
            }
            .onAppear {
                if firebase.isSignedIn {
                    firebase.listenToPosts(filter: selectedFilter)
                }
            }
        }
    }

    // MARK: - Sign In Prompt
    var signInPrompt: some View {
        VStack(spacing: 28) {
            Spacer()
            Text("🤝").font(.system(size: 72))

            VStack(spacing: 8) {
                Text(L.joinCommunity)
                    .font(.title2.bold()).foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text(L.communityDesc)
                    .font(.subheadline).foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    featureTag(L.reflections)
                    featureTag(L.questions)
                }
                HStack(spacing: 16) {
                    featureTag(L.discussions)
                    featureTag(L.recitations)
                }
            }

            // Apple Sign In Button
            Button(action: { firebase.signInWithApple() }) {
                HStack(spacing: 10) {
                    Image(systemName: "applelogo").font(.headline)
                    Text(L.continueWithApple).font(.headline)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(14)
                .padding(.horizontal, 32)
            }

            if let error = firebase.authError {
                VStack(spacing: 6) {
                    Text(error)
                        .font(.caption).foregroundColor(.red)
                        .padding(.horizontal)

                    // Help text for error 1000
                    if error.contains("1000") {
                        Text("Assure-toi que 'Sign in with Apple' est activé dans les capabilities Xcode et dans l'Apple Developer Portal.")
                            .font(.caption2).foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                }
            }

            Spacer()
        }
    }

    func featureTag(_ label: String) -> some View {
        Text(label)
            .font(.caption.bold())
            .foregroundColor(Theme.gold)
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(Theme.gold.opacity(0.1))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
    }

    // MARK: - Main Feed
    var mainFeed: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 16) {
                    // User bar
                    HStack {
                        Circle()
                            .fill(Theme.accent)
                            .frame(width: 34, height: 34)
                            .overlay(
                                Text(String(firebase.currentUserName.prefix(1)).uppercased())
                                    .foregroundColor(.white).font(.caption.bold())
                            )
                        Text(firebase.currentUserName.isEmpty ? L.anonymous : firebase.currentUserName)
                            .font(.subheadline.bold()).foregroundColor(Theme.gold)
                        Spacer()
                        Button(L.modify) { showNamePicker = true }
                            .font(.caption).foregroundColor(Theme.textSecondary)
                        Button(L.disconnect) { firebase.signOut() }
                            .font(.caption).foregroundColor(Theme.danger)
                    }
                    .padding(.horizontal, 16)

                    // Filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(filters, id: \.key) { filter in
                                Button(action: {
                                    selectedFilter = filter.key
                                    firebase.listenToPosts(filter: filter.key)
                                }) {
                                    Text(filter.label)
                                        .font(.caption.bold())
                                        .foregroundColor(selectedFilter == filter.key ? .black : .white)
                                        .padding(.horizontal, 14).padding(.vertical, 8)
                                        .background(selectedFilter == filter.key ? Theme.gold : Theme.secondaryBg)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // Posts
                    if firebase.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.gold))
                            .padding(.top, 60)
                    } else if firebase.posts.isEmpty {
                        VStack(spacing: 16) {
                            Text("🕊️").font(.system(size: 60))
                            Text(L.noPosts)
                                .font(.headline).foregroundColor(Theme.textSecondary)
                            Text(L.beFirst)
                                .font(.subheadline).foregroundColor(Theme.textSecondary.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        ForEach(firebase.posts) { post in
                            PostCard(post: post, firebase: firebase)
                        }
                    }
                }
                .padding(.bottom, 90)
            }

            // FAB
            Button(action: { showNewPost = true }) {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                    .frame(width: 58, height: 58)
                    .background(Theme.gold)
                    .clipShape(Circle())
                    .shadow(color: Theme.gold.opacity(0.4), radius: 8)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Post Card
struct PostCard: View {
    let post: FirebasePost
    let firebase: FirebaseManager
    @State private var showReplies = false
    @State private var replies: [FirebaseReply] = []
    @State private var replyText = ""
    @State private var isLoadingReplies = false
    @State private var isSendingReply = false

    var timeAgo: String {
        let seconds = Date().timeIntervalSince(post.timestamp)
        if seconds < 60 { return "À l'instant" }
        if seconds < 3600 { return "Il y a \(Int(seconds/60)) min" }
        if seconds < 86400 { return "Il y a \(Int(seconds/3600))h" }
        return "Il y a \(Int(seconds/86400))j"
    }

    var typeIcon: String {
        switch post.type {
        case "reflection": return "💭"
        case "question": return "❓"
        case "discussion": return "💬"
        case "recitation": return "🎙️"
        default: return "💬"
        }
    }

    var isLiked: Bool { firebase.isLikedByMe(post) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Circle().fill(Theme.accent).frame(width: 40, height: 40)
                    .overlay(Text(String(post.authorName.prefix(1)).uppercased()).foregroundColor(.white).font(.headline))
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName).font(.subheadline.bold()).foregroundColor(.white)
                    Text(timeAgo).font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Text(typeIcon).font(.title3)
            }

            Text(post.content).font(.subheadline).foregroundColor(.white).fixedSize(horizontal: false, vertical: true)

            if let surah = post.surahName {
                HStack(spacing: 4) {
                    Image(systemName: "book.fill").font(.caption)
                    Text(surah).font(.caption)
                }
                .foregroundColor(Theme.gold)
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(Theme.gold.opacity(0.12))
                .cornerRadius(8)
            }

            Divider().background(Theme.cardBorder)

            HStack(spacing: 24) {
                Button(action: { firebase.toggleLike(postId: post.id) }) {
                    HStack(spacing: 5) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                        Text("\(post.likes)")
                    }
                    .font(.subheadline)
                    .foregroundColor(isLiked ? .red : Theme.textSecondary)
                }

                Button(action: {
                    withAnimation(.spring()) {
                        showReplies.toggle()
                        if showReplies && replies.isEmpty {
                            isLoadingReplies = true
                            firebase.fetchReplies(postId: post.id) { fetched in
                                replies = fetched; isLoadingReplies = false
                            }
                        }
                    }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: showReplies ? "bubble.right.fill" : "bubble.right")
                        Text("\(post.replyCount)")
                    }
                    .font(.subheadline)
                    .foregroundColor(showReplies ? Theme.gold : Theme.textSecondary)
                }

                // Share post
                Button(action: {
                    let shareText = "\(post.authorName): \(post.content)\n\n— Communauté Iqra 🤲"
                    AppState.shareText(shareText)
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.subheadline).foregroundColor(Theme.textSecondary)
                }

                Spacer()
            }

            if showReplies {
                VStack(alignment: .leading, spacing: 10) {
                    if isLoadingReplies {
                        HStack { Spacer(); ProgressView().tint(Theme.gold); Spacer() }
                    }
                    ForEach(replies) { reply in
                        HStack(alignment: .top, spacing: 8) {
                            Circle().fill(Theme.secondaryBg).frame(width: 28, height: 28)
                                .overlay(Text(String(reply.authorName.prefix(1)).uppercased()).foregroundColor(.white).font(.caption2))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(reply.authorName).font(.caption.bold()).foregroundColor(.white)
                                Text(reply.content).font(.caption).foregroundColor(Theme.textSecondary)
                            }
                        }
                    }
                    HStack(spacing: 8) {
                        TextField(L.reply, text: $replyText)
                            .font(.caption).foregroundColor(.white)
                            .padding(10).background(Theme.secondaryBg).cornerRadius(10)
                        Button(action: sendReply) {
                            if isSendingReply { ProgressView().tint(Theme.gold).frame(width: 24, height: 24) }
                            else { Image(systemName: "paperplane.fill").foregroundColor(Theme.gold) }
                        }
                        .disabled(replyText.trimmingCharacters(in: .whitespaces).isEmpty || isSendingReply)
                    }
                }
                .padding(.leading, 12)
            }
        }
        .padding(16)
        .background(Theme.cardBg)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.cardBorder, lineWidth: 1))
        .padding(.horizontal, 16)
    }

    func sendReply() {
        let text = replyText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        isSendingReply = true; replyText = ""
        firebase.addReply(postId: post.id, content: text) { success in
            isSendingReply = false
            if success { firebase.fetchReplies(postId: post.id) { fetched in replies = fetched } }
        }
    }
}

// MARK: - New Post View
struct NewPostView: View {
    let firebase: FirebaseManager
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var content = ""
    @State private var selectedType = "reflection"
    @State private var surahRef = ""
    @State private var isPosting = false
    @State private var errorMsg: String? = nil

    let types: [(key: String, icon: String, label: String)] = [
        ("reflection", "💭", "Réflexion"),
        ("question", "❓", "Question"),
        ("discussion", "💬", "Discussion"),
        ("recitation", "🎙️", "Récitation")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(L.postType).font(.headline).foregroundColor(Theme.gold)
                            HStack(spacing: 8) {
                                ForEach(types, id: \.key) { t in
                                    Button(action: { selectedType = t.key }) {
                                        VStack(spacing: 4) {
                                            Text(t.icon).font(.title2)
                                            Text(t.label).font(.caption2)
                                        }
                                        .foregroundColor(selectedType == t.key ? .black : .white)
                                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                                        .background(selectedType == t.key ? Theme.gold : Theme.secondaryBg)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        .cardStyle()

                        VStack(alignment: .leading, spacing: 8) {
                            Text(L.yourMessage).font(.headline).foregroundColor(Theme.gold)
                            TextEditor(text: $content)
                                .frame(minHeight: 120).padding(8)
                                .background(Theme.secondaryBg).cornerRadius(12)
                                .foregroundColor(.white).scrollContentBackground(.hidden)
                        }
                        .cardStyle()

                        VStack(alignment: .leading, spacing: 8) {
                            Text(L.surahRef).font(.headline).foregroundColor(Theme.gold)
                            TextField("Ex: Al-Fatiha, Al-Kahf...", text: $surahRef)
                                .foregroundColor(.white).padding(12)
                                .background(Theme.secondaryBg).cornerRadius(10)
                        }
                        .cardStyle()

                        if let err = errorMsg {
                            Text(err).foregroundColor(.red).font(.caption)
                        }

                        Button(action: publishPost) {
                            HStack {
                                if isPosting { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .black)) }
                                Text(isPosting ? L.publishing : L.publish)
                            }
                            .goldButton()
                        }
                        .disabled(content.trimmingCharacters(in: .whitespaces).isEmpty || isPosting)
                        .opacity(content.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                    }
                    .padding()
                }
            }
            .navigationTitle(L.newPost)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L.cancel) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }

    func publishPost() {
        let trimmed = content.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        isPosting = true; errorMsg = nil
        firebase.createPost(content: trimmed, type: selectedType, surahName: surahRef.isEmpty ? nil : surahRef) { success in
            isPosting = false
            if success { appState.addHasanat(3); dismiss() }
            else { errorMsg = L.postError }
        }
    }
}

// MARK: - Name Picker
struct NamePickerView: View {
    let firebase: FirebaseManager
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                VStack(spacing: 24) {
                    Text("👤").font(.system(size: 60))
                    Text(L.yourPseudo).font(.headline).foregroundColor(.white)
                    TextField(L.pseudoPlaceholder, text: $name)
                        .foregroundColor(.white).padding()
                        .background(Theme.secondaryBg).cornerRadius(12).padding(.horizontal)
                    Button(action: {
                        if !name.trimmingCharacters(in: .whitespaces).isEmpty {
                            firebase.saveUserName(name.trimmingCharacters(in: .whitespaces))
                            dismiss()
                        }
                    }) { Text(L.save).goldButton() }
                    .padding(.horizontal)
                    Spacer()
                }
                .padding(.top, 40)
            }
            .navigationTitle(L.myProfile)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L.cancel) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
            .onAppear { name = firebase.currentUserName }
        }
    }
}
