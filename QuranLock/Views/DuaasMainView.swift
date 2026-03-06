import SwiftUI

struct DuaasMainView: View {
    @State private var selectedCategory: Duaa.DuaaCategory? = nil
    @State private var showAdhkar = false

    var filteredDuaas: [Duaa] {
        if let cat = selectedCategory {
            return DataProvider.duaas.filter { $0.category == cat }
        }
        return DataProvider.duaas
    }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Adhkar button
                        Button(action: { showAdhkar = true }) {
                            HStack(spacing: 12) {
                                Text("📿").font(.system(size: 28))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Adhkar & Dhikr").font(.headline).foregroundColor(.white)
                                    Text("Matin, Soir, Après prière...").font(.caption).foregroundColor(Theme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(Theme.gold)
                            }
                            .padding(16)
                            .background(Theme.gold.opacity(0.1))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.gold, lineWidth: 1))
                        }

                        // Category filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                categoryButton(nil, "Tout 🌍")
                                ForEach(Duaa.DuaaCategory.allCases, id: \.rawValue) { cat in
                                    categoryButton(cat, "\(cat.icon) \(cat.rawValue)")
                                }
                            }
                        }

                        // Duaas
                        ForEach(filteredDuaas) { duaa in
                            DuaaCard(duaa: duaa)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle(L.invocations)
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAdhkar) {
                AdhkarView()
            }
        }
    }

    func categoryButton(_ cat: Duaa.DuaaCategory?, _ label: String) -> some View {
        Button(action: { selectedCategory = cat }) {
            Text(label)
                .font(.caption.bold())
                .foregroundColor(selectedCategory == cat ? .black : .white)
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(selectedCategory == cat ? Theme.gold : Theme.secondaryBg)
                .cornerRadius(20)
        }
    }
}

struct DuaaCard: View {
    let duaa: Duaa
    @State private var showTransliteration = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(duaa.category.icon)
                Text(duaa.title).font(.headline).foregroundColor(Theme.gold)
                Spacer()
                Text(duaa.source).font(.caption2).foregroundColor(Theme.textSecondary)
            }

            Text(duaa.arabicText)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineSpacing(8)

            if showTransliteration {
                Text(duaa.transliteration)
                    .font(.caption).italic().foregroundColor(Theme.accent)
            }

            Text(duaa.translation)
                .font(.subheadline).foregroundColor(Theme.textSecondary)

            HStack(spacing: 16) {
                Button(action: { showTransliteration.toggle() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "text.book.closed")
                        Text(showTransliteration ? "Masquer" : "Phonétique")
                    }
                    .font(.caption).foregroundColor(Theme.accent)
                }

                // Share
                Button(action: {
                    let text = """
                    \(duaa.title)
                    
                    \(duaa.arabicText)
                    
                    \(duaa.transliteration)
                    
                    \(duaa.translation)
                    
                    Source : \(duaa.source)
                    — Partagé depuis l'app Iqra 🤲
                    """
                    AppState.shareText(text)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                        Text(L.share)
                    }
                    .font(.caption).foregroundColor(Theme.gold)
                }

                Spacer()
            }
        }
        .cardStyle()
    }
}

// MARK: - Adhkar View
struct AdhkarView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(DataProvider.adhkarCategories) { category in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(category.icon).font(.title2)
                                    VStack(alignment: .leading) {
                                        Text(category.title).font(.headline).foregroundColor(Theme.gold)
                                        Text(category.subtitle).font(.caption).foregroundColor(Theme.textSecondary)
                                    }
                                }

                                ForEach(category.adhkars) { dhikr in
                                    DhikrCard(dhikr: dhikr)
                                }
                            }
                            .cardStyle()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("📿 Adhkar")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }
}

struct DhikrCard: View {
    let dhikr: Dhikr
    @State private var count = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(dhikr.title).font(.subheadline.bold()).foregroundColor(.white)
            Text(dhikr.arabicText)
                .font(.system(size: 18)).foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text(dhikr.translation).font(.caption).foregroundColor(Theme.textSecondary)

            HStack {
                // Counter
                Text("\(count)/\(dhikr.repetitions)")
                    .font(.caption.bold())
                    .foregroundColor(count >= dhikr.repetitions ? .green : Theme.gold)

                Button(action: { if count < dhikr.repetitions { count += 1 } }) {
                    Text("+1").font(.caption.bold())
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Theme.gold).foregroundColor(.black)
                        .cornerRadius(8)
                }

                Spacer()

                // Share
                Button(action: {
                    AppState.shareText("\(dhikr.title)\n\n\(dhikr.arabicText)\n\n\(dhikr.translation)\n\n× \(dhikr.repetitions) fois\n\n— App Iqra 🤲")
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.caption).foregroundColor(Theme.gold)
                }

                if let reward = dhikr.reward {
                    Text(reward).font(.caption2).foregroundColor(Theme.accent)
                }
            }
        }
        .padding(10)
        .background(Theme.secondaryBg)
        .cornerRadius(10)
    }
}
