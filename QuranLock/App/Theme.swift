import SwiftUI

struct Theme {
    static let primaryBg = Color(red: 0.08, green: 0.07, blue: 0.16)
    static let secondaryBg = Color(red: 0.12, green: 0.11, blue: 0.22)
    static let cardBg = Color(red: 0.14, green: 0.13, blue: 0.26)
    static let gold = Color(red: 0.85, green: 0.72, blue: 0.30)
    static let goldLight = Color(red: 0.95, green: 0.85, blue: 0.50)
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.65, green: 0.62, blue: 0.75)
    static let accent = Color(red: 0.55, green: 0.40, blue: 0.85)
    static let accentLight = Color(red: 0.70, green: 0.55, blue: 0.95)
    static let success = Color(red: 0.30, green: 0.80, blue: 0.50)
    static let warning = Color(red: 0.95, green: 0.75, blue: 0.25)
    static let danger = Color(red: 0.90, green: 0.35, blue: 0.35)
    static let cardBorder = Color(red: 0.25, green: 0.23, blue: 0.40)
    
    // Ramadan special colors
    static let ramadanPurple = Color(red: 0.35, green: 0.20, blue: 0.60)
    static let ramadanGold = Color(red: 0.95, green: 0.80, blue: 0.30)
    
    static func cardStyle() -> some ViewModifier {
        CardModifier()
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Theme.cardBg)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Theme.cardBorder, lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
    
    func goldButton() -> some View {
        self
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.gold)
            .cornerRadius(12)
    }
    
    func outlineButton() -> some View {
        self
            .font(.headline)
            .foregroundColor(Theme.gold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.gold, lineWidth: 1.5)
            )
    }
}
