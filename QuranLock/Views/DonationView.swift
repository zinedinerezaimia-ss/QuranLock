import SwiftUI

struct DonationView: View {
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("❤️")
                        .font(.system(size: 60))
                    Text("Soutenir QuranLock")
                        .font(.title.bold())
                        .foregroundColor(Theme.ramadanGold)
                    Text("Chaque don est une Sadaqa Jariya")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(.top, 20)
                
                // Distribution card
                VStack(spacing: 16) {
                    Text("Comment sont utilisés les dons ?")
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text("👨‍💻")
                                .font(.largeTitle)
                            Text("50%")
                                .font(.title2.bold())
                                .foregroundColor(Theme.ramadanGold)
                            Text("Développeurs")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                            Text("Pour continuer à améliorer l'app")
                                .font(.caption2)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(Theme.ramadanGold.opacity(0.3))
                            .frame(width: 1, height: 100)
                        
                        VStack(spacing: 8) {
                            Text("🤝")
                                .font(.largeTitle)
                            Text("50%")
                                .font(.title2.bold())
                                .foregroundColor(Theme.ramadanGold)
                            Text("Charité")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                            Text("Causes humanitaires et éducation")
                                .font(.caption2)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Theme.ramadanCardBg)
                )
                
                // Donate button
                Button(action: {
                    if let url = URL(string: DonationInfo.url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Faire un Don")
                            .font(.headline.bold())
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.ramadanGold)
                    .cornerRadius(14)
                }
                
                // Hadith
                VStack(spacing: 10) {
                    Text("📜")
                        .font(.title)
                    Text("Le Prophète ﷺ a dit :")
                        .font(.caption.bold())
                        .foregroundColor(Theme.ramadanGold)
                    Text("\"Quand le fils d'Adam meurt, ses actions cessent sauf trois : une aumône continue (Sadaqa Jariya), une science bénéfique, ou un enfant pieux qui invoque pour lui.\"")
                        .font(.caption)
                        .foregroundColor(Theme.textPrimary.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .italic()
                    Text("— Muslim")
                        .font(.caption2)
                        .foregroundColor(Theme.textSecondary)
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
                
                // Share button
                Button(action: { showingShareSheet = true }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Partager QuranLock")
                    }
                    .font(.subheadline)
                    .foregroundColor(Theme.ramadanGold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.ramadanGold, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal)
        }
        .background(Theme.ramadanDarkBg.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingShareSheet) {
            let text = "🌙 QuranLock - Ton compagnon pour le Coran pendant le Ramadan ! Télécharge l'app et rejoins-nous insha'Allah 📖✨ \(DonationInfo.url)"
            ShareSheet(items: [text])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
