import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ramadanManager: RamadanManager
    @State private var showSettings = false
    @State private var questionText = ""
    @State private var aiAnswer: String?
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
                    HStack(spacing: 6) {
                        Text("إقرأ").font(.system(size: 18, weight: .bold)).foregroundColor(Theme.gold)
                        HStack(spacing: 4) {
                            Image(systemName: "hand.thumbsup.fill").font(.caption)
                            Text("\(appState.hasanat)").font(.caption.bold())
                        }
                        .foregroundColor(.white).padding(.horizontal, 10).padding(.vertical, 4)
                        .background(Color.orange).cornerRadius(20)
                    }
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
            .sheet(isPresented: $showSettings) { SettingsView() }
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

    var headerSection: some View {
        VStack(spacing: 4) {
            Text("السلام عليكم \(appState.userName)").font(.system(size: 22, weight: .bold)).foregroundColor(.white)
            Text("Que ta journée soit bénie").font(.subheadline).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 16).cardStyle()
    }

    var ramadanBanner: some View {
        Button(action: { showRamadan = true }) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("🌙 Ramadan Mubarak").font(.headline).foregroundColor(Theme.ramadanGold)
                        Text("Jour \(ramadanManager.ramadanDay)/30 • Appuie pour les duaas & infos")
                            .font(.caption).foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(Theme.ramadanGold)
                }
                HStack(spacing: 20) {
                    VStack { Text("Fajr").font(.caption).foregroundColor(Theme.textSecondary); Text(ramadanManager.fajrTime).font(.headline).foregroundColor(.white) }
                    VStack { Text("Iftar").font(.caption).foregroundColor(Theme.textSecondary); Text(ramadanManager.maghribTime).font(.headline).foregroundColor(Theme.ramadanGold) }
                    VStack { Text("Compte à rebours").font(.caption).foregroundColor(Theme.textSecondary); Text(ramadanManager.iftarCountdown).font(.headline).foregroundColor(Theme.ramadanGold) }
                }
                if ramadanManager.isLastTenNights {
                    HStack {
                        Text("⭐")
                        Text("Les 10 dernières nuits — Cherchez Laylat al-Qadr !").font(.caption).foregroundColor(Theme.ramadanGold)
                    }
                    .padding(8).background(Theme.ramadanPurple.opacity(0.3)).cornerRadius(8)
                }
            }
            .padding()
            .background(LinearGradient(colors: [Theme.ramadanPurple, Theme.cardBg], startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ramadanGold.opacity(0.5), lineWidth: 1.5))
        }
    }

    var preRamadanBanner: some View {
        HStack {
            Text("🌙").font(.title)
            VStack(alignment: .leading) {
                Text("Ramadan approche !").font(.headline).foregroundColor(Theme.gold)
                Text("Plus que \(ramadanManager.daysUntilRamadan) jours").font(.subheadline).foregroundColor(Theme.textSecondary)
            }
            Spacer()
            Button("Préparer") { showRamadan = true }
                .font(.caption.bold()).foregroundColor(.black)
                .padding(.horizontal, 16).padding(.vertical, 8).background(Theme.gold).cornerRadius(20)
        }
        .cardStyle()
    }

    var currentSurahCard: some View {
        let surah = DataProvider.surahs[appState.currentSurahIndex]
        return VStack(spacing: 8) {
            Text("\(surah.id)").font(.headline).foregroundColor(.black)
                .frame(width: 36, height: 36).background(Theme.gold).cornerRadius(8)
            Text(surah.arabicName).font(.system(size: 24, weight: .bold)).foregroundColor(.white)
            Text(surah.frenchName).font(.subheadline).foregroundColor(Theme.textSecondary)
            HStack(spacing: 12) {
                Label("\(surah.verseCount) versets", systemImage: "bookmark.fill").font(.caption).foregroundColor(Theme.textSecondary)
                Label(surah.revelationType, systemImage: "mappin").font(.caption).foregroundColor(Theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity).padding(.vertical, 20).cardStyle()
    }

    var questionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { Text("❓"); Text("Pose ta question").font(.headline).foregroundColor(Theme.gold) }
            HStack {
                TextField("Décris ta situation ou pose ta question...", text: $questionText)
                    .foregroundColor(.white).font(.subheadline)
                Button(action: answerQuestion) {
                    Image(systemName: "paperplane.fill").foregroundColor(.white)
                        .frame(width: 40, height: 40).background(Theme.accent).cornerRadius(20)
                }
            }
            .padding(12).background(Theme.secondaryBg).cornerRadius(12)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    QuickTag(text: "Période difficile") { questionText = "période difficile" }
                    QuickTag(text: "Demander pardon") { questionText = "demander pardon" }
                    QuickTag(text: "Anxiété") { questionText = "anxiété" }
                    QuickTag(text: "Prière") { questionText = "prière" }
                    QuickTag(text: "Ramadan") { questionText = "ramadan" }
                }
            }
            if let answer = aiAnswer {
                VStack(alignment: .leading, spacing: 8) {
                    Text("💡 Réponse").font(.subheadline.bold()).foregroundColor(Theme.gold)
                    Text(answer).font(.subheadline).foregroundColor(.white).lineSpacing(4)
                }
                .padding().background(Theme.secondaryBg).cornerRadius(12)
            }
        }
        .cardStyle()
    }

    var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { Text("⚡"); Text("Accès rapide").font(.headline).foregroundColor(Theme.gold) }
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                QuickAccessButton(icon: "📖", title: "Lire") { appState.selectedTab = 1 }
                QuickAccessButton(icon: "🏁", title: "Khatm") { showKhatm = true }
                QuickAccessButton(icon: "🤲", title: "Adhkar") { showAdhkar = true }
                QuickAccessButton(icon: "🎓", title: "Apprendre") { appState.selectedTab = 2 }
                QuickAccessButton(icon: "🌙", title: "Prophète ﷺ") { showProphet = true }
                QuickAccessButton(icon: "🕌", title: "Mosquées") { showSadaqa = true }
            }
        }
        .cardStyle()
    }

    var communitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("👥"); Text("Communauté").font(.headline).foregroundColor(Theme.gold)
                Spacer()
                Button("Voir tout") { showCommunity = true }.font(.caption).foregroundColor(Theme.accent)
            }
            Button(action: { showMusicChallenge = true }) {
                HStack {
                    Text("🎵"); Text("Défi Arrêter la Musique").font(.subheadline.bold()).foregroundColor(.white)
                    Spacer(); Image(systemName: "chevron.right").foregroundColor(Theme.textSecondary)
                }
                .padding().background(Theme.secondaryBg).cornerRadius(12)
            }
            Text("Récitations de la communauté").font(.subheadline).foregroundColor(Theme.textSecondary)
            Button(action: { showCommunity = true }) {
                Text("Rejoindre la communauté →").font(.subheadline.bold()).foregroundColor(Theme.gold)
            }
        }
        .cardStyle()
    }

    // Réponses islamiques vérifiées avec sources
    func answerQuestion() {
        guard !questionText.isEmpty else { return }
        let q = questionText.lowercased()

        if q.contains("difficile") || q.contains("épreuve") || q.contains("triste") || q.contains("déprim") {
            aiAnswer = "📖 Coran 94:5-6 : « Certes, avec la difficulté vient la facilité. »\n\n🤲 Dua : « Allāhumma lā sahla illā mā ja'altahu sahlā, wa anta taj'alul ḥazna idhā shi'ta sahlā »\n(Ô Allah, rien n'est facile sauf ce que Tu rends facile.)\n📚 Ibn Hibban n°974 — Sahih"
        } else if q.contains("pardon") || q.contains("péché") || q.contains("faute") {
            aiAnswer = "🤲 Sayyid al-Istighfar — Celui qui le dit avec conviction le matin et meurt ce jour entre au Paradis :\n« Allāhumma anta Rabbī, lā ilāha illā anta, khalaqtanī wa ana 'abduk... »\n📚 Sahih al-Bukhari n°6306\n\n📖 Coran 39:53 : « Ne désespérez pas de la miséricorde d'Allah. »"
        } else if q.contains("anxiété") || q.contains("stress") || q.contains("peur") || q.contains("angoisse") {
            aiAnswer = "📖 Coran 13:28 : « C'est par le rappel d'Allah que les cœurs se tranquillisent. »\n\n🤲 Dua du Prophète ﷺ lors de l'anxiété :\n« Allāhumma innī 'abduka, ibnu 'abdika, ibnu amatika, nāṣiyatī biyadik... »\n📚 Musnad Ahmad n°3704 — Sahih selon al-Albani\n\n→ Récite Ayat al-Kursi (2:255) après chaque prière."
        } else if q.contains("prière") || q.contains("salat") {
            aiAnswer = "🕌 Le Prophète ﷺ : « La fraîcheur de mes yeux a été placée dans la prière. »\n📚 Sunan an-Nasa'i n°3940 — Sahih\n\nPour le Khushu' : regarde le lieu de prosternation, comprends ce que tu récites.\n📚 Sahih al-Bukhari n°741"
        } else if q.contains("ramadan") || q.contains("jeûne") {
            aiAnswer = "🌙 Le Prophète ﷺ : « Quiconque jeûne avec foi et espérant la récompense, tous ses péchés antérieurs lui seront pardonnés. »\n📚 Sahih al-Bukhari n°38\n\n🤲 Dua Iftar : « Dhahaba ẓ-ẓama'u, wabtallatil 'urūqu, wa thabatal ajru in shā'Allah »\n📚 Sunan Abi Dawud n°2357 — Hassan\n\n→ Ouvre la bannière Ramadan 🌙 pour plus de contenu."
        } else {
            aiAnswer = "📖 Coran 17:36 : « Ne suis pas ce dont tu n'as pas de connaissance. »\n\nPour une réponse précise, partage ta question avec la communauté ou consulte un imam de confiance. Il vaut mieux s'abstenir que parler sans certitude en matière de religion (fatwa)."
        }
        appState.addHasanat(1)
    }
}

struct QuickTag: View {
    let text: String; let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(text).font(.caption).foregroundColor(.white)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(Theme.secondaryBg).cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.cardBorder, lineWidth: 1))
        }
    }
}

struct QuickAccessButton: View {
    let icon: String; let title: String; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(icon).font(.system(size: 24))
                Text(title).font(.caption).foregroundColor(.white)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background(Theme.secondaryBg).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
        }
    }
}
