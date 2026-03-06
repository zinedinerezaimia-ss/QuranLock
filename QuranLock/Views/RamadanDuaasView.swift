import SwiftUI

struct RamadanDuaasView: View {
    struct RamadanDuaa: Identifiable {
        let id = UUID()
        let titre: String
        let arabe: String
        let translitteration: String
        let traduction: String
        let contexte: String
    }

    let duaas: [RamadanDuaa] = [
        RamadanDuaa(titre: "Dua de rupture du jeûne", arabe: "اللَّهُمَّ إِنِّي لَكَ صُمْتُ وَبِكَ آمَنْتُ وَعَلَيْكَ تَوَكَّلْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ", translitteration: "Allahumma inni laka sumtu wa bika amantu wa 'alayka tawakkaltu wa 'ala rizqika aftartu", traduction: "Ô Allah, j'ai jeûné pour Toi, j'ai cru en Toi, je me suis confié à Toi et c'est avec Ta subsistance que je romps le jeûne.", contexte: "À réciter au moment de l'Iftar"),
        RamadanDuaa(titre: "Dua de la nuit de Qadr", arabe: "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي", translitteration: "Allahumma innaka 'afuwwun tuhibbul 'afwa fa'fu 'anni", traduction: "Ô Allah, Tu es Celui qui pardonne et Tu aimes pardonner, alors pardonne-moi.", contexte: "À réciter pendant Laylat al-Qadr"),
        RamadanDuaa(titre: "Dua avant le Suhoor", arabe: "وَبِصَوْمِ غَدٍ نَّوَيْتُ مِنْ شَهْرِ رَمَضَانَ", translitteration: "Wa bisawmi ghadin nawaytu min shahri ramadan", traduction: "J'ai l'intention de jeûner demain pour le mois de Ramadan.", contexte: "Intention de jeûne avant le Suhoor"),
        RamadanDuaa(titre: "Dua d'entrée à la mosquée", arabe: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ", translitteration: "Allahummaf-tah li abwaba rahmatik", traduction: "Ô Allah, ouvre pour moi les portes de Ta miséricorde.", contexte: "En entrant à la mosquée pour la Tarawih"),
        RamadanDuaa(titre: "Dua pour la guidance", arabe: "اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي", translitteration: "Allahumma-hdini wa saddidni", traduction: "Ô Allah, guide-moi et affermis-moi.", contexte: "Dua général de guidance"),
        RamadanDuaa(titre: "Istighfar du Ramadan", arabe: "أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيَّ الْقَيُّومَ وَأَتُوبُ إِلَيْهِ", translitteration: "Astaghfirullaha-l-'Azima alladhi la ilaha illa Huwa-l-Hayyu-l-Qayyumu wa atubu ilayh", traduction: "Je demande pardon à Allah le Tout-Puissant, en dehors de qui il n'y a pas de divinité, le Vivant, le Subsistant, et je me repens à Lui.", contexte: "À répéter souvent pendant le Ramadan"),
        RamadanDuaa(titre: "Dua pour la famille", arabe: "رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا", translitteration: "Rabbana hab lana min azwajina wa dhurriyyatina qurrata a'yunin waj'alna lil-muttaqina imama", traduction: "Notre Seigneur, accorde-nous de nos époux et de notre descendance une consolation pour nos yeux et fais de nous un modèle pour les pieux.", contexte: "Sourate Al-Furqan, verset 74"),
        RamadanDuaa(titre: "Dua de fin de Ramadan", arabe: "اللَّهُمَّ لَا تَجْعَلْهُ آخِرَ الْعَهْدِ مِنَّا لِشَهْرِ رَمَضَانَ", translitteration: "Allahumma la taj'alhu akhiral-'ahdi minna li-shahri ramadan", traduction: "Ô Allah, ne fais pas de ce Ramadan le dernier que nous vivons.", contexte: "À la fin du mois de Ramadan"),
    ]

    var body: some View {
        ZStack {
            Color(hex: "#0a0a0a").ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text("Duaas du Ramadan")
                        .font(.title2).bold()
                        .foregroundColor(Color(hex: "#d4a853"))
                        .padding(.top, 20)

                    ForEach(duaas) { duaa in
                        RamadanDuaaItemCard(duaa: duaa)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Duaas")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RamadanDuaaItemCard: View {
    let duaa: RamadanDuaasView.RamadanDuaa
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Text(duaa.titre)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#d4a853"))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color(hex: "#d4a853"))
                }
            }

            if isExpanded {
                VStack(alignment: .trailing, spacing: 8) {
                    Text(duaa.arabe)
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .environment(\.layoutDirection, .rightToLeft)

                    Text(duaa.translitteration)
                        .font(.footnote.italic())
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(duaa.traduction)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(duaa.contexte)
                        .font(.caption)
                        .foregroundColor(Color(hex: "#d4a853").opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#d4a853").opacity(0.3), lineWidth: 1))
    }
}
