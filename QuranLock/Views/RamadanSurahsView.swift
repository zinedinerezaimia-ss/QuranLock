import SwiftUI

struct RamadanSurahsView: View {

    struct SurahInfo: Identifiable {
        let id = UUID()
        let number: Int
        let nameFR: String
        let nameAR: String
        let versets: Int
        let theme: String
        let recommendation: String
    }

    let surahs: [SurahInfo] = [
        SurahInfo(number: 1, nameFR: "Al-Fatiha (L'Ouverture)", nameAR: "الفاتحة", versets: 7, theme: "Prière et guidance", recommendation: "À réciter dans chaque rak'at"),
        SurahInfo(number: 2, nameFR: "Al-Baqara (La Vache)", nameAR: "البقرة", versets: 286, theme: "Législation islamique complète", recommendation: "Protège la maison où elle est récitée"),
        SurahInfo(number: 18, nameFR: "Al-Kahf (La Caverne)", nameAR: "الكهف", versets: 110, theme: "Épreuves et foi", recommendation: "À lire chaque vendredi — protège du Dajjal"),
        SurahInfo(number: 36, nameFR: "Yasin (Ya-Sin)", nameAR: "يس", versets: 83, theme: "Résurrection et unicité d'Allah", recommendation: "Cœur du Coran — lire pour les défunts"),
        SurahInfo(number: 55, nameFR: "Ar-Rahman (Le Très Miséricordieux)", nameAR: "الرحمن", versets: 78, theme: "Bienfaits d'Allah", recommendation: "La mariée du Coran — réciter souvent"),
        SurahInfo(number: 56, nameFR: "Al-Waqia (L'Événement)", nameAR: "الواقعة", versets: 96, theme: "Résurrection et destin", recommendation: "Protège de la pauvreté — lire chaque soir"),
        SurahInfo(number: 67, nameFR: "Al-Mulk (La Royauté)", nameAR: "الملك", versets: 30, theme: "Souveraineté d'Allah", recommendation: "Protège du châtiment de la tombe — lire chaque nuit"),
        SurahInfo(number: 112, nameFR: "Al-Ikhlas (La Sincérité)", nameAR: "الإخلاص", versets: 4, theme: "Unicité pure d'Allah", recommendation: "Équivaut au tiers du Coran — réciter 3 fois"),
        SurahInfo(number: 113, nameFR: "Al-Falaq (L'Aube)", nameAR: "الفلق", versets: 5, theme: "Protection du mal extérieur", recommendation: "Réciter matin et soir avec An-Nas"),
        SurahInfo(number: 114, nameFR: "An-Nas (Les Hommes)", nameAR: "الناس", versets: 6, theme: "Protection du mal intérieur", recommendation: "Réciter matin et soir avec Al-Falaq"),
    ]

    var body: some View {
        ZStack {
            Color(hex: "#0a0a0a").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Text("Sourates du Ramadan")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(hex: "#d4a853"))
                        .padding(.top, 20)

                    Text("📖 Les sourates recommandées à réciter")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 8)

                    ForEach(surahs) { surah in
                        SurahCard(surah: surah)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SurahCard: View {
    let surah: RamadanSurahsView.SurahInfo
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#d4a853").opacity(0.2))
                            .frame(width: 44, height: 44)
                        Text("\(surah.number)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "#d4a853"))
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(surah.nameFR)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                        Text("\(surah.versets) versets • \(surah.theme)")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }

                    Spacer()

                    Text(surah.nameAR)
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#d4a853"))

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 12))
                }
            }

            if isExpanded {
                Divider().background(Color.white.opacity(0.1))

                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(hex: "#d4a853"))
                        .font(.system(size: 12))
                    Text(surah.recommendation)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(10)
                .background(Color(hex: "#d4a853").opacity(0.08))
                .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#d4a853").opacity(0.2), lineWidth: 1))
    }
}
