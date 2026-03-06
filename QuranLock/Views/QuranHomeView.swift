import SwiftUI

struct QuranHomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var quranService: QuranService
    @State private var selectedSurah: Surah? = nil
    @State private var searchText = ""

    var filteredSurahs: [Surah] {
        let all = appState.surahs
        if searchText.isEmpty { return all }
        return all.filter {
            $0.frenchName.localizedCaseInsensitiveContains(searchText) ||
            $0.arabicName.contains(searchText) ||
            "\($0.id)".contains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(Theme.textSecondary)
                        TextField("Rechercher une sourate...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(Theme.cardBg)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)

                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(filteredSurahs) { surah in
                                Button(action: { selectedSurah = surah }) {
                                    HStack(spacing: 14) {
                                        Text("\(surah.id)")
                                            .font(.caption.bold())
                                            .foregroundColor(.black)
                                            .frame(width: 30, height: 30)
                                            .background(Theme.gold)
                                            .cornerRadius(15)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(surah.frenchName)
                                                .font(.subheadline.bold())
                                                .foregroundColor(.white)
                                            Text("\(surah.verseCount) versets")
                                                .font(.caption)
                                                .foregroundColor(Theme.textSecondary)
                                        }
                                        Spacer()
                                        Text(surah.arabicName)
                                            .font(.system(size: 18))
                                            .foregroundColor(Theme.gold)
                                        if appState.completedSurahIndices.contains(surah.id) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .padding(12)
                                    .background(Theme.cardBg)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("القرآن الكريم")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $selectedSurah) { surah in
            QuranReadingView(surah: surah)
                .environmentObject(appState)
                .environmentObject(quranService)
        }
    }
}
