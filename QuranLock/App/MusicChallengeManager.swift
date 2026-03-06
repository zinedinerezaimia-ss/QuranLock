import SwiftUI

class MusicChallengeManager: ObservableObject {
    @Published var isActive: Bool = false
    @Published var selectedPlatform: MusicPlatform?
    @Published var challengeDuration: ChallengeDuration = .thirtyDays
    @Published var daysCompleted: Int = 0
    @Published var startDate: Date?
    @Published var dailyCheckIns: [String] = [] // dates checked in
    
    @AppStorage("musicChallengeActive") private var storedActive: Bool = false
    @AppStorage("musicChallengePlatform") private var storedPlatform: String = ""
    @AppStorage("musicChallengeDuration") private var storedDuration: Int = 30
    @AppStorage("musicChallengeStart") private var storedStart: String = ""
    @AppStorage("musicChallengeCheckIns") private var storedCheckIns: String = "[]"
    
    enum MusicPlatform: String, CaseIterable, Identifiable {
        case spotify = "Spotify"
        case appleMusic = "Apple Music"
        case deezer = "Deezer"
        case youtube = "YouTube Music"
        case other = "Autre"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .spotify: return "🟢"
            case .appleMusic: return "🍎"
            case .deezer: return "🟣"
            case .youtube: return "🔴"
            case .other: return "🎵"
            }
        }
        
        var color: Color {
            switch self {
            case .spotify: return Color(red: 0.11, green: 0.73, blue: 0.33)
            case .appleMusic: return Color(red: 0.98, green: 0.18, blue: 0.33)
            case .deezer: return Color(red: 0.63, green: 0.10, blue: 0.98)
            case .youtube: return Color.red
            case .other: return Theme.gold
            }
        }
    }
    
    enum ChallengeDuration: Int, CaseIterable, Identifiable {
        case sevenDays = 7
        case fourteenDays = 14
        case thirtyDays = 30
        case sixtyDays = 60
        case ninetyDays = 90
        
        var id: Int { rawValue }
        
        var label: String {
            switch self {
            case .sevenDays: return "7 jours"
            case .fourteenDays: return "14 jours"
            case .thirtyDays: return "30 jours"
            case .sixtyDays: return "60 jours"
            case .ninetyDays: return "90 jours"
            }
        }
    }
    
    init() {
        loadState()
    }
    
    func loadState() {
        isActive = storedActive
        selectedPlatform = MusicPlatform(rawValue: storedPlatform)
        challengeDuration = ChallengeDuration(rawValue: storedDuration) ?? .thirtyDays
        
        if !storedStart.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            startDate = formatter.date(from: storedStart)
        }
        
        if let data = storedCheckIns.data(using: .utf8),
           let checkIns = try? JSONDecoder().decode([String].self, from: data) {
            dailyCheckIns = checkIns
            daysCompleted = checkIns.count
        }
    }
    
    func startChallenge(platform: MusicPlatform, duration: ChallengeDuration) {
        selectedPlatform = platform
        challengeDuration = duration
        startDate = Date()
        isActive = true
        daysCompleted = 0
        dailyCheckIns = []
        
        storedActive = true
        storedPlatform = platform.rawValue
        storedDuration = duration.rawValue
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        storedStart = formatter.string(from: Date())
        storedCheckIns = "[]"
    }
    
    func checkInToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        guard !dailyCheckIns.contains(today) else { return }
        
        dailyCheckIns.append(today)
        daysCompleted = dailyCheckIns.count
        
        if let data = try? JSONEncoder().encode(dailyCheckIns),
           let string = String(data: data, encoding: .utf8) {
            storedCheckIns = string
        }
    }
    
    var hasCheckedInToday: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        return dailyCheckIns.contains(today)
    }
    
    var progress: Double {
        Double(daysCompleted) / Double(challengeDuration.rawValue)
    }
    
    var daysRemaining: Int {
        max(0, challengeDuration.rawValue - daysCompleted)
    }
    
    var isCompleted: Bool {
        daysCompleted >= challengeDuration.rawValue
    }
    
    func abandonChallenge() {
        isActive = false
        storedActive = false
        selectedPlatform = nil
        startDate = nil
        daysCompleted = 0
        dailyCheckIns = []
    }
}
