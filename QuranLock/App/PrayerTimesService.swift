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

// MARK: - Prayer Times Calculator (Muslim World League method)

class PrayerTimesCalculator {

    // Method: Muslim World League
    private let fajrAngle: Double = 18.0
    private let ishaAngle: Double = 17.0

    func calculate(for date: Date, latitude: Double, longitude: Double) -> PrayerTimes {
        let jd = julianDay(date: date)
        let d = jd - 2451545.0

        let eqTime = equationOfTime(d: d)
        let decl = sunDeclination(d: d)

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

    // MARK: - Astronomical calculations

    private func julianDay(date: Date) -> Double {
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.year, .month, .day], from: date)
        var y = Double(comps.year!)
        var m = Double(comps.month!)
        let d = Double(comps.day!)

        if m <= 2 { y -= 1; m += 12 }

        let a = floor(y / 100)
        let b = 2 - a + floor(a / 4)
        return floor(365.25 * (y + 4716)) + floor(30.6001 * (m + 1)) + d + b - 1524.5
    }

    private func equationOfTime(d: Double) -> Double {
        let e = 0.016708634 - d * (0.000042037 + 0.0000001267 * d)
        let m = toRad(280.46646 + d * 0.9856474 - 360 * floor((280.46646 + d * 0.9856474) / 360))
        let eq = -7.655 * sin(m) + 9.873 * sin(2 * m + toRad(3.588)) + 0.439 * sin(4 * m + toRad(7.176))
        return eq
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
        let hourAngle = toDeg(acos(num / den)) / 15.0
        return t + direction * hourAngle
    }

    private func asrPrayerTime(d: Double, latitude: Double, t: Double) -> Double {
        let decl = sunDeclination(d: d)
        let targetAlt = toDeg(atan(1.0 / (1.0 + tan(toRad(abs(latitude - decl))))))
        let num = sin(toRad(targetAlt)) - sin(toRad(latitude)) * sin(toRad(decl))
        let den = cos(toRad(latitude)) * cos(toRad(decl))
        let hourAngle = toDeg(acos(num / den)) / 15.0
        return t + hourAngle
    }

    private func toRad(_ deg: Double) -> Double { deg * .pi / 180 }
    private func toDeg(_ rad: Double) -> Double { rad * 180 / .pi }

    private func dateFromHours(hours: Double, base: Date) -> Date {
        let cal = Calendar(identifier: .gregorian)
        let startOfDay = cal.startOfDay(for: base)
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        let s = Int(((hours - Double(h)) * 60 - Double(m)) * 60)
        return cal.date(byAdding: .init(hour: h, minute: m, second: s), to: startOfDay) ?? base
    }
}

// MARK: - Notification Service

class PrayerNotificationService {

    static let shared = PrayerNotificationService()
    private let calculator = PrayerTimesCalculator()

    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        return granted ?? false
    }

    func scheduleNotifications(for location: CLLocation, days: Int = 7) async {
        let center = UNUserNotificationCenter.current()

        // Remove old prayer notifications
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
            let times = calculator.calculate(
                for: date,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )

            let prayerTimes = [times.fajr, times.dhuhr, times.asr, times.maghrib, times.isha]

            for (i, prayer) in prayers.enumerated() {
                let content = UNMutableNotificationContent()
                content.title = "\(prayer.emoji) Il est l'heure de \(prayer.name)"
                content.body = "Allahu Akbar - La prière est meilleure que le sommeil 🤲"
                content.sound = .default
                content.badge = 1

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
