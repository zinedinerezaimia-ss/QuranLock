import SwiftUI

// MARK: - Verse Data
struct SurahVerses {
    let surahId: Int
    let verses: [(Int, String, String)] // (num, arabic, french)
}

struct VerseProvider {
    static let surahVerses: [Int: [(Int, String, String)]] = [
        1: [
            (1, "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", "Au nom d'Allah, le Tout Miséricordieux, le Très Miséricordieux."),
            (2, "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", "Louange à Allah, Seigneur de l'univers."),
            (3, "الرَّحْمَٰنِ الرَّحِيمِ", "Le Tout Miséricordieux, le Très Miséricordieux,"),
            (4, "مَالِكِ يَوْمِ الدِّينِ", "Maître du Jour de la rétribution."),
            (5, "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", "C'est Toi [Seul] que nous adorons, et c'est Toi [Seul] dont nous implorons le secours."),
            (6, "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ", "Guide-nous dans le droit chemin,"),
            (7, "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ", "le chemin de ceux que Tu as comblés de faveurs, non pas de ceux qui ont encouru [Ta] colère, ni des égarés.")
        ],
        112: [
            (1, "قُلْ هُوَ اللَّهُ أَحَدٌ", "Dis : « Il est Allah, [le] Un."),
            (2, "اللَّهُ الصَّمَدُ", "Allah, le Seul à être imploré pour ce que nous désirons."),
            (3, "لَمْ يَلِدْ وَلَمْ يُولَدْ", "Il n'a pas engendré, n'a pas été engendré"),
            (4, "وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ", "et nul n'est égal à Lui. »")
        ],
        113: [
            (1, "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ", "Dis : « Je cherche protection auprès du Seigneur de l'Aube naissante,"),
            (2, "مِن شَرِّ مَا خَلَقَ", "contre le mal de ce qu'Il a créé,"),
            (3, "وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ", "contre le mal de l'obscurité quand elle s'étend,"),
            (4, "وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ", "contre le mal de celles qui soufflent sur les nœuds,"),
            (5, "وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ", "et contre le mal de l'envieux quand il envie. »")
        ],
        114: [
            (1, "قُلْ أَعُوذُ بِرَبِّ النَّاسِ", "Dis : « Je cherche protection auprès du Seigneur des hommes,"),
            (2, "مَلِكِ النَّاسِ", "du Roi des hommes,"),
            (3, "إِلَٰهِ النَّاسِ", "du Dieu des hommes,"),
            (4, "مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ", "contre le mal du mauvais chuchoteur qui se dérobe,"),
            (5, "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ", "qui souffle le mal dans les poitrines des hommes,"),
            (6, "مِنَ الْجِنَّةِ وَالنَّاسِ", "qu'il soit djinn ou être humain. »")
        ],
        108: [
            (1, "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ", "Nous t'avons accordé l'Abondance (Al-Kawthar)."),
            (2, "فَصَلِّ لِرَبِّكَ وَانْحَرْ", "Accomplis donc la prière pour ton Seigneur et sacrifie."),
            (3, "إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ", "C'est bien ton ennemi qui est sans postérité.")
        ],
        110: [
            (1, "إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ", "Quand vient le secours d'Allah et la victoire,"),
            (2, "وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا", "que tu vois les gens entrer en foule dans la religion d'Allah,"),
            (3, "فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ ۚ إِنَّهُ كَانَ تَوَّابًا", "alors célèbre les louanges de ton Seigneur et implore Son pardon. Certes, Il est Grand Accueillant au repentir.")
        ],
        109: [
            (1, "قُلْ يَا أَيُّهَا الْكَافِرُونَ", "Dis : « Ô vous les infidèles !"),
            (2, "لَا أَعْبُدُ مَا تَعْبُدُونَ", "Je n'adore pas ce que vous adorez."),
            (3, "وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ", "Et vous n'adorez pas ce que j'adore."),
            (4, "وَلَا أَنَا عَابِدٌ مَّا عَبَدتُّمْ", "Je n'adore pas ce que vous adorez."),
            (5, "وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ", "Et vous n'adorez pas ce que j'adore."),
            (6, "لَكُمْ دِينُكُمْ وَلِيَ دِينِ", "À vous votre religion, et à moi la mienne. »")
        ],
        103: [
            (1, "وَالْعَصْرِ", "Par le Temps !"),
            (2, "إِنَّ الْإِنسَانَ لَفِي خُسْرٍ", "L'homme est certes en perdition,"),
            (3, "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ", "sauf ceux qui ont cru, accompli de bonnes œuvres, et mutuellement recommandé la vérité et mutuellement recommandé l'endurance.")
        ],
        105: [
            (1, "أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ بِأَصْحَابِ الْفِيلِ", "N'as-tu pas vu comment ton Seigneur a agi envers les gens de l'Éléphant ?"),
            (2, "أَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ", "N'a-t-Il pas réduit leur stratagème à néant ?"),
            (3, "وَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ", "Il lança contre eux des oiseaux en bandes,"),
            (4, "تَرْمِيهِم بِحِجَارَةٍ مِّن سِجِّيلٍ", "qui leur lançaient des pierres d'argile cuite,"),
            (5, "فَجَعَلَهُمْ كَعَصْفٍ مَّأْكُولٍ", "et Il les rendit pareils à une paille mâchée.")
        ],
        107: [
            (1, "أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ", "As-tu vu celui qui traite de mensonge la Religion ?"),
            (2, "فَذَٰلِكَ الَّذِي يَدُعُّ الْيَتِيمَ", "C'est lui qui repousse l'orphelin,"),
            (3, "وَلَا يَحُضُّ عَلَىٰ طَعَامِ الْمِسْكِينِ", "et qui n'encourage pas à nourrir le pauvre."),
            (4, "فَوَيْلٌ لِّلْمُصَلِّينَ", "Malheur donc à ceux qui prient"),
            (5, "الَّذِينَ هُمْ عَن صَلَاتِهِمْ سَاهُونَ", "mais sont distraits dans leur prière,"),
            (6, "الَّذِينَ هُمْ يُرَاءُونَ", "qui font [leurs actes] par ostentation"),
            (7, "وَيَمْنَعُونَ الْمَاعُونَ", "et refusent les ustensiles de première nécessité.")
        ],
        111: [
            (1, "تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ", "Que périssent les deux mains d'Abû Lahab ! Et il périt, lui aussi."),
            (2, "مَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ", "Sa richesse et ce qu'il a acquis ne lui ont servi à rien."),
            (3, "سَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ", "Il sera brûlé dans un feu plein de flammes,"),
            (4, "وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ", "ainsi que sa femme, la porteuse de bois (de la calomniatrice),"),
            (5, "فِي جِيدِهَا حَبْلٌ مِّن مَّسَدٍ", "à son cou, une corde de fibres.")
        ],
        102: [
            (1, "أَلْهَاكُمُ التَّكَاثُرُ", "La course aux richesses vous distrait"),
            (2, "حَتَّىٰ زُرْتُمُ الْمَقَابِرَ", "jusqu'à ce que vous visitiez les tombeaux."),
            (3, "كَلَّا سَوْفَ تَعْلَمُونَ", "Non ! Vous saurez bientôt."),
            (4, "ثُمَّ كَلَّا سَوْفَ تَعْلَمُونَ", "Puis non ! Vous saurez bientôt."),
            (5, "كَلَّا لَوْ تَعْلَمُونَ عِلْمَ الْيَقِينِ", "Non ! Si vous saviez d'une science certaine..."),
            (6, "لَتَرَوُنَّ الْجَحِيمَ", "Vous verrez assurément la Fournaise."),
            (7, "ثُمَّ لَتَرَوُنَّهَا عَيْنَ الْيَقِينِ", "Puis vous la verrez avec une vision certaine."),
            (8, "ثُمَّ لَتُسْأَلُنَّ يَوْمَئِذٍ عَنِ النَّعِيمِ", "Puis, ce jour-là, vous serez certainement interrogés sur les délices.")
        ],
        101: [
            (1, "الْقَارِعَةُ", "L'Assommeuse !"),
            (2, "مَا الْقَارِعَةُ", "Qu'est-ce que l'Assommeuse ?"),
            (3, "وَمَا أَدْرَاكَ مَا الْقَارِعَةُ", "Et comment sauras-tu ce qu'est l'Assommeuse ?"),
            (4, "يَوْمَ يَكُونُ النَّاسُ كَالْفَرَاشِ الْمَبْثُوثِ", "Le jour où les gens seront comme des papillons éparpillés,"),
            (5, "وَتَكُونُ الْجِبَالُ كَالْعِهْنِ الْمَنفُوشِ", "et les montagnes comme une laine cardée."),
            (6, "فَأَمَّا مَن ثَقُلَتْ مَوَازِينُهُ", "Quant à celui dont la balance est lourde,"),
            (7, "فَهُوَ فِي عِيشَةٍ رَّاضِيَةٍ", "il aura une vie agréable."),
            (8, "وَأَمَّا مَنْ خَفَّتْ مَوَازِينُهُ", "Mais quant à celui dont la balance est légère,"),
            (9, "فَأُمُّهُ هَاوِيَةٌ", "le gouffre sera sa Mère."),
            (10, "وَمَا أَدْرَاكَ مَا هِيَهْ", "Et comment sauras-tu ce qu'il est ?"),
            (11, "نَارٌ حَامِيَةٌ", "C'est un feu ardent.")
        ],
        99: [
            (1, "إِذَا زُلْزِلَتِ الْأَرْضُ زِلْزَالَهَا", "Quand la Terre tremblera d'un puissant tremblement,"),
            (2, "وَأَخْرَجَتِ الْأَرْضُ أَثْقَالَهَا", "et que la Terre fera sortir ses fardeaux,"),
            (3, "وَقَالَ الْإِنسَانُ مَا لَهَا", "et que l'homme dira : « Qu'a-t-elle ? »"),
            (4, "يَوْمَئِذٍ تُحَدِّثُ أَخْبَارَهَا", "Ce jour-là, elle racontera ses nouvelles,"),
            (5, "بِأَنَّ رَبَّكَ أَوْحَىٰ لَهَا", "parce que ton Seigneur lui aura inspiré [de le faire]."),
            (6, "يَوْمَئِذٍ يَصْدُرُ النَّاسُ أَشْتَاتًا لِّيُرَوْا أَعْمَالَهُمْ", "Ce jour-là, les gens ressortiront en groupes dispersés pour qu'on leur montre leurs œuvres."),
            (7, "فَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ خَيْرًا يَرَهُ", "Quiconque aura fait le poids d'un atome de bien, le verra."),
            (8, "وَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ شَرًّا يَرَهُ", "Et quiconque aura fait le poids d'un atome de mal, le verra.")
        ],
        114: [
            (1, "قُلْ أَعُوذُ بِرَبِّ النَّاسِ", "Dis : « Je cherche protection auprès du Seigneur des hommes,"),
            (2, "مَلِكِ النَّاسِ", "du Roi des hommes,"),
            (3, "إِلَٰهِ النَّاسِ", "du Dieu des hommes,"),
            (4, "مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ", "contre le mal du mauvais chuchoteur qui se dérobe,"),
            (5, "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ", "qui souffle le mal dans les poitrines des hommes,"),
            (6, "مِنَ الْجِنَّةِ وَالنَّاسِ", "qu'il soit djinn ou être humain. »")
        ]
    ]
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
                Text("\(surah.verseCount) versets • \(surah.revelationType)").font(.caption).foregroundColor(Theme.textSecondary)
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
    @State private var reflectionText = ""

