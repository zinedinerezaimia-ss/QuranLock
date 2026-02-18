import SwiftUI

struct QuranReadingView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ramadanManager: RamadanManager
    @State private var searchText = ""
    @State private var selectedSurah: Surah?
    @State private var showKhatm = false
    
    var filteredSurahs: [Surah] {
        if searchText.isEmpty { return DataProvider.surahs }
        return DataProvider.surahs.filter {
            $0.frenchName.localizedCaseInsensitiveContains(searchText) ||
            $0.arabicName.contains(searchText) ||
            $0.phonetic.localizedCaseInsensitiveContains(searchText) ||
            "\($0.id)".contains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12) {
                        // Khatm Challenge Card
                        khatmCard
                        
                        // Ramadan recommended
                        if ramadanManager.isRamadan {
                            recommendedSection
                        }
                        
                        // Search
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Theme.textSecondary)
                            TextField("Rechercher une sourate...", text: $searchText)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Theme.cardBg)
                        .cornerRadius(12)
                        
                        // Surah list
                        LazyVStack(spacing: 8) {
                            ForEach(filteredSurahs) { surah in
                                SurahRow(surah: surah, isCompleted: appState.completedSurahIndices.contains(surah.id))
                                    .onTapGesture { selectedSurah = surah }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Coran")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedSurah) { surah in
                SurahDetailSheet(surah: surah)
            }
            .sheet(isPresented: $showKhatm) {
                KhatmChallengeView()
            }
        }
    }
    
    var khatmCard: some View {
        Button(action: { showKhatm = true }) {
            VStack(spacing: 8) {
                HStack {
                    Text("📖 Défi Khatm القرآن")
                        .font(.headline)
                        .foregroundColor(Theme.gold)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.textSecondary)
                }
                
                ProgressView(value: appState.khatmProgress)
                    .tint(Theme.gold)
                
                HStack {
                    Text("\(appState.completedSurahIndices.count) / 114 sourates")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("\(Int(appState.khatmProgress * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(Theme.gold)
                }
            }
            .cardStyle()
        }
    }
    
    var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("⭐ Sourates recommandées pour le Ramadan")
                .font(.subheadline.bold())
                .foregroundColor(Theme.ramadanGold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(DataProvider.surahs.filter { $0.isRamadanRecommended }) { surah in
                        VStack(spacing: 4) {
                            Text(surah.arabicName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text(surah.frenchName)
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Theme.ramadanPurple.opacity(0.3))
                        .cornerRadius(10)
                        .onTapGesture { selectedSurah = surah }
                    }
                }
            }
        }
        .cardStyle()
    }
}

struct SurahRow: View {
    let surah: Surah
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(surah.id)")
                .font(.caption.bold())
                .foregroundColor(isCompleted ? .black : .white)
                .frame(width: 32, height: 32)
                .background(isCompleted ? Theme.gold : Theme.secondaryBg)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(surah.frenchName)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text("\(surah.verseCount) versets • \(surah.revelationType)")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            Text(surah.arabicName)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.gold)
            
            if surah.isRamadanRecommended {
                Text("⭐").font(.caption)
            }
            
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Theme.success)
            }
        }
        .padding(12)
        .background(Theme.cardBg)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
    }
}

struct SurahDetailSheet: View {
    let surah: Surah
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text(surah.arabicName)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Theme.gold)
                        
                        Text(surah.frenchName)
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text(surah.phonetic)
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        HStack(spacing: 20) {
                            InfoBadge(title: "Versets", value: "\(surah.verseCount)")
                            InfoBadge(title: "Type", value: surah.revelationType)
                            InfoBadge(title: "Numéro", value: "\(surah.id)")
                        }
                        
                        if surah.isRamadanRecommended {
                            HStack {
                                Text("⭐ Recommandée pendant le Ramadan")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.ramadanGold)
                            }
                            .padding()
                            .background(Theme.ramadanPurple.opacity(0.2))
                            .cornerRadius(10)
                        }
                        
                        // Mark as read button
                        Button(action: {
                            appState.markSurahCompleted(surah.id)
                            appState.updateStreak()
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: appState.completedSurahIndices.contains(surah.id) ? "checkmark.circle.fill" : "book.fill")
                                Text(appState.completedSurahIndices.contains(surah.id) ? "Déjà lue ✓" : "Marquer comme lue")
                            }
                            .goldButton()
                        }
                        .disabled(appState.completedSurahIndices.contains(surah.id))
                        .opacity(appState.completedSurahIndices.contains(surah.id) ? 0.6 : 1)
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

struct InfoBadge: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundColor(Theme.gold)
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Theme.cardBg)
        .cornerRadius(10)
    }
}
