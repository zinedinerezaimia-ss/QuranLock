import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    @State private var showResetAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {

                        // MARK: - Profile Card
                        VStack(spacing: 12) {
                            Circle()
                                .fill(Theme.gold)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Text(String(appState.userName.prefix(1)).uppercased())
                                        .font(.title.bold())
                                        .foregroundColor(.black)
                                )
                            Text(appState.userName.isEmpty ? "Utilisateur" : appState.userName)
                                .font(.title3.bold()).foregroundColor(.white)

                            HStack(spacing: 20) {
                                statBlock("\(appState.hasanat)", "Hasanat", Theme.gold)
                                statBlock("\(appState.currentStreak)", "Jours", Theme.success)
                                statBlock("\(appState.completedSurahIndices.count)", "Sourates", Theme.accent)
                            }
                        }
                        .cardStyle()

                        // MARK: - Settings
                        VStack(alignment: .leading, spacing: 12) {
                            Text("⚙️ \(L.settings)")
                                .font(.headline).foregroundColor(Theme.gold)

                            // Name
                            HStack {
                                Image(systemName: "person.fill").foregroundColor(Theme.gold)
                                TextField(L.yourName, text: $appState.userName)
                                    .foregroundColor(.white)
                            }
                            .padding().background(Theme.secondaryBg).cornerRadius(10)

                            // Daily goal
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "target").foregroundColor(Theme.gold)
                                    Text("\(L.dailyGoal) : \(appState.dailyGoal) \(L.pages)")
                                        .foregroundColor(.white)
                                }
                                Slider(value: Binding(
                                    get: { Double(appState.dailyGoal) },
                                    set: { appState.dailyGoal = Int($0) }
                                ), in: 1...30, step: 1).tint(Theme.gold)
                            }
                            .padding().background(Theme.secondaryBg).cornerRadius(10)

                            // Ramadan toggle
                            Toggle(isOn: $appState.ramadanModeEnabled) {
                                HStack {
                                    Image(systemName: "moon.stars.fill").foregroundColor(Theme.ramadanGold)
                                    Text(L.ramadanMode).foregroundColor(.white)
                                }
                            }
                            .tint(Theme.gold)
                            .padding().background(Theme.secondaryBg).cornerRadius(10)
                        }
                        .cardStyle()

                        // MARK: - Language Selector
                        VStack(alignment: .leading, spacing: 12) {
                            Text(L.chooseLanguage)
                                .font(.headline).foregroundColor(Theme.gold)

                            HStack(spacing: 10) {
                                ForEach(AppLanguage.allCases, id: \.rawValue) { lang in
                                    Button(action: {
                                        withAnimation {
                                            languageManager.set(lang)
                                            appState.appLanguage = lang.rawValue
                                        }
                                    }) {
                                        Text(lang.displayName)
                                            .font(.caption.bold())
                                            .foregroundColor(languageManager.language == lang ? .black : .white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(languageManager.language == lang ? Theme.gold : Theme.secondaryBg)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .cardStyle()

                        // MARK: - Donation
                        VStack(alignment: .leading, spacing: 12) {
                            Text(L.supportUs)
                                .font(.headline).foregroundColor(Theme.gold)

                            Text(L.donationMsg)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)

                            Link(destination: URL(string: "https://buymeacoffee.com/quranlock")!) {
                                HStack {
                                    Text("☕")
                                    Text(L.donate)
                                        .font(.headline)
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color(red: 1.0, green: 0.81, blue: 0.27)) // buymeacoffee yellow
                                .cornerRadius(12)
                            }
                        }
                        .cardStyle()

                        // MARK: - About
                        VStack(alignment: .leading, spacing: 12) {
                            Text(L.about)
                                .font(.headline).foregroundColor(Theme.gold)
                            InfoRow(icon: "app.badge", label: L.version, value: "2.0.0")
                            InfoRow(icon: "building.2", label: L.developer, value: "Swift")
                        }
                        .cardStyle()

                        // MARK: - Danger Zone
                        VStack(spacing: 12) {
                            Text(L.dangerZone)
                                .font(.headline).foregroundColor(Theme.danger)
                            Button(action: { showResetAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text(L.resetAll)
                                }
                                .font(.subheadline)
                                .foregroundColor(Theme.danger)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.danger.opacity(0.1))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.danger.opacity(0.3), lineWidth: 1))
                            }
                        }
                        .cardStyle()
                    }
                    .padding()
                }
            }
            .navigationTitle(L.settings)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
            .alert(L.resetConfirm, isPresented: $showResetAlert) {
                Button(L.cancel, role: .cancel) {}
                Button(L.resetAll, role: .destructive) { appState.resetAll() }
            } message: {
                Text(L.resetMsg)
            }
        }
    }

    func statBlock(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack {
            Text(value).font(.title2.bold()).foregroundColor(color)
            Text(label).font(.caption).foregroundColor(Theme.textSecondary)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(Theme.gold).frame(width: 24)
            Text(label).foregroundColor(.white)
            Spacer()
            Text(value).foregroundColor(Theme.textSecondary)
        }
        .font(.subheadline)
    }
}
