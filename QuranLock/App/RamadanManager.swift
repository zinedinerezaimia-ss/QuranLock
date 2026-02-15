import Foundation

class RamadanManager: ObservableObject {
    // Ramadan 2026: February 18 - March 19, 2026
    static let ramadanStart2026 = Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 18))!
    static let ramadanEnd2026 = Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 19))!
    
    @Published var isRamadan: Bool = false
    @Published var currentDay: Int = 0 // 1-30
    @Published var currentNight: Int = 0
    @Published var isLastTenNights: Bool = false
    @Published var isOddNight: Bool = false
    @Published var daysRemaining: Int = 0
    @Published var daysUntilRamadan: Int = 0
    
    // Prayer times for Paris/Saint-Denis (approximate)
    @Published var fajrTime: String = "06:15"
    @Published var maghribTime: String = "18:30"
    @Published var iftarCountdown: String = ""
    
    private var timer: Timer?
    
    init() {
        updateRamadanStatus()
        startTimer()
    }
    
    func updateRamadanStatus() {
        let now = Date()
        let calendar = Calendar.current
        
        if now >= RamadanManager.ramadanStart2026 && now <= RamadanManager.ramadanEnd2026 {
            isRamadan = true
            let components = calendar.dateComponents([.day], from: RamadanManager.ramadanStart2026, to: now)
            currentDay = (components.day ?? 0) + 1
            currentNight = currentDay
            isLastTenNights = currentDay >= 21
            isOddNight = currentDay % 2 != 0
            
            let remainComponents = calendar.dateComponents([.day], from: now, to: RamadanManager.ramadanEnd2026)
            daysRemaining = (remainComponents.day ?? 0)
            daysUntilRamadan = 0
            
            updatePrayerTimes()
            updateIftarCountdown()
        } else if now < RamadanManager.ramadanStart2026 {
            isRamadan = false
            let components = calendar.dateComponents([.day], from: now, to: RamadanManager.ramadanStart2026)
            daysUntilRamadan = (components.day ?? 0)
        } else {
            isRamadan = false
            daysUntilRamadan = -1 // Ramadan passed
        }
    }
    
    private func updatePrayerTimes() {
        // Approximate times for Paris area during Feb-March 2026
        let day = currentDay
        if day <= 10 {
            fajrTime = "06:\(String(format: "%02d", 20 - day))"
            maghribTime = "18:\(String(format: "%02d", 25 + day))"
        } else if day <= 20 {
            fajrTime = "06:\(String(format: "%02d", 10 - (day - 10)))"
            maghribTime = "18:\(String(format: "%02d", 35 + (day - 10)))"
        } else {
            fajrTime = "05:\(String(format: "%02d", 60 - (day - 20)))"
            maghribTime = "19:\(String(format: "%02d", (day - 20) - 1))"
        }
    }
    
    func updateIftarCountdown() {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: now)
        let currentHour = components.hour ?? 0
        let currentMinute = components.minute ?? 0
        
        // Parse maghrib time
        let parts = maghribTime.split(separator: ":")
        let maghribHour = Int(parts[0]) ?? 18
        let maghribMinute = Int(parts[1]) ?? 30
        
        let totalMinutesNow = currentHour * 60 + currentMinute
        let totalMinutesMaghrib = maghribHour * 60 + maghribMinute
        
        if totalMinutesNow < totalMinutesMaghrib {
            let diff = totalMinutesMaghrib - totalMinutesNow
            let hours = diff / 60
            let minutes = diff % 60
            iftarCountdown = "\(hours)h \(String(format: "%02d", minutes))min"
        } else {
            iftarCountdown = "Iftar passé"
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateRamadanStatus()
        }
    }
    
    func getRamadanNights() -> [RamadanNight] {
        let calendar = Calendar.current
        return (1...30).map { day in
            let date = calendar.date(byAdding: .day, value: day - 1, to: RamadanManager.ramadanStart2026) ?? Date()
            let isLastTen = day >= 21
            let isOdd = day % 2 != 0
            var note: String? = nil
            if isLastTen && isOdd {
                note = "🌙 Nuit possiblement Laylat al-Qadr"
            }
            return RamadanNight(id: day, date: date, isOdd: isOdd, isLastTen: isLastTen, specialNote: note)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
