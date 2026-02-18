import SwiftUI

struct CommunityPost: Identifiable, Codable {
    let id: String
    let authorName: String
    let content: String
    let type: PostType
    let surahName: String?
    let timestamp: Date
    var likes: Int
    var replies: [CommunityReply]
    
    enum PostType: String, Codable {
        case reflection // Partage de compréhension d'une sourate
        case question   // Question posée à la communauté
        case discussion // Discussion/débat
        case recitation // Partage de récitation
    }
}

struct CommunityReply: Identifiable, Codable {
    let id: String
    let authorName: String
    let content: String
    let timestamp: Date
    var likes: Int
}

class CommunityManager: ObservableObject {
    @Published var posts: [CommunityPost] = []
    @Published var myPosts: [CommunityPost] = []
    
    init() {
        loadSamplePosts()
    }
    
    func loadSamplePosts() {
        posts = [
            CommunityPost(
                id: "1",
                authorName: "Ahmed",
                content: "Après avoir lu Sourate Al-Kahf cette semaine, j'ai été frappé par l'histoire des gens de la caverne. Elle nous enseigne que la foi sincère est protégée par Allah, même dans les moments les plus difficiles. Les jeunes ont tout quitté pour préserver leur foi. Quel courage ! 🤲",
                type: .reflection,
                surahName: "Al-Kahf",
                timestamp: Date().addingTimeInterval(-3600),
                likes: 24,
                replies: [
                    CommunityReply(id: "r1", authorName: "Fatima", content: "MashaAllah, j'ai eu la même réflexion ! L'histoire de Dhul-Qarnayn m'a aussi beaucoup inspiré.", timestamp: Date().addingTimeInterval(-1800), likes: 5),
                    CommunityReply(id: "r2", authorName: "Omar", content: "Baraka Allahou fik pour ce partage frère. C'est vrai que cette sourate est pleine de leçons.", timestamp: Date().addingTimeInterval(-900), likes: 3)
                ]
            ),
            CommunityPost(
                id: "2",
                authorName: "Khadija",
                content: "Salam alaykoum, j'ai une question sur le verset 255 de Sourate Al-Baqara (Ayat Al-Kursi). Est-ce qu'il y a un moment spécifique recommandé pour le réciter en dehors des 5 prières ?",
                type: .question,
                surahName: "Al-Baqara",
                timestamp: Date().addingTimeInterval(-7200),
                likes: 15,
                replies: [
                    CommunityReply(id: "r3", authorName: "Youssef", content: "Wa alaykoum salam ! Oui, il est recommandé de le réciter avant de dormir, après chaque prière obligatoire, et le matin/soir dans les adhkar.", timestamp: Date().addingTimeInterval(-5400), likes: 12)
                ]
            ),
            CommunityPost(
                id: "3",
                authorName: "Bilal",
                content: "Est-ce que quelqu'un peut m'expliquer la différence entre Sabr (patience) et Shukr (gratitude) dans le Coran ? Je vois les deux concepts souvent liés mais j'aimerais mieux comprendre.",
                type: .discussion,
                surahName: nil,
                timestamp: Date().addingTimeInterval(-14400),
                likes: 31,
                replies: []
            ),
            CommunityPost(
                id: "4",
                authorName: "Amina",
                content: "Je viens de terminer la lecture complète de Sourate Yasin. Cette sourate m'a profondément touchée, surtout les versets sur la résurrection. Allah nous montre Sa puissance à travers la nature. SubhanAllah 🌿",
                type: .reflection,
                surahName: "Ya-Sin",
                timestamp: Date().addingTimeInterval(-28800),
                likes: 42,
                replies: []
            )
        ]
    }
    
    func addPost(authorName: String, content: String, type: CommunityPost.PostType, surahName: String?) {
        let post = CommunityPost(
            id: UUID().uuidString,
            authorName: authorName,
            content: content,
            type: type,
            surahName: surahName,
            timestamp: Date(),
            likes: 0,
            replies: []
        )
        posts.insert(post, at: 0)
    }
    
    func addReply(to postId: String, authorName: String, content: String) {
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            let reply = CommunityReply(
                id: UUID().uuidString,
                authorName: authorName,
                content: content,
                timestamp: Date(),
                likes: 0
            )
            posts[index].replies.append(reply)
        }
    }
    
    func likePost(_ postId: String) {
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].likes += 1
        }
    }
}
