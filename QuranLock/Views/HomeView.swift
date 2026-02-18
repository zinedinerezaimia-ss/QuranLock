import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ramadanManager: RamadanManager
    @State private var showSettings = false
    @State private var showQuestion = false
    @State private var questionText = ""
    @State private var aiAnswer: String?
    @State private var showCommunity = false
    @State private var showMusicChallenge = false
    @State private var showEnseignements = false
    @State private var showAdhkar = false
    @State private var showKhatm = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Header
                        headerSection
                        
                        // Ramadan Banner (if active)
                        if ramadanManager.isRamadan && appState.ramadanModeEnabled {
                            ramadanBanner
                        } else if ramadanManager.daysUntilRamadan > 0 && ramadanManager.daysUntilRamadan <= 30 {
                            preRamadanBanner
                        }
                        
                        // Current Surah Card
                        currentSurahCard
                        
                        // AI Question Section
                        questionSection
                        
                        // Quick Access Grid
                        quickAccessSection
                        
                        // Community Recitations
                        communitySection
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 6) {
                        Text("إقرأ")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.gold)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "hand.thumbsup.fill")
                                .font(.caption)
                            Text("\(appState.hasanat)")
                                .font(.caption.bold())
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .cornerRadius(20)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showCommunity) {
                CommunityView()
            }
            .sheet(isPresented: $showMusicChallenge) {
                MusicChallengeView()
            }
            .sheet(isPresented: $showEnseignements) {
                EnseignementsView()
            }
            .sheet(isPresented: $showAdhkar) {
                AdhkarMainView()
            }
            .sheet(isPresented: $showKhatm) {
                KhatmChallengeView()
            }
        }
    }
    
    // MARK: - Header
    var headerSection: some View {
        VStack(spacing: 4) {
            Text("السلام عليكم \(appState.userName)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            Text("Que ta journée soit bénie")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .cardStyle()
    }
    
    // MARK: - Ramadan Banner
    var ramadanBanner: some View {
        VStack(spacing: 12) {
            HStack {
                Text("🌙 Ramadan Mubarak")
                    .font(.headline)
                    .foregroundColor(Theme.ramadanGold)
                Spacer()
                Text("Jour \(ramadanManager.ramadanDay)/30")
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.ramadanGold)
            }
            
            HStack(spacing: 20) {
                VStack {
                    Text("Fajr")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text(ramadanManager.fajrTime)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                VStack {
                    Text("Iftar")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text(ramadanManager.maghribTime)
                        .font(.headline)
                        .foregroundColor(Theme.ramadanGold)
                }
                
                VStack {
                    Text("Compte à rebours")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text(ramadanManager.iftarCountdown)
                        .font(.headline)
                        .foregroundColor(Theme.ramadanGold)
                }
            }
            
            if ramadanManager.isLastTenNights {
                HStack {
                    Text("⭐")
                    Text("Les 10 dernières nuits — Multipliez vos adorations !")
                        .font(.caption)
                        .foregroundColor(Theme.ramadanGold)
                }
                .padding(8)
                .background(Theme.ramadanPurple.opacity(0.3))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            LinearGradient(colors: [Theme.ramadanPurple, Theme.cardBg], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ramadanGold.opacity(0.3), lineWidth: 1))
    }
    
    var preRamadanBanner: some View {
        HStack {
            Text("🌙")
                .font(.title)
            VStack(alignment: .leading) {
                Text("Ramadan approche !")
                    .font(.headline)
                    .foregroundColor(Theme.gold)
                Text("Plus que \(ramadanManager.daysUntilRamadan) jours")
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            Spacer()
            Button("Activer") {
                appState.ramadanModeEnabled = true
            }
            .font(.caption.bold())
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Theme.gold)
            .cornerRadius(20)
        }
        .cardStyle()
    }
    
    // MARK: - Current Surah
    var currentSurahCard: some View {
        let surah = DataProvider.surahs[appState.currentSurahIndex]
        return VStack(spacing: 8) {
            Text("\(surah.id)")
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 36, height: 36)
                .background(Theme.gold)
                .cornerRadius(8)
            
            Text(surah.arabicName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(surah.frenchName)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            HStack(spacing: 12) {
                Label("\(surah.verseCount) versets", systemImage: "bookmark.fill")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                Label(surah.revelationType, systemImage: "mappin")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .cardStyle()
    }
    
    // MARK: - Question Section
    var questionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("❓")
                Text("Pose ta question")
                    .font(.headline)
                    .foregroundColor(Theme.gold)
            }
            
            HStack {
                TextField("Décris ta situation ou pose ta question...", text: $questionText)
                    .foregroundColor(.white)
                    .font(.subheadline)
                
                Button(action: answerQuestion) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Theme.accent)
                        .cornerRadius(20)
                }
            }
            .padding(12)
            .background(Theme.secondaryBg)
            .cornerRadius(12)
            
            // Quick tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    QuickTag(text: "Période difficile") { questionText = "Je traverse une période difficile" }
                    QuickTag(text: "Demander pardon") { questionText = "Comment demander pardon à Allah" }
                    QuickTag(text: "Anxiété") { questionText = "Je souffre d'anxiété" }
                    QuickTag(text: "Prière") { questionText = "Comment améliorer ma prière" }
                }
            }
            
            if let answer = aiAnswer {
                VStack(alignment: .leading, spacing: 8) {
                    Text("💡 Réponse")
                        .font(.subheadline.bold())
                        .foregroundColor(Theme.gold)
                    Text(answer)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Theme.secondaryBg)
                .cornerRadius(12)
            }
        }
        .cardStyle()
    }
    
    // MARK: - Quick Access
    var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("⚡")
                Text("Accès rapide")
                    .font(.headline)
                    .foregroundColor(Theme.gold)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                QuickAccessButton(icon: "📖", title: "Lire") { }
                QuickAccessButton(icon: "🏁", title: "Khatm") { showKhatm = true }
                QuickAccessButton(icon: "🤲", title: "Adhkar") { showAdhkar = true }
                QuickAccessButton(icon: "🎓", title: "Apprendre") { showEnseignements = true }
                QuickAccessButton(icon: "🌙", title: "Prophète ﷺ") { }
                QuickAccessButton(icon: "🕌", title: "Mosquées") { }
            }
        }
        .cardStyle()
    }
    
    // MARK: - Community Section
    var communitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("👥")
                Text("Communauté")
                    .font(.headline)
                    .foregroundColor(Theme.gold)
                Spacer()
                Button("Voir tout") { showCommunity = true }
                    .font(.caption)
                    .foregroundColor(Theme.accent)
            }
            
            // Music challenge shortcut
            Button(action: { showMusicChallenge = true }) {
                HStack {
                    Text("🎵")
                    Text("Défi Arrêter la Musique")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.textSecondary)
                }
                .padding()
                .background(Theme.secondaryBg)
                .cornerRadius(12)
            }
            
            Text("Récitations de la communauté")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Button(action: { showCommunity = true }) {
                Text("Rejoindre la communauté →")
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.gold)
            }
        }
        .cardStyle()
    }
    
    func answerQuestion() {
        guard !questionText.isEmpty else { return }
        
        // Simple keyword-based matching for offline functionality
        let q = questionText.lowercased()
        
        if q.contains("difficile") || q.contains("épreuve") || q.contains("triste") {
            aiAnswer = "🤲 Allah dit dans le Coran : « Certes, avec la difficulté, il y a une facilité » (Sourate Ash-Sharh, 94:6).\n\nRécite beaucoup d'Istighfar et fais confiance à Allah. Chaque épreuve est une purification et une élévation en degré."
        } else if q.contains("pardon") || q.contains("péché") {
            aiAnswer = "🤲 Récite le Sayyid al-Istighfar :\n« Allahumma anta Rabbi, la ilaha illa anta... »\n\nAllah dit : « Dis : Ô Mes serviteurs qui avez commis des excès à votre propre détriment, ne désespérez pas de la miséricorde d'Allah. » (39:53)"
        } else if q.contains("anxiété") || q.contains("stress") || q.contains("peur") {
            aiAnswer = "🤲 Le Prophète ﷺ recommandait de dire : « HasbunAllahu wa ni'mal Wakil » (Allah nous suffit, Il est le meilleur garant).\n\nRécite aussi Sourate Al-Fatiha et Ayat Al-Kursi régulièrement. La prière et le dhikr apaisent le cœur."
        } else if q.contains("prière") || q.contains("salat") {
            aiAnswer = "🕌 Pour améliorer ta prière :\n1. Fais tes ablutions avec soin\n2. Prie à l'heure\n3. Comprends ce que tu récites\n4. Concentre-toi sur la présence d'Allah\n5. Fais des prières surérogatoires\n\nLe Prophète ﷺ a dit : « La fraîcheur de mes yeux a été placée dans la prière. »"
        } else {
            aiAnswer = "🤲 Qu'Allah te guide et t'accorde la facilité. Je te recommande de lire Sourate Al-Fatiha avec méditation et de faire des duaas sincères. Tu peux aussi partager ta question avec la communauté pour recevoir des conseils."
        }
        
        appState.addHasanat(1)
    }
}

struct QuickTag: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Theme.secondaryBg)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.cardBorder, lineWidth: 1))
        }
    }
}

struct QuickAccessButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.secondaryBg)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
        }
    }
}
