import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ramadanManager: RamadanManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
            
            QuizMainView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Quiz")
                }
                .tag(4)
            
            SadaqaView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Sadaqa")
                }
                .tag(5)
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
