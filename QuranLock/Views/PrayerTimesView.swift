import SwiftUI
import CoreLocation

// MARK: - Location Manager

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var cityName: String = ""
    @Published var authStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func request() {
        locationError = nil
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            locationError = "Localisation refusée. Allez dans Réglages > Confidentialité > Services de localisation."
        @unknown default:
            manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        // Only accept locations less than 5 minutes old
        guard abs(loc.timestamp.timeIntervalSinceNow) < 300 else { return }
        self.location = loc
        self.locationError = nil
        manager.stopUpdatingLocation()

        CLGeocoder().reverseGeocodeLocation(loc) { placemarks, _ in
            DispatchQueue.main.async {
                self.cityName = placemarks?.first?.locality ?? placemarks?.first?.country ?? "Votre position"
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                locationError = "Localisation refusée. Activez-la dans les Réglages."
            case .locationUnknown:
                // Temporary error, keep trying
                break
            default:
                locationError = "Erreur de localisation. Réessayez."
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = manager.authorizationStatus
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
            locationError = nil
            manager.startUpdatingLocation()
        } else if authStatus == .denied {
            locationError = "Localisation refusée. Activez-la dans Réglages > Confidentialité."
        }
    }
}

// MARK: - PrayerTimesView

struct PrayerTimesView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var prayerTimes: PrayerTimes?
    @State private var isLoadingTimes = false
    @State private var notificationsEnabled = false
    @State private var now = Date()
    @State private var showMosqueFinder = false

    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "0D0D1A"), Color(hex: "1A1A2E")],
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        headerCard

                        // Error state
                        if let error = locationManager.locationError {
                            errorCard(message: error)
                        }

                        // Loading state
                        if isLoadingTimes && prayerTimes == nil {
                            loadingCard
                        }

                        // Next prayer countdown
                        if let times = prayerTimes, let next = times.nextPrayer {
                            nextPrayerCard(prayer: next)
                        }

                        // Hijri date
                        if let hijri = prayerTimes?.hijriDate {
                            hijriCard(date: hijri)
                        }

                        // All prayers list
                        if let times = prayerTimes {
                            allPrayersCard(times: times)
                        }

                        // Mosque finder button
                        mosquesButton

                        // Notifications toggle
                        notificationsCard

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Prières")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                locationManager.request()
            }
            .onChange(of: locationManager.location) { loc in
                if let loc = loc {
                    fetchTimes(location: loc)
                }
            }
            .onReceive(timer) { _ in
                now = Date()
            }
            .sheet(isPresented: $showMosqueFinder) {
                if let loc = locationManager.location {
                    MosqueFinderView(userLocation: loc, prayerTimes: prayerTimes)
                }
            }
        }
    }

    // MARK: - Subviews

    private var headerCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate())
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "9090A0"))
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(Color(hex: "C9A84C"))
                    Text(locationManager.cityName.isEmpty ? "Localisation en cours..." : locationManager.cityName)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            Spacer()
            if locationManager.location == nil && locationManager.locationError == nil {
                ProgressView()
                    .tint(Color(hex: "C9A84C"))
            } else if locationManager.location != nil {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
            }
        }
        .padding(16)
        .background(Color(hex: "1A1A2E"))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "C9A84C").opacity(0.3), lineWidth: 1))
    }

    private func errorCard(message: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
            Button("Réessayer") {
                locationManager.request()
            }
            .font(.caption.bold())
            .foregroundColor(Color(hex: "C9A84C"))
        }
        .padding(14)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }

    private var loadingCard: some View {
        HStack(spacing: 12) {
            ProgressView()
                .tint(Color(hex: "C9A84C"))
            Text("Chargement des horaires...")
                .font(.subheadline)
                .foregroundColor(Color(hex: "9090A0"))
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "1A1A2E"))
        .cornerRadius(16)
    }

    private func hijriCard(date: String) -> some View {
        HStack {
            Image(systemName: "moon.stars.fill")
                .foregroundColor(Color(hex: "C9A84C"))
            Text(date)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(12)
        .background(Color(hex: "C9A84C").opacity(0.1))
        .cornerRadius(12)
    }

    private func nextPrayerCard(prayer: (name: String, arabic: String, time: Date)) -> some View {
        let remaining = prayer.time.timeIntervalSince(now)
        let hours = Int(remaining) / 3600
        let minutes = Int(remaining) % 3600 / 60

        return VStack(spacing: 12) {
            Text("Prochaine prière")
                .font(.caption)
                .foregroundColor(Color(hex: "9090A0"))
            Text(prayer.arabic)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "C9A84C"))
            Text(prayer.name)
                .font(.title3.bold())
                .foregroundColor(.white)
            Text(formatTime(prayer.time))
                .font(.system(size: 36, weight: .black))
                .foregroundColor(.white)

            HStack(spacing: 4) {
                Text(hours > 0 ? "\(hours)h \(minutes)min" : "\(minutes) min")
                    .font(.subheadline.bold())
                    .foregroundColor(remaining < 600 ? .red : Color(hex: "C9A84C"))
                Text("restantes")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "9090A0"))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "C9A84C"))
                        .frame(width: geo.size.width * progressToNext(), height: 6)
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 20)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color(hex: "1A1A2E"), Color(hex: "C9A84C").opacity(0.15)],
                startPoint: .top, endPoint: .bottom
            )
        )
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(hex: "C9A84C").opacity(0.5), lineWidth: 1))
    }

    private func allPrayersCard(times: PrayerTimes) -> some View {
        VStack(spacing: 0) {
            Text("Horaires du jour")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)

            ForEach(times.all.indices, id: \.self) { i in
                let prayer = times.all[i]
                let isPassed = prayer.time < now
                let isNext = times.nextPrayer?.name == prayer.name

                HStack {
                    Text(prayer.arabic)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isNext ? Color(hex: "C9A84C") : .white)
                        .frame(width: 70, alignment: .trailing)

                    Spacer()

                    Text(prayer.name)
                        .font(.subheadline)
                        .foregroundColor(isPassed ? Color(hex: "9090A0") : .white)

                    Spacer()

                    Text(formatTime(prayer.time))
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(isNext ? Color(hex: "C9A84C") : (isPassed ? Color(hex: "9090A0") : .white))

                    if isPassed {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green.opacity(0.7))
                            .font(.caption)
                    } else if isNext {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color(hex: "C9A84C"))
                            .font(.system(size: 8))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(isNext ? Color(hex: "C9A84C").opacity(0.1) : Color.clear)

                if i < times.all.count - 1 {
                    Divider()
                        .background(Color.white.opacity(0.05))
                        .padding(.horizontal, 16)
                }
            }
            .padding(.bottom, 12)
        }
        .background(Color(hex: "1A1A2E"))
        .cornerRadius(16)
    }

    private var mosquesButton: some View {
        Button(action: {
            if locationManager.location != nil {
                showMosqueFinder = true
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "building.columns.fill")
                    .font(.title3)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Mosquées à proximité")
                        .font(.headline)
                    Text("Temps de trajet + compte à rebours")
                        .font(.caption)
                        .opacity(0.7)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            .padding(16)
            .background(Color(hex: "7C3AED").opacity(0.8))
            .cornerRadius(16)
        }
        .disabled(locationManager.location == nil)
        .opacity(locationManager.location == nil ? 0.5 : 1)
    }

    private var notificationsCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Rappels de prière")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Notification à chaque heure de prière")
                    .font(.caption)
                    .foregroundColor(Color(hex: "9090A0"))
            }
            Spacer()
            Toggle("", isOn: $notificationsEnabled)
                .tint(Color(hex: "C9A84C"))
                .onChange(of: notificationsEnabled) { enabled in
                    Task {
                        if enabled {
                            let granted = await PrayerNotificationService.shared.requestPermission()
                            if granted, let loc = locationManager.location {
                                await PrayerNotificationService.shared.scheduleNotifications(
                                    latitude: loc.coordinate.latitude,
                                    longitude: loc.coordinate.longitude
                                )
                            } else {
                                notificationsEnabled = false
                            }
                        } else {
                            PrayerNotificationService.shared.cancelAll()
                        }
                    }
                }
        }
        .padding(16)
        .background(Color(hex: "1A1A2E"))
        .cornerRadius(16)
    }

    // MARK: - Helpers

    private func fetchTimes(location: CLLocation) {
        isLoadingTimes = true
        Task {
            let times = await PrayerTimesService.shared.fetchPrayerTimes(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            await MainActor.run {
                self.prayerTimes = times
                self.isLoadingTimes = false
            }
        }
    }

    private func progressToNext() -> Double {
        guard let times = prayerTimes,
              let next = times.nextPrayer,
              let nextIdx = times.all.firstIndex(where: { $0.name == next.name }),
              nextIdx > 0 else { return 0.5 }

        let prev = times.all[nextIdx - 1]
        let total = next.time.timeIntervalSince(prev.time)
        let elapsed = now.timeIntervalSince(prev.time)
        return max(0, min(1, elapsed / total))
    }

    private func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.dateFormat = "EEEE d MMMM yyyy"
        return f.string(from: Date()).capitalized
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
