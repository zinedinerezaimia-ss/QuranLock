import SwiftUI

// MARK: - Duaa Situationnelle Model
struct SituationalDuaa: Identifiable {
    let id: String
    let title: String
    let arabicText: String
    let phonetic: String
    let translation: String
    let source: String
    let situations: [String] // mots-clés qui déclenchent cette duaa
}

struct DuaasMainView: View {
    @State private var selectedCategory: Duaa.DuaaCategory = .matin
    @State private var showSituational = false
    @State private var situationText = ""
    @State private var matchedDuaas: [SituationalDuaa] = []
    @State private var showPhoneticGlobal = false
    @EnvironmentObject var ramadanManager: RamadanManager
    @EnvironmentObject var languageManager: LanguageManager

    var filteredDuaas: [Duaa] {
        ExtendedDuaaData.allDuaas.filter { $0.category == selectedCategory }
    }

    var categories: [Duaa.DuaaCategory] {
        var cats: [Duaa.DuaaCategory] = [.matin, .soir, .priere, .protection, .pardon, .quotidien, .prophete]
        if ramadanManager.isRamadan { cats.append(.ramadan) }
        return cats
    }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {

                        // MARK: - Phonétique toggle global
                        HStack {
                            Text("🔤 Phonétique").font(.subheadline).foregroundColor(.white)
                            Spacer()
                            Toggle("", isOn: $showPhoneticGlobal).tint(Theme.gold)
                        }
                        .padding(.horizontal, 4)

                        // MARK: - Moteur situationnel
                        situationalCard

                        // MARK: - Catégories
                        VStack(alignment: .leading, spacing: 8) {
                            Text(L.invocations).font(.headline).foregroundColor(Theme.gold)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(categories, id: \.rawValue) { cat in
                                        CategoryPill(icon: cat.icon, title: cat.rawValue, isSelected: selectedCategory == cat) {
                                            selectedCategory = cat
                                        }
                                    }
                                }
                            }
                        }
                        .cardStyle()

                        // Prophet card
                        if selectedCategory == .prophete {
                            ProphetDuaaCard()
                        }

                        // Duaas de la catégorie
                        ForEach(filteredDuaas) { duaa in
                            EnhancedDuaaCard(duaa: duaa, showPhonetic: showPhoneticGlobal)
                        }

                        // Ramadan duaas
                        if ramadanManager.isRamadan && selectedCategory == .ramadan {
                            ForEach(DataProvider.ramadanDuaas) { rd in
                                RamadanDuaaCard(duaa: rd)
                            }
                        }
                    }
                    .padding(.horizontal, 16).padding(.bottom, 20)
                }
            }
            .navigationTitle("Duaas")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Carte situationnelle
    var situationalCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🤲")
                Text("Trouve la doua qui te correspond").font(.headline).foregroundColor(Theme.gold)
            }
            Text("Décris ta situation et reçois les vraies douaas qui correspondent")
                .font(.caption).foregroundColor(Theme.textSecondary)

            HStack(spacing: 10) {
                TextField("Ex: anxiété, chagrin, voyage, mariage...", text: $situationText)
                    .foregroundColor(.white).padding(12)
                    .background(Theme.secondaryBg).cornerRadius(10)

                Button(action: findDuaas) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Theme.accent)
                        .cornerRadius(10)
                }
            }

            // Suggestions rapides
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["Anxiété", "Tristesse", "Voyage", "Mariage", "Maladie", "Examen", "Pluie", "Colère", "Rêve", "Dettes"], id: \.self) { s in
                        Button(action: { situationText = s; findDuaas() }) {
                            Text(s).font(.caption.bold()).foregroundColor(Theme.accent)
                                .padding(.horizontal, 10).padding(.vertical, 5)
                                .background(Theme.accent.opacity(0.1)).cornerRadius(15)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Theme.accent.opacity(0.3), lineWidth: 1))
                        }
                    }
                }
            }

            if !matchedDuaas.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("✅ \(matchedDuaas.count) douaa(s) trouvée(s) :").font(.caption.bold()).foregroundColor(Theme.success)
                    ForEach(matchedDuaas) { d in
                        SituationalDuaaCard(duaa: d, showPhonetic: showPhoneticGlobal)
                    }
                }
            } else if !situationText.isEmpty {
                Text("Aucune correspondance. Essaie : tristesse, espoir, voyage, maladie, peur...").font(.caption).foregroundColor(Theme.textSecondary)
            }
        }
        .cardStyle()
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.accent.opacity(0.2), lineWidth: 1))
    }

    func findDuaas() {
        let q = situationText.lowercased()
        matchedDuaas = ExtendedDuaaData.situationalDuaas.filter { duaa in
            duaa.situations.contains { q.contains($0) }
        }
    }
}

