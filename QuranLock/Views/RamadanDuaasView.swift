import SwiftUI

struct RamadanDuaasView: View {
    @Environment(\.dismiss) var dismiss

    struct Duaa: Identifiable {
        let id = UUID()
        let titleFR: String
        let arabic: String
        let transliteration: String
        let translationFR: String
    }

    let duaas: [Duaa] = [
        Duaa(
            titleFR: "Duaa de rupture du jeûne",
            arabic: "اللَّهُمَّ إِنِّي لَكَ صُمْتُ وَبِكَ آمَنْتُ وَعَلَيْكَ تَوَكَّلْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ",
            transliteration: "Allahumma inni laka sumtu wa bika amantu wa 'alayka tawakkaltu wa 'ala rizqika aftartu",
            translationFR: "Ô Allah, j'ai jeûné pour Toi, j'ai cru en Toi, je me suis confié à Toi et j'ai rompu le jeûne avec Ta subsistance."
        ),
        Duaa(
            titleFR: "Duaa de Laylat al-Qadr",
            arabic: "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
            transliteration: "Allahumma innaka 'afuwwun tuhibbul 'afwa fa'fu 'anni",
            translationFR: "Ô Allah, Tu es le Très Pardonnant, Tu aimes le pardon, alors pardonne-moi."
        ),
        Duaa(
            titleFR: "Duaa d'entrée au Ramadan",
            arabic: "اللَّهُمَّ سَلِّمْنِي لِرَمَضَانَ وَسَلِّمْ لِي رَمَضَانَ وَتَسَلَّمْهُ مِنِّي مُتَقَبَّلاً",
            transliteration: "Allahumma sallimni li Ramadan wa sallim li Ramadan wa tasallamhu minni mutaqabbalan",
            translationFR: "Ô Allah, protège-moi pour le Ramadan, fais que le Ramadan soit pour moi et accepte-le de ma part."
        ),
        Duaa(
            titleFR: "Duaa après le Suhoor",
            arabic: "نَوَيْتُ صَوْمَ غَدٍ عَنْ أَدَاءِ فَرِيضَةِ رَمَضَانَ هَذِهِ السَّنَةِ لِلَّهِ تَعَالَى",
            transliteration: "Nawaytu sawma ghadin 'an ada'i farida Ramadan hadihis sanati lillahi ta'ala",
            translationFR: "J'ai l'intention de jeûner demain pour accomplir l'obligation du Ramadan de cette année pour Allah le Très-Haut."
        ),
        Duaa(
            titleFR: "Duaa pour le pardon",
            arabic: "رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ",
            transliteration: "Rabbana zalamna anfusana wa in lam taghfir lana wa tarhamna lanakunnanna minal khasirin",
            translationFR: "Notre Seigneur, nous nous sommes fait du tort. Et si Tu ne nous pardonnes pas et ne nous accordes pas Ta miséricorde, nous serons certes du nombre des perdants."
        ),
        Duaa(
            titleFR: "Duaa pour la guidance",
            arabic: "اللَّهُمَّ اهْدِنَا فِيمَنْ هَدَيْتَ وَعَافِنَا فِيمَنْ عَافَيْتَ",
            transliteration: "Allahumma ihdina fiman hadayta wa 'afina fiman 'afayta",
            translationFR: "Ô Allah, guide-nous parmi ceux que Tu as guidés, et protège-nous parmi ceux que Tu as protégés."
        ),
        Duaa(
            titleFR: "Duaa pour la nuit",
            arabic: "اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ",
            transliteration: "Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilaykan-nushur",
            translationFR: "Ô Allah, c'est par Toi que nous entrons dans le matin et par Toi que nous entrons dans le soir, par Toi nous vivons et par Toi nous mourons, et c'est vers Toi que sera la résurrection."
        ),
        Duaa(
            titleFR: "Duaa pour les 10 dernières nuits",
            arabic: "اللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيمٌ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
            transliteration: "Allahumma innaka 'afuwwun karimun tuhibbul 'afwa fa'fu 'anni",
            translationFR: "Ô Allah, Tu es le Très Pardonnant, le Noble, Tu aimes le pardon, alors pardonne-moi."
        )
    ]

    var body: some View {
        ZStack {
            Color(hex: "#0a0a0a").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Text("Duaas du Ramadan")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(hex: "#d4a853"))
                        .padding(.top, 20)

                    Text("🌙 Les invocations du mois béni")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 8)

                    ForEach(duaas) { duaa in
                        DuaaCard(duaa: duaa)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DuaaCard: View {
    let duaa: RamadanDuaasView.Duaa
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Text(duaa.titleFR)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color(hex: "#d4a853"))
                }
            }

            if isExpanded {
                Text(duaa.arabic)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#d4a853"))
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .environment(\.layoutDirection, .rightToLeft)

                Divider().background(Color.white.opacity(0.1))

                Text(duaa.transliteration)
                    .font(.system(size: 13, weight: .light))
                    .italic()
                    .foregroundColor(.white.opacity(0.7))

                Text(duaa.translationFR)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, 4)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#d4a853").opacity(0.2), lineWidth: 1))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
