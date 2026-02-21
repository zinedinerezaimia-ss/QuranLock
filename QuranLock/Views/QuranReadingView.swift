import SwiftUI

// MARK: - QuranReadingView (Complete — 114 Sourates)

struct QuranReadingView: View {
    let surah: Surah
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var quranService: QuranService
    @Environment(\.dismiss) var dismiss
    @State private var displayMode: DisplayMode = .all
    @State private var showShareReflection = false
    @State private var fontSize: CGFloat = 22
    @State private var isBookmarked = false

    enum DisplayMode: String, CaseIterable {
        case all = "Tout"
        case arabic = "Arabe"
        case french = "Français"
        case phonetic = "Phonétique"
    }

    var isCompleted: Bool {
        appState.completedSurahIndices.contains(surah.id)
    }

    var quranSurah: QuranSurah? {
        quranService.surahs.first { $0.id == surah.id }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        // Bismillah
                        if surah.id != 9 && surah.id != 1 {
                            bismillahCard
                        }

                        // Info badges
                        HStack(spacing: 12) {
                            InfoBadge(title: "Versets", value: "\(surah.verseCount)")
                            InfoBadge(title: "Type", value: surah.revelationType == "Mecquoise" ? "Mecq." : "Méd.")
                            InfoBadge(title: "Sourate", value: "N°\(surah.id)")
                        }

                        // Display mode picker
                        displayModePicker

                        // Font size control
                        fontSizeControl

                        // Verses content
                        versesContent

                        // Mark as read button
                        actionButtons
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text(surah.arabicName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.gold)
                        Text(surah.frenchName)
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Theme.gold)
                }
            }
            .task {
                await quranService.loadSurah(surah.id)
            }
        }
    }

    // MARK: - Subviews

    private var bismillahCard: some View {
        Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(Theme.gold)
            .multilineTextAlignment(.center)
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Theme.cardBg)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
    }

    private var displayModePicker: some View {
        HStack(spacing: 8) {
            ForEach(DisplayMode.allCases, id: \.self) { mode in
                Button(action: { displayMode = mode }) {
                    Text(mode.rawValue)
                        .font(.subheadline.bold())
                        .foregroundColor(displayMode == mode ? .black : Theme.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(displayMode == mode ? Theme.gold : Theme.cardBg)
                        .cornerRadius(20)
                }
            }
        }
        .padding(4)
        .background(Theme.secondaryBg)
        .cornerRadius(24)
    }

    private var fontSizeControl: some View {
        HStack(spacing: 12) {
            Text("Taille")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
            Button(action: { fontSize = max(14, fontSize - 2) }) {
                Image(systemName: "textformat.size.smaller")
                    .foregroundColor(Theme.gold)
            }
            Text("A")
                .font(.system(size: fontSize * 0.6))
                .foregroundColor(.white)
            Button(action: { fontSize = min(36, fontSize + 2) }) {
                Image(systemName: "textformat.size.larger")
                    .foregroundColor(Theme.gold)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Theme.cardBg)
        .cornerRadius(12)
    }

    @ViewBuilder
    private var versesContent: some View {
        if quranService.isLoading {
            loadingView
        } else if let qs = quranSurah, !qs.verses.isEmpty {
            LazyVStack(spacing: 12) {
                ForEach(qs.verses) { verse in
                    VerseCardFull(
                        verse: verse,
                        displayMode: displayMode,
                        fontSize: fontSize
                    )
                }
            }
        } else if quranService.isOffline {
            offlineView
        } else {
            loadingView
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(Theme.gold)
                .scaleEffect(1.5)
            Text("Chargement de la sourate...")
                .foregroundColor(Theme.textSecondary)
                .font(.subheadline)
        }
        .padding(40)
    }

    private var offlineView: some View {
        VStack(spacing: 12) {
            Text("📡")
                .font(.system(size: 40))
            Text("Connexion requise")
                .font(.headline)
                .foregroundColor(.white)
            Text("Cette sourate n'a pas encore été téléchargée. Connectez-vous à Internet pour la charger, elle sera disponible hors ligne ensuite.")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            Button("Réessayer") {
                Task { await quranService.loadSurah(surah.id) }
            }
            .foregroundColor(Theme.gold)
            .padding()
        }
        .padding(20)
        .background(Theme.cardBg)
        .cornerRadius(14)
    }

    private var actionButtons: some View {
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
                        Text("Partager ma réflexion")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.gold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.secondaryBg)
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.gold.opacity(0.4), lineWidth: 1))
                }
            }
        }
        .sheet(isPresented: $showShareReflection) {
            ShareReflectionView(surahName: surah.frenchName, surahArabic: surah.arabicName)
        }
    }
}