// MARK: - Enhanced Duaa Card (avec phonétique)
struct EnhancedDuaaCard: View {
    let duaa: Duaa
    let showPhonetic: Bool
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("⭐")
                Text(duaa.title).font(.headline).foregroundColor(Theme.gold)
                Spacer()
                Button(action: { withAnimation { expanded.toggle() } }) {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.caption).foregroundColor(Theme.textSecondary)
                }
            }

            Text(duaa.arabicText)
                .font(.system(size: 20, weight: .medium)).foregroundColor(.white)
                .multilineTextAlignment(.trailing).frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)

            if showPhonetic || expanded {
                Text("📢 \(duaa.transliteration)")
                    .font(.subheadline.italic()).foregroundColor(Theme.accent)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if expanded {
                Divider().background(Theme.cardBorder)
                Text(duaa.translation).font(.subheadline).foregroundColor(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Image(systemName: "book.fill").font(.caption)
                    Text(duaa.source).font(.caption)
                }
                .foregroundColor(Theme.accent)
            } else {
                Text(duaa.translation).font(.subheadline).foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
                HStack {
                    Image(systemName: "book.fill").font(.caption)
                    Text(duaa.source).font(.caption)
                }
                .foregroundColor(Theme.accent)
            }
        }
        .cardStyle()
    }
}

// MARK: - Situational Duaa Card
struct SituationalDuaaCard: View {
    let duaa: SituationalDuaa
    let showPhonetic: Bool
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("🤲")
                Text(duaa.title).font(.subheadline.bold()).foregroundColor(Theme.gold)
                Spacer()
                Button(action: { withAnimation { expanded.toggle() } }) {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down").font(.caption).foregroundColor(Theme.textSecondary)
                }
            }
            Text(duaa.arabicText)
                .font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                .multilineTextAlignment(.trailing).frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)
            if showPhonetic || expanded {
                Text("📢 \(duaa.phonetic)").font(.caption.italic()).foregroundColor(Theme.accent)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if expanded {
                Text(duaa.translation).font(.caption).foregroundColor(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text("📚 \(duaa.source)").font(.caption2).foregroundColor(Theme.gold)
            }
        }
        .padding(12).background(Theme.secondaryBg).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
    }
}

// MARK: - All Duaas Data (50+)
struct ExtendedDuaaData {

