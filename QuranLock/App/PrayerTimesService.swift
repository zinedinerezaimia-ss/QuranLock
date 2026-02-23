import Foundation
import CoreLocation
import UserNotifications

// MARK: - Aladhan API Models

struct AladhanResponse: Codable {
    let code: Int
    let data: AladhanData
}

struct AladhanData: Codable {
    let timings: AladhanTimings
    let date: AladhanDate?
}

struct AladhanTimings: Codable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

struct AladhanDate: Codable {
    let hijri: HijriDate?
}

struct HijriDate: Codable {
    let day: String?
    let month: HijriMonth?
    let year: String?
}

struct HijriMonth: Codable {
    let number: Int?
    let en: String?
    let ar: String?
}

// MARK: - Prayer Times Model

struct PrayerTimes {
    let fajr: Date
    let sunrise: Date
    let dhuhr: Date
    let asr: Date
    let maghrib: Date
    let isha: Date
    let hijriDate: String?

    var all: [(name: String, arabic: String, time: Date)] {
        [
            ("Fajr", "الفجر", fajr),
            ("Lever du soleil", "الشروق", sunrise),
            ("Dhuhr", "الظهر", dhuhr),
            ("Asr", "العصر", asr),
            ("Maghrib", "المغرب", maghrib),
            ("Isha", "العشاء", isha)
        ]
    }

    var nextPrayer: (name: String, arabic: String, time: Date)? {
        all.first { $0.time > Date() }
    }

    var timeUntilNext: TimeInterval? {
        nextPrayer.map { $0.time.timeIntervalSince(Date()) }
    }
}

// MARK: - Prayer Times Service (Aladhan API)

class PrayerTimesService {

    static let shared = PrayerTimesService()

    /// Fetch prayer times from Aladhan API
    /// Method 12 = UOIF (Union des Organisations Islamiques de France)
    func fetchPrayerTimes(latitude: Double, longitude: Double, date: Date = Date()) async -> PrayerTimes? {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)

        let dateStr = String(format: "%02d-%02d-%04d", day, month, year)

        // Method 12 = UOIF for France
        let urlString = "https://api.aladhan.com/v1/timings/\(dateStr)?latitude=\(latitude)&longitude=\(longitude)&method=12&school=0"

        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return nil }

            let aladhan = try JSONDecoder().decode(AladhanResponse.self, from: data)
            let timings = aladhan.data.timings

            guard let fajr = parseTime(timings.Fajr, on: date),
                  let sunrise = parseTime(timings.Sunrise, on: date),
                  let dhuhr = parseTime(timings.Dhuhr, on: date),
                  let asr = parseTime(timings.Asr, on: date),
                  let maghrib = parseTime(timings.Maghrib, on: date),
                  let isha = parseTime(timings.Isha, on: date) else { return nil }

            // Build hijri date string
            var hijriStr: String? = nil
            if let hijri = aladhan.data.date?.hijri {
                let d = hijri.day ?? ""
                let m = hijri.month?.ar ?? hijri.month?.en ?? ""
                let y = hijri.year ?? ""
                if !d.isEmpty && !m.isEmpty {
                    hijriStr = "\(d) \(m) \(y)"
                }
            }

            return PrayerTimes(
                fajr: fajr, sunrise: sunrise, dhuhr: dhuhr,
                asr: asr, maghrib: maghrib, isha: isha,
                hijriDate: hijriStr
            )
        } catch {
            print("Aladhan API error: \(error)")
            return nil
        }
    }

    /// Parse "HH:mm" or "HH:mm (CEST)" into Date
    private func parseTime(_ timeStr: String, on date: Date) -> Date? {
        let cleaned = timeStr.components(separatedBy: " ").first ?? timeStr
        let parts = cleaned.components(separatedBy: ":")
        guard parts.count == 2,
              let hour = Int(parts[0]),
              let minute = Int(parts[1]) else { return nil }

        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = minute
        components.second = 0
        return calendar.date(from: components)
    }
}

// MARK: - Notification Service

class PrayerNotificationService {

    static let shared = PrayerNotificationService()

    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        return granted ?? false
    }

    func scheduleNotifications(latitude: Double, longitude: Double, days: Int = 7) async {
        let center = UNUserNotificationCenter.current()

        center.removePendingNotificationRequests(withIdentifiers:
            (0..<days).flatMap { d in
                ["fajr_\(d)", "dhuhr_\(d)", "asr_\(d)", "maghrib_\(d)", "isha_\(d)"]
            }
        )

        let prayers: [(id: String, name: String, emoji: String)] = [
            ("fajr", "Fajr", "🌙"),
            ("dhuhr", "Dhuhr", "☀️"),
            ("asr", "Asr", "🌤️"),
            ("maghrib", "Maghrib", "🌅"),
            ("isha", "Isha", "🌟")
        ]

        for day in 0..<days {
            let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
            guard let times = await PrayerTimesService.shared.fetchPrayerTimes(
                latitude: latitude, longitude: longitude, date: date
            ) else { continue }

            let prayerTimes = [times.fajr, times.dhuhr, times.asr, times.maghrib, times.isha]

            for (i, prayer) in prayers.enumerated() {
                let content = UNMutableNotificationContent()
                content.title = "\(prayer.emoji) Il est l'heure de \(prayer.name)"
                content.body = "Allahu Akbar — La prière est meilleure que le sommeil 🤲"
                content.sound = .default

                let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: prayerTimes[i])
                let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
                let request = UNNotificationRequest(
                    identifier: "\(prayer.id)_\(day)",
                    content: content,
                    trigger: trigger
                )
                try? await center.add(request)
            }
        }
    }

    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
