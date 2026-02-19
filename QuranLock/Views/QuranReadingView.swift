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
                        khatmCard

                        if ramadanManager.isRamadan {
                            recommendedSection
                        }

                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Theme.textSecondary)
                            TextField("Rechercher une sourate...", text: $searchText)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Theme.cardBg)
                        .cornerRadius(12)

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
            // FIX CRASH: Pass environment objects explicitly to sheet
            .sheet(item: $selectedSurah) { surah in
                SurahDetailSheet(surah: surah)
                    .environmentObject(appState)
                    .environmentObject(ramadanManager)
            }
            .sheet(isPresented: $showKhatm) {
                KhatmChallengeView()
                    .environmentObject(appState)
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

// MARK: - Surah Detail Sheet (NO NavigationView inside — that was causing the crash)
struct SurahDetailSheet: View {
    let surah: Surah
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showVerses = false

    // Verse data for key surahs
    var verses: [(arabic: String, french: String)]? {
        SurahVerseData.verses(for: surah.id)
    }

    var body: some View {
        ZStack {
            Theme.primaryBg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    // Header bar (replaces NavigationView toolbar)
                    HStack {
                        Spacer()
                        Button("Fermer") { dismiss() }
                            .foregroundColor(Theme.gold)
                            .padding(.trailing, 20)
                            .padding(.top, 8)
                    }

                    // Arabic name
                    Text(surah.arabicName)
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(Theme.gold)

                    Text(surah.frenchName)
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Text(surah.phonetic)
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)

                    // Info badges
                    HStack(spacing: 16) {
                        InfoBadge(title: "Versets", value: "\(surah.verseCount)")
                        InfoBadge(title: "Type", value: surah.revelationType)
                        InfoBadge(title: "Numéro", value: "\(surah.id)")
                    }

                    if surah.isRamadanRecommended {
                        HStack {
                            Image(systemName: "moon.stars.fill")
                                .foregroundColor(Theme.ramadanGold)
                            Text("Recommandée pendant le Ramadan")
                                .font(.subheadline)
                                .foregroundColor(Theme.ramadanGold)
                        }
                        .padding()
                        .background(Theme.ramadanPurple.opacity(0.2))
                        .cornerRadius(10)
                    }

                    // Verses section
                    if let verses = verses {
                        VStack(spacing: 0) {
                            Button(action: { withAnimation { showVerses.toggle() } }) {
                                HStack {
                                    Text(showVerses ? "Masquer les versets" : "📖 Lire les versets")
                                        .font(.headline)
                                        .foregroundColor(Theme.gold)
                                    Spacer()
                                    Image(systemName: showVerses ? "chevron.up" : "chevron.down")
                                        .foregroundColor(Theme.gold)
                                }
                                .padding()
                                .background(Theme.cardBg)
                                .cornerRadius(12)
                            }

                            if showVerses {
                                VStack(spacing: 16) {
                                    // Basmala (except for At-Tawba, id=9)
                                    if surah.id != 9 {
                                        Text("بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(Theme.gold)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.vertical, 8)
                                    }

                                    ForEach(Array(verses.enumerated()), id: \.offset) { idx, verse in
                                        VStack(alignment: .trailing, spacing: 8) {
                                            // Arabic
                                            HStack {
                                                Spacer()
                                                Text(verse.arabic)
                                                    .font(.system(size: 20, weight: .regular))
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.trailing)
                                                    .environment(\.layoutDirection, .rightToLeft)
                                                Text("(\(idx + 1))")
                                                    .font(.caption.bold())
                                                    .foregroundColor(Theme.gold)
                                            }
                                            // French
                                            Text(verse.french)
                                                .font(.footnote)
                                                .foregroundColor(Theme.textSecondary)
                                                .frame(maxWidth: .infinity, alignment: .leading)

                                            if idx < verses.count - 1 {
                                                Divider().background(Theme.cardBorder)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Theme.cardBg)
                                .cornerRadius(12)
                            }
                        }
                    } else {
                        // For long surahs without embedded text → link to Quran.com
                        Link(destination: URL(string: "https://quran.com/\(surah.id)")!) {
                            HStack {
                                Image(systemName: "safari")
                                Text("Lire sur Quran.com")
                            }
                            .font(.subheadline.bold())
                            .foregroundColor(Theme.gold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.gold.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
                        }
                    }

                    // Mark as read
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
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Verse Data for key surahs
struct SurahVerseData {
    static func verses(for surahId: Int) -> [(arabic: String, french: String)]? {
        switch surahId {
        case 1: return fatiha
        case 112: return ikhlas
        case 113: return falaq
        case 114: return nas
        case 108: return kawthar
        case 103: return asr
        case 112: return ikhlas
        case 110: return nasr
        case 109: return kafirun
        case 107: return maun
        case 106: return quraysh
        case 105: return fil
        case 104: return humaza
        case 102: return takathur
        case 101: return qaria
        case 100: return adiyat
        case 99: return zalzalah
        case 97: return qadr
        case 96: return alaq
        default: return nil
        }
    }

    static let fatiha: [(arabic: String, french: String)] = [
        ("الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", "Louange à Allah, Seigneur de l'univers,"),
        ("الرَّحْمَنِ الرَّحِيمِ", "le Tout Miséricordieux, le Très Miséricordieux,"),
        ("مَالِكِ يَوْمِ الدِّينِ", "Maître du Jour de la rétribution."),
        ("إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", "C'est Toi [Seul] que nous adorons, et c'est Toi [Seul] dont nous implorons le secours."),
        ("اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ", "Guide-nous dans le droit chemin,"),
        ("صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ", "le chemin de ceux que Tu as comblés de bienfaits,"),
        ("غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ", "non pas [le chemin] de ceux qui ont encouru Ta colère, ni des égarés.")
    ]

    static let ikhlas: [(arabic: String, french: String)] = [
        ("قُلْ هُوَ اللَّهُ أَحَدٌ", "Dis: «Il est Allah, Unique»"),
        ("اللَّهُ الصَّمَدُ", "«Allah, le Seul à être imploré pour ce que nous désirons»"),
        ("لَمْ يَلِدْ وَلَمْ يُولَدْ", "«Il n'a jamais engendré, n'a pas été engendré non plus»"),
        ("وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ", "«Et nul n'est égal à Lui»")
    ]

    static let falaq: [(arabic: String, french: String)] = [
        ("قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ", "Dis: «Je cherche protection auprès du Seigneur de l'aube naissante,»"),
        ("مِن شَرِّ مَا خَلَقَ", "«contre le mal de ce qu'Il a créé,»"),
        ("وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ", "«contre le mal de l'obscurité quand elle s'étend,»"),
        ("وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ", "«contre le mal de celles qui soufflent sur les nœuds,»"),
        ("وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ", "«et contre le mal de l'envieux quand il envie»")
    ]

    static let nas: [(arabic: String, french: String)] = [
        ("قُلْ أَعُوذُ بِرَبِّ النَّاسِ", "Dis: «Je cherche protection auprès du Seigneur des hommes,»"),
        ("مَلِكِ النَّاسِ", "«du Roi des hommes,»"),
        ("إِلَهِ النَّاسِ", "«du Dieu des hommes,»"),
        ("مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ", "«contre le mal du mauvais conseiller qui se retire,»"),
        ("الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ", "«qui souffle le mal dans les poitrines des hommes,»"),
        ("مِنَ الْجِنَّةِ وَالنَّاسِ", "«qu'il soit djinn ou homme»")
    ]

    static let kawthar: [(arabic: String, french: String)] = [
        ("إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ", "Nous t'avons accordé l'Abondance."),
        ("فَصَلِّ لِرَبِّكَ وَانْحَرْ", "Accomplis donc la Salât pour ton Seigneur et sacrifie."),
        ("إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ", "Certes, c'est ton ennemi qui est sans postérité.")
    ]

    static let asr: [(arabic: String, french: String)] = [
        ("وَالْعَصْرِ", "Par le Temps!"),
        ("إِنَّ الْإِنسَانَ لَفِي خُسْرٍ", "L'homme est certes en perdition,"),
        ("إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ", "sauf ceux qui croient et accomplissent les bonnes œuvres, s'enjoignent mutuellement la vérité et s'enjoignent mutuellement l'endurance.")
    ]

    static let nasr: [(arabic: String, french: String)] = [
        ("إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ", "Quand vient le secours d'Allah et la victoire,"),
        ("وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا", "et que tu vois les gens entrer en foule dans la religion d'Allah,"),
        ("فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ إِنَّهُ كَانَ تَوَّابًا", "célèbre les louanges de ton Seigneur et implore Son pardon. Car Il est Grand Accueillant au repentir.")
    ]

    static let kafirun: [(arabic: String, french: String)] = [
        ("قُلْ يَا أَيُّهَا الْكَافِرُونَ", "Dis: «Ô vous les mécréants!»"),
        ("لَا أَعْبُدُ مَا تَعْبُدُونَ", "«Je n'adore pas ce que vous adorez,»"),
        ("وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ", "«et vous n'êtes pas adorateurs de ce que j'adore,»"),
        ("وَلَا أَنَا عَابِدٌ مَّا عَبَدتُّمْ", "«et je ne suis pas adorateur de ce que vous avez adoré,»"),
        ("وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ", "«et vous n'êtes pas adorateurs de ce que j'adore:»"),
        ("لَكُمْ دِينُكُمْ وَلِيَ دِينِ", "«À vous votre religion, et à moi ma religion!»")
    ]

    static let maun: [(arabic: String, french: String)] = [
        ("أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ", "As-tu vu celui qui traite la religion de mensonge?"),
        ("فَذَلِكَ الَّذِي يَدُعُّ الْيَتِيمَ", "C'est celui qui repousse l'orphelin,"),
        ("وَلَا يَحُضُّ عَلَى طَعَامِ الْمِسْكِينِ", "et qui n'encourage pas à nourrir le pauvre."),
        ("فَوَيْلٌ لِّلْمُصَلِّينَ", "Malheur donc à ceux qui prient"),
        ("الَّذِينَ هُمْ عَن صَلَاتِهِمْ سَاهُونَ", "mais qui sont distraits dans leur Salât,"),
        ("الَّذِينَ هُمْ يُرَاؤُونَ", "qui font montre (de leurs actes)"),
        ("وَيَمْنَعُونَ الْمَاعُونَ", "et refusent l'ustensile (ou l'aide) de première nécessité.")
    ]

    static let quraysh: [(arabic: String, french: String)] = [
        ("لِإِيلَافِ قُرَيْشٍ", "Pour la protection de Quraïch,"),
        ("إِيلَافِهِمْ رِحْلَةَ الشِّتَاءِ وَالصَّيْفِ", "leur protection lors du voyage d'hiver et de l'été,"),
        ("فَلْيَعْبُدُوا رَبَّ هَذَا الْبَيْتِ", "qu'ils adorent donc le Seigneur de cette Maison [la Ka'ba],"),
        ("الَّذِي أَطْعَمَهُم مِّن جُوعٍ وَآمَنَهُم مِّنْ خَوْفٍ", "qui les a nourris contre la faim et mis en sécurité contre la crainte.")
    ]

    static let fil: [(arabic: String, french: String)] = [
        ("أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ بِأَصْحَابِ الْفِيلِ", "N'as-tu pas vu comment ton Seigneur a agi envers les gens de l'Éléphant?"),
        ("أَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ", "N'a-t-Il pas rendu vaine leur ruse?"),
        ("وَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ", "Il envoya contre eux des oiseaux par volées,"),
        ("تَرْمِيهِم بِحِجَارَةٍ مِّن سِجِّيلٍ", "qui leur lançaient des pierres d'argile cuite,"),
        ("فَجَعَلَهُمْ كَعَصْفٍ مَّأْكُولٍ", "et Il les rendit semblables à des feuilles dévorées.")
    ]

    static let humaza: [(arabic: String, french: String)] = [
        ("وَيْلٌ لِّكُلِّ هُمَزَةٍ لُّمَزَةٍ", "Malheur à tout calomniateur, à tout contempteur!"),
        ("الَّذِي جَمَعَ مَالًا وَعَدَّدَهُ", "à celui qui amasse des richesses et les compte et recompte,"),
        ("يَحْسَبُ أَنَّ مَالَهُ أَخْلَدَهُ", "croyant que ses richesses le rendront immortel."),
        ("كَلَّا لَيُنبَذَنَّ فِي الْحُطَمَةِ", "Mais non! Il sera précipité dans la Hutama."),
        ("وَمَا أَدْرَاكَ مَا الْحُطَمَةُ", "Et comment sauras-tu ce qu'est la Hutama?"),
        ("نَارُ اللَّهِ الْمُوقَدَةُ", "C'est le feu allumé d'Allah,"),
        ("الَّتِي تَطَّلِعُ عَلَى الْأَفْئِدَةِ", "qui s'élève jusqu'aux cœurs."),
        ("إِنَّهَا عَلَيْهِم مُّؤْصَدَةٌ", "Certes, [ce feu] se referme sur eux"),
        ("فِي عَمَدٍ مُّمَدَّدَةٍ", "en colonnes interminables.")
    ]

    static let takathur: [(arabic: String, french: String)] = [
        ("أَلْهَاكُمُ التَّكَاثُرُ", "La course aux richesses vous distrait,"),
        ("حَتَّى زُرْتُمُ الْمَقَابِرَ", "jusqu'à ce que vous visitiez les tombeaux."),
        ("كَلَّا سَوْفَ تَعْلَمُونَ", "Mais non! Vous saurez bientôt!"),
        ("ثُمَّ كَلَّا سَوْفَ تَعْلَمُونَ", "Puis non! Vous saurez bientôt!"),
        ("كَلَّا لَوْ تَعْلَمُونَ عِلْمَ الْيَقِينِ", "Mais non! Si vous saviez avec certitude!"),
        ("لَتَرَوُنَّ الْجَحِيمَ", "Vous verrez sûrement la Fournaise,"),
        ("ثُمَّ لَتَرَوُنَّهَا عَيْنَ الْيَقِينِ", "puis vous la verrez de l'œil de la certitude."),
        ("ثُمَّ لَتُسْأَلُنَّ يَوْمَئِذٍ عَنِ النَّعِيمِ", "Puis, vous serez interrogés ce jour-là au sujet des délices.")
    ]

    static let qaria: [(arabic: String, french: String)] = [
        ("الْقَارِعَةُ", "La Fracassante!"),
        ("مَا الْقَارِعَةُ", "Qu'est-ce que la Fracassante?"),
        ("وَمَا أَدْرَاكَ مَا الْقَارِعَةُ", "Et comment sauras-tu ce qu'est la Fracassante?"),
        ("يَوْمَ يَكُونُ النَّاسُ كَالْفَرَاشِ الْمَبْثُوثِ", "Le Jour où les gens seront comme des papillons éparpillés,"),
        ("وَتَكُونُ الْجِبَالُ كَالْعِهْنِ الْمَنفُوشِ", "et où les montagnes seront comme de la laine cardée."),
        ("فَأَمَّا مَن ثَقُلَتْ مَوَازِينُهُ", "Alors quant à celui dont la balance est lourde,"),
        ("فَهُوَ فِي عِيشَةٍ رَّاضِيَةٍ", "il sera dans une vie agréable."),
        ("وَأَمَّا مَنْ خَفَّتْ مَوَازِينُهُ", "Mais quant à celui dont la balance est légère,"),
        ("فَأُمُّهُ هَاوِيَةٌ", "il aura pour demeure l'Abîme."),
        ("وَمَا أَدْرَاكَ مَا هِيَهْ", "Et comment sauras-tu ce que c'est?"),
        ("نَارٌ حَامِيَةٌ", "C'est un Feu ardent!")
    ]

    static let adiyat: [(arabic: String, french: String)] = [
        ("وَالْعَادِيَاتِ ضَبْحًا", "Par les [chevaux] qui courent haletants,"),
        ("فَالْمُورِيَاتِ قَدْحًا", "et qui font jaillir des étincelles [en frappant le sol],"),
        ("فَالْمُغِيرَاتِ صُبْحًا", "et qui font des incursions au matin,"),
        ("فَأَثَرْنَ بِهِ نَقْعًا", "soulevant ainsi un nuage de poussière,"),
        ("فَوَسَطْنَ بِهِ جَمْعًا", "et se retrouvant au milieu d'une troupe [ennemie],"),
        ("إِنَّ الْإِنسَانَ لِرَبِّهِ لَكَنُودٌ", "l'homme est vraiment ingrat envers son Seigneur."),
        ("وَإِنَّهُ عَلَى ذَلِكَ لَشَهِيدٌ", "Il est lui-même témoin de cela."),
        ("وَإِنَّهُ لِحُبِّ الْخَيْرِ لَشَدِيدٌ", "Et il est vraiment ardent dans l'amour des biens."),
        ("أَفَلَا يَعْلَمُ إِذَا بُعْثِرَ مَا فِي الْقُبُورِ", "Ne sait-il pas que quand on bouleversera le contenu des tombeaux,"),
        ("وَحُصِّلَ مَا فِي الصُّدُورِ", "et qu'on dévoilera ce que renferment les poitrines,"),
        ("إِنَّ رَبَّهُم بِهِمْ يَوْمَئِذٍ لَّخَبِيرٌ", "leur Seigneur, ce Jour-là, sera parfaitement au courant de ce qu'ils auront fait.")
    ]

    static let zalzalah: [(arabic: String, french: String)] = [
        ("إِذَا زُلْزِلَتِ الْأَرْضُ زِلْزَالَهَا", "Quand la terre sera secouée d'un violent séisme,"),
        ("وَأَخْرَجَتِ الْأَرْضُ أَثْقَالَهَا", "et que la terre évacuera ses fardeaux,"),
        ("وَقَالَ الْإِنسَانُ مَا لَهَا", "et que l'homme dira: «Qu'a-t-elle?»"),
        ("يَوْمَئِذٍ تُحَدِّثُ أَخْبَارَهَا", "ce Jour-là, elle contera son histoire,"),
        ("بِأَنَّ رَبَّكَ أَوْحَى لَهَا", "parce que ton Seigneur lui en aura donné l'inspiration."),
        ("يَوْمَئِذٍ يَصْدُرُ النَّاسُ أَشْتَاتًا لِّيُرَوْا أَعْمَالَهُمْ", "Ce Jour-là, les gens sortiront en groupes distincts pour qu'on leur montre leurs œuvres."),
        ("فَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ خَيْرًا يَرَهُ", "Celui qui aura fait le bien, fût-ce du poids d'un atome, le verra."),
        ("وَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ شَرًّا يَرَهُ", "Et celui qui aura fait le mal, fût-ce du poids d'un atome, le verra.")
    ]

    static let qadr: [(arabic: String, french: String)] = [
        ("إِنَّا أَنزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ", "Nous l'avons certes révélé [le Coran] pendant la nuit d'Al-Qadr."),
        ("وَمَا أَدْرَاكَ مَا لَيْلَةُ الْقَدْرِ", "Et comment sauras-tu ce qu'est la nuit d'Al-Qadr?"),
        ("لَيْلَةُ الْقَدْرِ خَيْرٌ مِّنْ أَلْفِ شَهْرٍ", "La nuit d'Al-Qadr est meilleure que mille mois."),
        ("تَنَزَّلُ الْمَلَائِكَةُ وَالرُّوحُ فِيهَا بِإِذْنِ رَبِّهِم مِّن كُلِّ أَمْرٍ", "Les anges et l'Esprit y descendent, par permission de leur Seigneur, pour tout ordre."),
        ("سَلَامٌ هِيَ حَتَّى مَطْلَعِ الْفَجْرِ", "Elle est paix et salut jusqu'à l'apparition de l'aube.")
    ]

    static let alaq: [(arabic: String, french: String)] = [
        ("اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ", "Lis, au nom de ton Seigneur qui a créé,"),
        ("خَلَقَ الْإِنسَانَ مِنْ عَلَقٍ", "qui a créé l'homme d'une adhérence."),
        ("اقْرَأْ وَرَبُّكَ الْأَكْرَمُ", "Lis! Ton Seigneur est le Très Noble,"),
        ("الَّذِي عَلَّمَ بِالْقَلَمِ", "qui a enseigné par le calame,"),
        ("عَلَّمَ الْإِنسَانَ مَا لَمْ يَعْلَمْ", "a enseigné à l'homme ce qu'il ne savait pas.")
    ]
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
