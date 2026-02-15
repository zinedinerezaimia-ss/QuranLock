import SwiftUI

@main
struct QuranLockApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isOnboarded {
                ContentView()
                    .environmentObject(appState)
                    .preferredColorScheme(.dark)
            } else {
                OnboardingView()
                    .environmentObject(appState)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