// MARK: - Full Verse Card

struct VerseCardFull: View {
    let verse: QuranVerse
    let displayMode: QuranReadingView.DisplayMode
    let fontSize: CGFloat

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Verse number
            HStack {
                Text("\(verse.number)")
                    .font(.caption.bold())
                    .foregroundColor(.black)
                    .frame(width: 26, height: 26)
                    .background(Theme.gold)
                    .cornerRadius(13)
                Spacer()
            }

            // Arabic
            if displayMode == .all || displayMode == .arabic {
                Text(verse.arabic)
                    .font(.system(size: fontSize, weight: .regular))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .lineSpacing(10)
                    .environment(\.layoutDirection, .rightToLeft)
            }

            // Phonetic
            if displayMode == .all || displayMode == .phonetic {
                if displayMode == .all {
                    Divider().background(Color.white.opacity(0.08))
                }
                Text(verse.phonetic)
                    .font(.system(size: fontSize * 0.6, design: .serif))
                    .italic()
                    .foregroundColor(Theme.gold.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(4)
            }

            // French
            if displayMode == .all || displayMode == .french {
                if displayMode == .all {
                    Divider().background(Color.white.opacity(0.08))
                }
                Text(verse.french)
                    .font(.system(size: fontSize * 0.65))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(4)
            }
        }
        .padding(16)
        .background(Theme.cardBg)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
    }
}

// MARK: - Quran Download Progress View

struct QuranDownloadView: View {
    @EnvironmentObject var quranService: QuranService

    var body: some View {
        if quranService.isLoading && quranService.downloadProgress > 0 {
            VStack(spacing: 8) {
                Text(quranService.loadingMessage)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                ProgressView(value: quranService.downloadProgress)
                    .tint(Theme.gold)
                    .padding(.horizontal)
            }
            .padding()
            .background(Theme.cardBg)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

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

struct ShareReflectionView: View {
    let surahName: String
    let surahArabic: String
    @Environment(\.dismiss) var dismiss
    @State private var reflectionText = ""
    @State private var shared = false
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text(surahArabic).font(.system(size: 32, weight: .bold)).foregroundColor(Theme.gold)
                    Text("Sourate \(surahName)").font(.headline).foregroundColor(.white)
                    Text("MashaAllah ! Tu as terminé cette sourate 🎉").font(.subheadline).foregroundColor(Theme.textSecondary)
                    TextEditor(text: $reflectionText).foregroundColor(.white).frame(height: 120)
                        .padding(10).background(Theme.secondaryBg).cornerRadius(12).padding(.horizontal)
                    if shared {
                        Text("Partagé ! Barakallahu fik 🤲").foregroundColor(Theme.success).padding()
                    }
                    Spacer()
                    Button(action: { if !shared { shared = true } else { dismiss() } }) {
                        Text(shared ? "Fermer" : "Partager").goldButton()
                    }.padding(.horizontal)
                    Button("Passer") { dismiss() }.foregroundColor(Theme.textSecondary).padding(.bottom)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Fermer") { dismiss() }.foregroundColor(Theme.gold) } }
        }
    }
}
