import SwiftUI

struct RamadanDuaasView: View {
    @State private var selectedCategory: RamadanDuaa.DuaaCategory = .suhoor
    
    var filteredDuaas: [RamadanDuaa] {
        RamadanDuaasData.allDuaas.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("🤲 Duaas du Ramadan")
                    .font(.title2.bold())
                    .foregroundColor(Theme.ramadanGold)
                    .padding(.top)
                
                // Category picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(RamadanDuaa.DuaaCategory.allCases, id: \.rawValue) { cat in
                            Button(action: { selectedCategory = cat }) {
                                Text(cat.rawValue)
                                    .font(.caption.bold())
                                    .foregroundColor(selectedCategory == cat ? .black : Theme.textSecondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(selectedCategory == cat ? Theme.ramadanGold : Theme.ramadanCardBg)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Duaas list
                ForEach(filteredDuaas) { duaa in
                    duaaCard(duaa)
                }
            }
            .padding(.horizontal)
        }
        .background(Theme.ramadanDarkBg.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func duaaCard(_ duaa: RamadanDuaa) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(duaa.title)
                    .font(.headline)
                    .foregroundColor(Theme.ramadanGold)
                Spacer()
                Text(duaa.context)
                    .font(.caption2)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.trailing)
            }
            
            // Arabic text
            Text(duaa.arabic)
                .font(.title2)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical, 8)
            
            // Phonetic
            Text(duaa.phonetic)
                .font(.subheadline.italic())
                .foregroundColor(Theme.ramadanAccent.opacity(0.8))
            
            // Translation
            Text(duaa.translation)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.ramadanCardBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.ramadanGold.opacity(0.15), lineWidth: 1)
                )
        )
    }
}
