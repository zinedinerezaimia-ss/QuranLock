import SwiftUI

// MARK: - QuranListView (Tab Coran — liste des 114 sourates)

struct QuranListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ramadanManager: RamadanManager
    @EnvironmentObject var quranService: QuranService
    @State private var searchText = ""
    @State private var selectedSurah: QuranSurah?
    @State private var showKhatm = false
    @State private var showDownloadSheet = false

    var filteredSurahs: [QuranSurah] {
        if searchText.isEmpty { return quranService.surahs }
        return quranService.surahs.filter {
            $0.nameFrench.localizedCaseInsensitiveContains(searchText) ||
            $0.nameArabic.contains(searchText) ||
            $0.nameTranslit.localizedCaseInsensitiveContains(searchText) ||
            "\($0.id)".contains(searchText)
        }
    }

    var loadedCount: Int { quranService.surahs.filter { $0.isLoaded }.count }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {

                        // Download banner
                        if !quranService.isFullyLoaded {
                            downloadBanner
                        } else if loadedCount < 114 {
                            partialDownloadBanner
                        }

                        // Khatm card
                        khatmCard

                        // Ramadan recommended
                        if ramadanManager.isRamadan {
                            recommendedSection
                        }

                        // Search
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(Theme.textSecondary)
                            TextField("Rechercher une sourate...", text: $searchText)
                                .foregroundColor(.white)
                        }
                        .padding().background(Theme.cardBg).cornerRadius(12)

                        // Surah list
                        LazyVStack(spacing: 8) {
                            ForEach(filteredSurahs) { surah in
                                SurahRowItem(
                                    surah: surah,
                                    isCompleted: appState.completedSurahIndices.contains(surah.id)
                                )
                                .onTapGesture { selectedSurah = surah }
                            }
                        }
                    }
                    .padding(.horizontal, 16).padding(.bottom, 20)
                }
            }
            .navigationTitle("القرآن الكريم")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedSurah) { surah in
                QuranReadingView(surah: Surah(id: surah.id, arabicName: surah.nameArabic, frenchName: surah.nameFrench, englishName: "", phonetic: surah.nameTranslit, verseCount: surah.verseCount, revelationType: surah.revelationType == "Meccan" ? "Mecquoise" : "Médinoise", isRamadanRecommended: false))
                    .environmentObject(appState)
                    .environmentObject(quranService)
            }
            .sheet(isPresented: $showKhatm) { KhatmChallengeView() }
            .sheet(isPresented: $showDownloadSheet) { DownloadQuranView() }
        }
    }

    // MARK: - Download Banner

    private var downloadBanner: some View {
        VStack(spacing: 10) {
            HStack {
                Text("📥").font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Télécharger le Coran complet").font(.headline).foregroundColor(.white)
                    Text("114 sourates • Arabe, Français, Phonétique").font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
            }
            Text("Nécessite une connexion Wi-Fi (une seule fois, puis hors-ligne à vie)")
                .font(.caption).foregroundColor(Theme.textSecondary)
            Button(action: { showDownloadSheet = true }) {
                HStack {
                    Image(systemName: "icloud.and.arrow.down")
                    Text("Télécharger maintenant")
                }
                .goldButton()
            }
        }
        .padding(16).background(Theme.cardBg).cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.gold.opacity(0.4), lineWidth: 1))
    }

    private var partialDownloadBanner: some View {
        HStack(spacing: 12) {
            Text("📥").font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(loadedCount)/114 sourates hors-ligne").font(.subheadline.bold()).foregroundColor(.white)
                ProgressView(value: quranService.isFullyLoaded ? 114.0 : Double(loadedCount), total: 114).tint(Theme.gold)
            }
            Button("Compléter") { showDownloadSheet = true }
                .font(.caption.bold()).foregroundColor(Theme.gold)
        }
        .padding(12).background(Theme.cardBg).cornerRadius(12)
    }

    private var khatmCard: some View {
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

    private var recommendedSection: some View {
        let ramadanIds = [1, 2, 3, 18, 36, 67, 112, 113, 114]
        let recommended = quranService.surahs.filter { ramadanIds.contains($0.id) }
        return VStack(alignment: .leading, spacing: 8) {
            Text("⭐ Sourates recommandées pour le Ramadan").font(.subheadline.bold()).foregroundColor(Theme.gold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(recommended) { surah in
                        VStack(spacing: 4) {
                            Text(surah.nameArabic).font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                            Text(surah.nameFrench).font(.caption).foregroundColor(Theme.textSecondary)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 10)
                        .background(Color.purple.opacity(0.3)).cornerRadius(10)
                        .onTapGesture { selectedSurah = surah }
                    }
                }
            }
        }
        .cardStyle()
    }
}

