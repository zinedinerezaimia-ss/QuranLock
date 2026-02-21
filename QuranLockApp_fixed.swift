import SwiftUI
import FirebaseCore

@main
struct QuranLockApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var appState = AppState()
    @StateObject private var ramadanManager = RamadanManager()
    @StateObject private var arabicCourseManager = ArabicCourseManager()
    @StateObject private var musicChallengeManager = MusicChallengeManager()
    @StateObject private var languageManager = LanguageManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environmentObject(appState)
                    .environmentObject(ramadanManager)
                    .environmentObject(arabicCourseManager)
                    .environmentObject(musicChallengeManager)
                    .environmentObject(languageManager)
                    .preferredColorScheme(.dark)
                    .environment(\.layoutDirection, languageManager.isRTL ? .rightToLeft : .leftToRight)
                    .id(languageManager.currentLanguage)
            } else {
                OnboardingView()
                    .environmentObject(appState)
                    .environmentObject(languageManager)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