    var verses: [(Int, String, String)]? {
        VerseProvider.surahVerses[surah.id]
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

                        // Verses or online link
                        if let verseList = verses {
                            ForEach(verseList, id: \.0) { verse in
                                VerseCard(number: verse.0, arabic: verse.1, french: verse.2)
                            }
                        } else {
                            // Longer surah — direct to online
                            VStack(spacing: 12) {
                                Text("📖").font(.system(size: 40))
                                Text("Cette sourate contient \(surah.verseCount) versets.")
                                    .font(.headline).foregroundColor(.white).multilineTextAlignment(.center)
                                Text("Pour lire le texte complet en arabe avec traduction, utilise l'une des applications ci-dessous.")
                                    .font(.subheadline).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center)

                                VStack(spacing: 10) {
                                    externalLink(title: "🌐 Quran.com", subtitle: "Texte arabe + traduction française")
                                    externalLink(title: "📱 Ayah — Coran pour iOS", subtitle: "Application dédiée à la récitation")
                                    externalLink(title: "🎙️ iQuran", subtitle: "Avec récitation audio intégrée")
                                }
                            }
                            .padding()
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

    func externalLink(title: String, subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.bold()).foregroundColor(.white)
                Text(subtitle).font(.caption).foregroundColor(Theme.textSecondary)
            }
            Spacer()
            Image(systemName: "arrow.up.right.square").foregroundColor(Theme.gold)
        }
        .padding(12).background(Theme.secondaryBg).cornerRadius(10)
    }
}

// MARK: - Verse Card
struct VerseCard: View {
    let number: Int
    let arabic: String
    let french: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            HStack {
                Text("\(number)")
                    .font(.caption.bold()).foregroundColor(.black)
                    .frame(width: 24, height: 24).background(Theme.gold).cornerRadius(12)
                Spacer()
            }
            Text(arabic)
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineSpacing(8)

            Divider().background(Theme.cardBorder)

            Text(french)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineSpacing(4)
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
