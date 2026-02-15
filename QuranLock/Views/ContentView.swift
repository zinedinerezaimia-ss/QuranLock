import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var isRamadan: Bool { appState.ramadanManager.isRamadan }
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: isRamadan ? "moon.stars.fill" : "house.fill")
                    Text("Accueil")
                }
                .tag(0)
            
            QuranReadingView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Coran")
                }
                .tag(1)
            
            if isRamadan {
                RamadanView()
                    .tabItem {
                        Image(systemName: "moon.fill")
                        Text("Ramadan")
                    }
                    .tag(2)
            }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Réglages")
                }
                .tag(isRamadan ? 3 : 2)
        }
        .tint(Theme.primary(isRamadan: isRamadan))
    }
}
