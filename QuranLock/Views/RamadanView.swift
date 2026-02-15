import SwiftUI

struct RamadanView: View {
    @EnvironmentObject var appState: AppState
    
    var rm: RamadanManager { appState.ramadanManager }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("🌙 Ramadan 2026")
                            .font(.largeTitle.bold())
                            .foregroundColor(Theme.ramadanGold)
                        Text("Jour \(rm.currentDay) / 30")
                            .font(.title3)
                            .foregroundColor(Theme.textSecondary)
                        
                        // Night calendar strip
                        nightCalendarStrip
                    }
                    .padding(.top)
                    
                    // Iftar Countdown Card
                    iftarCard
                    
                    // Navigation Cards
                    NavigationLink(destination: RamadanDuaasView()) {
                        featureCard(
                            icon: "hands.sparkles.fill",
                            title: "Duaas du Ramadan",
                            subtitle: "Suhoor, Iftar, Nuit, Laylat al-Qadr",
                            count: "\(RamadanDuaasData.allDuaas.count) duaas"
                        )
                    }
                    
                    NavigationLink(destination: RamadanSurahsView()) {
                        featureCard(
                            icon: "star.fill",
                            title: "Sourates Recommandées",
                            subtitle: "Al-Baqara, Ya-Sin, Al-Mulk avec tafsir",
                            count: "3 sourates"
                        )
                    }
                    
                    NavigationLink(destination: DonationView()) {
                        featureCard(
                            icon: "heart.fill",
                            title: "Soutenir QuranLock",
                            subtitle: "50% développeurs / 50% charité",
                            count: "Sadaqa"
                        )
                    }
                    
                    // Odd nights reminder
                    if rm.isLastTenNights {
                        oddNightsInfo
                    }
                }
                .padding(.horizontal)
            }
            .background(Theme.ramadanDarkBg.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Night Calendar Strip
    var nightCalendarStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 6) {
                    ForEach(1...30, id: \.self) { day in
                        VStack(spacing: 4) {
                            Text("\(day)")
                                .font(.caption2.bold())
                                .foregroundColor(day == rm.currentDay ? .black : day <= rm.currentDay ? Theme.ramadanGold : Theme.textSecondary)
                            
                            if day >= 21 && day % 2 != 0 {
                                Text("⭐")
                                    .font(.system(size: 8))
                            }
                        }
                        .frame(width: 32, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(day == rm.currentDay ? Theme.ramadanGold : (day < rm.currentDay ? Theme.ramadanPurple.opacity(0.5) : Color.clear))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(day >= 21 ? Theme.ramadanGold.opacity(0.5) : Color.clear, lineWidth: 1)
                                )
                        )
                        .id(day)
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    proxy.scrollTo(rm.currentDay, anchor: .center)
                }
            }
        }
    }
    
    // MARK: - Iftar Card
    var iftarCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("☀️ Fajr / Suhoor")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text(rm.fajrTime)
                        .font(.title2.bold())
                        .foregroundColor(Theme.textPrimary)
                }
                Spacer()
                VStack(spacing: 4) {
                    Text("⏱ Iftar dans")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text(rm.iftarCountdown)
                        .font(.title.bold())
                        .foregroundColor(Theme.ramadanGold)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("🌅 Maghrib / Iftar")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text(rm.maghribTime)
                        .font(.title2.bold())
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
    }
    
    // MARK: - Feature Card
    func featureCard(icon: String, title: String, subtitle: String, count: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(Theme.ramadanGold)
                .frame(width: 50, height: 50)
                .background(Theme.ramadanPurple.opacity(0.5))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            VStack {
                Text(count)
                    .font(.caption.bold())
                    .foregroundColor(Theme.ramadanGold)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.ramadanCardBg)
        )
    }
    
    // MARK: - Odd Nights Info
    var oddNightsInfo: some View {
        VStack(spacing: 10) {
            Text("🔍 Nuits Impaires des 10 Dernières Nuits")
                .font(.subheadline.bold())
                .foregroundColor(Theme.ramadanGold)
            Text("Nuits 21, 23, 25, 27, 29 - Cherche Laylat al-Qadr !")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
            Text("Cette nuit vaut mieux que mille mois (Sourate Al-Qadr)")
                .font(.caption.italic())
                .foregroundColor(Theme.ramadanGold.opacity(0.7))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.ramadanCardBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.ramadanGold, lineWidth: 1)
                )
        )
    }
}