    static let allDuaas: [Duaa] = [
        // ========== MATIN ==========
        Duaa(id: "m1", title: "Au réveil", arabicText: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ", transliteration: "Al-hamdu lillahi alladhi ahyana ba'da ma amatana wa ilayhi an-nushur", translation: "Louange à Allah qui nous a redonné la vie après nous avoir fait mourir, et vers Lui est le retour.", source: "Bukhari n°6312", category: .matin),
        Duaa(id: "m2", title: "Adhkar du matin (1)", arabicText: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", transliteration: "Asbahna wa asbahal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah", translation: "Nous voilà au matin et la royauté appartient à Allah. Louange à Allah. Il n'y a de divinité qu'Allah, Seul, sans associé.", source: "Muslim n°2720", category: .matin),
        Duaa(id: "m3", title: "Protection du matin", arabicText: "اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ", transliteration: "Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilayka an-nushur", translation: "Ô Allah, c'est grâce à Toi que nous sommes au matin, c'est grâce à Toi que nous sommes au soir, c'est grâce à Toi que nous vivons, c'est grâce à Toi que nous mourrons et vers Toi est le retour.", source: "Tirmidhi n°3391", category: .matin),
        Duaa(id: "m4", title: "Matin — Santé et bien-être", arabicText: "اللَّهُمَّ عَافِنِي فِي بَدَنِي اللَّهُمَّ عَافِنِي فِي سَمْعِي اللَّهُمَّ عَافِنِي فِي بَصَرِي", transliteration: "Allahumma 'afini fi badani, Allahumma 'afini fi sam'i, Allahumma 'afini fi basari", translation: "Ô Allah, accorde-moi la santé dans mon corps. Ô Allah, accorde-moi la santé dans mon ouïe. Ô Allah, accorde-moi la santé dans ma vue.", source: "Abu Dawud n°5090", category: .matin),
        Duaa(id: "m5", title: "Matin — Pardon et guidance", arabicText: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى", transliteration: "Allahumma inni as'aluka al-huda wat-tuqa wal-'afafa wal-ghina", translation: "Ô Allah, je Te demande la guidance, la piété, la chasteté et la suffisance.", source: "Muslim n°2721", category: .matin),
        Duaa(id: "m6", title: "Matin — Sayyid al-Istighfar", arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ", transliteration: "Allahumma anta Rabbi la ilaha illa anta, khalaqtani wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mastata'tu", translation: "Ô Allah, Tu es mon Seigneur. Il n'y a de divinité que Toi. Tu m'as créé et je suis Ton serviteur. Je respecte Ton pacte et Ta promesse autant que je le peux.", source: "Bukhari n°6306", category: .matin),
        Duaa(id: "m7", title: "Matin — Sourate Al-Ikhlas (3x)", arabicText: "قُلْ هُوَ اللَّهُ أَحَدٌ اللَّهُ الصَّمَدُ لَمْ يَلِدْ وَلَمْ يُولَدْ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ", transliteration: "Qul Huwa Allahu Ahad, Allahu As-Samad, Lam yalid wa lam yulad, wa lam yakun lahu kufuwan ahad", translation: "Dis : Il est Allah, l'Unique. Allah, le Seul à être imploré pour ce que nous désirons. Il n'a jamais engendré, n'a pas été engendré non plus. Et nul n'est égal à Lui.", source: "Abu Dawud n°5082 — réciter 3x", category: .matin),

        // ========== SOIR ==========
        Duaa(id: "s1", title: "Adhkar du soir", arabicText: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", transliteration: "Amsayna wa amsal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah", translation: "Nous voilà au soir et la royauté appartient à Allah. Louange à Allah. Il n'y a de divinité qu'Allah, Seul, sans associé.", source: "Muslim n°2723", category: .soir),
        Duaa(id: "s2", title: "Avant de dormir", arabicText: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا", transliteration: "Bismika Allahumma amutu wa ahya", translation: "C'est en Ton nom, ô Allah, que je meurs et que je vis.", source: "Bukhari n°6324", category: .soir),
        Duaa(id: "s3", title: "Soir — Protection complète", arabicText: "اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ", transliteration: "Allahumma bika amsayna wa bika asbahna wa bika nahya wa bika namutu wa ilayka al-masir", translation: "Ô Allah, c'est grâce à Toi que nous sommes au soir, c'est grâce à Toi que nous sommes au matin, c'est grâce à Toi que nous vivons, c'est grâce à Toi que nous mourrons et vers Toi est la destination.", source: "Tirmidhi n°3391", category: .soir),
        Duaa(id: "s4", title: "Avant de dormir — Ayat al-Kursi", arabicText: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ", transliteration: "Allahu la ilaha illa Huwa, al-Hayyul-Qayyum, la ta'khudhuhu sinatun wa la nawm", translation: "Allah ! Il n'y a de divinité que Lui, le Vivant, le Subsistant. Ni somnolence ni sommeil ne Le saisissent.", source: "Bukhari n°5010 — protection toute la nuit", category: .soir),
        Duaa(id: "s5", title: "Soir — Tasbih avant sommeil", arabicText: "سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَٰهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ", transliteration: "SubhanAllah, wal-hamdu lillah, wa la ilaha illAllah, Allahu Akbar (33x chacun)", translation: "Gloire à Allah, louange à Allah, pas de divinité sauf Allah, Allah est le Plus Grand.", source: "Bukhari n°3113 — meilleur des dhikrs avant le sommeil", category: .soir),

        // ========== PRIERE ==========
        Duaa(id: "p1", title: "Entrée à la mosquée", arabicText: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ", transliteration: "Allahumma iftah li abwaba rahmatik", translation: "Ô Allah, ouvre-moi les portes de Ta miséricorde.", source: "Muslim n°713", category: .priere),
        Duaa(id: "p2", title: "Sortie de la mosquée", arabicText: "اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ", transliteration: "Allahumma inni as'aluka min fadlika", translation: "Ô Allah, je Te demande de Ta grâce.", source: "Muslim n°713", category: .priere),
        Duaa(id: "p3", title: "Après la prière (Tasbih)", arabicText: "سُبْحَانَ اللَّهِ ×33 الْحَمْدُ لِلَّهِ ×33 اللَّهُ أَكْبَرُ ×34", transliteration: "SubhanAllah x33, Alhamdulillah x33, Allahu Akbar x34", translation: "Gloire à Allah (33x), Louange à Allah (33x), Allah est le Plus Grand (34x).", source: "Muslim n°597", category: .priere),
        Duaa(id: "p4", title: "Doua du Qunut (prière Witr)", arabicText: "اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ وَعَافِنِي فِيمَنْ عَافَيْتَ", transliteration: "Allahumma-hdini fiman hadayt, wa 'afini fiman 'afayt, wa tawallani fiman tawallayt", translation: "Ô Allah, guide-moi parmi ceux que Tu as guidés, accorde-moi la santé parmi ceux auxquels Tu as accordé la santé.", source: "Abu Dawud n°1425 — Sahih", category: .priere),
        Duaa(id: "p5", title: "Avant la prière (Istiftah)", arabicText: "اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ", transliteration: "Allahumma ba'id bayni wa bayna khatayaya kama ba'adta baynal-mashriqi wal-maghrib", translation: "Ô Allah, éloigne de moi mes fautes comme Tu as éloigné l'Est de l'Ouest.", source: "Bukhari n°744", category: .priere),
        Duaa(id: "p6", title: "Après le Fajr et Maghrib", arabicText: "لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ", transliteration: "La ilaha illAllahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa 'ala kulli shay'in qadir", translation: "Il n'y a de divinité qu'Allah, Seul, sans associé. À Lui appartient la royauté, à Lui la louange, et Il est sur toute chose Puissant.", source: "Muslim n°597 — réciter 10x après Fajr et Maghrib", category: .priere),

        // ========== PROTECTION ==========
        Duaa(id: "pr1", title: "Protection divine — Bismillah", arabicText: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ", transliteration: "Bismillahi alladhi la yadurru ma'a ismihi shay'un fil-ardi wa la fis-sama'i wa huwas-Sami'ul-'Alim", translation: "Au nom d'Allah, avec le Nom de Qui rien ne peut nuire sur terre ni dans le ciel, et Il est l'Audient, l'Omniscient.", source: "Abu Dawud n°5088, Tirmidhi n°3388 — 3x le matin et le soir", category: .protection),
        Duaa(id: "pr2", title: "Protection contre le mal de l'œil", arabicText: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ", transliteration: "A'udhu bi-kalimatillahi at-tammati min sharri ma khalaq", translation: "Je cherche refuge dans les paroles parfaites d'Allah contre le mal de ce qu'Il a créé.", source: "Muslim n°2708 — 3x le soir", category: .protection),
        Duaa(id: "pr3", title: "Protection complète du Prophète ﷺ", arabicText: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ", transliteration: "Allahumma inni a'udhu bika minal-hammi wal-hazan, wa a'udhu bika minal-'ajzi wal-kasal", translation: "Ô Allah, je cherche refuge en Toi contre l'inquiétude et la tristesse, contre l'impuissance et la paresse.", source: "Bukhari n°6363", category: .protection),
        Duaa(id: "pr4", title: "Protection avant de sortir", arabicText: "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", transliteration: "Bismillah, tawakkaltu 'alallah, wa la hawla wa la quwwata illa billah", translation: "Au nom d'Allah, je place ma confiance en Allah. Il n'y a de force ni de puissance qu'en Allah.", source: "Abu Dawud n°5095, Tirmidhi n°3426", category: .protection),
        Duaa(id: "pr5", title: "Ayat al-Kursi — Protection totale", arabicText: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ", transliteration: "Allahu la ilaha illa Huwa, al-Hayyul-Qayyum, la ta'khudhuhu sinatun wa la nawm, lahu ma fis-samawati wa ma fil-ard", translation: "Allah ! Il n'y a de divinité que Lui, le Vivant, le Subsistant. Ni somnolence ni sommeil ne Le saisissent. À Lui appartient ce qui est dans les cieux et sur la terre.", source: "Coran 2:255 — après chaque prière, protection jusqu'à la suivante", category: .protection),

        // ========== PARDON ==========
        Duaa(id: "pa1", title: "Demande de pardon — Adam et Ève", arabicText: "رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ", transliteration: "Rabbana zalamna anfusana wa in lam taghfir lana wa tarhamna lanakounanna minal-khasirin", translation: "Seigneur ! Nous nous sommes fait du tort à nous-mêmes. Si Tu ne nous pardonnes pas et ne nous fais pas miséricorde, nous serons parmi les perdants.", source: "Coran 7:23", category: .pardon),
        Duaa(id: "pa2", title: "Sayyid al-Istighfar", arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَىٰ عَهْدِكَ", transliteration: "Allahumma anta Rabbi la ilaha illa anta, khalaqtani wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mastata'tu, a'udhu bika min sharri ma sana'tu, abu'u laka bini'matika 'alayya, wa abu'u bidhanbī, faghfir li fa'innahu la yaghfiru adh-dhunuba illa anta", translation: "Ô Allah, Tu es mon Seigneur. Il n'y a de divinité que Toi. Tu m'as créé et je suis Ton serviteur. Je respecte Ton pacte et Ta promesse autant que je le peux. Je cherche refuge en Toi contre le mal que j'ai fait. Je reconnais Ta grâce sur moi et je reconnais mon péché. Pardonne-moi, car nul ne pardonne les péchés sauf Toi.", source: "Bukhari n°6306 — le meilleur istighfar", category: .pardon),
        Duaa(id: "pa3", title: "Pardon — Doua de Yunus ﷺ", arabicText: "لَّا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ", transliteration: "La ilaha illa anta subhanaka inni kuntu minadh-dhalimin", translation: "Il n'y a de divinité que Toi. Gloire à Toi ! Certes, je suis du nombre des injustes.", source: "Coran 21:87 — répondu en 40 jours selon les savants", category: .pardon),
        Duaa(id: "pa4", title: "Doua de repentir sincère", arabicText: "رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنتَ التَّوَّابُ الرَّحِيمُ", transliteration: "Rabbighfir li wa tub 'alayya innaka antat-Tawwabur-Rahim", translation: "Seigneur, pardonne-moi et accepte mon repentir. Tu es Celui qui accepte le repentir, le Très Miséricordieux.", source: "Tirmidhi n°3434 — le Prophète ﷺ le récitait 100x par jour", category: .pardon),

        // ========== QUOTIDIEN ==========
        Duaa(id: "q1", title: "Avant de manger", arabicText: "بِسْمِ اللَّهِ", transliteration: "Bismillah", translation: "Au nom d'Allah.", source: "Muslim n°2017", category: .quotidien),
        Duaa(id: "q2", title: "Après avoir mangé", arabicText: "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَٰذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ", transliteration: "Al-hamdu lillahi alladhi at'amani hadha wa razaqaniihi min ghayri hawlin minni wa la quwwah", translation: "Louange à Allah qui m'a nourri de cela et me l'a accordé sans effort ni puissance de ma part.", source: "Tirmidhi n°3458", category: .quotidien),
        Duaa(id: "q3", title: "En sortant de chez soi", arabicText: "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", transliteration: "Bismillah, tawakkaltu 'alallah, la hawla wa la quwwata illa billah", translation: "Au nom d'Allah, je me confie à Allah. Il n'y a de force et de puissance qu'en Allah.", source: "Abu Dawud n°5095", category: .quotidien),
        Duaa(id: "q4", title: "En entrant chez soi", arabicText: "اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلِجِ وَخَيْرَ الْمَخْرَجِ بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا", transliteration: "Allahumma inni as'aluka khayral-mawliji wa khayral-makhraji, bismillahi walajna wa bismillahi kharajna", translation: "Ô Allah, je Te demande la bénédiction à l'entrée et à la sortie. Au nom d'Allah nous sommes entrés, et au nom d'Allah nous sommes sortis.", source: "Abu Dawud n°5096", category: .quotidien),
        Duaa(id: "q5", title: "Avant de dormir — Al-Kafirun", arabicText: "قُلْ يَا أَيُّهَا الْكَافِرُونَ لَا أَعْبُدُ مَا تَعْبُدُونَ", transliteration: "Qul ya ayyuhal-kafirun, la a'budu ma ta'budun...", translation: "Dis : Ô vous les incroyants ! Je n'adore pas ce que vous adorez...", source: "Tirmidhi n°3403 — réciter avant de dormir, protection contre le shirk", category: .quotidien),
        Duaa(id: "q6", title: "En entrant aux toilettes", arabicText: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ", transliteration: "Allahumma inni a'udhu bika minal-khubuti wal-khaba'ith", translation: "Ô Allah, je cherche refuge en Toi contre les démons mâles et femelles.", source: "Bukhari n°142, Muslim n°375", category: .quotidien),
        Duaa(id: "q7", title: "En s'habillant", arabicText: "الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَٰذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ", transliteration: "Alhamdulillahil-ladhi kasani hadha wa razaqaniihi min ghayri hawlin minni wa la quwwah", translation: "Louange à Allah qui m'a vêtu de cela et me l'a accordé sans effort ni puissance de ma part.", source: "Tirmidhi n°3458 — péchés passés pardonnés", category: .quotidien),
        Duaa(id: "q8", title: "Lors d'une difficulté", arabicText: "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ", transliteration: "HasbunAllahu wa ni'mal-Wakil", translation: "Allah nous suffit, Il est le meilleur des garants.", source: "Bukhari n°4563 — parole d'Ibrahim ﷺ quand lancé au feu", category: .quotidien),
        Duaa(id: "q9", title: "Face à un imprévu", arabicText: "إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ", transliteration: "Inna lillahi wa inna ilayhi raji'un", translation: "Certes nous appartenons à Allah et certes vers Lui nous retournons.", source: "Coran 2:156", category: .quotidien),
        Duaa(id: "q10", title: "Quand on est surpris ou admiratif", arabicText: "سُبْحَانَ اللَّهِ", transliteration: "SubhanAllah", translation: "Gloire à Allah.", source: "Bukhari — expression de l'émerveillement", category: .quotidien),

        // ========== PROPHÈTE ﷺ ==========
        Duaa(id: "ph1", title: "Invocation sur le Prophète ﷺ (courte)", arabicText: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ", transliteration: "Allahumma salli 'ala Muhammad wa 'ala ali Muhammad", translation: "Ô Allah, bénis Muhammad et la famille de Muhammad.", source: "Bukhari n°3370 — la salutation sur le Prophète ﷺ", category: .prophete),
        Duaa(id: "ph2", title: "Salat Ibrahimiyya complète", arabicText: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ", transliteration: "Allahumma salli 'ala Muhammad wa 'ala ali Muhammad, kama sallayta 'ala Ibrahim wa 'ala ali Ibrahim, wa barik 'ala Muhammad wa 'ala ali Muhammad kama barakta 'ala Ibrahim wa 'ala ali Ibrahim fil-'alamin, innaka Hamidun Majid", translation: "Ô Allah, bénis Muhammad et la famille de Muhammad comme Tu as béni Ibrahim et la famille d'Ibrahim. Et bénis Muhammad et la famille de Muhammad comme Tu as béni Ibrahim et la famille d'Ibrahim dans les mondes. Tu es certes le Loué, le Glorieux.", source: "Bukhari n°3370 — récitée dans le Tashahhud", category: .prophete),

        // ========== RAMADAN ==========
        Duaa(id: "r1", title: "Doua Laylat al-Qadr", arabicText: "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي", transliteration: "Allahumma innaka 'Afuwwun tuhibbul-'afwa fa'fu 'anni", translation: "Ô Allah, Tu es le Pardonneur, Tu aimes le pardon, alors pardonne-moi.", source: "Tirmidhi n°3513 — Sahih — pour les 10 dernières nuits", category: .ramadan),
        Duaa(id: "r2", title: "Rupture du jeûne", arabicText: "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ", transliteration: "Dhahaba adh-dhama'u wabtallatil-'uruqu wa thabatal-ajru in sha Allah", translation: "La soif est partie, les veines sont humidifiées et la récompense est confirmée si Allah le veut.", source: "Abu Dawud n°2357 — Hassan", category: .ramadan),
        Duaa(id: "r3", title: "Intention du jeûne", arabicText: "نَوَيْتُ صَوْمَ غَدٍ مِنْ شَهْرِ رَمَضَانَ الْمُبَارَكِ فَرْضًا لِلَّهِ تَعَالَى", transliteration: "Nawaytu sawma ghadin min shahri Ramadanal-mubarak fardan lillahi ta'ala", translation: "J'ai l'intention de jeûner demain du mois de Ramadan béni, par obligation pour Allah le Très-Haut.", source: "Intention recommandée avant le Fajr", category: .ramadan)
    ]

    // MARK: - Situational Duaas (50+)
    static let situationalDuaas: [SituationalDuaa] = [
        SituationalDuaa(id: "sit1", title: "Anxiété et inquiétude", arabicText: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ", phonetic: "Allahumma inni a'udhu bika minal-hammi wal-hazan, wal-'ajzi wal-kasal, wal-bukhli wal-jubn, wa dhala'id-dayni wa ghalabatir-rijal", translation: "Ô Allah, je cherche refuge en Toi contre l'anxiété et la tristesse, l'impuissance et la paresse, l'avarice et la lâcheté, le poids des dettes et la domination des hommes.", source: "Bukhari n°6363", situations: ["anxiété", "anxiete", "angoisse", "stress", "inquiet", "peur", "worri", "nervous"]),

        SituationalDuaa(id: "sit2", title: "Tristesse et chagrin", arabicText: "اللَّهُمَّ إِنِّي عَبْدُكَ ابْنُ عَبْدِكَ ابْنُ أَمَتِكَ نَاصِيَتِي بِيَدِكَ", phonetic: "Allahumma inni 'abduka ibnu 'abdika ibnu amatika, nasiyati biyadik, madin fiyya hukmuk, 'adlun fiyya qada'uk, as'aluka bikulli ismin huwa lak, sammayta bihi nafsak, aw 'allamtahu ahadan min khalqik, aw anzaltahu fi kitabik, aw ista'tharta bihi fi 'ilmil-ghaybi 'indak, an taj'alal-Qurana rabi'a qalbi, wa nura sadri, wa jala'a huzni, wa dhahaba hammi", translation: "Ô Allah, je suis Ton serviteur, fils de Ton serviteur, fils de Ta servante. Mon destin est entre Tes mains. Ton jugement s'applique à moi. Ton décret est juste. Je Te demande par chacun de Tes noms... de faire du Coran le printemps de mon cœur, la lumière de ma poitrine, la dissipation de ma tristesse et la disparition de mon inquiétude.", source: "Musnad Ahmad n°3704 — Sahih selon al-Albani", situations: ["tristesse", "chagrin", "peine", "déprime", "malheur", "pleurer", "pleure", "depressed", "sad"]),

        SituationalDuaa(id: "sit3", title: "Voyage", arabicText: "اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَٰذَا الْبِرَّ وَالتَّقْوَى", phonetic: "Allahumma inna nas'aluka fi safarina hadhal-birra wat-taqwa, wa minal-'amali ma tarda, Allahumma hawwin 'alayna safarana hadha, watwi 'anna bu'dah", translation: "Ô Allah, nous Te demandons dans ce voyage la piété et la crainte de Toi, et parmi les actes ce qui T'agrée. Ô Allah, facilite pour nous ce voyage et abrège-nous sa distance.", source: "Muslim n°1342", situations: ["voyage", "voyager", "déplacement", "avion", "route", "partir", "trip", "travel"]),

        SituationalDuaa(id: "sit4", title: "Maladie et douleur", arabicText: "أَسْأَلُ اللَّهَ الْعَظِيمَ رَبَّ الْعَرْشِ الْعَظِيمِ أَنْ يَشْفِيَكَ", phonetic: "As'alullahul-'azima rabbal-'arshil-'azim an yashfiyak", translation: "Je demande à Allah l'Immense, Seigneur du Trône Immense, de te guérir.", source: "Tirmidhi n°2083 — 7 fois pour la guérison", situations: ["maladie", "malade", "douleur", "mal", "blessure", "santé", "guérison", "médecin", "hopital", "hôpital", "sick"]),

        SituationalDuaa(id: "sit5", title: "Examen et décision difficile", arabicText: "اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ", phonetic: "Allahumma inni astakhiruka bi'ilmik, wa astaqdiruka biqudratik, wa as'aluka min fadlikal-'azim, fa'innaka taqdiru wa la aqdir, wa ta'lamu wa la a'lam, wa anta 'allamul-ghuyub", translation: "Ô Allah, je Te demande de me guider avec Ta science, de me donner la capacité avec Ta puissance et je Te demande de Ta grande faveur. Car Tu as le pouvoir et je ne l'ai pas, Tu sais et je ne sais pas, Tu es le Connaisseur de l'invisible.", source: "Bukhari n°6382 — prière de l'Istikhara (2 rak'at puis cette doua)", situations: ["examen", "décision", "choix", "istikhara", "hésiter", "hésitation", "incertitude", "test"]),

        SituationalDuaa(id: "sit6", title: "Dettes et difficultés financières", arabicText: "اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ", phonetic: "Allahumma-kfini bihalâlika 'an haramik, wa aghnini bifadlika 'amman siwak", translation: "Ô Allah, suffis-moi avec le halal pour que je n'aie pas recours au haram, et enrichis-moi par Ta grâce pour que je n'aie pas besoin d'autre que Toi.", source: "Tirmidhi n°3563 — Sahih", situations: ["dette", "dettes", "argent", "pauvre", "pauvreté", "financier", "money", "rizq", "subsistance"]),

        SituationalDuaa(id: "sit7", title: "Mariage et conjoint", arabicText: "رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا", phonetic: "Rabbana hab lana min azwajina wa dhurriyyatina qurrata a'yunin waj'alna lil-muttaqina imama", translation: "Seigneur, accorde-nous, de nos épouses et de nos descendants, la joie de nos yeux et fais de nous un modèle pour les pieux.", source: "Coran 25:74", situations: ["mariage", "marier", "conjoint", "époux", "épouse", "femme", "mari", "nikah", "célibataire"]),

        SituationalDuaa(id: "sit8", title: "Enfants et descendance", arabicText: "رَبِّ هَبْ لِي مِن لَّدُنكَ ذُرِّيَّةً طَيِّبَةً إِنَّكَ سَمِيعُ الدُّعَاءِ", phonetic: "Rabbi hab li min ladunka dhurriyyatan tayyibah, innaka sami'ud-du'a'", translation: "Seigneur, accorde-moi de Ta part une bonne descendance. Tu es Celui qui entend la prière.", source: "Coran 3:38 — doua de Zakariya ﷺ", situations: ["enfant", "bébé", "grossesse", "enceinte", "fertilité", "infertilité", "descendance"]),

        SituationalDuaa(id: "sit9", title: "Pluie et bénédiction", arabicText: "اللَّهُمَّ أَغِثْنَا اللَّهُمَّ أَغِثْنَا اللَّهُمَّ أَغِثْنَا", phonetic: "Allahumma aghithna, Allahumma aghithna, Allahumma aghithna", translation: "Ô Allah, fais tomber la pluie sur nous. Ô Allah, fais tomber la pluie sur nous. Ô Allah, fais tomber la pluie sur nous.", source: "Bukhari n°1013", situations: ["pluie", "sécheresse", "eau", "chaleur", "météo"]),

        SituationalDuaa(id: "sit10", title: "Colère", arabicText: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ", phonetic: "A'udhu billahi minash-shaytanir-rajim", translation: "Je cherche refuge auprès d'Allah contre le diable maudit.", source: "Bukhari n°3282 — pour maîtriser la colère", situations: ["colère", "énervement", "nerveux", "énervé", "dispute", "conflict", "anger"]),

        SituationalDuaa(id: "sit11", title: "Rêve (bon ou mauvais)", arabicText: "الْحَمْدُ لِلَّهِ — après un bon rêve / أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ — après un mauvais", phonetic: "Alhamdulillah — bon rêve / A'udhu billahi minash-shaytanir-rajim — mauvais rêve (puis cracher 3x à gauche)", translation: "Après un bon rêve : Dis Alhamdulillah et tu peux en parler. Après un mauvais rêve : Cherche refuge contre Satan, crache légèrement 3x à gauche, ne le raconte à personne et change de côté.", source: "Muslim n°2261", situations: ["rêve", "cauchemar", "dormir", "nuit", "vision"]),

        SituationalDuaa(id: "sit12", title: "Entrée au marché/commerce", arabicText: "لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لَا يَمُوتُ بِيَدِهِ الْخَيْرُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ", phonetic: "La ilaha illAllahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd, yuhyi wa yumitu wa huwa hayyun la yamut, biyadihil-khayr, wa huwa 'ala kulli shay'in qadir", translation: "Il n'y a de divinité qu'Allah, Seul, sans associé. À Lui la royauté et la louange. Il vivifie et Il fait mourir. Il est le Vivant qui ne meurt pas. Entre Ses mains est le bien. Il est sur toute chose Puissant.", source: "Tirmidhi n°3428 — 1 million de bonnes actions récompensées", situations: ["marché", "commerce", "magasin", "shopping", "achat", "vente", "travail", "emploi"]),

        SituationalDuaa(id: "sit13", title: "Quand on se regarde dans le miroir", arabicText: "اللَّهُمَّ أَنْتَ حَسَّنْتَ خَلْقِي فَحَسِّنْ خُلُقِي", phonetic: "Allahumma anta hassanta khalqi fa-hassin khuluqi", translation: "Ô Allah, Tu as embelli ma création, embellis aussi mon caractère.", source: "Musnad Ahmad n°3823 — Sahih", situations: ["miroir", "beauté", "apparence", "regard", "confiance"]),

        SituationalDuaa(id: "sit14", title: "Lors d'un vent fort ou d'une tempête", arabicText: "اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ مَا فِيهَا وَأَعُوذُ بِكَ مِنْ شَرِّهَا", phonetic: "Allahumma inni as'aluka khayrahā wa khayra ma fiha, wa a'udhu bika min sharriha", translation: "Ô Allah, je Te demande son bien et le bien qu'elle contient, et je cherche refuge en Toi contre son mal.", source: "Muslim n°899", situations: ["vent", "tempête", "orage", "pluie forte", "storm"]),

        SituationalDuaa(id: "sit15", title: "Lors d'une mort ou deuil", arabicText: "إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ اللَّهُمَّ أْجُرْنِي فِي مُصِيبَتِي وَأَخْلِفْ لِي خَيْرًا مِنْهَا", phonetic: "Inna lillahi wa inna ilayhi raji'un, Allahumma-jurni fi musibati wa akhlif li khayran minha", translation: "Certes nous appartenons à Allah et c'est à Lui que nous retournons. Ô Allah, récompense-moi dans cette épreuve et remplace-moi par quelque chose de meilleur.", source: "Muslim n°918", situations: ["mort", "décès", "deuil", "enterrement", "perte", "janaza", "funérailles"])
    ]
}

// MARK: - Category Pill
struct CategoryPill: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(icon).font(.caption)
                Text(title).font(.caption.bold())
            }
            .foregroundColor(isSelected ? .black : .white)
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(isSelected ? Theme.gold : Theme.secondaryBg)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(isSelected ? Theme.gold : Theme.cardBorder, lineWidth: 1))
        }
    }
}

// MARK: - Duaa Card (compatibilité)
struct DuaaCard: View {
    let duaa: Duaa
    var body: some View {
        EnhancedDuaaCard(duaa: duaa, showPhonetic: false)
    }
}

// MARK: - Prophet Duaa Card
struct ProphetDuaaCard: View {
    @State private var showPhonetic = true
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("💚")
                VStack(alignment: .leading, spacing: 2) {
                    Text("Duaa pour le Prophète Muhammad ﷺ").font(.headline).foregroundColor(Theme.gold)
                    Text("Sallallahu alayhi wa salam").font(.caption.italic()).foregroundColor(Theme.textSecondary)
                }
            }
            Text("اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ عَبْدِكَ وَرَسُولِكَ النَّبِيِّ الْأُمِّيِّ")
                .font(.system(size: 20, weight: .medium)).foregroundColor(.white)
                .multilineTextAlignment(.trailing).frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)
            Button(action: { withAnimation { showPhonetic.toggle() } }) {
                HStack {
                    Text(showPhonetic ? "Masquer la phonétique" : "Voir la phonétique").font(.caption.bold()).foregroundColor(Theme.accent)
                    Spacer()
                    Image(systemName: showPhonetic ? "chevron.up" : "chevron.down").font(.caption).foregroundColor(Theme.accent)
                }
            }
            if showPhonetic {
                Text("Allahumma salli wa sallim wa barik 'ala sayyidina Muhammad 'abdika wa rasulikan-nabiyyil-ummi...").font(.subheadline.italic()).foregroundColor(Theme.accent).fixedSize(horizontal: false, vertical: true)
            }
            Divider().background(Theme.cardBorder)
            Text("Ô Allah, prie, salue et bénis notre Seigneur Muhammad, Ton serviteur et Ton messager, le Prophète illettré.").font(.subheadline).foregroundColor(Theme.textSecondary).fixedSize(horizontal: false, vertical: true)
            HStack {
                Image(systemName: "star.fill").font(.caption).foregroundColor(Theme.gold)
                Text("Salutation sur le Prophète ﷺ — Bukhari").font(.caption).foregroundColor(Theme.gold)
            }
        }
        .cardStyle()
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.green.opacity(0.3), lineWidth: 1))
    }
}

// MARK: - Ramadan Duaa Card
struct RamadanDuaaCard: View {
    let duaa: RamadanDuaa
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("🌙")
                Text(duaa.title).font(.headline).foregroundColor(Theme.ramadanGold)
                Spacer()
                Text(duaa.category).font(.caption).foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Theme.ramadanPurple).cornerRadius(8)
            }
            Text(duaa.arabicText).font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                .multilineTextAlignment(.trailing).frame(maxWidth: .infinity, alignment: .trailing)
            Text(duaa.phonetic).font(.subheadline.italic()).foregroundColor(Theme.accent)
            Divider().background(Theme.cardBorder)
            Text(duaa.translation).font(.subheadline).foregroundColor(Theme.textSecondary)
            Text("📌 \(duaa.context)").font(.caption).foregroundColor(Theme.gold)
        }
        .cardStyle()
    }
}

// MARK: - Adhkar Views
struct AdhkarMainView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 12) {
                        Text("🤲 Adhkar & Dhikrs").font(.title2.bold()).foregroundColor(Theme.gold)
                        ForEach(DataProvider.adhkarCategories) { cat in
                            NavigationLink(destination: AdhkarDetailView(category: cat)) {
                                HStack {
                                    Text(cat.icon).font(.title2)
                                    VStack(alignment: .leading) {
                                        Text(cat.title).font(.headline).foregroundColor(.white)
                                        Text(cat.subtitle).font(.caption).foregroundColor(Theme.textSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundColor(Theme.gold)
                                }
                                .cardStyle()
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
        }
    }
}

struct AdhkarDetailView: View {
    let category: AdhkarCategory
    @State private var counters: [String: Int] = [:]
    var body: some View {
        ZStack {
            Theme.primaryBg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 12) {
                    Text("\(category.icon) \(category.title)").font(.title2.bold()).foregroundColor(Theme.gold)
                    ForEach(category.adhkars) { dhikr in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(dhikr.title).font(.headline).foregroundColor(Theme.gold)
                            Text(dhikr.arabicText).font(.system(size: 20)).foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Text(dhikr.transliteration).font(.caption.italic()).foregroundColor(Theme.accent)
                            Text(dhikr.translation).font(.subheadline).foregroundColor(Theme.textSecondary)
                            HStack {
                                Text("Répéter \(dhikr.repetitions)x").font(.caption).foregroundColor(Theme.accent)
                                Spacer()
                                HStack(spacing: 12) {
                                    Text("\(counters[dhikr.id] ?? 0)/\(dhikr.repetitions)").font(.headline).foregroundColor(Theme.gold)
                                    Button(action: {
                                        let c = counters[dhikr.id] ?? 0
                                        if c < dhikr.repetitions { counters[dhikr.id] = c + 1 }
                                    }) {
                                        Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(Theme.gold)
                                    }
                                }
                            }
                            if let reward = dhikr.reward { Text("🎁 \(reward)").font(.caption).foregroundColor(Theme.success) }
                            Text("📖 \(dhikr.source)").font(.caption).foregroundColor(Theme.textSecondary)
                        }
                        .cardStyle()
                    }
                }
                .padding()
            }
        }
    }
}
