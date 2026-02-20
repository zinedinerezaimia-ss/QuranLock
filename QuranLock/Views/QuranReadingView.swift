import SwiftUI

// MARK: - Models for JSON
struct QuranVerse: Codable, Identifiable {
    let id: Int
    let arabic: String
    let french: String
    let phonetic: String
}

struct QuranSurahData: Codable, Identifiable {
    let id: Int
    let name_arabic: String
    let name_french: String
    let name_phonetic: String
    let verses: [QuranVerse]
}

// MARK: - Data Loader
class QuranDataLoader {
    static let shared = QuranDataLoader()
    private(set) var surahsData: [Int: QuranSurahData] = [:]

    private init() {
        load()
    }

    private func load() {
        guard let url = Bundle.main.url(forResource: "quran_data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([QuranSurahData].self, from: data)
        else {
            return
        }
        for s in decoded {
            surahsData[s.id] = s
        }
    }

    func verses(for surahId: Int) -> [QuranVerse]? {
        return surahsData[surahId]?.verses
    }
}

// MARK: - Display Mode
enum VerseDisplayMode: String, CaseIterable {
    case all = "Tout"
    case arabic = "Arabe"
    case french = "Français"
    case phonetic = "Phonétique"
}

// MARK: - Main View
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
                        khatmCard
                        if ramadanManager.isRamadan { recommendedSection }

                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(Theme.textSecondary)
                            TextField("Rechercher une sourate...", text: $searchText).foregroundColor(.white)
                        }
                        .padding().background(Theme.cardBg).cornerRadius(12)

                        LazyVStack(spacing: 8) {
                            ForEach(filteredSurahs) { surah in
                                SurahRow(surah: surah, isCompleted: appState.completedSurahIndices.contains(surah.id))
                                    .onTapGesture { selectedSurah = surah }
                            }
                        }
                    }
                    .padding(.horizontal, 16).padding(.bottom, 20)
                }
            }
            .navigationTitle("Coran")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedSurah) { surah in
                SurahDetailSheet(surah: surah)
                    .environmentObject(appState)
            }
            .sheet(isPresented: $showKhatm) { KhatmChallengeView() }
        }
    }

    var khatmCard: some View {
        Button(action: { showKhatm = true }) {
            VStack(spacing: 8) {
                HStack {
                    Text("📖 Défi Khatm القرآن").font(.headline).foregroundColor(Theme.gold)
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(Theme.textSecondary)
                }
                ProgressView(value: appState.khatmProgress).tint(Theme.gold)
                HStack {
                    Text("\(appState.completedSurahIndices.count) / 114 sourates").font(.caption).foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("\(Int(appState.khatmProgress * 100))%").font(.caption.bold()).foregroundColor(Theme.gold)
                }
            }
            .cardStyle()
        }
    }

    var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("⭐ Sourates recommandées pour le Ramadan").font(.subheadline.bold()).foregroundColor(Theme.ramadanGold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(DataProvider.surahs.filter { $0.isRamadanRecommended }) { surah in
                        VStack(spacing: 4) {
                            Text(surah.arabicName).font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                            Text(surah.frenchName).font(.caption).foregroundColor(Theme.textSecondary)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 10)
                        .background(Theme.ramadanPurple.opacity(0.3)).cornerRadius(10)
                        .onTapGesture { selectedSurah = surah }
                    }
                }
            }
        }
        .cardStyle()
    }
}

// MARK: - Surah Row
struct SurahRow: View {
    let surah: Surah
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text("\(surah.id)").font(.caption.bold())
                .foregroundColor(isCompleted ? .black : .white)
                .frame(width: 32, height: 32)
                .background(isCompleted ? Theme.gold : Theme.secondaryBg)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 2) {
                Text(surah.frenchName).font(.subheadline.bold()).foregroundColor(.white)
                HStack(spacing: 4) {
                    Text("\(surah.verseCount) versets • \(surah.revelationType)").font(.caption).foregroundColor(Theme.textSecondary)
                    // Indicate if full text available offline
                    let hasData = QuranDataLoader.shared.verses(for: surah.id) != nil
                    if hasData {
                        Text("📥").font(.caption2)
                    }
                }
            }
            Spacer()
            Text(surah.arabicName).font(.system(size: 18, weight: .bold)).foregroundColor(Theme.gold)
            if surah.isRamadanRecommended { Text("⭐").font(.caption) }
            if isCompleted { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success) }
        }
        .padding(12).background(Theme.cardBg).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
    }
}

// MARK: - Surah Detail Sheet
struct SurahDetailSheet: View {
    let surah: Surah
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showShareReflection = false
    @State private var displayMode: VerseDisplayMode = .all

    var verses: [QuranVerse]? {
        QuranDataLoader.shared.verses(for: surah.id)
    }

    var isCompleted: Bool { appState.completedSurahIndices.contains(surah.id) }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {

                        // Header
                        VStack(spacing: 8) {
                            Text(surah.arabicName).font(.system(size: 40, weight: .bold)).foregroundColor(Theme.gold)
                            Text(surah.frenchName).font(.title2).foregroundColor(.white)
                            Text(surah.phonetic).font(.subheadline).foregroundColor(Theme.textSecondary)
                            HStack(spacing: 20) {
                                InfoBadge(title: "Versets", value: "\(surah.verseCount)")
                                InfoBadge(title: "Type", value: surah.revelationType)
                                InfoBadge(title: "Numéro", value: "\(surah.id)")
                            }
                            if surah.isRamadanRecommended {
                                Text("⭐ Recommandée pendant le Ramadan")
                                    .font(.subheadline).foregroundColor(Theme.ramadanGold)
                                    .padding().background(Theme.ramadanPurple.opacity(0.2)).cornerRadius(10)
                            }
                        }

                        // Basmalah
                        if surah.id != 1 && surah.id != 9 {
                            Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Theme.gold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Theme.secondaryBg)
                                .cornerRadius(12)
                        }

