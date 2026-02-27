import SwiftUI

struct AdhanSettingsView: View {
    @StateObject private var adhan = AdhanService.shared

    let prayers = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
    let prayerEmojis = ["🌙", "☀️", "🌤️", "🌅", "🌑"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🔔 Adhan")
                .font(.headline).foregroundColor(Theme.gold)

            HStack {
                Text("Activer l'adhan").foregroundColor(.white)
                Spacer()
                Toggle("", isOn: $adhan.adhanEnabled)
                    .tint(Theme.gold)
                    .onChange(of: adhan.adhanEnabled) { enabled in
                        adhan.savePreferences()
                        if enabled { Task { await adhan.downloadAdhanIfNeeded() } }
                        else { adhan.cancelAllAdhan() }
                    }
            }
            .padding().background(Theme.secondaryBg).cornerRadius(10)

            if adhan.adhanEnabled {
                if adhan.isDownloading {
                    HStack {
                        ProgressView().tint(Theme.gold)
                        Text("Téléchargement...").font(.caption).foregroundColor(Theme.textSecondary)
                    }
                } else if adhan.isDownloaded {
                    HStack {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success)
                        Text("Adhan prêt").font(.caption).foregroundColor(Theme.success)
                        Spacer()
                        Button(action: { adhan.playAdhan() }) {
                            Label("Tester", systemImage: "play.fill")
                                .font(.caption).padding(.horizontal, 10).padding(.vertical, 5)
                                .background(Theme.gold.opacity(0.2)).cornerRadius(8)
                                .foregroundColor(Theme.gold)
                        }
                    }
                } else {
                    Button(action: { Task { await adhan.downloadAdhanIfNeeded() } }) {
                        Label("Télécharger l'adhan", systemImage: "arrow.down.circle.fill")
                            .font(.caption).padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Theme.accent.opacity(0.2)).cornerRadius(8)
                            .foregroundColor(Theme.accent)
                    }
                }

                ForEach(Array(prayers.enumerated()), id: \.offset) { index, prayer in
                    HStack {
                        Text(prayerEmojis[index])
                        Text(prayer).foregroundColor(.white)
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { adhan.adhanPerPrayer[prayer] ?? true },
                            set: { val in
                                adhan.adhanPerPrayer[prayer] = val
                                adhan.savePreferences()
                            }
                        )).tint(Theme.gold)
                    }
                    .padding(.horizontal).padding(.vertical, 8)
                    .background(Theme.secondaryBg).cornerRadius(10)
                }
            }
        }
        .onAppear {
            if adhan.adhanEnabled && !adhan.isDownloaded {
                Task { await adhan.downloadAdhanIfNeeded() }
            }
        }
    }
}
