import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ramadanManager: RamadanManager
    @State private var questionText = ""
    @State private var aiAnswer: String?
    @State private var isLoading = false
    @State private var showSettings = false
    @State private var showCommunity = false
    @State private var showMusicChallenge = false
    @State private var showEnseignements = false
    @State private var showAdhkar = false
    @State private var showKhatm = false
    @State private var showProphet = false
    @State private var showSadaqa = false
    @State private var showRamadan = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        headerSection
                        if ramadanManager.isRamadan {
                            ramadanBanner
                        } else if ramadanManager.daysUntilRamadan > 0 && ramadanManager.daysUntilRamadan <= 30 {
                            preRamadanBanner
                        }
                        currentSurahCard
                        questionSection
                        quickAccessSection
                        communitySection
                    }
                    .padding(.horizontal, 16).padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("إقرأ").font(.system(size: 18, weight: .bold)).foregroundColor(Theme.gold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        if ramadanManager.isRamadan {
                            Button(action: { showRamadan = true }) {
                                Text("🌙").font(.title3).padding(6)
                                    .background(Theme.ramadanPurple.opacity(0.5)).cornerRadius(10)
                            }
                        }
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape.fill").foregroundColor(Theme.textSecondary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView().environmentObject(appState).environmentObject(languageManagerPlaceholder) }
            .sheet(isPresented: $showCommunity) { CommunityView() }
            .sheet(isPresented: $showMusicChallenge) { MusicChallengeView() }
            .sheet(isPresented: $showEnseignements) { EnseignementsView() }
            .sheet(isPresented: $showAdhkar) { AdhkarMainView() }
            .sheet(isPresented: $showKhatm) { KhatmChallengeView() }
            .sheet(isPresented: $showProphet) { ProphetStoriesView() }
            .sheet(isPresented: $showSadaqa) { SadaqaView() }
            .sheet(isPresented: $showRamadan) {
                RamadanView().environmentObject(ramadanManager)
            }
        }
    }

    // MARK: - Header
    var headerSection: some View {
        VStack(spacing: 4) {
            Text("السلام عليكم \(appState.userName)").font(.system(size: 22, weight: .bold)).foregroundColor(.white)
            Text("Que ta journée soit bénie").font(.subheadline).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 16).cardStyle()
    }

    // MARK: - Ramadan Banners
    var ramadanBanner: some View {
        Button(action: { showRamadan = true }) {
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("🌙 Ramadan Mubarak").font(.headline).foregroundColor(Theme.ramadanGold)
                        Text("Jour \(ramadanManager.ramadanDay)/30 • Appuie pour les duaas & infos")
                            .font(.caption).foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(Theme.ramadanGold)
                }
            }
            .cardStyle()
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ramadanGold.opacity(0.4), lineWidth: 1))
        }
    }

    var preRamadanBanner: some View {
        VStack(spacing: 4) {
            Text("🌙 Ramadan dans \(ramadanManager.daysUntilRamadan) jours").font(.headline).foregroundColor(Theme.ramadanGold)
            Text("Prépare-toi spirituellement").font(.caption).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity).cardStyle()
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ramadanGold.opacity(0.3), lineWidth: 1))
    }

    // MARK: - Current Surah Card
    var currentSurahCard: some View {
        let surah = DataProvider.surahs[min(appState.currentSurahIndex, DataProvider.surahs.count - 1)]
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("📖 Là où tu en es").font(.headline).foregroundColor(Theme.gold)
                Spacer()
                Text("Sourate \(surah.id)/114").font(.caption).foregroundColor(Theme.textSecondary)
            }
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(surah.arabicName).font(.title2.bold()).foregroundColor(.white)
                    Text(surah.frenchName).font(.subheadline).foregroundColor(Theme.textSecondary)
                    Text(surah.phonetic).font(.caption.italic()).foregroundColor(Theme.accent)
                }
                Spacer()
                Text("\(surah.verseCount) versets").font(.caption).foregroundColor(Theme.textSecondary)
            }
            ProgressView(value: Double(appState.currentSurahIndex), total: 114).tint(Theme.gold)
            Text("\(Int((Double(appState.currentSurahIndex) / 114.0) * 100))% du Coran lu").font(.caption).foregroundColor(Theme.textSecondary)
        }
        .cardStyle()
    }

    // MARK: - Question Section (IA améliorée)
    var questionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("❓")
                Text("Pose ta question").font(.headline).foregroundColor(Theme.gold)
            }

            HStack(spacing: 10) {
                TextField("Décris ta situation ou pose ta question...", text: $questionText)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Theme.secondaryBg)
                    .cornerRadius(10)

                Button(action: askQuestion) {
                    ZStack {
                        Circle().fill(Theme.accent).frame(width: 44, height: 44)
                        if isLoading {
                            ProgressView().tint(.white).scaleEffect(0.7)
                        } else {
                            Image(systemName: "paperplane.fill").foregroundColor(.white)
                        }
                    }
                }
                .disabled(isLoading || questionText.isEmpty)
            }

            // Tags suggestions
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["Période difficile", "Demander pardon", "Anxiété", "Prière", "Ramadan", "Famille", "Travail", "Santé"], id: \.self) { tag in
                        QuickTag(text: tag) { questionText = tag }
                    }
                }
            }

            if let answer = aiAnswer {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("💡").font(.title3)
                        Text("Réponse").font(.headline).foregroundColor(Theme.gold)
                    }
                    Text(answer)
                        .font(.subheadline).foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(5)

                    Text("⚠️ Pour une fatwa personnelle, consulte toujours un imam de confiance.")
                        .font(.caption).foregroundColor(Theme.textSecondary.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .background(Theme.secondaryBg)
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.gold.opacity(0.2), lineWidth: 1))
            }
        }
        .cardStyle()
    }

    // MARK: - Question IA Logic
    func askQuestion() {
        guard !questionText.isEmpty else { return }
        isLoading = true
        aiAnswer = nil
        let q = questionText.lowercased()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            aiAnswer = generateIslamicAnswer(for: q)
            isLoading = false
        }
    }

    func generateIslamicAnswer(for q: String) -> String {
        // Thèmes principaux détectés
        if q.contains("difficulté") || q.contains("difficile") || q.contains("période") || q.contains("epreuve") || q.contains("épreuve") || q.contains("souffrance") {
            return """
            📖 Coran 94:5-6 : « Certes, avec la difficulté vient la facilité. »

            🤲 Doua du Prophète ﷺ lors des épreuves :
            « Allāhumma lā sahla illā mā ja'altahu sahlā, wa anta taj'alul ḥazna idhā shi'ta sahlā »
            Ô Allah, rien n'est facile sauf ce que Tu rends facile, et Tu peux rendre facile ce qui est difficile si Tu le veux.
            📚 Ibn Hibban n°974 — Sahih

            📖 Coran 2:286 : « Allah n'impose à aucune âme une charge au-delà de ses capacités. »

            💡 Conseil : La difficulté est un signe qu'Allah te fait confiance. Le Prophète ﷺ a dit : « Plus l'épreuve est grande, plus la récompense est grande. »
            📚 Tirmidhi n°2396 — Hassan Sahih
            """
        }

        if q.contains("pardon") || q.contains("péché") || q.contains("faute") || q.contains("tawbah") || q.contains("istighfar") {
            return """
            🤲 Sayyid al-Istighfar — Le meilleur des demandes de pardon :
            « Allāhumma anta Rabbī, lā ilāha illā anta, khalaqtanī wa anā 'abduk, wa anā 'alā 'ahdika wa wa'dika mastata'tu, a'ūdhu bika min sharri mā ṣana'tu, abū'u laka bini'matika 'alayya, wa abū'u bidhanbī, faghfir lī fa'innahu lā yaghfiru adh-dhunūba illā anta. »
            📚 Sahih al-Bukhari n°6306

            📖 Coran 39:53 : « Ne désespérez pas de la miséricorde d'Allah. Certes Allah pardonne tous les péchés. Il est le Tout Pardonnant, le Très Miséricordieux. »

            💡 Les conditions du repentir sincère (Tawbah) :
            1. Regretter sincèrement l'acte
            2. Cesser immédiatement
            3. Avoir la ferme intention de ne plus recommencer
            4. Restituer les droits si quelqu'un a été lésé
            """
        }

        if q.contains("anxiété") || q.contains("anxiete") || q.contains("angoisse") || q.contains("stress") || q.contains("peur") || q.contains("inquiet") {
            return """
            📖 Coran 13:28 : « C'est par le rappel d'Allah que les cœurs se tranquillisent. »

            🤲 Doua du Prophète ﷺ lors de l'anxiété :
            « Allāhumma innī 'abduka, ibnu 'abdika, ibnu amatika, nāṣiyatī biyadik, māḍin fiyya ḥukmuk, 'adlun fiyya qaḍā'uk, as'aluka bi-kulli ismin huwa laka... »
            📚 Musnad Ahmad n°3704 — Sahih selon al-Albani

            💡 Pratiques recommandées :
            • Récite Ayat al-Kursi (2:255) après chaque prière
            • Sourate Al-Duha (93) — révélée quand le Prophète ﷺ était dans la détresse
            • Le dhikr : « HasbunAllahu wa ni'mal-Wakil » (Allah nous suffit)
            📚 Bukhari n°4563
            """
        }

        if q.contains("prière") || q.contains("salat") || q.contains("namaz") || q.contains("concentration") || q.contains("khushu") {
            return """
            🕌 Le Prophète ﷺ : « La fraîcheur de mes yeux a été placée dans la prière. »
            📚 Sunan an-Nasa'i n°3940 — Sahih

            💡 Pour améliorer ton Khushu' (concentration) :
            • Fais le Wudu avec attention, chaque geste compte
            • Rappelle-toi que tu parles à Allah directement
            • Regarde le lieu de prosternation pendant la prière
            • Comprends ce que tu récites — apprends la traduction d'Al-Fatiha

            📖 Coran 23:1-2 : « Heureux les croyants qui sont humbles dans leurs prières. »

            🤲 Doua avant la prière :
            « Allāhumma bā'id baynī wa bayna khaṭāyāya kamā bā'adta bayna l-mashriqi wa l-maghrib. »
            📚 Bukhari n°744
            """
        }

        if q.contains("famille") || q.contains("parent") || q.contains("mère") || q.contains("père") || q.contains("enfant") {
            return """
            📖 Coran 17:23-24 : « Ton Seigneur a décrété que vous n'adoriez que Lui et que vous soyez bons envers vos parents... abaisse envers eux l'aile de l'humilité par miséricorde et dis : Seigneur, fais-leur miséricorde comme ils m'ont élevé petit enfant. »

            🤲 Doua pour les parents :
            « Rabbir ḥamhumā kamā rabbayānī ṣaghīrā »
            Seigneur, fais-leur miséricorde comme ils m'ont élevé petit enfant.
            📚 Coran 17:24

            💡 Le Prophète ﷺ a dit : « Le paradis se trouve sous les pieds des mères. »
            📚 Ibn Majah n°2781 — Sahih selon al-Albani

            💡 Concernant les conflits familiaux : Le Prophète ﷺ a dit : « Celui qui coupe les liens de parenté n'entrera pas au Paradis. »
            📚 Bukhari n°5984
            """
        }

        if q.contains("travail") || q.contains("argent") || q.contains("rizq") || q.contains("subsistance") || q.contains("emploi") || q.contains("chômage") {
            return """
            📖 Coran 65:3 : « Quiconque place sa confiance en Allah, Il lui suffira. Allah atteint ce qu'Il veut. »

            🤲 Doua pour le rizq (subsistance) :
            « Allāhumma innī as'aluka 'ilman nāfi'an wa rizqan ṭayyiban wa 'amalan mutaqabbalan »
            Ô Allah, je Te demande une science utile, une bonne subsistance et une œuvre acceptée.
            📚 Ibn Majah n°925 — Sahih

            💡 Le Prophète ﷺ a dit : « Cherchez la subsistance tôt le matin, car l'aube est bénie. »
            📚 Tabarani — Hassan

            📖 Coran 11:6 : « Il n'est pas de créature sur terre dont Allah ne prenne pas en charge la subsistance. »
            """
        }

        if q.contains("santé") || q.contains("maladie") || q.contains("malade") || q.contains("guérison") || q.contains("shifa") {
            return """
            📖 Coran 26:80 : « Et quand je suis malade, c'est Lui qui me guérit. »

            🤲 Doua de la maladie — récité 7 fois sur la partie douloureuse :
            « A'ūdhu bi-'izzatillāhi wa qudratihi min sharri mā ajidu wa uḥādhiru »
            Je cherche refuge dans la puissance et la toute-puissance d'Allah contre le mal que je ressens et que je crains.
            📚 Muslim n°2202

            🤲 Doua pour visiter un malade :
            « As'alullāhal-'aẓīma rabbil-'arshil-'aẓīmi an yashfiyak »
            Je demande à Allah l'Immense, Seigneur du Trône Immense, de te guérir. (7 fois)
            📚 Tirmidhi n°2083 — Hassan Sahih

            💡 Le Prophète ﷺ a dit : « Pour chaque maladie, Allah a créé un remède. »
            📚 Muslim n°2204
            """
        }

        if q.contains("mort") || q.contains("décès") || q.contains("deuil") || q.contains("janaza") || q.contains("enterrement") {
            return """
            📖 Coran 2:156 : « Ceux qui, lorsqu'un malheur les atteint, disent : Nous appartenons à Allah et c'est à Lui que nous retournons. »

            🤲 Doua pour le défunt :
            « Allāhummaghfir lahu warḥamhu wa 'āfihi wa'fu 'anhu »
            Ô Allah, pardonne-lui, fais-lui miséricorde, accorde-lui le salut et pardonne-lui.
            📚 Muslim n°963

            🤲 Parole lors d'un décès (Inna lillahi wa inna ilayhi raji'un) :
            « Certes nous appartenons à Allah et certes vers Lui nous retournons. Ô Allah, rends-moi ma récompense dans cette épreuve et remplace pour moi ce que j'ai perdu par quelque chose de meilleur. »
            📚 Muslim n°918

            💡 Le Prophète ﷺ a dit : « La mort est un cadeau pour le croyant. »
            📚 Kanz al-Ummal
            """
        }

        if q.contains("mariage") || q.contains("nikah") || q.contains("époux") || q.contains("femme") || q.contains("mari") || q.contains("divorce") {
            return """
            📖 Coran 30:21 : « Et parmi Ses signes : Il a créé pour vous, de vos semblables, des épouses pour que vous viviez en tranquillité avec elles et Il a mis entre vous de l'amour et de la bonté. »

            🤲 Doua pour trouver un conjoint pieux :
            « Rabbī hab lī min ladunka dhurriyyatan ṭayyibah »
            Seigneur, accorde-moi de Ta part une bonne descendance.
            📚 Coran 3:38

            🤲 Doua des époux lors du mariage :
            « Bārakallāhu laka wa bāraka 'alayka wa jama'a baynakumā fī khayr »
            📚 Abu Dawud n°2130 — Sahih

            💡 Le Prophète ﷺ : « Le meilleur d'entre vous est celui qui est le meilleur envers sa famille. »
            📚 Tirmidhi n°3895 — Sahih
            """
        }

        if q.contains("ramadan") || q.contains("iftar") || q.contains("suhoor") || q.contains("jeûne") || q.contains("jeune") {
            return """
            🌙 Le Prophète ﷺ : « Quiconque jeûne avec foi et espérant la récompense, tous ses péchés antérieurs lui seront pardonnés. »
            📚 Sahih al-Bukhari n°38

            🤲 Doua Iftar :
            « Dhahaba aẓ-ẓama'u, wabtallatil-'urūqu, wa thabatal-ajru in shā'Allāh »
            La soif est partie, les veines sont humidifiées, et la récompense est confirmée si Allah le veut.
            📚 Sunan Abi Dawud n°2357 — Hassan

            🤲 Doua de Laylat al-Qadr (les 10 dernières nuits) :
            « Allāhumma innaka 'afuwwun tuḥibbul-'afwa fa'fu 'annī »
            Ô Allah, Tu es le Pardonneur, Tu aimes le pardon, alors pardonne-moi.
            📚 Tirmidhi n°3513 — Sahih

            💡 Les 5 piliers du Ramadan : Le jeûne, la prière de Tarawih, la Sadaqa, la récitation du Coran, les Duaas.
            """
        }

        // Réponse générale si aucun thème spécifique détecté
        return """
        📖 Coran 2:186 : « Quand Mes serviteurs t'interrogent à Mon sujet, [dis-leur] : Je suis tout proche d'eux. Je réponds à l'appel de celui qui M'invoque. »

        🤲 Doua universel du Prophète ﷺ :
        « Allāhumma innī as'aluka al-hudā wat-tuqā wal-'afāfa wal-ghinā »
        Ô Allah, je Te demande la guidance, la piété, la chasteté et la suffisance.
        📚 Muslim n°2721

        💡 Quel que soit ton besoin, Allah est proche. Le Prophète ﷺ a dit : « L'invocation EST l'adoration. »
        📚 Tirmidhi n°2969 — Sahih

        → Précise ta situation dans la zone de texte pour une réponse plus adaptée, ou consulte la section Douaas de l'app pour des invocations selon ta situation.

        ⚠️ Pour les questions de jurisprudence spécifiques (halal/haram, fatwa), consulte un imam qualifié.
        """
    }

    // MARK: - Quick Access
    var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("⚡ Accès rapide").font(.headline).foregroundColor(.white)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                QuickAccessButton(icon: "🎓", title: "Enseignements") { showEnseignements = true }
                QuickAccessButton(icon: "📿", title: "Adhkar") { showAdhkar = true }
                QuickAccessButton(icon: "📜", title: "Khatm") { showKhatm = true }
                QuickAccessButton(icon: "🌿", title: "Prophètes") { showProphet = true }
                QuickAccessButton(icon: "💰", title: "Sadaqa") { showSadaqa = true }
                QuickAccessButton(icon: "🎵", title: "Défi 40j") { showMusicChallenge = true }
            }
        }
        .cardStyle()
    }

    var communitySection: some View {
        Button(action: { showCommunity = true }) {
            HStack {
                Text("👥")
                VStack(alignment: .leading, spacing: 2) {
                    Text("Communauté").font(.headline).foregroundColor(.white)
                    Text("Partage et progresse avec d'autres musulmans").font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(Theme.gold)
            }
            .cardStyle()
        }
    }

    // Placeholder pour le LanguageManager dans la sheet
    var languageManagerPlaceholder: LanguageManager { LanguageManager() }
}

// MARK: - Quick Tag
struct QuickTag: View {
    let text: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(text).font(.caption.bold()).foregroundColor(.white)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(Theme.secondaryBg).cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.cardBorder, lineWidth: 1))
        }
    }
}

// MARK: - Quick Access Button
struct QuickAccessButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(icon).font(.title2)
                Text(title).font(.caption.bold()).foregroundColor(.white).multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background(Theme.cardBg).cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
        }
    }
}