                        if let verseList = verses {
                            // Language selector
                            VStack(spacing: 12) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(VerseDisplayMode.allCases, id: \.self) { mode in
                                            Button(action: { displayMode = mode }) {
                                                Text(mode.rawValue)
                                                    .font(.caption.bold())
                                                    .foregroundColor(displayMode == mode ? .black : Theme.textSecondary)
                                                    .padding(.horizontal, 14).padding(.vertical, 7)
                                                    .background(displayMode == mode ? Theme.gold : Theme.cardBg)
                                                    .cornerRadius(20)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 2)
                                }

                                ForEach(verseList) { verse in
                                    VerseCard(verse: verse, mode: displayMode)
                                }
                            }
                        } else {
                            // Surah not yet in local data
                            VStack(spacing: 16) {
                                Text("📖").font(.system(size: 50))
                                Text("Sourate \(surah.frenchName)")
                                    .font(.title3.bold()).foregroundColor(.white)
                                Text("Cette sourate (\(surah.verseCount) versets) sera disponible dans une prochaine mise à jour de l'application.")
                                    .font(.subheadline).foregroundColor(Theme.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(24)
                            .background(Theme.cardBg).cornerRadius(14)
                        }

                        // Actions
                        VStack(spacing: 12) {
                            Button(action: {
                                appState.markSurahCompleted(surah.id)
                                appState.updateStreak()
                                if !isCompleted { showShareReflection = true }
                            }) {
                                HStack {
                                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "book.fill")
                                    Text(isCompleted ? "Déjà lue ✓" : "Marquer comme lue")
                                }
                                .goldButton()
                            }
                            .disabled(isCompleted)
                            .opacity(isCompleted ? 0.6 : 1)

                            if isCompleted {
                                Button(action: { showShareReflection = true }) {
                                    HStack {
                                        Image(systemName: "bubble.left.and.bubble.right.fill")
                                        Text("Partager ma réflexion avec la communauté")
                                    }
                                    .font(.subheadline.bold())
                                    .foregroundColor(Theme.gold)
                                    .frame(maxWidth: .infinity).padding()
                                    .background(Theme.secondaryBg).cornerRadius(14)
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.gold.opacity(0.4), lineWidth: 1))
                                }
                            }
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
            .sheet(isPresented: $showShareReflection) {
                ShareReflectionView(surahName: surah.frenchName, surahArabic: surah.arabicName)
            }
        }
    }
}

// MARK: - Verse Card (3 languages)
struct VerseCard: View {
    let verse: QuranVerse
    let mode: VerseDisplayMode

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Verse number badge
            HStack {
                Text("\(verse.id)")
                    .font(.caption.bold()).foregroundColor(.black)
                    .frame(width: 24, height: 24).background(Theme.gold).cornerRadius(12)
                Spacer()
            }

            // Arabic
            if mode == .all || mode == .arabic {
                Text(verse.arabic)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .lineSpacing(8)
            }

            // Phonetic
            if mode == .all || mode == .phonetic {
                if mode == .all {
                    Divider().background(Theme.cardBorder)
                }
                Text(verse.phonetic)
                    .font(.system(size: 14, weight: .regular).italic())
                    .foregroundColor(Theme.gold.opacity(0.85))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(4)
            }

            // French
            if mode == .all || mode == .french {
                if mode == .all {
                    Divider().background(Theme.cardBorder)
                }
                Text(verse.french)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(4)
            }
        }
        .padding(16).background(Theme.cardBg).cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
    }
}

// MARK: - Share Reflection
struct ShareReflectionView: View {
    let surahName: String
    let surahArabic: String
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var reflectionText = ""
    @State private var shared = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                VStack(spacing: 20) {
                    VStack(spacing: 6) {
                        Text(surahArabic).font(.system(size: 32, weight: .bold)).foregroundColor(Theme.gold)
                        Text("Sourate \(surahName)").font(.headline).foregroundColor(.white)
                        Text("MashaAllah ! Tu as terminé cette sourate 🎉").font(.subheadline).foregroundColor(Theme.textSecondary)
                    }
                    .padding()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ta réflexion (optionnel)").font(.headline).foregroundColor(Theme.gold)
                        Text("Qu'est-ce que cette sourate t'a apporté ? Une pensée, une émotion, une compréhension ?")
                            .font(.caption).foregroundColor(Theme.textSecondary)
                        TextEditor(text: $reflectionText)
                            .foregroundColor(.white)
                            .frame(height: 120)
                            .padding(10)
                            .background(Theme.secondaryBg)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    if shared {
                        HStack {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success)
                            Text("Partagé avec la communauté ! Barakallahu fik 🤲")
                                .font(.subheadline).foregroundColor(Theme.success)
                        }
                        .padding().background(Theme.success.opacity(0.15)).cornerRadius(12)
                        .padding(.horizontal)
                    }

                    Spacer()

                    VStack(spacing: 12) {
                        if !shared {
                            Button(action: { shared = true; appState.addHasanat(5) }) {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                    Text("Partager avec la communauté")
                                }
                                .goldButton()
                            }
                            .padding(.horizontal)
                        }
                        Button(action: { dismiss() }) {
                            Text(shared ? "Fermer" : "Passer")
                                .font(.subheadline).foregroundColor(Theme.textSecondary)
                        }
                    }
                    .padding(.bottom, 20)
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
}

// MARK: - Info Badge
struct InfoBadge: View {
    let title: String; let value: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.headline).foregroundColor(Theme.gold)
            Text(title).font(.caption).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10)
        .background(Theme.cardBg).cornerRadius(10)
    }
}
