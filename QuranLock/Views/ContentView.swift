import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ramadanManager: RamadanManager

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Accueil")
                }
                .tag(0)

            QuranReadingView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Coran")
                }
                .tag(1)

            ArabicCoursesView()
                .tabItem {
                    Image(systemName: "character.book.closed.fill")
                    Text("Arabe")
                }
                .tag(2)

            DuaasMainView()
                .tabItem {
                    Image(systemName: "hands.clap.fill")
                    Text("Duaas")
                }
                .tag(3)

            MoreView()
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text("Autre")
                }
                .tag(4)
        }
        .accentColor(Theme.gold)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Theme.primaryBg)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - More Tab
struct MoreView: View {
    @State private var showQuiz = false
    @State private var showCommunity = false
    @State private var showMusicChallenge = false
    @State private var showEnseignements = false
    @State private var showSadaqa = false
    @State private var showKhatm = false
    @State private var showProphet = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 14) {
                        moreButton(icon: "🧠", title: "Quiz Islamique", sub: "Teste tes connaissances") { showQuiz = true }
                        moreButton(icon: "👥", title: "Communauté", sub: "Partage & discussions") { showCommunity = true }
                        moreButton(icon: "🎵", title: "Défi Arrêter la Musique", sub: "Remplace la musique par le Coran") { showMusicChallenge = true }
                        moreButton(icon: "📖", title: "Enseignements", sub: "Piliers de l'Islam, Prière...") { showEnseignements = true }
                        moreButton(icon: "🕌", title: "Mosquées & Sadaqa", sub: "Soutenir les mosquées") { showSadaqa = true }
                        moreButton(icon: "🏁", title: "Défi Khatm", sub: "Terminer le Coran complet") { showKhatm = true }
                        moreButton(icon: "🌙", title: "Histoire du Prophète ﷺ", sub: "La Sîra du Prophète") { showProphet = true }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("إقرأ — Autre")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showQuiz) { QuizMainView() }
        .sheet(isPresented: $showCommunity) { CommunityView() }
        .sheet(isPresented: $showMusicChallenge) { MusicChallengeView() }
        .sheet(isPresented: $showEnseignements) { EnseignementsView() }
        .sheet(isPresented: $showSadaqa) { SadaqaView() }
        .sheet(isPresented: $showKhatm) { KhatmChallengeView() }
        .sheet(isPresented: $showProphet) { ProphetStoriesView() }
    }

    func moreButton(icon: String, title: String, sub: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(icon).font(.system(size: 28))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline).foregroundColor(.white)
                    Text(sub).font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(Theme.textSecondary)
            }
            .padding(16)
            .background(Theme.cardBg)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
        }
    }
}

// MARK: - Prophet Stories View
struct ProphetStoriesView: View {
    @Environment(\.dismiss) var dismiss

    let stories: [(String, String, String)] = [
        ("🌟", "La naissance du Prophète ﷺ", "Muhammad ﷺ est né à La Mecque le 12 Rabi' al-Awwal, l'Année de l'Éléphant (570 ou 571 EC). Son père Abdullah mourut avant sa naissance et sa mère Amina mourut quand il avait 6 ans. Il fut élevé par son grand-père Abd al-Muttalib puis par son oncle Abu Talib."),
        ("📖", "La première révélation", "À l'âge de 40 ans, dans la grotte de Hira, l'ange Jibril (Gabriel) lui apparut et lui dit : « Lis ! » C'est ainsi que commença la révélation du Coran. Muhammad ﷺ tremblait de peur et courut vers Khadija qui le réconforta. Ce fut le début de sa mission prophétique."),
        ("🕊️", "L'Hégire — La migration vers Médine", "En 622 EC, face aux persécutions des Quraysh, le Prophète ﷺ migra de La Mecque vers Médine avec ses compagnons. Cette migration (Hégire) marque le début du calendrier islamique. À Médine, il établit la première communauté musulmane unie."),
        ("⚔️", "La bataille de Badr", "En l'an 2 de l'Hégire, 313 musulmans mal équipés affrontèrent une armée de 1000 Qurayshites. Allah accorda la victoire aux croyants. Cette bataille est mentionnée dans le Coran comme le « Jour du Discernement » (Al-Furqan)."),
        ("🏛️", "La conquête de La Mecque", "En l'an 8 de l'Hégire, le Prophète ﷺ entra à La Mecque avec 10 000 compagnons. Il y entra avec humilité, la tête baissée, en récitant la Sourate Al-Fath. Il accorda la grâce générale aux habitants et purifia la Ka'ba des idoles."),
        ("💫", "Le Voyage Nocturne — Al-Isra wal-Mi'raj", "En une seule nuit, le Prophète ﷺ voyagea de La Mecque à Jérusalem (Al-Isra), puis s'éleva à travers les cieux (Al-Mi'raj). Il rencontra les prophètes précédents et reçut l'injonction des 5 prières quotidiennes directement d'Allah."),
        ("🤲", "Les dernières paroles du Prophète ﷺ", "Lors du Pèlerinage d'Adieu en l'an 10 de l'Hégire, le Prophète ﷺ dit : « Ô gens, je vous ai laissé deux choses. Si vous vous y accrochez, vous ne vous égarerez jamais : le Livre d'Allah et la Sunna de Son Prophète. » Il mourut peu après, le 12 Rabi' al-Awwal de l'an 11 H.")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 14) {
                        Text("La vie du Prophète Muhammad ﷺ est un guide pour toute l'humanité")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 4)

                        ForEach(stories, id: \.1) { story in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 10) {
                                    Text(story.0).font(.title2)
                                    Text(story.1).font(.headline).foregroundColor(Theme.gold)
                                }
                                Text(story.2).font(.subheadline).foregroundColor(.white).lineSpacing(4)
                            }
                            .padding(16)
                            .background(Theme.cardBg)
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("🌙 Sîra du Prophète ﷺ")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }
}
