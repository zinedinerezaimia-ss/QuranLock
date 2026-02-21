import SwiftUI

// MARK: - QuranService (chargeur JSON local)
// NOTE: QuranService.swift et QuranData.swift doivent être SUPPRIMÉS du projet.
// Toute la logique est centralisée ici pour éviter les doublons.
class QuranService: ObservableObject {
    static let shared = QuranService()
    private var data: [String: Any] = [:]

    private init() { loadData() }

    private func loadData() {
        guard let url = Bundle.main.url(forResource: "quran_data", withExtension: "json"),
              let raw = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: raw) as? [String: Any] else { return }
        data = json
    }

    func verses(surahId: Int, language: AppLanguage) -> [(arabic: String, translation: String)]? {
        let key = language == .arabic ? "arabic" : language == .french ? "french" : "english"
        guard let surahs = data["surahs"] as? [[String: Any]],
              let surah = surahs.first(where: { ($0["id"] as? Int) == surahId }),
              let verses = surah["verses"] as? [[String: Any]] else { return nil }

        return verses.compactMap { v -> (arabic: String, translation: String)? in
            guard let arabic = v["arabic"] as? String else { return nil }
            let translation = (v[key] as? String) ?? (v["french"] as? String) ?? ""
            return (arabic: arabic, translation: translation)
        }
    }
}

// MARK: - Main View
struct QuranReadingView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ramadanManager: RamadanManager
    @EnvironmentObject var languageManager: LanguageManager
    @State private var searchText = ""
    @State private var selectedSurah: Surah?
    @State private var showKhatm = false

    var filteredSurahs: [Surah] {
        if searchText.isEmpty { return DataProvider.surahs }
        return DataProvider.surahs.filter {
            $0.frenchName.localizedCaseInsensitiveContains(searchText) ||
            $0.englishName.localizedCaseInsensitiveContains(searchText) ||
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
                            TextField(L.searchSurah, text: $searchText).foregroundColor(.white)
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
            .navigationTitle(L.quran)
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedSurah) { surah in
                SurahDetailSheet(surah: surah)
                    .environmentObject(appState)
                    .environmentObject(ramadanManager)
                    .environmentObject(languageManager)
            }
            .sheet(isPresented: $showKhatm) {
                KhatmChallengeView().environmentObject(appState)
            }
        }
    }

    var khatmCard: some View {
        Button(action: { showKhatm = true }) {
            VStack(spacing: 8) {
                HStack {
                    Text(L.khatmChallenge).font(.headline).foregroundColor(Theme.gold)
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
            Text("⭐ \(L.ramadanRecommended)").font(.subheadline.bold()).foregroundColor(Theme.ramadanGold)
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
            Text("\(surah.id)")
                .font(.caption.bold())
                .foregroundColor(isCompleted ? .black : .white)
                .frame(width: 32, height: 32)
                .background(isCompleted ? Theme.gold : Theme.secondaryBg)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 2) {
                Text(surah.frenchName).font(.subheadline.bold()).foregroundColor(.white)
                Text("\(surah.verseCount) \(L.verses) • \(L.surahType(surah.revelationType))")
                    .font(.caption).foregroundColor(Theme.textSecondary)
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
    @EnvironmentObject var ramadanManager: RamadanManager
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss

    @State private var showVerses = false
    @State private var verses: [(arabic: String, translation: String)] = []
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Theme.primaryBg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button(L.close) { dismiss() }
                            .foregroundColor(Theme.gold).padding(.trailing, 20).padding(.top, 8)
                    }

                    Text(surah.arabicName).font(.system(size: 44, weight: .bold)).foregroundColor(Theme.gold)
                    Text(surah.frenchName).font(.title2.bold()).foregroundColor(.white)
                    Text(surah.phonetic).font(.subheadline).foregroundColor(Theme.textSecondary)

                    HStack(spacing: 16) {
                        InfoBadge(title: L.verses, value: "\(surah.verseCount)")
                        InfoBadge(title: L.type, value: L.surahType(surah.revelationType))
                        InfoBadge(title: L.number, value: "\(surah.id)")
                    }

                    if surah.isRamadanRecommended {
                        HStack {
                            Image(systemName: "moon.stars.fill").foregroundColor(Theme.ramadanGold)
                            Text(L.ramadanRecommended).font(.subheadline).foregroundColor(Theme.ramadanGold)
                        }
                        .padding().background(Theme.ramadanPurple.opacity(0.2)).cornerRadius(10)
                    }

                    Button(action: {
                        withAnimation { showVerses.toggle() }
                        if showVerses && verses.isEmpty { loadVerses() }
                    }) {
                        HStack {
                            Text(showVerses ? L.hideVerses : L.readVerses)
                                .font(.headline).foregroundColor(Theme.gold)
                            Spacer()
                            Image(systemName: showVerses ? "chevron.up" : "chevron.down").foregroundColor(Theme.gold)
                        }
                        .padding().background(Theme.cardBg).cornerRadius(12)
                    }

                    if showVerses {
                        if isLoading {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Theme.gold))
                                .frame(maxWidth: .infinity).padding()
                        } else if verses.isEmpty {
                            Link(destination: URL(string: "https://quran.com/\(surah.id)")!) {
                                HStack {
                                    Image(systemName: "safari")
                                    Text(L.readOnline)
                                }
                                .font(.subheadline.bold()).foregroundColor(Theme.gold)
                                .frame(maxWidth: .infinity).padding()
                                .background(Theme.gold.opacity(0.1)).cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
                            }
                        } else {
                            VStack(alignment: .trailing, spacing: 16) {
                                if surah.id != 9 {
                                    Text("بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(Theme.gold)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.vertical, 4)
                                }

                                ForEach(Array(verses.enumerated()), id: \.offset) { idx, verse in
                                    VStack(alignment: .trailing, spacing: 8) {
                                        HStack(alignment: .top) {
                                            Spacer()
                                            Text(verse.arabic)
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.trailing)
                                                .environment(\.layoutDirection, .rightToLeft)
                                            Text("(\(idx + 1))")
                                                .font(.caption.bold()).foregroundColor(Theme.gold)
                                        }
                                        if languageManager.language != .arabic {
                                            Text(verse.translation)
                                                .font(.footnote).foregroundColor(Theme.textSecondary)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        if idx < verses.count - 1 {
                                            Divider().background(Theme.cardBorder)
                                        }
                                    }
                                }
                            }
                            .padding().background(Theme.cardBg).cornerRadius(12)
                        }
                    }

                    Button(action: {
                        appState.markSurahCompleted(surah.id)
                        appState.updateStreak()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: appState.completedSurahIndices.contains(surah.id) ? "checkmark.circle.fill" : "book.fill")
                            Text(appState.completedSurahIndices.contains(surah.id) ? L.alreadyRead : L.markAsRead)
                        }
                        .goldButton()
                    }
                    .disabled(appState.completedSurahIndices.contains(surah.id))
                    .opacity(appState.completedSurahIndices.contains(surah.id) ? 0.6 : 1)
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    func loadVerses() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let result = QuranService.shared.verses(surahId: surah.id, language: languageManager.language) ?? []
            DispatchQueue.main.async {
                verses = result
                isLoading = false
            }
        }
    }
}

// MARK: - Info Badge
struct InfoBadge: View {
    let title: String
    let value: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.headline).foregroundColor(Theme.gold)
            Text(title).font(.caption).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10)
        .background(Theme.cardBg).cornerRadius(10)
    }
}
