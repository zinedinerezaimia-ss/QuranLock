import SwiftUI
import Foundation

class AppState: ObservableObject {
    @Published var isOnboarded: Bool
    @Published var userName: String
    @Published var dailyGoalPages: Int
    @Published var pagesReadToday: Int
    @Published var totalPagesRead: Int
    @Published var currentSurah: Int
    @Published var streakDays: Int
    @Published var selectedTab: Int = 0
    
    let ramadanManager = RamadanManager()
    
    init() {
        let defaults = UserDefaults.standard
        self.isOnboarded = defaults.bool(forKey: "isOnboarded")
        self.userName = defaults.string(forKey: "userName") ?? ""
        self.dailyGoalPages = defaults.integer(forKey: "dailyGoalPages") == 0 ? 5 : defaults.integer(forKey: "dailyGoalPages")
        self.pagesReadToday = defaults.integer(forKey: "pagesReadToday")
        self.totalPagesRead = defaults.integer(forKey: "totalPagesRead")
        self.currentSurah = defaults.integer(forKey: "currentSurah") == 0 ? 1 : defaults.integer(forKey: "currentSurah")
        self.streakDays = defaults.integer(forKey: "streakDays")
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(isOnboarded, forKey: "isOnboarded")
        defaults.set(userName, forKey: "userName")
        defaults.set(dailyGoalPages, forKey: "dailyGoalPages")
        defaults.set(pagesReadToday, forKey: "pagesReadToday")
        defaults.set(totalPagesRead, forKey: "totalPagesRead")
        defaults.set(currentSurah, forKey: "currentSurah")
        defaults.set(streakDays, forKey: "streakDays")
    }
    
    func addPages(_ count: Int) {
        pagesReadToday += count
        totalPagesRead += count
        save()
    }
    
    func completeOnboarding(name: String, goal: Int) {
        userName = name
        dailyGoalPages = goal
        isOnboarded = true
        save()
    }
}
