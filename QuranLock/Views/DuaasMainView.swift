import SwiftUI

struct DuaasMainView: View {
    @State private var selectedCategory: Duaa.DuaaCategory = .matin
    @EnvironmentObject var ramadanManager: RamadanManager
    @EnvironmentObject var languageManager: LanguageManager

    var filteredDuaas: [Duaa] {
        DataProvider.duaas.filter { $0.category == selectedCategory }
    }

    var categories: [Duaa.DuaaCategory] {
        var cats: [Duaa.DuaaCategory] = [.matin, .soir, .priere, .protection, .pardon, .quotidien, .prophete]
        if ramadanManager.isRamadan { cats.append(.ramadan) }
        return cats
    }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(L.invocations)
                                .font(.headline).foregroundColor(Theme.gold)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(categories, id: \.rawValue) { cat in
                                        CategoryPill(
                                            icon: cat.icon,
                                            title: cat.rawValue,
                                            isSelected: selectedCategory == cat
                                        ) { selectedCategory = cat }
                                    }
                                }
                            }
                        }
                        .cardStyle()

                        // Prophet duaa special card
                        if selectedCategory == .prophete {
                            ProphetDuaaCard()
                        }

                        ForEach(filteredDuaas) { duaa in
                            DuaaCard(duaa: duaa)
                        }

                        if ramadanManager.isRamadan && selectedCategory == .ramadan {
                            ForEach(DataProvider.ramadanDuaas) { rd in
                                RamadanDuaaCard(duaa: rd)
                            }
                        }
                    }
                    .padding(.horizontal, 16).padding(.bottom, 20)
                }
            }
            .navigationTitle("Duaas")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Duaa pour le Prophète ﷺ
struct ProphetDuaaCard: View {
    @State private var showPhonetic = true

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack {
                Text("💚")
                VStack(alignment: .leading, spacing: 2) {
                    Text("Duaa pour le Prophète Muhammad ﷺ")
                        .font(.headline).foregroundColor(Theme.gold)
                    Text("Sallallahu alayhi wa salam")
                        .font(.caption.italic()).foregroundColor(Theme.textSecondary)
                }
            }

            // Arabic
            Text("اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ وَزِدْ كَرَمًا حَلَا سَيِّدِنَا مُحَمَّدٍ عَبْدِكَ وَرَسُولِكَ النَّبِيِّ الْأُمِّيِّ الْكَرِيمِ الْهَادِي أَرْسَلْتَهُ رَحْمَةً لِلْعَالَمِينَ وَجَعَلْتَهُ بِالْمُؤْمِنِينَ رَءُوفًا رَحِيمًا وَاللهُ عَلِيٌّ وَصَاحِبِي")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)
                .padding(.vertical, 4)

            Divider().background(Theme.cardBorder)

            // Phonetic toggle
            Button(action: { withAnimation { showPhonetic.toggle() } }) {
                HStack {
                    Text(showPhonetic ? "Masquer la phonétique" : "Voir la phonétique")
                        .font(.caption.bold()).foregroundColor(Theme.accent)
                    Spacer()
                    Image(systemName: showPhonetic ? "chevron.up" : "chevron.down")
                        .font(.caption).foregroundColor(Theme.accent)
                }
            }

            if showPhonetic {
                Text("Allahouma salli wa sallim wa barik wa zid karaman hala Sayyidina Muhammed abdouka wa rasuluka anabi al oumi al karim al hadi arsaltaou rahmatan lil'alamin wa ja'altaou bilmou'minina raoufou rahim. WAllahu aliy wa saahbi.")
                    .font(.subheadline.italic())
                    .foregroundColor(Theme.accent)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Divider().background(Theme.cardBorder)

            // Translation
            Text("Ô Allah, prie, salue, bénis et ajoute en honneur et en grâce notre Seigneur Muhammad, Ton serviteur et Ton messager, le Prophète illettré, le noble, le guide. Tu l'as envoyé comme miséricorde pour les mondes et Tu l'as rendu plein de bonté et de compassion envers les croyants. Et Allah est Élevé, et il est mon compagnon.")
                .font(.subheadline).foregroundColor(Theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            // Source
            HStack {
                Image(systemName: "star.fill").font(.caption).foregroundColor(Theme.gold)
                Text("Duaa de louange et de salutation sur le Prophète ﷺ")
                    .font(.caption).foregroundColor(Theme.gold)
            }
        }
        .cardStyle()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Category Pill
struct CategoryPill: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(icon).font(.caption)
                Text(title).font(.caption.bold())
            }
            .foregroundColor(isSelected ? .black : .white)
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(isSelected ? Theme.gold : Theme.secondaryBg)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(isSelected ? Theme.gold : Theme.cardBorder, lineWidth: 1))
        }
    }
}

