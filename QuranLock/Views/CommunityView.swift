import SwiftUI

struct CommunityView: View {
    @EnvironmentObject var communityManager: CommunityManager
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showNewPost = false
    @State private var selectedFilter: PostType? = nil
    
    var filteredPosts: [CommunityPost] {
        if let filter = selectedFilter {
            return communityManager.posts.filter { $0.type == filter }
        }
        return communityManager.posts
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Filter tabs
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                FilterChip(title: "Tout", isSelected: selectedFilter == nil) {
                                    selectedFilter = nil
                                }
                                ForEach(PostType.allCases, id: \.rawValue) { type in
                                    FilterChip(title: type.label, isSelected: selectedFilter == type) {
                                        selectedFilter = type
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Posts
                        ForEach(filteredPosts) { post in
                            PostCard(post: post)
                        }
                        
                        if filteredPosts.isEmpty {
                            VStack(spacing: 12) {
                                Text("🕊️").font(.system(size: 50))
                                Text("Aucune publication")
                                    .font(.headline)
                                    .foregroundColor(Theme.textSecondary)
                                Text("Sois le premier à partager !")
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                        }
                    }
                    .padding(.bottom, 80)
                }
                
                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showNewPost = true }) {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .foregroundColor(.black)
                                .frame(width: 56, height: 56)
                                .background(Theme.gold)
                                .clipShape(Circle())
                                .shadow(color: Theme.gold.opacity(0.4), radius: 8)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("🤝 Communauté")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Theme.gold)
                }
            }
            .sheet(isPresented: $showNewPost) {
                NewPostView()
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(isSelected ? .black : .white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.gold : Theme.secondaryBg)
                .cornerRadius(20)
        }
    }
}

enum PostType: String, CaseIterable {
    case reflection = "Réflexion"
    case question = "Question"
    case discussion = "Discussion"
    case recitation = "Récitation"
    
    var label: String { rawValue }
    var icon: String {
        switch self {
        case .reflection: return "💭"
        case .question: return "❓"
        case .discussion: return "💬"
        case .recitation: return "🎙️"
        }
    }
}

struct PostCard: View {
    let post: CommunityPost
    @EnvironmentObject var communityManager: CommunityManager
    @State private var showReplies = false
    @State private var replyText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Circle()
                    .fill(Theme.accent)
                    .frame(width: 36, height: 36)
                    .overlay(Text(String(post.authorName.prefix(1))).foregroundColor(.white).font(.headline))
                
                VStack(alignment: .leading) {
                    Text(post.authorName)
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                    Text(post.timeAgo)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Text(post.type.icon)
                    .font(.title3)
            }
            
            // Content
            Text(post.content)
                .font(.subheadline)
                .foregroundColor(.white)
            
            // Surah reference
            if let surah = post.surahReference {
                HStack {
                    Image(systemName: "book.fill")
                    Text(surah)
                }
                .font(.caption)
                .foregroundColor(Theme.gold)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Theme.gold.opacity(0.1))
                .cornerRadius(8)
            }
            
            Divider().background(Theme.cardBorder)
            
            // Actions
            HStack(spacing: 20) {
                Button(action: { communityManager.toggleLike(post.id) }) {
                    HStack(spacing: 4) {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(post.isLiked ? .red : Theme.textSecondary)
                        Text("\(post.likes)")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                Button(action: { withAnimation { showReplies.toggle() } }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                        Text("\(post.replies.count)")
                    }
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            // Replies section
            if showReplies {
                VStack(spacing: 8) {
                    ForEach(post.replies) { reply in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .fill(Theme.secondaryBg)
                                .frame(width: 24, height: 24)
                                .overlay(Text(String(reply.authorName.prefix(1))).foregroundColor(.white).font(.caption2))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(reply.authorName)
                                    .font(.caption.bold())
                                    .foregroundColor(.white)
                                Text(reply.content)
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                    }
                    
                    HStack {
                        TextField("Répondre...", text: $replyText)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Theme.secondaryBg)
                            .cornerRadius(8)
                        
                        Button(action: {
                            if !replyText.isEmpty {
                                communityManager.addReply(to: post.id, content: replyText, author: "Moi")
                                replyText = ""
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(Theme.gold)
                        }
                    }
                }
                .padding(.leading, 16)
            }
        }
        .cardStyle()
        .padding(.horizontal, 16)
    }
}

struct NewPostView: View {
    @EnvironmentObject var communityManager: CommunityManager
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var content = ""
    @State private var selectedType: PostType = .reflection
    @State private var surahRef = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Type selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type de publication")
                                .font(.headline)
                                .foregroundColor(Theme.gold)
                            
                            HStack(spacing: 8) {
                                ForEach(PostType.allCases, id: \.rawValue) { type in
                                    Button(action: { selectedType = type }) {
                                        VStack {
                                            Text(type.icon).font(.title2)
                                            Text(type.rawValue).font(.caption2)
                                        }
                                        .foregroundColor(selectedType == type ? .black : .white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(selectedType == type ? Theme.gold : Theme.secondaryBg)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .cardStyle()
                        
                        // Content
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contenu")
                                .font(.headline)
                                .foregroundColor(Theme.gold)
                            
                            TextEditor(text: $content)
                                .frame(minHeight: 120)
                                .padding(8)
                                .background(Theme.secondaryBg)
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        .cardStyle()
                        
                        // Surah reference
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Référence (optionnel)")
                                .font(.headline)
                                .foregroundColor(Theme.gold)
                            
                            TextField("Ex: Sourate Al-Baqara 2:255", text: $surahRef)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Theme.secondaryBg)
                                .cornerRadius(10)
                        }
                        .cardStyle()
                        
                        // Publish
                        Button(action: {
                            if !content.isEmpty {
                                let post = CommunityPost(
                                    id: UUID().uuidString,
                                    authorName: appState.userName.isEmpty ? "Anonyme" : appState.userName,
                                    type: selectedType,
                                    content: content,
                                    surahReference: surahRef.isEmpty ? nil : surahRef,
                                    likes: 0,
                                    isLiked: false,
                                    replies: [],
                                    timeAgo: "À l'instant"
                                )
                                communityManager.addPost(post)
                                appState.addHasanat(3)
                                dismiss()
                            }
                        }) {
                            Text("Publier ✨").goldButton()
                        }
                        .disabled(content.isEmpty)
                        .opacity(content.isEmpty ? 0.5 : 1)
                    }
                    .padding()
                }
            }
            .navigationTitle("Nouvelle publication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { dismiss() }
                        .foregroundColor(Theme.gold)
                }
            }
        }
    }
}
