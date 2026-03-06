import Foundation
import CoreLocation
import UserNotifications

// MARK: - Prayer Times Model

struct PrayerTimes {
    let fajr: Date
    let sunrise: Date
    let dhuhr: Date
    let asr: Date
    let maghrib: Date
    let isha: Date

    var all: [(name: String, arabic: String, time: Date)] {
        [
            ("Fajr", "الفجر", fajr),
            ("Shurûq", "الشروق", sunrise),
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

// MARK: - Aladhan API Response

struct AladhanResponse: Codable {
    let data: AladhanData
}

struct AladhanData: Codable {
    let timings: AladhanTimings
}

struct AladhanTimings: Codable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

// MARK: - Prayer Times Service (Aladhan API)

class PrayerTimesService: ObservableObject {
    @Published var currentTimes: PrayerTimes?
    @Published var isLoading = false
    @Published var error: String?

    // Method 12 = UOIF (France) — change method based on region if needed
    // Method 2 = ISNA, Method 1 = MWL, Method 3 = Umm Al-Qura
    private let defaultMethod = 12 // UOIF for France

    func fetchPrayerTimes(latitude: Double, longitude: Double, date: Date = Date()) async {
        await MainActor.run { isLoading = true; error = nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateStr = formatter.string(from: date)

        let urlStr = "https://api.aladhan.com/v1/timings/\(dateStr)?latitude=\(latitude)&longitude=\(longitude)&method=\(defaultMethod)"

        guard let url = URL(string: urlStr) else {
            await MainActor.run { error = "URL invalide"; isLoading = false }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AladhanResponse.self, from: data)
            let timings = response.data.timings

            let times = PrayerTimes(
                fajr: parseTime(timings.Fajr, on: date),
                sunrise: parseTime(timings.Sunrise, on: date),
                dhuhr: parseTime(timings.Dhuhr, on: date),
                asr: parseTime(timings.Asr, on: date),
                maghrib: parseTime(timings.Maghrib, on: date),
                isha: parseTime(timings.Isha, on: date)
            )

            await MainActor.run {
                currentTimes = times
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = "Erreur de chargement des horaires"
                isLoading = false
            }
            // Fallback to local calculation
            let calc = PrayerTimesCalculator()
            let times = calc.calculate(for: date, latitude: latitude, longitude: longitude)
            await MainActor.run { currentTimes = times }
        }
    }

    private func parseTime(_ str: String, on date: Date) -> Date {
        // Aladhan returns "HH:mm" or "HH:mm (TZ)"
        let clean = str.components(separatedBy: " ").first ?? str
        let parts = clean.split(separator: ":")
        guard parts.count == 2,
              let h = Int(parts[0]),
              let m = Int(parts[1]) else { return date }

        let cal = Calendar.current
        let startOfDay = cal.startOfDay(for: date)
        return cal.date(byAdding: .init(hour: h, minute: m), to: startOfDay) ?? date
    }
}

// MARK: - Fallback Local Calculator (MWL method)

class PrayerTimesCalculator {
    private let fajrAngle: Double = 18.0
    private let ishaAngle: Double = 17.0

    func calculate(for date: Date, latitude: Double, longitude: Double) -> PrayerTimes {
        let jd = julianDay(date: date)
        let d = jd - 2451545.0
        let eqTime = equationOfTime(d: d)

        let fajrTime = prayerTime(d: d, latitude: latitude, t: 5.0 - eqTime / 60.0, angle: fajrAngle, direction: -1)
        let sunriseTime = prayerTime(d: d, latitude: latitude, t: 6.0 - eqTime / 60.0, angle: 0.833, direction: -1)
        let dhuhrTime = 12.0 - eqTime / 60.0 - longitude / 15.0
        let asrTime = asrPrayerTime(d: d, latitude: latitude, t: dhuhrTime + 1.0)
        let maghribTime = prayerTime(d: d, latitude: latitude, t: dhuhrTime + 1.0, angle: 0.833, direction: 1)
        let ishaTime = prayerTime(d: d, latitude: latitude, t: dhuhrTime + 1.0, angle: ishaAngle, direction: 1)

        let tz = TimeZone.current.secondsFromGMT() / 3600
        let offset = Double(tz) - longitude / 15.0

        return PrayerTimes(
            fajr: dateFromHours(hours: fajrTime + offset, base: date),
            sunrise: dateFromHours(hours: sunriseTime + offset, base: date),
            dhuhr: dateFromHours(hours: dhuhrTime + offset, base: date),
            asr: dateFromHours(hours: asrTime + offset, base: date),
            maghrib: dateFromHours(hours: maghribTime + offset, base: date),
            isha: dateFromHours(hours: ishaTime + offset, base: date)
        )
    }

    private func julianDay(date: Date) -> Double {
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.year, .month, .day], from: date)
        var y = Double(comps.year!); var m = Double(comps.month!); let d = Double(comps.day!)
        if m <= 2 { y -= 1; m += 12 }
        let a = floor(y / 100); let b = 2 - a + floor(a / 4)
        return floor(365.25 * (y + 4716)) + floor(30.6001 * (m + 1)) + d + b - 1524.5
    }

    private func equationOfTime(d: Double) -> Double {
        let m = toRad(280.46646 + d * 0.9856474 - 360 * floor((280.46646 + d * 0.9856474) / 360))
        return -7.655 * sin(m) + 9.873 * sin(2 * m + toRad(3.588)) + 0.439 * sin(4 * m + toRad(7.176))
    }

    private func sunDeclination(d: Double) -> Double {
        let g = toRad(357.529 + 0.98560028 * d)
        let q = 280.459 + 0.98564736 * d
        let l = toRad(q + 1.915 * sin(g) + 0.020 * sin(2 * g))
        let e = toRad(23.439 - 0.00000036 * d)
        return toDeg(asin(sin(e) * sin(l)))
    }

    private func prayerTime(d: Double, latitude: Double, t: Double, angle: Double, direction: Double) -> Double {
        let decl = sunDeclination(d: d)
        let num = -sin(toRad(angle)) - sin(toRad(latitude)) * sin(toRad(decl))
        let den = cos(toRad(latitude)) * cos(toRad(decl))
        return t + direction * toDeg(acos(num / den)) / 15.0
    }

    private func asrPrayerTime(d: Double, latitude: Double, t: Double) -> Double {
        let decl = sunDeclination(d: d)
        let targetAlt = toDeg(atan(1.0 / (1.0 + tan(toRad(abs(latitude - decl))))))
        let num = sin(toRad(targetAlt)) - sin(toRad(latitude)) * sin(toRad(decl))
        let den = cos(toRad(latitude)) * cos(toRad(decl))
        return t + toDeg(acos(num / den)) / 15.0
    }

    private func toRad(_ deg: Double) -> Double { deg * .pi / 180 }
    private func toDeg(_ rad: Double) -> Double { rad * 180 / .pi }

    private func dateFromHours(hours: Double, base: Date) -> Date {
        let cal = Calendar(identifier: .gregorian)
        let startOfDay = cal.startOfDay(for: base)
        let h = Int(hours); let m = Int((hours - Double(h)) * 60); let s = Int(((hours - Double(h)) * 60 - Double(m)) * 60)
        return cal.date(byAdding: .init(hour: h, minute: m, second: s), to: startOfDay) ?? base
    }
}

// MARK: - Notification Service with Adhan Sound

class PrayerNotificationService {
    static let shared = PrayerNotificationService()

    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        return granted ?? false
    }

