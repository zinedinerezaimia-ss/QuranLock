import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var editingName = false
    @State private var tempName = ""
    
    var isRamadan: Bool { appState.ramadanManager.isRamadan }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile
                    VStack(spacing: 12) {
                        Text("👤")
                            .font(.system(size: 50))
                        
                        if editingName {
                            HStack {
                                TextField("Prénom", text: $tempName)
                                    .textFieldStyle(.roundedBorder)
                                Button("OK") {
                                    appState.userName = tempName
                                    appState.save()
                                    editingName = false
                                }
                                .foregroundColor(Theme.primary(isRamadan: isRamadan))
                            }
                            .padding(.horizontal, 40)
                        } else {
                            HStack {
                                Text(appState.userName)
                                    .font(.title2.bold())
                                    .foregroundColor(Theme.textPrimary)
                                Button(action: {
                                    tempName = appState.userName
                                    editingName = true
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    // Daily Goal
                    settingsCard(title: "Objectif quotidien") {
                        Stepper("\(appState.dailyGoalPages) pages / jour", value: Binding(
                            get: { appState.dailyGoalPages },
                            set: { newVal in
                                appState.dailyGoalPages = newVal
                                appState.save()
                            }
                        ), in: 1...50)
                        .foregroundColor(Theme.textPrimary)
                    }
                    
                    // Stats
                    settingsCard(title: "Statistiques") {
                        VStack(spacing: 10) {
                            statRow("Pages lues aujourd'hui", "\(appState.pagesReadToday)")
                            statRow("Total pages lues", "\(appState.totalPagesRead)")
                            statRow("Jours consécutifs", "\(appState.streakDays)")
                            statRow("Sourate actuelle", "\(appState.currentSurah)/114")
                        }
                    }
                    
                    // Ramadan Info
                    if isRamadan {
                        settingsCard(title: "🌙 Ramadan 2026") {
                            VStack(spacing: 10) {
                                statRow("Jour", "\(appState.ramadanManager.currentDay)/30")
                                statRow("Jours restants", "\(appState.ramadanManager.daysRemaining)")
                                statRow("10 dernières nuits", appState.ramadanManager.isLastTenNights ? "OUI ⭐" : "Non")
                                statRow("Fajr", appState.ramadanManager.fajrTime)
                                statRow("Maghrib", appState.ramadanManager.maghribTime)
                            }
                        }
                    }
                    
                    // Reset
                    Button(action: {
                        appState.pagesReadToday = 0
                        appState.save()
                    }) {
                        Text("Réinitialiser les pages du jour")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red.opacity(0.1))
                            )
                    }
                    
                    // About
                    VStack(spacing: 6) {
                        Text("QuranLock V4")
                            .font(.caption.bold())
                            .foregroundColor(Theme.textSecondary)
                        Text("Par ZETA Entreprise")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                        Text("© 2026 - Tous droits réservés")
                            .font(.caption2)
                            .foregroundColor(Theme.textSecondary.opacity(0.5))
                    }
                    .padding()
                }
                .padding(.horizontal)
            }
            .background(Theme.background(isRamadan: isRamadan).ignoresSafeArea())
            .navigationTitle("⚙️ Réglages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func settingsCard(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.primary(isRamadan: isRamadan))
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.card(isRamadan: isRamadan))
        )
    }
    
    func statRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(Theme.textPrimary)
        }
    }
}
