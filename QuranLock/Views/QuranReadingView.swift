import SwiftUI

struct QuranReadingView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedSurah: Surah? = nil
    
    var isRamadan: Bool { appState.ramadanManager.isRamadan }
    
    var filteredSurahs: [Surah] {
        if searchText.isEmpty {
            return SurahData.allSurahs
        }
        return SurahData.allSurahs.filter {
            $0.nameFr.localizedCaseInsensitiveContains(searchText) ||
            $0.nameEn.localizedCaseInsensitiveContains(searchText) ||
            $0.name.contains(searchText) ||
            "\($0.id)" == searchText
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Theme.textSecondary)
                    TextField("Rechercher une sourate...", text: $searchText)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Theme.card(isRamadan: isRamadan))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Ramadan recommended banner
                if isRamadan && searchText.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Text("🌙 Recommandées:")
                                .font(.caption.bold())
                                .foregroundColor(Theme.ramadanGold)
                            ForEach(["Al-Baqara", "Ya-Sin", "Al-Mulk"], id: \.self) { name in
                                Text(name)
                                    .font(.caption.bold())
                                    .foregroundColor(Theme.ramadanGold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Theme.ramadanPurple.opacity(0.5))
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
                
                // Surah list
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(filteredSurahs) { surah in
                            Button(action: {
                                selectedSurah = surah
                                appState.currentSurah = surah.id
                                appState.save()
                            }) {
                                surahRow(surah)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Theme.background(isRamadan: isRamadan).ignoresSafeArea())
            .navigationTitle("📖 Coran")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedSurah) { surah in
                SurahDetailSheet(surah: surah)
            }
        }
    }
    
    func surahRow(_ surah: Surah) -> some View {
        HStack(spacing: 14) {
            // Number
            ZStack {
                Image(systemName: "diamond.fill")
                    .font(.title)
                    .foregroundColor(surah.isRecommendedRamadan && isRamadan ? Theme.ramadanGold : Theme.primary(isRamadan: isRamadan))
                    .opacity(0.3)
                Text("\(surah.id)")
                    .font(.caption.bold())
                    .foregroundColor(Theme.textPrimary)
            }
            .frame(width: 40, height: 40)
            
            // Info
            VStack(alignment: .leading, spacing: 2) {
                Text(surah.nameFr)
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.textPrimary)
                Text("\(surah.revelationType) • \(surah.versesCount) versets")
                    .font(.caption2)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            // Arabic name
            VStack(alignment: .trailing, spacing: 2) {
                Text(surah.name)
                    .font(.title3)
                    .foregroundColor(Theme.textPrimary)
                if surah.isRecommendedRamadan && isRamadan {
                    Text("⭐ Ramadan")
                        .font(.caption2)
                        .foregroundColor(Theme.ramadanGold)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(surah.id == appState.currentSurah ? Theme.primary(isRamadan: isRamadan).opacity(0.15) : Color.clear)
        )
    }
}

// MARK: - Surah Detail Sheet
struct SurahDetailSheet: View {
    let surah: Surah
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text(surah.name)
                            .font(.largeTitle)
                            .foregroundColor(Theme.textPrimary)
                        Text(surah.nameFr)
                            .font(.title2)
                            .foregroundColor(Theme.primaryGreen)
                        Text(surah.nameEn)
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        HStack {
                            Text(surah.revelationType)
                            Text("•")
                            Text("\(surah.versesCount) versets")
                        }
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.top, 20)
                    
                    // Bismillah
                    if surah.id != 9 {
                        Text("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
                            .font(.title)
                            .foregroundColor(Theme.textPrimary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Theme.cardBackground)
                            )
                    }
                    
                    // Phonetic sample
                    VStack(spacing: 8) {
                        Text("Début:")
                            .font(.caption.bold())
                            .foregroundColor(Theme.textSecondary)
                        Text(surah.phonetic)
                            .font(.title3.italic())
                            .foregroundColor(Theme.primaryGreen)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.cardBackground)
                    )
                    
                    Text("Ouvre le Coran complet pour lire la sourate dans son intégralité. QuranLock est un compagnon de lecture, pas un mushaf numérique complet.")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding(.horizontal)
            }
            .background(Theme.darkBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Theme.primaryGreen)
                }
            }
        }
    }
}