    /// Schedule prayer notifications using Aladhan API times
    func scheduleNotifications(latitude: Double, longitude: Double, useAdhan: Bool = true, days: Int = 7) async {
        let center = UNUserNotificationCenter.current()

        // Remove all existing prayer notifications
        center.removeAllPendingNotificationRequests()

        let prayers: [(id: String, name: String, nameAr: String, emoji: String)] = [
            ("fajr", "Fajr", "الفجر", "🌙"),
            ("dhuhr", "Dhuhr", "الظهر", "☀️"),
            ("asr", "Asr", "العصر", "🌤️"),
            ("maghrib", "Maghrib", "المغرب", "🌅"),
            ("isha", "Isha", "العشاء", "🌟")
        ]

        let service = PrayerTimesService()

        for day in 0..<days {
            let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
            await service.fetchPrayerTimes(latitude: latitude, longitude: longitude, date: date)

            guard let times = service.currentTimes else { continue }
            let prayerDates = [times.fajr, times.dhuhr, times.asr, times.maghrib, times.isha]

            for (i, prayer) in prayers.enumerated() {
                let prayerDate = prayerDates[i]
                guard prayerDate > Date() else { continue }

                let content = UNMutableNotificationContent()
                content.title = "\(prayer.emoji) \(prayer.name) — \(prayer.nameAr)"
                content.body = "Allahu Akbar — Hayya 'ala as-Salah 🤲"
                content.badge = 1

                // Use adhan.mp3 if enabled, otherwise default
                if useAdhan {
                    content.sound = UNNotificationSound(named: UNNotificationSoundName("adhan.mp3"))
                } else {
                    content.sound = .default
                }

                let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: prayerDate)
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
