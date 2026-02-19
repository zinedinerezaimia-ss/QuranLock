import SwiftUI

struct DonationView: View {

    let donationTiers = [
        ("☕ Café", "1€", "Un petit geste pour soutenir le projet"),
        ("📖 Soutien", "5€", "Aide à maintenir l'app active"),
        ("⭐ Généreux", "10€", "Contribue aux nouvelles fonctionnalités"),
        ("🌟 Bienfaiteur", "20€", "Soutient le développement à long terme"),
        ("🏆 Mécène", "50€", "Aide majeure pour l'équipe Iqra"),
    ]

    var body: some View {
        ZStack {
            Color(hex: "#0a0a0a").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Text("💛")
                            .font(.system(size: 60))
                        Text("Soutenir Iqra")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(hex: "#d4a853"))
                        Text("Chaque don nous aide à améliorer l'application et à la garder gratuite pour tous les musulmans.")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 30)

                    // Hadith
                    VStack(spacing: 8) {
                        Text("\"Quand un être humain meurt, ses actes s'interrompent, sauf pour trois choses : une aumône continue (Sadaqa Jariya), une science dont on profite, ou un enfant pieux qui prie pour lui.\"")
                            .font(.system(size: 13))
                            .italic()
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                        Text("— Sahih Muslim")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "#d4a853"))
                    }
                    .padding(16)
                    .background(Color(hex: "#d4a853").opacity(0.06))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#d4a853").opacity(0.3), lineWidth: 1))
                    .padding(.horizontal, 16)

                    // Donation tiers
                    VStack(spacing: 12) {
                        ForEach(donationTiers, id: \.0) { tier in
                            Button(action: {
                                if let url = URL(string: "https://buymeacoffee.com/rezaimia") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Text(tier.0)
                                        .font(.system(size: 20))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(tier.1)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                        Text(tier.2)
                                            .font(.system(size: 12))
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(Color(hex: "#d4a853"))
                                }
                                .padding(16)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#d4a853").opacity(0.2), lineWidth: 1))
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    // Note
                    Text("Tous les dons sont versés directement à l'équipe de développement Iqra. Barakallahu fik pour votre générosité 🤲")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
