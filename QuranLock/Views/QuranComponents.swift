import SwiftUI

// MARK: - InfoBadge
struct InfoBadge: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(Theme.gold)
            Text(title)
                .font(.caption2)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Theme.cardBg)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.cardBorder, lineWidth: 1))
    }
}

// MARK: - ShareReflectionView
struct ShareReflectionView: View {
    let surahName: String
    let surahArabic: String
    @Environment(\.dismiss) var dismiss
    @State private var reflection = ""

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                VStack(spacing: 16) {
                    Text(surahArabic)
                        .font(.title)
                        .foregroundColor(Theme.gold)
                    Text(surahName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Écris ta réflexion sur cette sourate :")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                    TextEditor(text: $reflection)
                        .frame(height: 150)
                        .padding(8)
                        .background(Theme.cardBg)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                    Button(action: {
                        let text = "J'ai lu \(surahName) (\(surahArabic)) 📖\n\n\(reflection)\n\n— App Iqra 🤲"
                        AppState.shareText(text)
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Partager ma réflexion")
                        }
                        .goldButton()
                    }
                    Spacer()
                }
                .padding(16)
            }
            .navigationTitle("Ma réflexion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }
}
