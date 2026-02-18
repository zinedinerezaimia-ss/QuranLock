import SwiftUI

struct DuaasMainView: View {
    @State private var selectedCategory: Duaa.DuaaCategory = .matin
    @EnvironmentObject var ramadanManager: RamadanManager
    
    var filteredDuaas: [Duaa] {
        DataProvider.duaas.filter { $0.category == selectedCategory }
    }
    
    var categories: [Duaa.DuaaCategory] {
        var cats: [Duaa.DuaaCategory] = [.matin, .soir, .priere, .protection, .pardon, .quotidien]
        if ramadanManager.isRamadan { cats.append(.ramadan) }
        return cats
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Category tabs
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🤲 Invocations")
                                .font(.headline)
                                .foregroundColor(Theme.gold)
                            
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
                        
                        // Duaas list
                        ForEach(filteredDuaas) { duaa in
                            DuaaCard(duaa: duaa)
                        }
                        
                        // Ramadan Duaas section
                        if ramadanManager.isRamadan && selectedCategory == .ramadan {
                            ForEach(DataProvider.ramadanDuaas) { rd in
                                RamadanDuaaCard(duaa: rd)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Duaas")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

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
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Theme.gold : Theme.secondaryBg)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Theme.gold : Theme.cardBorder, lineWidth: 1)
            )
        }
    }
}

struct DuaaCard: View {
    let duaa: Duaa
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("⭐")
                Text(duaa.title)
                    .font(.headline)
                    .foregroundColor(Theme.gold)
            }
            
            Text(duaa.arabicText)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)
            
            Divider().background(Theme.cardBorder)
            
            Text(duaa.translation)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            HStack {
                Image(systemName: "book.fill")
                    .font(.caption)
                Text(duaa.source)
                    .font(.caption)
            }
            .foregroundColor(Theme.accent)
        }
        .cardStyle()
    }
}

struct RamadanDuaaCard: View {
    let duaa: RamadanDuaa
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("🌙")
                Text(duaa.title)
                    .font(.headline)
                    .foregroundColor(Theme.ramadanGold)
                Spacer()
                Text(duaa.category)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.ramadanPurple)
                    .cornerRadius(8)
            }
            
            Text(duaa.arabicText)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text(duaa.phonetic)
                .font(.subheadline.italic())
                .foregroundColor(Theme.accent)
            
            Divider().background(Theme.cardBorder)
            
            Text(duaa.translation)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Text("📌 \(duaa.context)")
                .font(.caption)
                .foregroundColor(Theme.gold)
        }
        .cardStyle()
    }
}

// MARK: - Adhkar Main View
struct AdhkarMainView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12) {
                        Text("🤲 Adhkar & Dhikrs")
                            .font(.title2.bold())
                            .foregroundColor(Theme.gold)
                        
                        ForEach(DataProvider.adhkarCategories) { cat in
                            NavigationLink(destination: AdhkarDetailView(category: cat)) {
                                HStack {
                                    Text(cat.icon).font(.title2)
                                    VStack(alignment: .leading) {
                                        Text(cat.title)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(cat.subtitle)
                                            .font(.caption)
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Theme.gold)
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
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Theme.gold)
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
                    Text("\(category.icon) \(category.title)")
                        .font(.title2.bold())
                        .foregroundColor(Theme.gold)
                    
                    ForEach(category.adhkars) { dhikr in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(dhikr.title)
                                .font(.headline)
                                .foregroundColor(Theme.gold)
                            
                            Text(dhikr.arabicText)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Text(dhikr.translation)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            HStack {
                                Text("Répéter \(dhikr.repetitions)x")
                                    .font(.caption)
                                    .foregroundColor(Theme.accent)
                                
                                Spacer()
                                
                                // Counter
                                HStack(spacing: 12) {
                                    Text("\(counters[dhikr.id] ?? 0)/\(dhikr.repetitions)")
                                        .font(.headline)
                                        .foregroundColor(Theme.gold)
                                    
                                    Button(action: {
                                        let current = counters[dhikr.id] ?? 0
                                        if current < dhikr.repetitions {
                                            counters[dhikr.id] = current + 1
                                        }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(Theme.gold)
                                    }
                                }
                            }
                            
                            if let reward = dhikr.reward {
                                Text("🎁 \(reward)")
                                    .font(.caption)
                                    .foregroundColor(Theme.success)
                            }
                            
                            Text("📖 \(dhikr.source)")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        .cardStyle()
                    }
                }
                .padding()
            }
        }
    }
}
