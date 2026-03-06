import SwiftUI

struct KhatmChallengeView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var completedCount: Int { appState.completedSurahIndices.count }
    var remainingCount: Int { 114 - completedCount }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("📖 Défi Khatm القرآن")
                            .font(.title2.bold())
                            .foregroundColor(Theme.gold)
                        
                        Text("Suis ta progression pour terminer la lecture complète du Coran")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        // Progress circle
                        ZStack {
                            Circle()
                                .stroke(Theme.cardBorder, lineWidth: 12)
                                .frame(width: 180, height: 180)
                            
                            Circle()
                                .trim(from: 0, to: appState.khatmProgress)
                                .stroke(Theme.gold, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                .frame(width: 180, height: 180)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut, value: appState.khatmProgress)
                            
                            Text("\(Int(appState.khatmProgress * 100))%")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .cardStyle()
                        
                        // Stats
                        HStack(spacing: 16) {
                            StatBox(value: "\(completedCount)", label: "Sourates\nlues", color: Theme.gold)
                            StatBox(value: "\(remainingCount)", label: "Restantes", color: Theme.textSecondary)
                            StatBox(value: "\(appState.currentStreak)", label: "Jours\nconsécutifs", color: Theme.success)
                        }
                        .cardStyle()
                        
                        // Next surah
                        if let nextSurah = DataProvider.surahs.first(where: { !appState.completedSurahIndices.contains($0.id) }) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("🔖 Prochaine sourate")
                                    .font(.headline)
                                    .foregroundColor(Theme.gold)
                                
                                HStack {
                                    Text("\(nextSurah.id)")
                                        .font(.caption.bold())
                                        .foregroundColor(.black)
                                        .frame(width: 28, height: 28)
                                        .background(Theme.gold)
                                        .cornerRadius(6)
                                    
                                    VStack(alignment: .leading) {
                                        Text(nextSurah.frenchName)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.white)
                                        Text("\(nextSurah.verseCount) versets")
                                            .font(.caption)
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(nextSurah.arabicName)
                                        .font(.headline)
                                        .foregroundColor(Theme.gold)
                                }
                                
                                Button(action: {
                                    appState.markSurahCompleted(nextSurah.id)
                                    appState.updateStreak()
                                }) {
                                    Text("Marquer comme lue ✓")
                                        .goldButton()
                                }
                            }
                            .cardStyle()
                        }
                        
                        // Completed list
                        if !appState.completedSurahIndices.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("📋 Sourates complétées")
                                    .font(.headline)
                                    .foregroundColor(Theme.gold)
                                
                                ForEach(appState.completedSurahIndices.sorted(), id: \.self) { id in
                                    if let surah = DataProvider.surahs.first(where: { $0.id == id }) {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(Theme.success)
                                            Text("\(surah.id). \(surah.frenchName)")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text(surah.arabicName)
                                                .font(.subheadline)
                                                .foregroundColor(Theme.textSecondary)
                                        }
                                    }
                                }
                            }
                            .cardStyle()
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Theme.gold)
                }
            }
        }
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title.bold())
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
