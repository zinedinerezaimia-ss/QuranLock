import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    @State private var showResetAlert = false
    @State private var showDonation = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Language
                        VStack(alignment: .leading, spacing: 12) {
                            Text(L.chooseLanguage)
                                .font(.headline).foregroundColor(Theme.gold)

                            ForEach(AppLanguage.allCases, id: \.rawValue) { lang in
                                Button(action: {
                                    languageManager.set(lang)
                                    appState.appLanguage = lang.rawValue
                                }) {
                                    HStack {
                                        Text(lang.displayName)
                                            .foregroundColor(languageManager.language == lang ? .black : .white)
                                        Spacer()
                                        if languageManager.language == lang {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .padding(12)
                                    .background(languageManager.language == lang ? Theme.gold : Theme.secondaryBg)
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .cardStyle()

                        // Daily goal
                        VStack(alignment: .leading, spacing: 8) {
                            Text(L.dailyGoal)
                                .font(.headline).foregroundColor(Theme.gold)
                            Stepper("\(appState.dailyGoal) \(L.pages)", value: $appState.dailyGoal, in: 1...50)
                                .foregroundColor(.white)
                        }
                        .cardStyle()

                        // Notifications
                        VStack(alignment: .leading, spacing: 12) {
                            Text(L.notifications)
                                .font(.headline).foregroundColor(Theme.gold)

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
                        }
                        .cardStyle()

                        // Ramadan Mode
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle(isOn: $appState.ramadanModeEnabled) {
                                HStack {
                                    Text("🌙")
                                    Text(L.ramadanMode).foregroundColor(.white)
                                }
                            }
                            .tint(Theme.gold)
                        }
                        .cardStyle()

                        // About
                        VStack(alignment: .leading, spacing: 8) {
                            Text(L.about).font(.headline).foregroundColor(Theme.gold)
                            HStack {
                                Text(L.version).foregroundColor(Theme.textSecondary)
                                Spacer()
                                Text("3.0").foregroundColor(.white)
                            }
                            HStack {
                                Text(L.developer).foregroundColor(Theme.textSecondary)
                                Spacer()
                                Text("ZETA Entreprise").foregroundColor(.white)
                            }
                        }
                        .cardStyle()

                        // Support
                        VStack(spacing: 12) {
                            Text(L.supportUs).font(.headline).foregroundColor(Theme.gold)
                            Text(L.donationMsg)
                                .font(.caption).foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                            Button(action: { showDonation = true }) {
                                Text(L.donate).goldButton()
                            }
                        }
                        .cardStyle()

                        // Danger zone
                        VStack(spacing: 12) {
                            Text(L.dangerZone).font(.headline).foregroundColor(.red)
                            Button(action: { showResetAlert = true }) {
                                Text(L.resetAll)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(10)
                            }
                        }
                        .cardStyle()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle(L.settings)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
            .alert(L.resetConfirm, isPresented: $showResetAlert) {
                Button(L.cancel, role: .cancel) { }
                Button(L.resetAll, role: .destructive) { appState.resetAll() }
            } message: {
                Text(L.resetMsg)
            }
            .sheet(isPresented: $showDonation) {
                DonationView()
            }
        }
    }
}
