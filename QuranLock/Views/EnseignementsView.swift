import SwiftUI

struct EnseignementsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTopic: Enseignement?
    @State private var showPrayerGuide = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        Text(L.teachings)
                            .font(.title2.bold()).foregroundColor(Theme.gold)

                        Text(L.teachingsDesc)
                            .font(.subheadline).foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)

                        // Prayer Guide (special featured card)
                        Button(action: { showPrayerGuide = true }) {
                            HStack(spacing: 12) {
                                Text("🧎").font(.system(size: 36)).frame(width: 44)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(L.prayerGuideTitle).font(.headline).foregroundColor(.white)
                                    Text(L.prayerGuideSub).font(.caption).foregroundColor(Theme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "star.fill").foregroundColor(Theme.gold)
                                Image(systemName: "chevron.right").foregroundColor(Theme.gold)
                            }
                            .padding(16)
                            .background(Theme.gold.opacity(0.1))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.gold, lineWidth: 1))
                        }

                        ForEach(DataProvider.enseignements) { topic in
                            Button(action: { selectedTopic = topic }) {
                                HStack(spacing: 12) {
                                    Text(topic.icon).font(.system(size: 32)).frame(width: 44)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(topic.title).font(.headline).foregroundColor(.white)
                                        Text("\(topic.sections.count) \(L.sections)").font(.caption).foregroundColor(Theme.textSecondary)
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
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
            .sheet(item: $selectedTopic) { topic in
                EnseignementDetailView(topic: topic)
            }
            .sheet(isPresented: $showPrayerGuide) {
                PrayerGuideView()
            }
        }
    }
}

struct EnseignementDetailView: View {
    let topic: Enseignement
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        Text(topic.icon).font(.system(size: 60))
                        Text(topic.title).font(.title.bold()).foregroundColor(Theme.gold)

                        ForEach(topic.sections.indices, id: \.self) { i in
                            let section = topic.sections[i]
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("\(i + 1)")
                                        .font(.caption.bold()).foregroundColor(.black)
                                        .frame(width: 24, height: 24)
                                        .background(Theme.gold).cornerRadius(12)
                                    Text(section.title).font(.headline).foregroundColor(Theme.gold)
                                }
                                Text(section.content).font(.subheadline).foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)

                                if let arabic = section.arabicReference {
                                    Text(arabic).font(.system(size: 16)).foregroundColor(Theme.accent)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                if let hadith = section.hadithReference {
                                    HStack(alignment: .top) {
                                        Image(systemName: "book.fill").foregroundColor(Theme.gold).font(.caption)
                                        Text(hadith).font(.caption).foregroundColor(Theme.gold).italic()
                                    }
                                    .padding(10).background(Theme.gold.opacity(0.08)).cornerRadius(8)
                                }

                                // Share button
                                Button(action: {
                                    AppState.shareText("\(section.title)\n\n\(section.content)\n\n— App Iqra 🤲")
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "square.and.arrow.up")
                                        Text(L.share)
                                    }
                                    .font(.caption).foregroundColor(Theme.gold)
                                }
                            }
                            .cardStyle()
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }
}

// MARK: - Complete Prayer Guide (Step by Step)
struct PrayerGuideView: View {
    @Environment(\.dismiss) var dismiss

