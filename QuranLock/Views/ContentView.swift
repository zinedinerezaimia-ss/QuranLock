import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ramadanManager: RamadanManager
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(L.home)
                }
                .tag(0)

            QuranReadingView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text(L.quran)
                }
                .tag(1)

            ArabicCoursesView()
                .tabItem {
                    Image(systemName: "character.book.closed.fill")
                    Text(L.learn)
                }
                .tag(2)

            DuaasMainView()
                .tabItem {
                    Image(systemName: "hands.clap.fill")
                    Text(L.duaas)
                }
                .tag(3)

            MoreView()
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text(L.other)
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
                        moreButton(icon: "🧠", title: L.quizTitle, sub: L.quizSub) { showQuiz = true }
                        moreButton(icon: "👥", title: L.community, sub: L.communitySub) { showCommunity = true }
                        moreButton(icon: "🎵", title: L.musicTitle, sub: L.musicSub) { showMusicChallenge = true }
                        moreButton(icon: "📖", title: L.teachingsTitle, sub: L.teachingsSub) { showEnseignements = true }
                        moreButton(icon: "🕌", title: L.mosqueSadaqa, sub: L.mosqueSub) { showSadaqa = true }
                        moreButton(icon: "🏁", title: L.khatmTitle, sub: L.khatmSub) { showKhatm = true }
                        moreButton(icon: "🌙", title: L.prophetTitle, sub: L.prophetSub) { showProphet = true }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("إقرأ — \(L.other)")
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
        ("📖", "La première révélation", "À l'âge de 40 ans, dans la grotte de Hira, l'ange Jibril (Gabriel) lui apparut et lui dit : « Lis ! » C'est ainsi que commença la révélation du Coran. Muhammad ﷺ tremblait de peur et courut vers Khadija qui le réconforta."),
        ("🕊️", "L'Hégire", "En 622 EC, face aux persécutions des Quraysh, le Prophète ﷺ migra de La Mecque vers Médine. Cette migration (Hégire) marque le début du calendrier islamique."),
        ("⚔️", "La bataille de Badr", "En l'an 2 de l'Hégire, 313 musulmans affrontèrent 1000 Qurayshites. Allah accorda la victoire aux croyants."),
        ("🏛️", "La conquête de La Mecque", "En l'an 8 de l'Hégire, le Prophète ﷺ entra à La Mecque avec 10 000 compagnons. Il accorda la grâce générale et purifia la Ka'ba des idoles."),
        ("💫", "Al-Isra wal-Mi'raj", "En une seule nuit, le Prophète ﷺ voyagea de La Mecque à Jérusalem puis s'éleva à travers les cieux. Il reçut l'injonction des 5 prières quotidiennes."),
        ("🤲", "Les dernières paroles", "Lors du Pèlerinage d'Adieu : « Je vous ai laissé deux choses. Si vous vous y accrochez, vous ne vous égarerez jamais : le Livre d'Allah et la Sunna de Son Prophète. »")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(stories, id: \.1) { story in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 10) {
                                    Text(story.0).font(.title2)
                                    Text(story.1).font(.headline).foregroundColor(Theme.gold)
                                }
                                Text(story.2).font(.subheadline).foregroundColor(.white).lineSpacing(4)

                                // Share button
                                Button(action: {
                                    AppState.shareText("\(story.1)\n\n\(story.2)\n\n— App Iqra 🤲")
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "square.and.arrow.up")
                                        Text(L.share)
                                    }
                                    .font(.caption).foregroundColor(Theme.gold)
                                }
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
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }
}
