import SwiftUI

struct RamadanSurahsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("⭐ Sourates Recommandées")
                    .font(.title2.bold())
                    .foregroundColor(Theme.ramadanGold)
                    .padding(.top)
                
                Text("Le Prophète ﷺ recommandait particulièrement ces sourates")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                
                ForEach(RecommendedSurahsData.surahs) { surah in
                    surahDetailCard(surah)
                }
            }
            .padding(.horizontal)
        }
        .background(Theme.ramadanDarkBg.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func surahDetailCard(_ surah: RecommendedSurah) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(surah.name)
                        .font(.headline.bold())
                        .foregroundColor(Theme.ramadanGold)
                    Text(surah.arabicName)
                        .font(.title)
                        .foregroundColor(Theme.textPrimary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(surah.versesCount) versets")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Image(systemName: "star.fill")
                        .foregroundColor(Theme.ramadanGold)
                }
            }
            
            Divider().background(Theme.ramadanGold.opacity(0.3))
            
            // Theme
            HStack(alignment: .top) {
                Image(systemName: "text.book.closed")
                    .foregroundColor(Theme.ramadanAccent)
                Text(surah.theme)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            
            // Why read
            VStack(alignment: .leading, spacing: 4) {
                Text("📜 Pourquoi la lire ?")
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.ramadanGold)
                Text(surah.whyRead)
                    .font(.caption)
                    .foregroundColor(Theme.textPrimary.opacity(0.85))
            }
            
            // Key verses
            VStack(alignment: .leading, spacing: 10) {
                Text("🔑 Versets clés")
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.ramadanGold)
                
                ForEach(surah.keyVerses) { verse in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Verset \(verse.verseNumber)")
                                .font(.caption.bold())
                                .foregroundColor(Theme.ramadanAccent)
                            Spacer()
                        }
                        Text(verse.arabic)
                            .font(.title3)
                            .foregroundColor(Theme.textPrimary)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(verse.translation)
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                            .italic()
                        Text(verse.explanation)
                            .font(.caption)
                            .foregroundColor(Theme.textPrimary.opacity(0.7))
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Theme.ramadanPurple.opacity(0.3))
                    )
                }
            }
            
            // Reward
            HStack {
                Image(systemName: "gift.fill")
                    .foregroundColor(Theme.ramadanGold)
                Text("Récompense: \(surah.reward)")
                    .font(.caption.bold())
                    .foregroundColor(Theme.ramadanGold)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Theme.ramadanGold.opacity(0.15))
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.ramadanCardBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.ramadanGold.opacity(0.2), lineWidth: 1)
                )
        )
    }
}
