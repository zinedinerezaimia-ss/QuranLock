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
    static var home: String { t("Accueil", "Home", "الرئيسية") }
    static var quran: String { t("Coran", "Quran", "القرآن") }
    static var learn: String { t("Apprendre", "Learn", "تعلم") }
    static var community: String { t("Communauté", "Community", "المجتمع") }
    static var settings: String { t("Paramètres", "Settings", "الإعدادات") }
    static var duaas: String { t("Duaas", "Duaas", "الأدعية") }
    static var other: String { t("Autre", "More", "المزيد") }

    // MARK: - Quran
    static var searchSurah: String { t("Rechercher une sourate...", "Search surah...", "ابحث عن سورة...") }
    static var verses: String { t("Versets", "Verses", "الآيات") }
    static var readVerses: String { t("📖 Lire les versets", "📖 Read verses", "📖 قراءة الآيات") }
    static var hideVerses: String { t("Masquer les versets", "Hide verses", "إخفاء الآيات") }
    static var markAsRead: String { t("Marquer comme lue", "Mark as read", "تحديد كمقروءة") }
    static var alreadyRead: String { t("Déjà lue ✓", "Already read ✓", "تمت القراءة ✓") }
    static var readOnline: String { t("Lire sur Quran.com", "Read on Quran.com", "اقرأ على Quran.com") }
    static var loading: String { t("Chargement...", "Loading...", "جاري التحميل...") }
    static var type: String { t("Type", "Type", "النوع") }
    static var number: String { t("Numéro", "Number", "الرقم") }
    static var ramadanRecommended: String { t("Recommandée pendant le Ramadan", "Recommended during Ramadan", "موصى بها في رمضان") }
    static var khatmChallenge: String { t("📖 Défi Khatm القرآن", "📖 Khatm Challenge", "📖 تحدي ختم القرآن") }

    // MARK: - Settings
    static var language: String { t("Langue", "Language", "اللغة") }
    static var chooseLanguage: String { t("🌍 Langue de l'application", "🌍 App Language", "🌍 لغة التطبيق") }
    static var dailyGoal: String { t("Objectif quotidien", "Daily goal", "الهدف اليومي") }
    static var pages: String { t("pages", "pages", "صفحات") }
    static var ramadanMode: String { t("Mode Ramadan", "Ramadan Mode", "وضع رمضان") }
    static var about: String { t("ℹ️ À propos", "ℹ️ About", "ℹ️ حول") }
    static var version: String { t("Version", "Version", "الإصدار") }
    static var developer: String { t("Développeur", "Developer", "المطور") }
    static var supportUs: String { t("☕ Soutenir Iqra", "☕ Support Iqra", "☕ ادعم إقرأ") }
    static var donationMsg: String { t("50% des dons iront à l'équipe de développement, les 50% autres seront distribués sous forme de repas / de dons.", "50% of donations go to the development team, the other 50% are distributed as meals / charitable donations.", "50% من التبرعات ستذهب لفريق التطوير، و50% الأخرى ستوزع في شكل وجبات / تبرعات خيرية.") }
    static var donate: String { t("Faire un don ❤️", "Donate ❤️", "تبرع ❤️") }
    static var dangerZone: String { t("⚠️ Zone dangereuse", "⚠️ Danger Zone", "⚠️ منطقة خطر") }
    static var resetAll: String { t("Réinitialiser toutes les données", "Reset all data", "إعادة تعيين جميع البيانات") }
    static var resetConfirm: String { t("Réinitialiser ?", "Reset?", "إعادة تعيين؟") }
    static var resetMsg: String { t("Toutes tes données seront supprimées. Cette action est irréversible.", "All your data will be deleted. This action is irreversible.", "سيتم حذف جميع بياناتك. هذا الإجراء لا رجعة فيه.") }
    static var cancel: String { t("Annuler", "Cancel", "إلغاء") }
    static var close: String { t("Fermer", "Close", "إغلاق") }
    static var yourName: String { t("Ton prénom", "Your name", "اسمك") }

    // MARK: - Home
    static var salam: String { t("السلام عليكم", "As-Salamu Alaykum", "السلام عليكم") }
    static var streak: String { t("Série", "Streak", "سلسلة") }
    static var days: String { t("jours", "days", "أيام") }
    static var hasanatLabel: String { t("Hasanat", "Hasanat", "حسنات") }
    static var nextPrayer: String { t("Prochaine prière", "Next prayer", "الصلاة القادمة") }
    static var prayerTimes: String { t("🕌 Horaires de prière", "🕌 Prayer times", "🕌 مواقيت الصلاة") }
    static var quickActions: String { t("Actions rapides", "Quick actions", "إجراءات سريعة") }

    // MARK: - Duaas
    static var invocations: String { t("🤲 Invocations", "🤲 Invocations", "🤲 الأدعية") }
    static var share: String { t("Partager", "Share", "مشاركة") }
    static var copied: String { t("Copié !", "Copied!", "تم النسخ!") }

    // MARK: - Community
    static var joinCommunity: String { t("Rejoins la communauté Iqra", "Join the Iqra community", "انضم إلى مجتمع إقرأ") }
    static var communityDesc: String { t("Partage tes réflexions sur les sourates, pose des questions et échange avec des musulmans du monde entier — en temps réel.", "Share your reflections on surahs, ask questions, and connect with Muslims worldwide — in real time.", "شارك تأملاتك حول السور واطرح أسئلتك وتواصل مع المسلمين حول العالم — في الوقت الفعلي.") }
    static var continueWithApple: String { t("Continuer avec Apple", "Continue with Apple", "المتابعة مع Apple") }
    static var reflections: String { t("💭 Réflexions", "💭 Reflections", "💭 تأملات") }
    static var questions: String { t("❓ Questions", "❓ Questions", "❓ أسئلة") }
    static var discussions: String { t("💬 Discussions", "💬 Discussions", "💬 نقاشات") }
    static var recitations: String { t("🎙️ Récitations", "🎙️ Recitations", "🎙️ تلاوات") }
    static var anonymous: String { t("Anonyme", "Anonymous", "مجهول") }
    static var modify: String { t("Modifier", "Edit", "تعديل") }
    static var disconnect: String { t("Déco", "Logout", "خروج") }
    static var noPosts: String { t("Aucune publication pour l'instant", "No posts yet", "لا توجد منشورات حالياً") }
    static var beFirst: String { t("Sois le premier à partager !", "Be the first to share!", "كن أول من يشارك!") }
    static var reply: String { t("Répondre...", "Reply...", "رد...") }
    static var newPost: String { t("Nouvelle publication", "New post", "منشور جديد") }
    static var postType: String { t("Type de publication", "Post type", "نوع المنشور") }
    static var yourMessage: String { t("Ton message", "Your message", "رسالتك") }
    static var surahRef: String { t("Sourate référencée (optionnel)", "Referenced surah (optional)", "السورة المرجعية (اختياري)") }
    static var publish: String { t("Publier ✨", "Publish ✨", "نشر ✨") }
    static var publishing: String { t("Publication...", "Publishing...", "جاري النشر...") }
    static var postError: String { t("Erreur lors de la publication. Réessaie.", "Error posting. Try again.", "خطأ في النشر. حاول مرة أخرى.") }
    static var myProfile: String { t("Mon profil", "My profile", "ملفي الشخصي") }
    static var yourPseudo: String { t("Ton pseudo dans la communauté", "Your community username", "اسمك في المجتمع") }
    static var pseudoPlaceholder: String { t("Ton prénom ou pseudo", "Your name or pseudo", "اسمك أو لقبك") }
    static var save: String { t("Enregistrer", "Save", "حفظ") }

    // MARK: - More tab
    static var quizTitle: String { t("🧠 Quiz Islamique", "🧠 Islamic Quiz", "🧠 اختبار إسلامي") }
    static var quizSub: String { t("Teste tes connaissances", "Test your knowledge", "اختبر معلوماتك") }
    static var communitySub: String { t("Partage & discussions", "Share & discuss", "مشاركة ونقاش") }
    static var musicTitle: String { t("🎵 Défi Arrêter la Musique", "🎵 Stop Music Challenge", "🎵 تحدي ترك الموسيقى") }
    static var musicSub: String { t("Remplace la musique par le Coran", "Replace music with Quran", "استبدل الموسيقى بالقرآن") }
    static var teachingsTitle: String { t("📖 Enseignements", "📖 Teachings", "📖 التعليم") }
    static var teachingsSub: String { t("Piliers de l'Islam, Prière...", "Pillars of Islam, Prayer...", "أركان الإسلام، الصلاة...") }
    static var mosqueSadaqa: String { t("🕌 Mosquées & Sadaqa", "🕌 Mosques & Sadaqa", "🕌 المساجد والصدقة") }
    static var mosqueSub: String { t("Soutenir les mosquées", "Support mosques", "دعم المساجد") }
    static var khatmTitle: String { t("🏁 Défi Khatm", "🏁 Khatm Challenge", "🏁 تحدي الختم") }
    static var khatmSub: String { t("Terminer le Coran complet", "Complete the entire Quran", "ختم القرآن الكريم") }
    static var prophetTitle: String { t("🌙 Histoire du Prophète ﷺ", "🌙 Prophet's Story ﷺ", "🌙 سيرة النبي ﷺ") }
    static var prophetSub: String { t("La Sîra du Prophète", "The Prophet's Sira", "السيرة النبوية") }

    // MARK: - Sadaqa
    static var sadaqaTitle: String { t("Sadaqa - Aide ta mosquée", "Sadaqa - Help your mosque", "صدقة - ساعد مسجدك") }
    static var manageMosque: String { t("Tu gères une mosquée ?", "Do you manage a mosque?", "هل تدير مسجداً؟") }
    static var registerMosque: String { t("Inscrire ma mosquée", "Register my mosque", "تسجيل مسجدي") }
    static var registerMosqueDesc: String { t("Inscris ta mosquée pour recevoir des dons de la communauté Iqra", "Register your mosque to receive donations from the Iqra community", "سجّل مسجدك لتلقي التبرعات من مجتمع إقرأ") }
    static var participate: String { t("Participer", "Participate", "المشاركة") }
    static var mosqueName: String { t("Nom de la mosquée", "Mosque name", "اسم المسجد") }
    static var mosqueCity: String { t("Ville", "City", "المدينة") }
    static var mosqueProject: String { t("Projet (ex: rénovation...)", "Project (e.g. renovation...)", "المشروع (مثل: تجديد...)") }
    static var mosqueGoal: String { t("Objectif (€)", "Goal (€)", "الهدف (€)") }
    static var mosqueIBAN: String { t("IBAN de la mosquée", "Mosque IBAN", "IBAN المسجد") }
    static var mosqueBIC: String { t("BIC/SWIFT", "BIC/SWIFT", "BIC/SWIFT") }
    static var mosqueContact: String { t("Email de contact", "Contact email", "البريد الإلكتروني") }
    static var submitMosque: String { t("Soumettre la mosquée", "Submit mosque", "إرسال المسجد") }
    static var mosqueSubmitted: String { t("Mosquée soumise ! Elle sera vérifiée sous 48h insha'Allah.", "Mosque submitted! It will be verified within 48h insha'Allah.", "تم إرسال المسجد! سيتم التحقق منه خلال 48 ساعة إن شاء الله.") }
    static var donateToMosque: String { t("Faire un don", "Donate", "تبرع") }
    static var donationInstructions: String { t("Effectue un virement bancaire aux coordonnées ci-dessous :", "Make a bank transfer to the details below:", "قم بتحويل مصرفي إلى التفاصيل أدناه:") }

    // MARK: - Notifications
    static var notifications: String { t("🔔 Notifications", "🔔 Notifications", "🔔 الإشعارات") }
    static var adhanNotif: String { t("Adhan à chaque prière", "Adhan at each prayer", "أذان كل صلاة") }
    static var prayerReminder: String { t("Rappel de prière", "Prayer reminder", "تذكير الصلاة") }

    // MARK: - Arabic Course
    static var learnArabic: String { t("🎓 Apprendre l'Arabe", "🎓 Learn Arabic", "🎓 تعلم العربية") }
    static var chooseRhythm: String { t("Choisis ton rythme d'apprentissage", "Choose your learning pace", "اختر وتيرة التعلم") }
    static var rhythmDesc: String { t("L'application s'adaptera à ton rythme pour t'aider à progresser durablement", "The app will adapt to your pace to help you progress steadily", "سيتكيف التطبيق مع وتيرتك لمساعدتك على التقدم بثبات") }
    static var myProgress: String { t("Ma Progression", "My Progress", "تقدمي") }
    static var lessonsCompleted: String { t("leçons complétées", "lessons completed", "دروس مكتملة") }
    static var availableCourses: String { t("📚 Cours disponibles", "📚 Available courses", "📚 الدروس المتاحة") }
    static var change: String { t("Changer", "Change", "تغيير") }
    static var rhythm: String { t("Rythme", "Pace", "الوتيرة") }
    static var lessonsPerWeek: String { t("leçons/semaine", "lessons/week", "دروس/أسبوع") }
    static var beginner: String { t("Débutant", "Beginner", "مبتدئ") }
    static var intermediate: String { t("Intermédiaire", "Intermediate", "متوسط") }
    static var advanced: String { t("Avancé", "Advanced", "متقدم") }

    // MARK: - Enseignements
    static var teachings: String { t("📚 Enseignements Islamiques", "📚 Islamic Teachings", "📚 التعليم الإسلامي") }
    static var teachingsDesc: String { t("Apprends les bases de l'Islam avec des sources authentiques", "Learn the basics of Islam with authentic sources", "تعلم أساسيات الإسلام من مصادر موثوقة") }
    static var sections: String { t("sections", "sections", "أقسام") }

    // MARK: - Prayer Guide
    static var prayerGuideTitle: String { t("🧎 Guide complet de la Prière", "🧎 Complete Prayer Guide", "🧎 دليل الصلاة الكامل") }
    static var prayerGuideSub: String { t("Apprends à prier étape par étape", "Learn to pray step by step", "تعلم الصلاة خطوة بخطوة") }

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

    // MARK: - Helper
    private static func t(_ fr: String, _ en: String, _ ar: String) -> String {
        switch lang {
        case .french: return fr
        case .english: return en
        case .arabic: return ar
        }
    }
}

// MARK: - Language Manager
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