// MARK: - SurahRowItem

struct SurahRowItem: View {
    let surah: QuranSurah
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
                Text(surah.nameFrench).font(.subheadline.bold()).foregroundColor(.white)
                HStack(spacing: 4) {
                    Text("\(surah.verseCount) versets • \(surah.revelationType)")
                        .font(.caption).foregroundColor(Theme.textSecondary)
                    if surah.isLoaded {
                        Text("• ✓ hors-ligne").font(.caption).foregroundColor(Theme.gold.opacity(0.7))
                    }
                }
            }
            Spacer()
            Text(surah.nameArabic).font(.system(size: 18, weight: .bold)).foregroundColor(Theme.gold)
            if isCompleted {
                Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success)
            }
        }
        .padding(12).background(Theme.cardBg).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
    }
}

// MARK: - Download Sheet

struct DownloadQuranView: View {
    @EnvironmentObject var quranService: QuranService
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                VStack(spacing: 30) {
                    Spacer()
                    VStack(spacing: 16) {
                        Text("📥").font(.system(size: 60))
                        Text("Télécharger le Coran").font(.title2.bold()).foregroundColor(.white)
                        Text("Le Coran complet sera téléchargé une seule fois.\nEnsuite, tout fonctionne hors-ligne, sans Wi-Fi, pour toujours.")
                            .font(.subheadline).foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center).padding(.horizontal)
                        VStack(spacing: 6) {
                            HStack { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success); Text("114 sourates complètes").foregroundColor(.white); Spacer() }
                            HStack { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success); Text("Texte arabe officiel (Uthman)").foregroundColor(.white); Spacer() }
                            HStack { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success); Text("Traduction française (Hamidullah)").foregroundColor(.white); Spacer() }
                            HStack { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success); Text("Translittération phonétique").foregroundColor(.white); Spacer() }
                        }
                        .padding(16).background(Theme.cardBg).cornerRadius(12)
                    }

                    if quranService.isDownloading {
                        VStack(spacing: 12) {
                            ProgressView(value: quranService.downloadProgress)
                                .tint(Theme.gold).scaleEffect(x: 1, y: 2)
                            Text(("Chargement du Coran...")).font(.caption).foregroundColor(Theme.textSecondary)
                            Text("\(Int(quranService.downloadProgress * 100))%").font(.title3.bold()).foregroundColor(Theme.gold)
                        }
                        .padding(.horizontal)
                    } else if quranService.isFullyLoaded {
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill").font(.system(size: 50)).foregroundColor(Theme.success)
                            Text("Coran téléchargé !").font(.headline).foregroundColor(Theme.success)
                            Text("100% hors-ligne maintenant 🎉").font(.subheadline).foregroundColor(Theme.textSecondary)
                        }
                        Button("Fermer") { dismiss() }.goldButton().padding(.horizontal)
                    } else {
                        Button(action: {
                            Task { await quranService.downloadFullQuran() }
                        }) {
                            HStack {
                                Image(systemName: "icloud.and.arrow.down")
                                Text("Télécharger le Coran complet")
                            }
                            .goldButton()
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !quranService.isDownloading {
                        Button("Fermer") { dismiss() }.foregroundColor(Theme.gold)
                    }
                }
            }
        }
    }
}
