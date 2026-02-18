import SwiftUI
import Combine

class RamadanManager: ObservableObject {
    @Published var isRamadan: Bool = false
    @Published var ramadanDay: Int = 0
    @Published var daysRemaining: Int = 0
    @Published var daysUntilRamadan: Int = 0
    @Published var fajrTime: String = "05:45"
    @Published var maghribTime: String = "18:30"
    @Published var iftarCountdown: String = ""
    @Published var isLastTenNights: Bool = false
    @Published var isOddNight: Bool = false
    
    private var timer: Timer?
    
    // Ramadan 2026: Feb 18 - Mar 19 (approx)
    let ramadanStart = Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 18))!
    let ramadanEnd = Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 19))!
    
    // Prayer times for Paris (approximate, varies by day)
    let fajrTimes: [Int: String] = [
        1: "06:30", 2: "06:28", 3: "06:26", 4: "06:24", 5: "06:22",
        6: "06:20", 7: "06:18", 8: "06:16", 9: "06:14", 10: "06:12",
        11: "06:09", 12: "06:07", 13: "06:05", 14: "06:02", 15: "06:00",
        16: "05:57", 17: "05:55", 18: "05:52", 19: "05:50", 20: "05:47",
        21: "05:45", 22: "05:42", 23: "05:40", 24: "05:37", 25: "05:35",
        26: "05:32", 27: "05:30", 28: "05:27", 29: "05:25", 30: "05:22"
    ]
    
    let maghribTimes: [Int: String] = [
        1: "18:15", 2: "18:16", 3: "18:18", 4: "18:19", 5: "18:21",
        6: "18:22", 7: "18:24", 8: "18:25", 9: "18:27", 10: "18:28",
        11: "18:30", 12: "18:31", 13: "18:33", 14: "18:34", 15: "18:36",
        16: "18:37", 17: "18:39", 18: "18:40", 19: "18:42", 20: "18:43",
        21: "18:45", 22: "18:46", 23: "18:48", 24: "18:49", 25: "18:51",
        26: "18:52", 27: "18:54", 28: "18:55", 29: "18:57", 30: "18:58"
    ]
    
    init() {
        updateRamadanStatus()
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateRamadanStatus()
        }
    }
    
    func updateRamadanStatus() {
        let now = Date()
        let calendar = Calendar.current
        
        if now >= ramadanStart && now <= ramadanEnd {
            isRamadan = true
            ramadanDay = calendar.dateComponents([.day], from: ramadanStart, to: now).day! + 1
            daysRemaining = calendar.dateComponents([.day], from: now, to: ramadanEnd).day! + 1
            isLastTenNights = ramadanDay >= 21
            isOddNight = ramadanDay >= 21 && ramadanDay % 2 == 1
            
            fajrTime = fajrTimes[ramadanDay] ?? "06:00"
            maghribTime = maghribTimes[ramadanDay] ?? "18:30"
            updateIftarCountdown()
        } else if now < ramadanStart {
            isRamadan = false
            daysUntilRamadan = calendar.dateComponents([.day], from: now, to: ramadanStart).day! + 1
        } else {
            isRamadan = false
            daysUntilRamadan = 0
        }
    }
    
    func updateIftarCountdown() {
        let now = Date()
        let calendar = Calendar.current
        let maghribStr = maghribTimes[ramadanDay] ?? "18:30"
        let parts = maghribStr.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return }
        
        var iftarComponents = calendar.dateComponents([.year, .month, .day], from: now)
        iftarComponents.hour = parts[0]
        iftarComponents.minute = parts[1]
        
        guard let iftarDate = calendar.date(from: iftarComponents) else { return }
        
        if now < iftarDate {
            let diff = calendar.dateComponents([.hour, .minute], from: now, to: iftarDate)
            iftarCountdown = String(format: "%02dh %02dm", diff.hour ?? 0, diff.minute ?? 0)
        } else {
            iftarCountdown = "Iftar passé"
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