// MARK: - Duaa Card
struct DuaaCard: View {
    let duaa: Duaa
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("⭐")
                Text(duaa.title).font(.headline).foregroundColor(Theme.gold)
            }
            Text(duaa.arabicText)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)
            Divider().background(Theme.cardBorder)
            Text(duaa.translation).font(.subheadline).foregroundColor(Theme.textSecondary)
            HStack {
                Image(systemName: "book.fill").font(.caption)
                Text(duaa.source).font(.caption)
            }
            .foregroundColor(Theme.accent)
        }
        .cardStyle()
    }
}

// MARK: - Ramadan Duaa Card
struct RamadanDuaaCard: View {
    let duaa: RamadanDuaa
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("🌙")
                Text(duaa.title).font(.headline).foregroundColor(Theme.ramadanGold)
                Spacer()
                Text(duaa.category).font(.caption).foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Theme.ramadanPurple).cornerRadius(8)
            }
            Text(duaa.arabicText)
                .font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                .multilineTextAlignment(.trailing).frame(maxWidth: .infinity, alignment: .trailing)
            Text(duaa.phonetic).font(.subheadline.italic()).foregroundColor(Theme.accent)
            Divider().background(Theme.cardBorder)
            Text(duaa.translation).font(.subheadline).foregroundColor(Theme.textSecondary)
            Text("📌 \(duaa.context)").font(.caption).foregroundColor(Theme.gold)
        }
        .cardStyle()
    }
}

// MARK: - Adhkar Views (unchanged)
struct AdhkarMainView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 12) {
                        Text("🤲 Adhkar & Dhikrs").font(.title2.bold()).foregroundColor(Theme.gold)
                        ForEach(DataProvider.adhkarCategories) { cat in
                            NavigationLink(destination: AdhkarDetailView(category: cat)) {
                                HStack {
                                    Text(cat.icon).font(.title2)
                                    VStack(alignment: .leading) {
                                        Text(cat.title).font(.headline).foregroundColor(.white)
                                        Text(cat.subtitle).font(.caption).foregroundColor(Theme.textSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundColor(Theme.gold)
                                }
                                .cardStyle()
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }
}

struct AdhkarDetailView: View {
    let category: AdhkarCategory
    @State private var counters: [String: Int] = [:]
    var body: some View {
        ZStack {
            Theme.primaryBg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 12) {
                    Text("\(category.icon) \(category.title)").font(.title2.bold()).foregroundColor(Theme.gold)
                    ForEach(category.adhkars) { dhikr in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(dhikr.title).font(.headline).foregroundColor(Theme.gold)
                            Text(dhikr.arabicText).font(.system(size: 20)).foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Text(dhikr.translation).font(.subheadline).foregroundColor(Theme.textSecondary)
                            HStack {
                                Text("Répéter \(dhikr.repetitions)x").font(.caption).foregroundColor(Theme.accent)
                                Spacer()
                                HStack(spacing: 12) {
                                    Text("\(counters[dhikr.id] ?? 0)/\(dhikr.repetitions)").font(.headline).foregroundColor(Theme.gold)
                                    Button(action: {
                                        let c = counters[dhikr.id] ?? 0
                                        if c < dhikr.repetitions { counters[dhikr.id] = c + 1 }
                                    }) {
                                        Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(Theme.gold)
                                    }
                                }
                            }
                            if let reward = dhikr.reward { Text("🎁 \(reward)").font(.caption).foregroundColor(Theme.success) }
                            Text("📖 \(dhikr.source)").font(.caption).foregroundColor(Theme.textSecondary)
                        }
                        .cardStyle()
                    }
                }
                .padding()
            }
        }
    }
}
