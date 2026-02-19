import SwiftUI

// MARK: - App Language
enum AppLanguage: String, CaseIterable {
    case french = "fr"
    case english = "en"
    case arabic = "ar"

    var displayName: String {
        switch self {
        case .french: return "Français 🇫🇷"
        case .english: return "English 🇬🇧"
        case .arabic: return "العربية 🇸🇦"
        }
    }

    var isRTL: Bool { self == .arabic }

    var quranEdition: String {
        switch self {
        case .french: return "fr.hamidullah"
        case .english: return "en.sahih"
        case .arabic: return "ar.alafasy"
        }
    }
}

// MARK: - Localized Strings
struct L {
    static var lang: AppLanguage {
        guard let raw = UserDefaults.standard.string(forKey: "appLanguage"),
              let l = AppLanguage(rawValue: raw) else { return .french }
        return l
    }

    // MARK: - Navigation / Tabs
    static var home: String {
        switch lang {
        case .french: return "Accueil"
        case .english: return "Home"
        case .arabic: return "الرئيسية"
        }
    }
    static var quran: String {
        switch lang {
        case .french: return "Coran"
        case .english: return "Quran"
        case .arabic: return "القرآن"
        }
    }
    static var learn: String {
        switch lang {
        case .french: return "Apprendre"
        case .english: return "Learn"
        case .arabic: return "تعلم"
        }
    }
    static var community: String {
        switch lang {
        case .french: return "Communauté"
        case .english: return "Community"
        case .arabic: return "المجتمع"
        }
    }
    static var settings: String {
        switch lang {
        case .french: return "Paramètres"
        case .english: return "Settings"
        case .arabic: return "الإعدادات"
        }
    }

    // MARK: - Quran
    static var searchSurah: String {
        switch lang {
        case .french: return "Rechercher une sourate..."
        case .english: return "Search surah..."
        case .arabic: return "ابحث عن سورة..."
        }
    }
    static var verses: String {
        switch lang {
        case .french: return "Versets"
        case .english: return "Verses"
        case .arabic: return "الآيات"
        }
    }
    static var readVerses: String {
        switch lang {
        case .french: return "📖 Lire les versets"
        case .english: return "📖 Read verses"
        case .arabic: return "📖 قراءة الآيات"
        }
    }
    static var hideVerses: String {
        switch lang {
        case .french: return "Masquer les versets"
        case .english: return "Hide verses"
        case .arabic: return "إخفاء الآيات"
        }
    }
    static var markAsRead: String {
        switch lang {
        case .french: return "Marquer comme lue"
        case .english: return "Mark as read"
        case .arabic: return "تحديد كمقروءة"
        }
    }
    static var alreadyRead: String {
        switch lang {
        case .french: return "Déjà lue ✓"
        case .english: return "Already read ✓"
        case .arabic: return "تمت القراءة ✓"
        }
    }
    static var readOnline: String {
        switch lang {
        case .french: return "Lire sur Quran.com"
        case .english: return "Read on Quran.com"
        case .arabic: return "اقرأ على Quran.com"
        }
    }
    static var loading: String {
        switch lang {
        case .french: return "Chargement..."
        case .english: return "Loading..."
        case .arabic: return "جاري التحميل..."
        }
    }
    static var type: String {
        switch lang {
        case .french: return "Type"
        case .english: return "Type"
        case .arabic: return "النوع"
        }
    }
    static var number: String {
        switch lang {
        case .french: return "Numéro"
        case .english: return "Number"
        case .arabic: return "الرقم"
        }
    }
    static var ramadanRecommended: String {
        switch lang {
        case .french: return "Recommandée pendant le Ramadan"
        case .english: return "Recommended during Ramadan"
        case .arabic: return "موصى بها في رمضان"
        }
    }
    static var khatmChallenge: String {
        switch lang {
        case .french: return "📖 Défi Khatm القرآن"
        case .english: return "📖 Khatm Challenge"
        case .arabic: return "📖 تحدي ختم القرآن"
        }
    }

