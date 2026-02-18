import SwiftUI

struct MusicChallengeView: View {
    @EnvironmentObject var challengeManager: MusicChallengeManager
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlatform: MusicChallengeManager.MusicPlatform = .spotify
    @State private var selectedDuration: MusicChallengeManager.ChallengeDuration = .thirtyDays
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if challengeManager.isActive {
                            activeChallengeView
                        } else {
                            setupView
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }
    
    var activeChallengeView: some View {
        VStack(spacing: 20) {
            Text("🎵➡️📖").font(.system(size: 50))
            
            Text("Défi Musique en cours")
                .font(.title2.bold()).foregroundColor(Theme.gold)
            
            Text("Remplace la musique par le Coran")
                .font(.subheadline).foregroundColor(Theme.textSecondary)
            
            // Progress circle
            ZStack {
                Circle()
                    .stroke(Theme.cardBorder, lineWidth: 10)
                    .frame(width: 160, height: 160)
                Circle()
                    .trim(from: 0, to: challengeManager.progress)
                    .stroke(Theme.gold, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: challengeManager.progress)
                VStack {
                    Text("\(challengeManager.daysCompleted)")
                        .font(.system(size: 36, weight: .bold)).foregroundColor(.white)
                    Text("/ \(challengeManager.challengeDuration.rawValue) jours")
                        .font(.caption).foregroundColor(Theme.textSecondary)
                }
            }
            .cardStyle()
            
            // Stats
            HStack(spacing: 16) {
                VStack {
                    Text("\(challengeManager.daysRemaining)")
                        .font(.title.bold()).foregroundColor(Theme.gold)
                    Text("Jours\nrestants").font(.caption)
                        .foregroundColor(Theme.textSecondary).multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(Int(challengeManager.progress * 100))%")
                        .font(.title.bold()).foregroundColor(Theme.success)
                    Text("Progression").font(.caption).foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text(challengeManager.selectedPlatform?.icon ?? "🎵").font(.title)
                    Text(challengeManager.selectedPlatform?.rawValue ?? "")
                        .font(.caption).foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
            }
            .cardStyle()
            
            // Daily check-in
            if !challengeManager.hasCheckedInToday {
                Button(action: {
                    challengeManager.checkInToday()
                    appState.addHasanat(5)
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text("Check-in aujourd'hui ✅")
                    }
                    .goldButton()
                }
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success)
                    Text("Check-in fait aujourd'hui ! MashaAllah 🤲").foregroundColor(Theme.success)
                }
                .font(.subheadline).cardStyle()
            }
            
            // Motivation
            VStack(spacing: 8) {
                Text("💡 Rappel").font(.headline).foregroundColor(Theme.gold)
                Text("Le Prophète ﷺ a dit : « Celui qui lit le Coran avec aisance sera avec les anges nobles et vertueux. »")
                    .font(.subheadline).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center)
                Text("— Sahih al-Bukhari & Muslim")
                    .font(.caption).foregroundColor(Theme.accent)
            }
            .cardStyle()
            
            Button(action: { challengeManager.abandonChallenge() }) {
                Text("Abandonner le défi").font(.caption).foregroundColor(Theme.danger)
            }
        }
    }
    
    var setupView: some View {
        VStack(spacing: 20) {
            Text("🎵 ➡️ 📖").font(.system(size: 50))
            
            Text("Défi : Remplace la musique")
                .font(.title2.bold()).foregroundColor(Theme.gold)
            
            Text("Écouter le Coran plutôt que de la musique est un acte d'adoration.")
                .font(.subheadline).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center)
            
            // Platform selection
            VStack(alignment: .leading, spacing: 12) {
                Text("🎧 Ta plateforme principale").font(.headline).foregroundColor(Theme.gold)
                
                ForEach(MusicChallengeManager.MusicPlatform.allCases) { platform in
                    Button(action: { selectedPlatform = platform }) {
                        HStack {
                            Text(platform.icon).font(.title3)
                            Text(platform.rawValue).font(.subheadline).foregroundColor(.white)
                            Spacer()
                            if selectedPlatform == platform {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.gold)
                            }
                        }
                        .padding()
                        .background(selectedPlatform == platform ? Theme.gold.opacity(0.1) : Theme.secondaryBg)
                        .cornerRadius(10)
                    }
                }
            }
            .cardStyle()
            
            // Duration
            VStack(alignment: .leading, spacing: 12) {
                Text("⏱️ Durée du défi").font(.headline).foregroundColor(Theme.gold)
                
                HStack(spacing: 8) {
                    ForEach(MusicChallengeManager.ChallengeDuration.allCases) { dur in
                        Button(action: { selectedDuration = dur }) {
                            VStack {
                                Text("\(dur.rawValue)").font(.headline)
                                Text("jours").font(.caption2)
                            }
                            .foregroundColor(selectedDuration == dur ? .black : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedDuration == dur ? Theme.gold : Theme.secondaryBg)
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .cardStyle()
            
            // Start button
            Button(action: {
                challengeManager.startChallenge(platform: selectedPlatform, duration: selectedDuration)
                appState.addHasanat(10)
            }) {
                Text("Commencer le défi بسم الله").goldButton()
            }
            
            Text("Tu recevras des hasanat pour chaque jour de check-in 🤲")
                .font(.caption).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center)
        }
    }
}
