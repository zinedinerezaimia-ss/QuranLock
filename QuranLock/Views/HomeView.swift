import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    
    var isRamadan: Bool { appState.ramadanManager.isRamadan }
    var rm: RamadanManager { appState.ramadanManager }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Greeting
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Assalamu Alaikum")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            Text(appState.userName.isEmpty ? "Bienvenue" : appState.userName)
                                .font(.title.bold())
                                .foregroundColor(Theme.textPrimary)
                        }
                        Spacer()
                        if isRamadan {
                            VStack {
                                Text("🌙")
                                    .font(.largeTitle)
                                Text("Jour \(rm.currentDay)")
                                    .font(.caption.bold())
                                    .foregroundColor(Theme.ramadanGold)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Ramadan Banner
                    if isRamadan {
                        ramadanBanner
                    } else if rm.daysUntilRamadan > 0 {
                        preRamadanBanner
                    }
                    
                    // Daily Progress
                    dailyProgressCard
                    
                    // Quick Actions
                    quickActions
                    
                    // Stats
                    statsGrid
                    
                    // Last Ten Nights Alert
                    if isRamadan && rm.isLastTenNights {
                        lastTenNightsAlert
                    }
                }
                .padding(.vertical)
            }
            .background(Theme.background(isRamadan: isRamadan).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Ramadan Banner
    var ramadanBanner: some View {
        VStack(spacing: 12) {
            HStack {
                Text("🕌 Ramadan Mubarak")
                    .font(.headline.bold())
                    .foregroundColor(Theme.ramadanGold)
                Spacer()
                Text("\(rm.daysRemaining) jours restants")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Divider().background(Theme.ramadanGold.opacity(0.3))
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("Suhoor")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text(rm.fajrTime)
                        .font(.title3.bold())
                        .foregroundColor(Theme.textPrimary)
                }
                
                VStack(spacing: 4) {
                    Text("⏱ Iftar dans")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text(rm.iftarCountdown)
                        .font(.title3.bold())
                        .foregroundColor(Theme.ramadanGold)
                }
                
                VStack(spacing: 4) {
                    Text("Maghrib")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text(rm.maghribTime)
                        .font(.title3.bold())
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.ramadanCardBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.ramadanGold.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
    
    var preRamadanBanner: some View {
        HStack {
            Text("🌙")
                .font(.title)
            VStack(alignment: .leading) {
                Text("Ramadan approche !")
                    .font(.headline)
                    .foregroundColor(Theme.primaryGreen)
                Text("Plus que \(rm.daysUntilRamadan) jours - Prépare-toi !")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.cardBackground)
        )
        .padding(.horizontal)
    }
    
    // MARK: - Daily Progress
    var dailyProgressCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("📖 Progression du jour")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("\(appState.pagesReadToday)/\(appState.dailyGoalPages) pages")
                    .font(.subheadline)
                    .foregroundColor(Theme.primary(isRamadan: isRamadan))
            }
            
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.primary(isRamadan: isRamadan))
                        .frame(width: geo.size.width * min(CGFloat(appState.pagesReadToday) / CGFloat(max(appState.dailyGoalPages, 1)), 1.0))
                }
            }
            .frame(height: 12)
            
            if appState.pagesReadToday >= appState.dailyGoalPages {
                Text("Objectif atteint ! MashaAllah !")
                    .font(.caption.bold())
                    .foregroundColor(Theme.primary(isRamadan: isRamadan))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.card(isRamadan: isRamadan))
        )
        .padding(.horizontal)
    }
    
    // MARK: - Quick Actions
    var quickActions: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            quickActionButton(icon: "book.fill", title: "Lire le Coran", color: Theme.primary(isRamadan: isRamadan)) {
                appState.selectedTab = 1
            }
            
            if isRamadan {
                quickActionButton(icon: "hands.sparkles.fill", title: "Duaas Ramadan", color: Theme.ramadanGold) {
                    appState.selectedTab = 2
                }
                quickActionButton(icon: "star.fill", title: "Sourates\nRecommandées", color: Theme.ramadanAccent) {
                    appState.selectedTab = 2
                }
                quickActionButton(icon: "heart.fill", title: "Faire un Don", color: .pink) {
                    appState.selectedTab = 2
                }
            } else {
                quickActionButton(icon: "mic.fill", title: "Récitation", color: .blue) {
                    // Navigate to recitation
                }
            }
        }
        .padding(.horizontal)
    }
    
    func quickActionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Theme.card(isRamadan: isRamadan))
            )
        }
    }
    
    // MARK: - Stats
    var statsGrid: some View {
        HStack(spacing: 12) {
            statCard(value: "\(appState.totalPagesRead)", label: "Pages lues", icon: "📄")
            statCard(value: "\(appState.streakDays)", label: "Jours consécutifs", icon: "🔥")
            statCard(value: "\(appState.currentSurah)/114", label: "Sourate", icon: "📖")
        }
        .padding(.horizontal)
    }
    
    func statCard(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Text(icon)
                .font(.title3)
            Text(value)
                .font(.title3.bold())
                .foregroundColor(Theme.primary(isRamadan: isRamadan))
            Text(label)
                .font(.caption2)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.card(isRamadan: isRamadan))
        )
    }
    
    // MARK: - Last Ten Nights
    var lastTenNightsAlert: some View {
        VStack(spacing: 8) {
            Text("⭐ Les 10 Dernières Nuits")
                .font(.headline.bold())
                .foregroundColor(Theme.ramadanGold)
            Text("Intensifie tes adorations ! Nuit \(rm.currentNight) - \(rm.isOddNight ? "Nuit IMPAIRE (possible Laylat al-Qadr)" : "Nuit paire")")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            Text("اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي")
                .font(.title3)
                .foregroundColor(Theme.textPrimary)
                .padding(.top, 4)
            Text("Ô Allah, Tu es Celui qui pardonne, Tu aimes le pardon, alors pardonne-moi.")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
                .italic()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.ramadanCardBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.ramadanGold.opacity(0.5), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
}
