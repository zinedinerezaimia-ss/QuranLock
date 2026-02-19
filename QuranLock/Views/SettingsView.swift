import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showResetAlert = false
    @State private var showAbout = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Profile
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
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            HStack(spacing: 20) {
                                VStack {
                                    Text("\(appState.hasanat)")
                                        .font(.title2.bold())
                                        .foregroundColor(Theme.gold)
                                    Text("Hasanat")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                }
                                
                                VStack {
                                    Text("\(appState.currentStreak)")
                                        .font(.title2.bold())
                                        .foregroundColor(Theme.success)
                                    Text("Jours")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                }
                                
                                VStack {
                                    Text("\(appState.completedSurahIndices.count)")
                                        .font(.title2.bold())
                                        .foregroundColor(Theme.accent)
                                    Text("Sourates")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                        }
                        .cardStyle()
                        
                        // Settings sections
                        VStack(alignment: .leading, spacing: 12) {
                            Text("⚙️ Paramètres")
                                .font(.headline)
                                .foregroundColor(Theme.gold)
                            
                            // Name
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(Theme.gold)
                                TextField("Ton prénom", text: $appState.userName)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Theme.secondaryBg)
                            .cornerRadius(10)
                            
                            // Daily goal
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "target")
                                        .foregroundColor(Theme.gold)
                                    Text("Objectif quotidien : \(appState.dailyGoal) pages")
                                        .foregroundColor(.white)
                                }
                                
                                Slider(value: Binding(
                                    get: { Double(appState.dailyGoal) },
                                    set: { appState.dailyGoal = Int($0) }
                                ), in: 1...30, step: 1)
                                .tint(Theme.gold)
                            }
                            .padding()
                            .background(Theme.secondaryBg)
                            .cornerRadius(10)
                            
                            // Ramadan toggle
                            Toggle(isOn: $appState.ramadanModeEnabled) {
                                HStack {
                                    Image(systemName: "moon.stars.fill")
                                        .foregroundColor(Theme.ramadanGold)
                                    Text("Mode Ramadan")
                                        .foregroundColor(.white)
                                }
                            }
                            .tint(Theme.gold)
                            .padding()
                            .background(Theme.secondaryBg)
                            .cornerRadius(10)
                        }
                        .cardStyle()
                        
                        // App info
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ℹ️ À propos")
                                .font(.headline)
                                .foregroundColor(Theme.gold)
                            
                            InfoRow(icon: "app.badge", label: "Version", value: "1.0.0")
                            InfoRow(icon: "building.2", label: "Développeur", value: "Swift")
                        }
                        .cardStyle()
                        
                        // Danger zone
                        VStack(spacing: 12) {
                            Text("⚠️ Zone dangereuse")
                                .font(.headline)
                                .foregroundColor(Theme.danger)
                            
                            Button(action: { showResetAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Réinitialiser toutes les données")
                                }
                                .font(.subheadline)
                                .foregroundColor(Theme.danger)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.danger.opacity(0.1))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Theme.danger.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        .cardStyle()
                    }
                    .padding()
                }
            }
            .navigationTitle("Paramètres")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Theme.gold)
                }
            }
            .alert("Réinitialiser ?", isPresented: $showResetAlert) {
                Button("Annuler", role: .cancel) { }
                Button("Réinitialiser", role: .destructive) {
                    appState.resetAll()
                }
            } message: {
                Text("Toutes tes données (hasanat, progression, sourates lues) seront supprimées. Cette action est irréversible.")
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Theme.gold)
                .frame(width: 24)
            Text(label)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(Theme.textSecondary)
        }
        .font(.subheadline)
    }
}
