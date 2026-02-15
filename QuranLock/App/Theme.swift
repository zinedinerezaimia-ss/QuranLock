import SwiftUI

struct Theme {
    // Normal theme
    static let primaryGreen = Color(red: 0.13, green: 0.55, blue: 0.13)
    static let darkBackground = Color(red: 0.05, green: 0.05, blue: 0.08)
    static let cardBackground = Color(red: 0.10, green: 0.10, blue: 0.14)
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.6)
    
    // Ramadan theme
    static let ramadanPurple = Color(red: 0.30, green: 0.10, blue: 0.50)
    static let ramadanGold = Color(red: 0.85, green: 0.65, blue: 0.13)
    static let ramadanDarkBg = Color(red: 0.05, green: 0.02, blue: 0.10)
    static let ramadanCardBg = Color(red: 0.12, green: 0.06, blue: 0.18)
    static let ramadanAccent = Color(red: 0.95, green: 0.75, blue: 0.20)
    
    static func primary(isRamadan: Bool) -> Color {
        isRamadan ? ramadanGold : primaryGreen
    }
    
    static func background(isRamadan: Bool) -> Color {
        isRamadan ? ramadanDarkBg : darkBackground
    }
    
    static func card(isRamadan: Bool) -> Color {
        isRamadan ? ramadanCardBg : cardBackground
    }
    
    static func accent(isRamadan: Bool) -> Color {
        isRamadan ? ramadanAccent : primaryGreen
    }
}
