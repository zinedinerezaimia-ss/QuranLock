import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var locationHelper = LocationHelper()
    @StateObject private var prayerService = PrayerTimesService()
    @State private var showSettings = false
    @State private var showPrayerTimes = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Greeting
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(L.salam)
                                    .font(.title.bold())
                                    .foregroundColor(Theme.gold)
                                if !appState.userName.isEmpty {
                                    Text(appState.userName)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }
                            }
                            Spacer()
                            Button(action: { showSettings = true }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.title2)
                                    .foregroundColor(Theme.gold)
                            }
                        }
                        .padding(.horizontal, 4)

                        // Stats
                        HStack(spacing: 12) {
                            statCard(icon: "🔥", value: "\(appState.currentStreak)", label: "\(L.streak) (\(L.days))")
                            statCard(icon: "⭐", value: "\(appState.hasanat)", label: L.hasanatLabel)
                        }

                        // Next Prayer
                        if let times = prayerService.currentTimes, let next = times.nextPrayer {
                            Button(action: { showPrayerTimes = true }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(L.nextPrayer)
                                            .font(.caption).foregroundColor(Theme.textSecondary)
                                        Text("\(next.name) — \(next.arabic)")
                                            .font(.headline).foregroundColor(Theme.gold)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text(formatTime(next.time))
                                            .font(.title2.bold()).foregroundColor(.white)
                                        if let remaining = times.timeUntilNext {
                                            Text(formatRemaining(remaining))
                                                .font(.caption).foregroundColor(Theme.accent)
                                        }
                                    }
                                }
                                .cardStyle()
                            }
                        }

                        // Quick Actions
                        VStack(alignment: .leading, spacing: 10) {
                            Text(L.quickActions)
                                .font(.headline).foregroundColor(Theme.gold)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                quickAction(icon: "📖", title: L.quran) { appState.selectedTab = 1 }
                                quickAction(icon: "🤲", title: L.duaas) { appState.selectedTab = 3 }
                                quickAction(icon: "🕌", title: L.prayerTimes) { showPrayerTimes = true }
                                quickAction(icon: "🎓", title: L.learn) { appState.selectedTab = 2 }
                            }
                        }

                        // Daily reminder
                        VStack(spacing: 8) {
                            Text("💡")
                                .font(.system(size: 30))
                            Text("« La meilleure des actions est celle qui est régulière, même si elle est peu abondante. »")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                            Text("— Sahih al-Bukhari & Muslim")
                                .font(.caption2)
                                .foregroundColor(Theme.accent)

                            Button(action: {
                                AppState.shareText("« La meilleure des actions est celle qui est régulière, même si elle est peu abondante. »\n— Sahih al-Bukhari & Muslim\n\nPartagé depuis l'app Iqra 🤲")
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "square.and.arrow.up")
                                    Text(L.share)
                                }
                                .font(.caption).foregroundColor(Theme.gold)
                            }
                        }
                        .cardStyle()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(appState)
                    .environmentObject(languageManager)
            }
            .sheet(isPresented: $showPrayerTimes) {
                PrayerTimesView()
                    .environmentObject(appState)
            }
            .onAppear {
                locationHelper.requestLocation()
            }
            .onChange(of: locationHelper.location) { loc in
                if let loc = loc {
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

    func statCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Text(icon).font(.title2)
            Text(value).font(.title.bold()).foregroundColor(.white)
            Text(label).font(.caption).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Theme.cardBg)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
    }

    func quickAction(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(icon).font(.system(size: 28))
                Text(title).font(.caption.bold()).foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Theme.cardBg)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
        }
    }

    func formatTime(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "HH:mm"; return f.string(from: date)
    }

    func formatRemaining(_ interval: TimeInterval) -> String {
        let h = Int(interval) / 3600; let m = (Int(interval) % 3600) / 60
        if h > 0 { return "Dans \(h)h\(String(format: "%02d", m))" }
        return "Dans \(m) min"
    }
}
