import SwiftUI

@main
struct QuranLockApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var appState = AppState()
    @StateObject private var ramadanManager = RamadanManager()
    @StateObject private var communityManager = CommunityManager()
    @StateObject private var arabicCourseManager = ArabicCourseManager()
    @StateObject private var musicChallengeManager = MusicChallengeManager()
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environmentObject(appState)
                    .environmentObject(ramadanManager)
                    .environmentObject(communityManager)
                    .environmentObject(arabicCourseManager)
                    .environmentObject(musicChallengeManager)
                    .preferredColorScheme(.dark)
            } else {
                OnboardingView()
                    .environmentObject(appState)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