    // MARK: - Settings
    static var language: String {
        switch lang {
        case .french: return "Langue"
        case .english: return "Language"
        case .arabic: return "اللغة"
        }
    }
    static var chooseLanguage: String {
        switch lang {
        case .french: return "🌍 Langue de l'application"
        case .english: return "🌍 App Language"
        case .arabic: return "🌍 لغة التطبيق"
        }
    }
    static var dailyGoal: String {
        switch lang {
        case .french: return "Objectif quotidien"
        case .english: return "Daily goal"
        case .arabic: return "الهدف اليومي"
        }
    }
    static var pages: String {
        switch lang {
        case .french: return "pages"
        case .english: return "pages"
        case .arabic: return "صفحات"
        }
    }
    static var ramadanMode: String {
        switch lang {
        case .french: return "Mode Ramadan"
        case .english: return "Ramadan Mode"
        case .arabic: return "وضع رمضان"
        }
    }
    static var about: String {
        switch lang {
        case .french: return "ℹ️ À propos"
        case .english: return "ℹ️ About"
        case .arabic: return "ℹ️ حول"
        }
    }
    static var version: String {
        switch lang {
        case .french: return "Version"
        case .english: return "Version"
        case .arabic: return "الإصدار"
        }
    }
    static var developer: String {
        switch lang {
        case .french: return "Développeur"
        case .english: return "Developer"
        case .arabic: return "المطور"
        }
    }
    static var supportUs: String {
        switch lang {
        case .french: return "☕ Soutenir Iqra"
        case .english: return "☕ Support Iqra"
        case .arabic: return "☕ ادعم إقرأ"
        }
    }
    static var donationMsg: String {
        switch lang {
        case .french: return "50% des dons iront à l'équipe de développement, les 50% autres seront distribués sous forme de repas / de dons."
        case .english: return "50% of donations will go to the development team, the other 50% will be distributed as meals / charitable donations."
        case .arabic: return "50% من التبرعات ستذهب لفريق التطوير، و50% الأخرى ستوزع في شكل وجبات / تبرعات خيرية."
        }
    }
    static var donate: String {
        switch lang {
        case .french: return "Faire un don ❤️"
        case .english: return "Donate ❤️"
        case .arabic: return "تبرع ❤️"
        }
    }
    static var dangerZone: String {
        switch lang {
        case .french: return "⚠️ Zone dangereuse"
        case .english: return "⚠️ Danger Zone"
        case .arabic: return "⚠️ منطقة خطر"
        }
    }
    static var resetAll: String {
        switch lang {
        case .french: return "Réinitialiser toutes les données"
        case .english: return "Reset all data"
        case .arabic: return "إعادة تعيين جميع البيانات"
        }
    }
    static var resetConfirm: String {
        switch lang {
        case .french: return "Réinitialiser ?"
        case .english: return "Reset?"
        case .arabic: return "إعادة تعيين؟"
        }
    }
    static var resetMsg: String {
        switch lang {
        case .french: return "Toutes tes données (hasanat, progression, sourates lues) seront supprimées. Cette action est irréversible."
        case .english: return "All your data (hasanat, progress, surahs read) will be deleted. This action is irreversible."
        case .arabic: return "سيتم حذف جميع بياناتك (حسنات، التقدم، السور المقروءة). هذا الإجراء لا رجعة فيه."
        }
    }
    static var cancel: String {
        switch lang {
        case .french: return "Annuler"
        case .english: return "Cancel"
        case .arabic: return "إلغاء"
        }
    }
    static var close: String {
        switch lang {
        case .french: return "Fermer"
        case .english: return "Close"
        case .arabic: return "إغلاق"
        }
    }
    static var yourName: String {
        switch lang {
        case .french: return "Ton prénom"
        case .english: return "Your name"
        case .arabic: return "اسمك"
        }
    }

    // MARK: - Duaas
    static var invocations: String {
        switch lang {
        case .french: return "🤲 Invocations"
        case .english: return "🤲 Invocations"
        case .arabic: return "🤲 الأدعية"
        }
    }

    // MARK: - Surah types
    static func surahType(_ type: String) -> String {
        switch lang {
        case .french: return type
        case .english:
            switch type {
            case "Mecquoise": return "Meccan"
            case "Médinoise": return "Medinan"
            default: return type
            }
        case .arabic:
            switch type {
            case "Mecquoise": return "مكية"
            case "Médinoise": return "مدنية"
            default: return type
            }
        }
    }
}

// MARK: - Language Manager (ObservableObject for live switching)
class LanguageManager: ObservableObject {
    @AppStorage("appLanguage") var currentLanguage: String = AppLanguage.french.rawValue {
        didSet { objectWillChange.send() }
    }

    var language: AppLanguage {
        AppLanguage(rawValue: currentLanguage) ?? .french
    }

    var isRTL: Bool { language.isRTL }

    func set(_ lang: AppLanguage) {
        currentLanguage = lang.rawValue
    }
}
