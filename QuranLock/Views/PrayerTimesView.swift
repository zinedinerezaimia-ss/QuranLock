import SwiftUI
import CoreLocation

struct PrayerTimesView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @StateObject private var locationManager = LocationHelper()
    @StateObject private var prayerService = PrayerTimesService()
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        VStack(spacing: 8) {
                            Text("🕌").font(.system(size: 50))
                            Text(L.prayerTimes)
                                .font(.title2.bold()).foregroundColor(Theme.gold)

                            if prayerService.isLoading {
                                ProgressView().tint(Theme.gold)
                            }

                            if let error = prayerService.error {
                                Text(error).font(.caption).foregroundColor(.red)
                            }
                        }

                        // Next Prayer
                        if let times = prayerService.currentTimes, let next = times.nextPrayer {
                            VStack(spacing: 8) {
                                Text(L.nextPrayer)
                                    .font(.caption).foregroundColor(Theme.textSecondary)
                                Text("\(next.name) — \(next.arabic)")
                                    .font(.title.bold()).foregroundColor(Theme.gold)
                                Text(formatTime(next.time))
                                    .font(.title3).foregroundColor(.white)

                                if let remaining = times.timeUntilNext {
                                    Text(formatRemaining(remaining))
                                        .font(.caption).foregroundColor(Theme.accent)
                                }
                            }
                            .cardStyle()
                        }

                        // All prayer times
                        if let times = prayerService.currentTimes {
                            VStack(spacing: 0) {
                                ForEach(times.all, id: \.name) { prayer in
                                    let isNext = times.nextPrayer?.name == prayer.name

                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(prayer.name)
                                                .font(.headline)
                                                .foregroundColor(isNext ? Theme.gold : .white)
                                            Text(prayer.arabic)
                                                .font(.caption)
                                                .foregroundColor(Theme.textSecondary)
                                        }

                                        Spacer()

                                        Text(formatTime(prayer.time))
                                            .font(.headline)
                                            .foregroundColor(isNext ? Theme.gold : .white)

                                        if prayer.time < Date() && !isNext {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green).font(.caption)
                                        }
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(isNext ? Theme.gold.opacity(0.1) : Color.clear)

                                    if prayer.name != times.all.last?.name {
                                        Divider().background(Theme.cardBorder)
                                    }
                                }
                            }
                            .background(Theme.cardBg)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.cardBorder, lineWidth: 1))
                        }

                        // Notification settings
                        VStack(spacing: 12) {
                            Text(L.notifications).font(.headline).foregroundColor(Theme.gold)

                            Toggle(isOn: $appState.notificationsEnabled) {
                                HStack {
                                    Text("🔔")
                                    Text(L.prayerReminder).foregroundColor(.white)
                                }
                            }
                            .tint(Theme.gold)

                            Toggle(isOn: $appState.adhanEnabled) {
                                HStack {
                                    Text("🕌")
                                    Text(L.adhanNotif).foregroundColor(.white)
                                }
                            }
                            .tint(Theme.gold)

                            Button(action: scheduleNotifications) {
                                Text("Activer les notifications").goldButton()
                            }
                        }
                        .cardStyle()

                        // Method info
                        Text("Horaires basés sur la méthode UOIF (France) via Aladhan API")
                            .font(.caption2).foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
            .onAppear {
                locationManager.requestLocation()
            }
            .onChange(of: locationManager.location) { newLoc in
                if let loc = newLoc {
                    Task {
                        await prayerService.fetchPrayerTimes(
                            latitude: loc.coordinate.latitude,
                            longitude: loc.coordinate.longitude
                        )
                    }
                }
            }
        }
    }

    func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }

    func formatRemaining(_ interval: TimeInterval) -> String {
        let h = Int(interval) / 3600
        let m = (Int(interval) % 3600) / 60
        if h > 0 { return "Dans \(h)h\(String(format: "%02d", m))" }
        return "Dans \(m) min"
    }

    func scheduleNotifications() {
        guard let loc = locationManager.location else { return }
        Task {
            let granted = await PrayerNotificationService.shared.requestPermission()
            if granted {
                await PrayerNotificationService.shared.scheduleNotifications(
                    latitude: loc.coordinate.latitude,
                    longitude: loc.coordinate.longitude,
                    useAdhan: appState.adhanEnabled
                )
            }
        }
    }
}

// MARK: - Location Helper
class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        // Default: Asnières-sur-Seine
        location = CLLocation(latitude: 48.9147, longitude: 2.2879)
    }
}
