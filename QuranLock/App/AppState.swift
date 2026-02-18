import SwiftUI

class AppState: ObservableObject {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("dailyGoal") var dailyGoal: Int = 5
    @AppStorage("pagesRead") var pagesRead: Int = 0
    @AppStorage("totalPagesRead") var totalPagesRead: Int = 0
    @AppStorage("currentStreak") var currentStreak: Int = 0
    @AppStorage("currentSurahIndex") var currentSurahIndex: Int = 0
    @AppStorage("lastReadDate") var lastReadDate: String = ""
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("ramadanModeEnabled") var ramadanModeEnabled: Bool = false
    @AppStorage("hasanat") var hasanat: Int = 0
    @AppStorage("arabicLearningRhythm") var arabicLearningRhythm: String = ""
    @AppStorage("completedSurahsData") var completedSurahsData: String = "[]"
    @AppStorage("khatmCompletedSurahs") var khatmCompletedSurahs: String = "[]"
    @AppStorage("quizHighScore") var quizHighScore: Int = 0
    @AppStorage("musicChallengeActive") var musicChallengeActive: Bool = false
    @AppStorage("musicChallengeDaysCompleted") var musicChallengeDaysCompleted: Int = 0
    
    var completedSurahIndices: [Int] {
        get {
            guard let data = khatmCompletedSurahs.data(using: .utf8),
                  let indices = try? JSONDecoder().decode([Int].self, from: data) else { return [] }
            return indices
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                khatmCompletedSurahs = string
            }
        }
    }
    
    var khatmProgress: Double {
        return Double(completedSurahIndices.count) / 114.0
    }
    
    func markSurahCompleted(_ index: Int) {
        var current = completedSurahIndices
        if !current.contains(index) {
            current.append(index)
            completedSurahIndices = current
            addHasanat(10)
        }
    }
    
    func addHasanat(_ amount: Int) {
        hasanat += amount
    }
    
    func updateStreak() {
        let today = Self.dateString(from: Date())
        if lastReadDate != today {
            let yesterday = Self.dateString(from: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
            if lastReadDate == yesterday {
                currentStreak += 1
            } else if lastReadDate != today {
                currentStreak = 1
            }
            lastReadDate = today
        }
    }
    
    static func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func resetAll() {
        userName = ""
        dailyGoal = 5
        pagesRead = 0
        totalPagesRead = 0
        currentStreak = 0
        currentSurahIndex = 0
        lastReadDate = ""
        hasCompletedOnboarding = false
        ramadanModeEnabled = false
        hasanat = 0
        arabicLearningRhythm = ""
        khatmCompletedSurahs = "[]"
        quizHighScore = 0
        musicChallengeActive = false
        musicChallengeDaysCompleted = 0
    }
}