    let steps: [(icon: String, title: String, action: String, arabic: String, transliteration: String, translation: String, explanation: String)] = [
        ("1️⃣", "Intention (Niyyah)", "Dans le cœur", "", "", "Formuler l'intention dans le cœur (pas à voix haute) de prier telle prière.", "L'intention est un pilier. Elle se fait dans le cœur avant le Takbir. On précise quelle prière on va accomplir (ex: Dhuhr, 4 raka'at)."),

        ("2️⃣", "Takbir d'ouverture", "Lever les mains aux oreilles", "اللهُ أَكْبَر", "Allâhu Akbar", "Allah est le Plus Grand", "On lève les mains au niveau des oreilles (hommes) ou des épaules (femmes) et on dit 'Allahu Akbar'. C'est le Takbirat al-Ihram qui commence la prière."),

        ("3️⃣", "Du'a d'ouverture", "Mains croisées sur la poitrine", "سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَى جَدُّكَ وَلَا إِلَهَ غَيْرُكَ", "Subhânaka Allâhumma wa bihamdika wa tabâraka ismuka wa ta'âlâ jadduka wa lâ ilâha ghayruk", "Gloire et louange à Toi ô Allah, béni soit Ton nom, exaltée soit Ta majesté, et il n'y a pas de divinité en dehors de Toi.", "Invocation d'ouverture récitée à voix basse. Puis on dit : أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ (Je cherche refuge auprès d'Allah contre Satan le lapidé) puis بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ (Au nom d'Allah le Tout Miséricordieux, le Très Miséricordieux)."),

        ("4️⃣", "Récitation d'Al-Fatiha", "Debout, réciter", "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ ۝ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝ الرَّحْمَنِ الرَّحِيمِ ۝ مَالِكِ يَوْمِ الدِّينِ ۝ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ۝ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ۝ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ", "", "L'Ouverture — sourate obligatoire dans chaque raka'a", "Al-Fatiha est le pilier de la prière. On la récite debout dans chaque raka'a. À la fin on dit آمين (Âmîn). Ensuite on récite une autre sourate (dans les 2 premières raka'at)."),

        ("5️⃣", "Ruku' (Inclinaison)", "S'incliner, mains sur les genoux", "سُبْحَانَ رَبِّيَ الْعَظِيمِ", "Subhâna Rabbiya al-'Azîm", "Gloire à mon Seigneur le Très Grand", "On dit 'Allahu Akbar' et on s'incline, le dos droit et horizontal, les mains sur les genoux. On répète 'Subhana Rabbiya al-'Azim' 3 fois (minimum 1 fois)."),

        ("6️⃣", "Se relever du Ruku'", "Debout, bras le long du corps", "سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ ۝ رَبَّنَا وَلَكَ الْحَمْدُ", "Sami'a Allâhu liman hamidah / Rabbanâ wa laka al-hamd", "Allah entend celui qui Le loue / Seigneur, à Toi la louange", "En se relevant on dit 'Sami'a Allahu liman hamidah' puis debout 'Rabbana wa laka al-hamd'."),

        ("7️⃣", "Premier Sujud (Prosternation)", "Front, nez, paumes, genoux et orteils au sol", "سُبْحَانَ رَبِّيَ الْأَعْلَى", "Subhâna Rabbiya al-A'lâ", "Gloire à mon Seigneur le Très Haut", "On dit 'Allahu Akbar' et on se prosterne. 7 parties du corps touchent le sol : front+nez, 2 paumes, 2 genoux, 2 pieds. On répète 'Subhana Rabbiya al-A'la' 3 fois. C'est le moment le plus proche d'Allah."),

        ("8️⃣", "S'asseoir entre les 2 Sujud", "Assis sur le pied gauche", "رَبِّ اغْفِرْ لِي رَبِّ اغْفِرْ لِي", "Rabbi ighfir lî, Rabbi ighfir lî", "Seigneur pardonne-moi, Seigneur pardonne-moi", "On dit 'Allahu Akbar', on s'assoit sur le pied gauche, pied droit redressé. On dit 'Rabbi ighfir li' 2 fois."),

        ("9️⃣", "Deuxième Sujud", "Même que le premier", "سُبْحَانَ رَبِّيَ الْأَعْلَى", "Subhâna Rabbiya al-A'lâ", "Gloire à mon Seigneur le Très Haut", "Identique au premier sujud. Cela termine la première raka'a. On se relève pour la suivante en disant 'Allahu Akbar'."),

        ("🔟", "Tashahhud (à la 2ème et dernière raka'a)", "Assis, index pointé", "التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ ۝ السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ ۝ السَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ ۝ أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ", "At-tahiyyâtu lillâhi was-salawâtu wat-tayyibât...", "Les salutations appartiennent à Allah...", "Assis après la 2ème raka'a (et la dernière). L'index droit pointe vers la Qibla. On récite le Tashahhud complet. Au dernier Tashahhud, on ajoute la prière sur le Prophète (Salat Ibrahimiya)."),

        ("🏁", "Salam final", "Tourner la tête à droite puis à gauche", "السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ", "As-Salâmu 'alaykum wa rahmatullâh", "Que la paix et la miséricorde d'Allah soient sur vous", "On tourne la tête à droite en disant 'As-Salamu alaykum wa rahmatullah', puis à gauche de même. Cela termine la prière.")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        Text("🧎").font(.system(size: 60))
                        Text(L.prayerGuideTitle).font(.title2.bold()).foregroundColor(Theme.gold)

                        Text("Nombre de raka'at : Fajr 2 • Dhuhr 4 • Asr 4 • Maghrib 3 • Isha 4")
                            .font(.caption).foregroundColor(Theme.accent)
                            .multilineTextAlignment(.center)

                        ForEach(steps.indices, id: \.self) { i in
                            let step = steps[i]
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 8) {
                                    Text(step.icon).font(.title2)
                                    VStack(alignment: .leading) {
                                        Text(step.title).font(.headline).foregroundColor(Theme.gold)
                                        Text(step.action).font(.caption).foregroundColor(Theme.accent)
                                    }
                                }

                                if !step.arabic.isEmpty {
                                    Text(step.arabic)
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.trailing)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(10)
                                        .background(Theme.secondaryBg)
                                        .cornerRadius(10)

                                    if !step.transliteration.isEmpty {
                                        Text(step.transliteration)
                                            .font(.caption).italic().foregroundColor(Theme.textSecondary)
                                    }
                                    Text(step.translation)
                                        .font(.caption).foregroundColor(Theme.accent)
                                }

                                Text(step.explanation)
                                    .font(.subheadline).foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)

                                // Share step
                                Button(action: {
                                    AppState.shareText("\(step.title)\n\n\(step.arabic)\n\n\(step.translation)\n\n\(step.explanation)\n\n— App Iqra 🤲")
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "square.and.arrow.up")
                                        Text(L.share)
                                    }
                                    .font(.caption).foregroundColor(Theme.gold)
                                }
                            }
                            .cardStyle()
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }
}
