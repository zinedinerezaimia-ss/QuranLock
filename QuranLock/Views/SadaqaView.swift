import SwiftUI

struct SadaqaView: View {
    @State private var showRegisterMosque = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        VStack(spacing: 8) {
                            Text("🕌").font(.system(size: 50))
                            Text("Sadaqa - Aide ta mosquée")
                                .font(.title2.bold()).foregroundColor(Theme.gold)
                            Text("« Celui qui construit une mosquée pour Allah, Allah lui construit une maison au Paradis. »")
                                .font(.caption).foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                            Text("— Sahih al-Bukhari")
                                .font(.caption).foregroundColor(Theme.accent)
                        }
                        .cardStyle()
                        
                        // Mosque list
                        ForEach(DataProvider.mosqueFundraisers) { mosque in
                            MosqueCard(mosque: mosque)
                        }
                        
                        // Register mosque
                        VStack(spacing: 12) {
                            Text("Tu gères une mosquée ?")
                                .font(.headline).foregroundColor(.white)
                            Text("Inscris ta mosquée pour recevoir des dons de la communauté Iqra")
                                .font(.caption).foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: { showRegisterMosque = true }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text("Inscrire ma mosquée")
                                }
                                .goldButton()
                            }
                        }
                        .cardStyle()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Sadaqa")
            .navigationBarTitleDisplayMode(.large)
            .alert("Bientôt disponible", isPresented: $showRegisterMosque) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("L'inscription de mosquées sera disponible dans une prochaine mise à jour insha'Allah.")
            }
        }
    }
}

struct MosqueCard: View {
    let mosque: MosqueFundraiser
    @State private var showParticipation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mosque.name)
                        .font(.headline).foregroundColor(.white)
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text("\(mosque.location) • \(mosque.distance) km")
                    }
                    .font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Text(mosque.icon).font(.title)
            }
            
            Text(mosque.project)
                .font(.subheadline).foregroundColor(Theme.accent)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(mosque.collected)€")
                        .font(.headline).foregroundColor(Theme.gold)
                    Text("/ \(mosque.goal)€")
                        .font(.subheadline).foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("\(Int(mosque.progress * 100))%")
                        .font(.subheadline.bold()).foregroundColor(Theme.gold)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Theme.secondaryBg)
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Theme.gold)
                            .frame(width: geo.size.width * min(mosque.progress, 1.0), height: 8)
                    }
                }
                .frame(height: 8)
            }
            
            Button(action: { showParticipation = true }) {
                HStack {
                    Image(systemName: "heart.fill")
                    Text("Participer")
                }
                .goldButton()
            }
        }
        .cardStyle()
        .alert("Bientôt disponible", isPresented: $showParticipation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Le paiement sera disponible dans une prochaine mise à jour insha'Allah. Visite ta mosquée directement !")
        }
    }
}
