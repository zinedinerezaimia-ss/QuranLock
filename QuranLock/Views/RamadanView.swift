import SwiftUI

// MARK: - Ramadan Main View
struct RamadanView: View {
    @EnvironmentObject var ramadanManager: RamadanManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedSection = 0

    let sections = ["🌙 Jours", "📖 Sourates", "🤲 Duaas", "⭐ Nuits", "🕌 Tarawih", "🍽️ Sunnah"]

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Header
                    ramadanHeader

                    // Section selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(sections.indices, id: \.self) { i in
                                Button(action: { selectedSection = i }) {
                                    Text(sections[i])
                                        .font(.caption.bold())
                                        .foregroundColor(selectedSection == i ? .black : Theme.textSecondary)
                                        .padding(.horizontal, 14).padding(.vertical, 8)
                                        .background(selectedSection == i ? Theme.ramadanGold : Theme.secondaryBg)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal, 16).padding(.vertical, 10)
                    }
                    .background(Theme.secondaryBg)

                    ScrollView {
                        VStack(spacing: 14) {
                            switch selectedSection {
                            case 0: calendarSection
                            case 1: surahsSection
                            case 2: duaasSection
                            case 3: nightsSection
                            case 4: tarawihSection
                            case 5: sunnahSection
                            default: calendarSection
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("🌙 Ramadan 1447")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }.foregroundColor(Theme.ramadanGold)
                }
            }
        }
    }

    // MARK: - Header
    var ramadanHeader: some View {
        VStack(spacing: 10) {
            HStack(spacing: 30) {
                VStack(spacing: 2) {
                    Text("Jour \(ramadanManager.ramadanDay)/30")
                        .font(.title2.bold()).foregroundColor(Theme.ramadanGold)
                    Text("Fajr").font(.caption).foregroundColor(Theme.textSecondary)
                    Text(ramadanManager.fajrTime).font(.headline).foregroundColor(.white)
                }
                VStack(spacing: 2) {
                    Text("Iftar dans").font(.caption).foregroundColor(Theme.textSecondary)
                    Text(ramadanManager.iftarCountdown).font(.title3.bold()).foregroundColor(Theme.ramadanGold)
                    Text("Maghrib \(ramadanManager.maghribTime)").font(.caption).foregroundColor(Theme.textSecondary)
                }
                VStack(spacing: 2) {
                    Text("\(30 - ramadanManager.ramadanDay)")
                        .font(.title2.bold()).foregroundColor(Theme.ramadanGold)
                    Text("jours").font(.caption).foregroundColor(Theme.textSecondary)
                    Text("restants").font(.caption).foregroundColor(Theme.textSecondary)
                }
            }
            if ramadanManager.isLastTenNights {
                Text("⭐ Les 10 dernières nuits — Cherchez Laylat al-Qadr !")
                    .font(.caption.bold()).foregroundColor(Theme.ramadanGold)
                    .padding(8).background(Theme.ramadanPurple.opacity(0.3)).cornerRadius(8)
            }
        }
        .padding(16)
        .background(LinearGradient(colors: [Theme.ramadanPurple, Theme.cardBg], startPoint: .top, endPoint: .bottom))
    }

    // MARK: - 1. Calendar des 30 nuits
    var calendarSection: some View {
        VStack(spacing: 12) {
            infoCard(title: "📅 Les 30 nuits du Ramadan",
                     content: "Chaque nuit du Ramadan a une récompense particulière. Le Prophète ﷺ a dit : « Quiconque jeûne pendant le mois de Ramadan avec foi et espérant la récompense, tous ses péchés antérieurs lui seront pardonnés. »",
                     source: "Sahih al-Bukhari n°38, Sahih Muslim n°760")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(1...30, id: \.self) { day in
                    VStack(spacing: 2) {
                        ZStack {
                            Circle()
                                .fill(day == ramadanManager.ramadanDay ? Theme.ramadanGold :
                                      day < ramadanManager.ramadanDay ? Theme.success.opacity(0.4) :
                                      Theme.secondaryBg)
                                .frame(width: 36, height: 36)
                            if day >= 21 && day % 2 == 1 {
                                // Odd nights - potential Qadr
                                Text("⭐").font(.system(size: 8)).offset(y: -16)
                            }
                            Text("\(day)").font(.caption.bold())
                                .foregroundColor(day == ramadanManager.ramadanDay ? .black :
                                                 day < ramadanManager.ramadanDay ? Theme.success : .white)
                        }
                    }
                }
            }
            .padding().background(Theme.cardBg).cornerRadius(14)

            Text("⭐ Nuits impaires (21, 23, 25, 27, 29) : nuits potentielles de Laylat al-Qadr")
                .font(.caption).foregroundColor(Theme.ramadanGold)
                .multilineTextAlignment(.center)
                .padding(10).background(Theme.ramadanPurple.opacity(0.2)).cornerRadius(10)
        }
    }

    // MARK: - 2. Meilleures sourates à lire
    var surahsSection: some View {
        VStack(spacing: 12) {
            infoCard(title: "📖 Meilleures sourates pendant le Ramadan",
                     content: "Le Prophète ﷺ récitait le Coran entier pendant le Ramadan avec Jibril. Voici les sourates les plus recommandées.",
                     source: "Sahih al-Bukhari n°3554")

            let recommendedSurahs: [(String, String, String, String)] = [
                ("البقرة", "Al-Baqara (2)", "286 versets — La plus longue sourate. Contient Ayat al-Kursi (v.255). Le Prophète ﷺ a dit : « Ne faites pas de vos maisons des tombeaux. Récitez Al-Baqara chez vous. »", "Sahih Muslim n°780"),
                ("يٰس", "Ya-Sin (36)", "83 versets — Cœur du Coran. Recommandée la nuit. « Récitez Ya-Sin pour ceux qui sont en train de mourir. »", "Sunan Abi Dawud n°3121 — chaîne discutée, pratique connue"),
                ("الملك", "Al-Mulk (67)", "30 versets — À lire chaque soir. « Elle intercède pour celui qui la récite jusqu'à ce qu'il soit pardonné. »", "Sunan at-Tirmidhi n°2891, Hassan"),
                ("الكهف", "Al-Kahf (18)", "110 versets — À lire le vendredi. « Celui qui lit Al-Kahf le vendredi, une lumière brillera pour lui entre deux vendredis. »", "Sunan al-Bayhaqi — Hassan selon al-Albani"),
                ("الإخلاص", "Al-Ikhlas (112)", "4 versets — Équivaut au tiers du Coran. « Celui qui la lit 3 fois vaut une khatm. »", "Sahih al-Bukhari n°5013"),
                ("الفاتحة", "Al-Fatiha (1)", "7 versets — Mère du Coran, obligatoire dans chaque rak'ah de prière.", "Sahih al-Bukhari n°756"),
            ]

            ForEach(recommendedSurahs, id: \.1) { surah in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(surah.0).font(.system(size: 24, weight: .bold)).foregroundColor(Theme.ramadanGold)
                        Spacer()
                        Text(surah.1).font(.subheadline.bold()).foregroundColor(.white)
                    }
                    Text(surah.2).font(.subheadline).foregroundColor(.white).lineSpacing(3)
                    Text("📚 Source : \(surah.3)").font(.caption).foregroundColor(Theme.ramadanGold)
                }
                .padding(14).background(Theme.cardBg).cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ramadanPurple.opacity(0.5), lineWidth: 1))
            }
        }
    }

    // MARK: - 3. Duaas du Ramadan
    var duaasSection: some View {
        VStack(spacing: 12) {
            infoCard(title: "🤲 Invocations du Ramadan",
                     content: "Le Prophète ﷺ a dit : « Trois invocations ne sont pas rejetées : celle du père, celle du jeûneur, et celle du voyageur. »",
                     source: "Sunan at-Tirmidhi n°3598, Hassan")

            let duas: [(String, String, String, String, String)] = [
                ("Dua de l'Iftar",
                 "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ",
                 "Dhahaba ẓ-ẓama'u, wabtallatil 'urûqu, wa thabatal ajru in shâ'Allah",
                 "La soif est partie, les veines sont désaltérées, et la récompense est acquise si Allah le veut.",
                 "Sunan Abi Dawud n°2357 — Hassan selon al-Albani"),
                ("Dua du Suhoor",
                 "نَوَيْتُ صَوْمَ غَدٍ لِشَهْرِ رَمَضَانَ الْمُبَارَكِ",
                 "Nawaytu sawma ghadin li shahri Ramadhan al-mubarak",
                 "J'ai l'intention de jeûner demain pour le mois béni de Ramadan.",
                 "Intention du cœur — pratique des savants"),
                ("Dua des 10 dernières nuits",
                 "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
                 "Allāhumma innaka 'afuwwun tuḥibbul 'afwa fa'fu 'annī",
                 "Ô Allah, Tu es le Pardonneur, Tu aimes le pardon, pardonne-moi.",
                 "Sunan at-Tirmidhi n°3513 — Sahih selon al-Albani"),
                ("Dua à la vue du croissant",
                 "اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِالأَمْنِ وَالإِيمَانِ",
                 "Allāhumma ahillahu 'alaynā bil amni wal īmān, was salāmati wal islām, Rabbī wa rabbuka Allah",
                 "Ô Allah, fais apparaître ce croissant sur nous avec sécurité et foi, paix et Islam. Mon Seigneur et ton Seigneur est Allah.",
                 "Sunan at-Tirmidhi n°3451 — Hassan"),
                ("Dua pendant le Ramadan",
                 "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ النَّارِ",
                 "Allāhumma innī as'alukal jannata wa a'ūdhu bika minan nār",
                 "Ô Allah, je Te demande le Paradis et je me réfugie en Toi contre le Feu.",
                 "Sunan Abi Dawud n°792 — Sahih"),
            ]

            ForEach(duas, id: \.0) { dua in
                VStack(alignment: .leading, spacing: 10) {
                    Text(dua.0).font(.headline).foregroundColor(Theme.ramadanGold)
                    Text(dua.1)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white).multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .lineSpacing(6)
                    Text(dua.2).font(.caption.bold()).foregroundColor(Theme.accent).italic()
                    Divider().background(Theme.cardBorder)
                    Text(dua.3).font(.subheadline).foregroundColor(Theme.textSecondary)
                    Text("📚 \(dua.4)").font(.caption).foregroundColor(Theme.ramadanGold)
                }
                .padding(14).background(Theme.cardBg).cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ramadanPurple.opacity(0.5), lineWidth: 1))
            }
        }
    }

    // MARK: - 4. Les nuits importantes
    var nightsSection: some View {
        VStack(spacing: 12) {
            infoCard(title: "⭐ Laylat al-Qadr — La Nuit du Destin",
                     content: "« La Nuit du Destin vaut mieux que mille mois. » (Sourate Al-Qadr, 97:3). À chercher dans les nuits impaires des 10 dernières nuits du Ramadan.",
                     source: "Coran 97:1-5 — Sahih al-Bukhari n°2017")

            let nights: [(String, String, String)] = [
                ("Nuit du 21", "Première nuit impaire des 10 dernières. Intensifie les adorations.", "Sahih al-Bukhari n°2021"),
                ("Nuit du 23", "Le Prophète ﷺ et ses compagnons l'intensifiaient particulièrement.", "Sahih Muslim n°1167"),
                ("Nuit du 25", "Certains savants estiment qu'elle est la plus probable.", "Sunan Abi Dawud — avis des savants"),
                ("Nuit du 27", "La nuit la plus célèbre selon beaucoup de savants. Ubay ibn Ka'b était convaincu que c'était le 27.", "Sahih Muslim n°762"),
                ("Nuit du 29", "Dernière chance. Allah cache cette nuit pour que les croyants adorent dans toutes les nuits impaires.", "Fatawa Ibn Baz"),
            ]

            ForEach(nights, id: \.0) { night in
                HStack(alignment: .top, spacing: 12) {
                    Text("⭐").font(.title3)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(night.0).font(.subheadline.bold()).foregroundColor(Theme.ramadanGold)
                        Text(night.1).font(.subheadline).foregroundColor(.white)
                        Text("📚 \(night.2)").font(.caption).foregroundColor(Theme.ramadanGold)
                    }
                }
                .padding(12).background(Theme.cardBg).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ramadanGold.opacity(0.3), lineWidth: 1))
            }

            infoCard(title: "🤲 Que faire la nuit de Laylat al-Qadr ?",
                     content: "1. Réciter la dua spéciale (Allahumma innaka 'afuwwun...)\n2. Faire du Qiyam (prière de nuit)\n3. Réciter le Coran\n4. Faire du dhikr et de l'istighfar\n5. Faire des duaas sincères",
                     source: "Sunan at-Tirmidhi n°3513, Sahih al-Bukhari n°2024")
        }
    }

    // MARK: - 5. Tarawih
    var tarawihSection: some View {
        VStack(spacing: 12) {
            infoCard(title: "🕌 La prière du Tarawih",
                     content: "Le Prophète ﷺ a dit : « Quiconque accomplit la prière de nuit pendant le Ramadan avec foi et espérant la récompense, tous ses péchés antérieurs lui seront pardonnés. »",
                     source: "Sahih al-Bukhari n°37, Sahih Muslim n°759")

            let tarawihInfo: [(String, String, String)] = [
                ("Nombre de rak'ahs", "8 rak'ahs selon la Sunnah du Prophète ﷺ + 3 de Witr. Certains savants permettent 20 rak'ahs selon la pratique d'Umar ibn al-Khattab (ra).", "Sahih al-Bukhari n°1147 — Muwatta' Malik"),
                ("Heure", "Après la prière d'Isha. Il est préférable de la faire après minuit (Qiyam al-Layl) mais les 2 sont valides.", "Sahih Muslim n°736"),
                ("En groupe ou seul ?", "En groupe à la mosquée est meilleur selon la Sunnah établie par Umar (ra). Seul chez soi est aussi valide.", "Sahih al-Bukhari n°2010"),
                ("Le Witr", "Le Witr (3 rak'ahs ou 1) doit être la dernière prière de la nuit. Il est vivement recommandé.", "Sahih al-Bukhari n°998"),
            ]

            ForEach(tarawihInfo, id: \.0) { info in
                VStack(alignment: .leading, spacing: 8) {
                    Text(info.0).font(.headline).foregroundColor(Theme.ramadanGold)
                    Text(info.1).font(.subheadline).foregroundColor(.white).lineSpacing(3)
                    Text("📚 \(info.2)").font(.caption).foregroundColor(Theme.ramadanGold)
                }
                .padding(14).background(Theme.cardBg).cornerRadius(14)
            }
        }
    }

    // MARK: - 6. Sunnah du Ramadan
    var sunnahSection: some View {
        VStack(spacing: 12) {
            infoCard(title: "🍽️ Sunnahs du Ramadan",
                     content: "Le Prophète ﷺ a enseigné plusieurs pratiques spécifiques pendant le Ramadan que tout Muslim devrait connaître.",
                     source: "Compilé de Sahih al-Bukhari et Sahih Muslim")

            let sunnahs: [(String, String, String, String)] = [
                ("🌅 Suhoor (repas du pré-aube)",
                 "Le Prophète ﷺ a dit : « Prenez le repas du Suhoor car dans le Suhoor il y a une bénédiction. »",
                 "Tardez le Suhoor jusqu'au proche de l'Adhan du Fajr.",
                 "Sahih al-Bukhari n°1923, Sahih Muslim n°1095"),
                ("🌇 Iftar (rupture du jeûne)",
                 "« Les gens ne cesseront d'être dans le bien tant qu'ils hâteront la rupture du jeûne. »",
                 "Rompre avec des dattes fraîches, ou des dattes sèches, ou de l'eau.",
                 "Sahih al-Bukhari n°1957 — Sunan Abi Dawud n°2356"),
                ("💝 Générosité (Sadaqa)",
                 "« Le Prophète ﷺ était la personne la plus généreuse, et il l'était encore plus pendant le Ramadan. »",
                 "Donner la Sadaqa, nourrir les jeûneurs, aider les nécessiteux.",
                 "Sahih al-Bukhari n°1902"),
                ("📖 Récitation du Coran",
                 "Jibril venait chaque nuit du Ramadan réviser le Coran avec le Prophète ﷺ.",
                 "Fixer un objectif de récitation quotidien selon ses capacités.",
                 "Sahih al-Bukhari n°3554"),
                ("🚫 Ce qui ne rompt pas le jeûne",
                 "Le bain, le miswak, les injections médicales non nutritives, les gouttes pour les yeux.",
                 "Avis de la majorité des savants contemporains — Fatawa Ibn Baz et Ibn Uthaymin",
                 "Fatawa des grands savants contemporains"),
                ("⚠️ Ce qui invalide le jeûne",
                 "Manger, boire, les rapports conjugaux intentionnels, le vomissement intentionnel.",
                 "Expier par 60 jours de jeûne ou nourrir 60 pauvres pour les rapports conjugaux.",
                 "Sahih al-Bukhari n°1936, Sahih Muslim n°1111"),
            ]

            ForEach(sunnahs, id: \.0) { sunnah in
                VStack(alignment: .leading, spacing: 8) {
                    Text(sunnah.0).font(.headline).foregroundColor(Theme.ramadanGold)
                    Text(sunnah.1).font(.subheadline).foregroundColor(.white).lineSpacing(3).italic()
                    Text("→ \(sunnah.2)").font(.subheadline).foregroundColor(Theme.textSecondary)
                    Text("📚 \(sunnah.3)").font(.caption).foregroundColor(Theme.ramadanGold)
                }
                .padding(14).background(Theme.cardBg).cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
            }
        }
    }

    // MARK: - Helper
    func infoCard(title: String, content: String, source: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline).foregroundColor(Theme.ramadanGold)
            Text(content).font(.subheadline).foregroundColor(.white).lineSpacing(4)
            Text("📚 \(source)").font(.caption).foregroundColor(Theme.ramadanGold)
        }
        .padding(14)
        .background(LinearGradient(colors: [Theme.ramadanPurple.opacity(0.3), Theme.cardBg], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ramadanGold.opacity(0.3), lineWidth: 1))
    }
}
