import SwiftUI

struct CommunityView: View {
    @EnvironmentObject var communityManager: CommunityManager
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showNewPost = false
    @State private var selectedFilter: CommunityPost.PostType? = nil
    
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
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                FilterChip(title: "Tout", isSelected: selectedFilter == nil) { selectedFilter = nil }
                                FilterChip(title: "💭 Réflexion", isSelected: selectedFilter == .reflection) { selectedFilter = .reflection }
                                FilterChip(title: "❓ Question", isSelected: selectedFilter == .question) { selectedFilter = .question }
                                FilterChip(title: "💬 Discussion", isSelected: selectedFilter == .discussion) { selectedFilter = .discussion }
                                FilterChip(title: "🎙️ Récitation", isSelected: selectedFilter == .recitation) { selectedFilter = .recitation }
                            }
                            .padding(.horizontal)
                        }
                        
                        ForEach(filteredPosts) { post in
                            PostCard(post: post)
                        }
                        
                        if filteredPosts.isEmpty {
                            VStack(spacing: 12) {
                                Text("🕊️").font(.system(size: 50))
                                Text("Aucune publication")
                                    .font(.headline)
                                    .foregroundColor(Theme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                        }
                    }
                    .padding(.bottom, 80)
                }
                
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
                    Button("Fermer") { dismiss() }.foregroundColor(Theme.gold)
                }
            }
            .sheet(isPresented: $showNewPost) { NewPostView() }
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

struct PostCard: View {
    let post: CommunityPost
    @EnvironmentObject var communityManager: CommunityManager
    @State private var showReplies = false
    @State private var replyText = ""
    
    var typeIcon: String {
        switch post.type {
        case .reflection: return "💭"
        case .question: return "❓"
        case .discussion: return "💬"
        case .recitation: return "🎙️"
        }
    }
    
    var timeAgoText: String {
        let interval = Date().timeIntervalSince(post.timestamp)
        if interval < 60 { return "À l'instant" }
        if interval < 3600 { return "Il y a \(Int(interval / 60)) min" }
        if interval < 86400 { return "Il y a \(Int(interval / 3600))h" }
        return "Il y a \(Int(interval / 86400))j"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Theme.accent)
                    .frame(width: 36, height: 36)
                    .overlay(Text(String(post.authorName.prefix(1))).foregroundColor(.white).font(.headline))
                
                VStack(alignment: .leading) {
                    Text(post.authorName).font(.subheadline.bold()).foregroundColor(.white)
                    Text(timeAgoText).font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Text(typeIcon).font(.title3)
            }
            
            Text(post.content).font(.subheadline).foregroundColor(.white)
            
            if let surah = post.surahName {
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
            
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    Image(systemName: "heart")
                    Text("\(post.likes)")
                }
                .font(.caption).foregroundColor(Theme.textSecondary)
                
                Button(action: { withAnimation { showReplies.toggle() } }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                        Text("\(post.replies.count)")
                    }
                    .font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
            }
            
            if showReplies {
                repliesSection
            }
        }
        .cardStyle()
        .padding(.horizontal, 16)
    }
    
    var repliesSection: some View {
        VStack(spacing: 8) {
            ForEach(post.replies) { reply in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(Theme.secondaryBg)
                        .frame(width: 24, height: 24)
                        .overlay(Text(String(reply.authorName.prefix(1))).foregroundColor(.white).font(.caption2))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(reply.authorName).font(.caption.bold()).foregroundColor(.white)
                        Text(reply.content).font(.caption).foregroundColor(Theme.textSecondary)
                    }
                }
            }
            
            HStack {
                TextField("Répondre...", text: $replyText)
                    .font(.caption).foregroundColor(.white)
                    .padding(8).background(Theme.secondaryBg).cornerRadius(8)
                
                Button(action: {
                    if !replyText.isEmpty {
                        communityManager.addReply(to: post.id, authorName: "Moi", content: replyText)
                        replyText = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill").foregroundColor(Theme.gold)
                }
            }
        }
        .padding(.leading, 16)
    }
}

struct NewPostView: View {
    @EnvironmentObject var communityManager: CommunityManager
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var content = ""
    @State private var selectedType: CommunityPost.PostType = .reflection
    @State private var surahRef = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type de publication").font(.headline).foregroundColor(Theme.gold)
                            
                            HStack(spacing: 8) {
                                typeBtn("💭", "Réflexion", .reflection)
                                typeBtn("❓", "Question", .question)
                                typeBtn("💬", "Discussion", .discussion)
                                typeBtn("🎙️", "Récitation", .recitation)
                            }
                        }
                        .cardStyle()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contenu").font(.headline).foregroundColor(Theme.gold)
                            TextEditor(text: $content)
                                .frame(minHeight: 120)
                                .padding(8).background(Theme.secondaryBg).cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        .cardStyle()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Référence (optionnel)").font(.headline).foregroundColor(Theme.gold)
                            TextField("Ex: Al-Baqara", text: $surahRef)
                                .foregroundColor(.white).padding(12)
                                .background(Theme.secondaryBg).cornerRadius(10)
                        }
                        .cardStyle()
                        
                        Button(action: {
                            if !content.isEmpty {
                                communityManager.addPost(
                                    authorName: appState.userName.isEmpty ? "Anonyme" : appState.userName,
                                    content: content,
                                    type: selectedType,
                                    surahName: surahRef.isEmpty ? nil : surahRef
                                )
                                appState.addHasanat(3)
                                dismiss()
                            }
                        }) {
                            Text("Publier ✨").goldButton()
                        }
                        .disabled(content.isEmpty).opacity(content.isEmpty ? 0.5 : 1)
                    }
                    .padding()
                }
            }
            .navigationTitle("Nouvelle publication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }
    
    func typeBtn(_ icon: String, _ label: String, _ type: CommunityPost.PostType) -> some View {
        Button(action: { selectedType = type }) {
            VStack {
                Text(icon).font(.title2)
                Text(label).font(.caption2)
            }
            .foregroundColor(selectedType == type ? .black : .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(selectedType == type ? Theme.gold : Theme.secondaryBg)
            .cornerRadius(10)
        }
    }
}
