import Foundation

// MARK: - Surah Model
struct Surah: Identifiable {
    let id: Int
    let arabicName: String
    let frenchName: String
    let englishName: String
    let phonetic: String
    let verseCount: Int
    let revelationType: String  // "Mecquoise" or "Médinoise"
    let isRamadanRecommended: Bool
    
    var displayNumber: String {
        return "\(id)"
    }
}

// MARK: - Duaa Model
struct Duaa: Identifiable {
    let id: String
    let title: String
    let arabicText: String
    let transliteration: String
    let translation: String
    let source: String
    let category: DuaaCategory
    
    enum DuaaCategory: String, CaseIterable {
        case matin = "Matin"
        case soir = "Soir"
        case priere = "Prière"
        case protection = "Protection"
        case pardon = "Pardon"
        case quotidien = "Quotidien"
        case ramadan = "Ramadan"
        case prophete = "Prophète ﷺ"
        
        var icon: String {
            switch self {
            case .matin: return "☀️"
            case .soir: return "🌙"
            case .priere: return "🕌"
            case .protection: return "🛡️"
            case .pardon: return "🤲"
            case .quotidien: return "📅"
            case .ramadan: return "🌙"
            case .prophete: return "💚"
            }
        }
    }
}

// MARK: - Adhkar Model
struct AdhkarCategory: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let adhkars: [Dhikr]
}

struct Dhikr: Identifiable {
    let id: String
    let title: String
    let arabicText: String
    let transliteration: String
    let translation: String
    let repetitions: Int
    let source: String
    let reward: String?
}

// MARK: - Enseignement Model
struct Enseignement: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let sections: [EnseignementSection]
}

struct EnseignementSection: Identifiable {
    let id = UUID().uuidString
    let title: String
    let content: String
    let arabicReference: String?
    let hadithReference: String?
}

// MARK: - Quiz Model
struct QuizQuestion: Identifiable {
    let id: String
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    let difficulty: QuizDifficulty
    let category: String
    
    enum QuizDifficulty: String {
        case facile = "Facile"
        case moyen = "Moyen"
        case difficile = "Difficile"
    }
}

// MARK: - Mosque Fundraising Model
struct MosqueFundraiser: Identifiable {
    let id: String
    let name: String
    let location: String
    let distance: String
    let project: String
    let collected: Int
    let goal: Int
    let icon: String
    
    var progress: Double {
        Double(collected) / Double(goal)
    }
    
    var collectedFormatted: String {
        "\(collected.formatted()) €"
    }
    
    var goalFormatted: String {
        "\(goal.formatted()) €"
    }
}

// MARK: - Ramadan Duaa
struct RamadanDuaa: Identifiable {
    let id: String
    let title: String
    let arabicText: String
    let phonetic: String
    let translation: String
    let context: String
    let category: String // Suhoor, Iftar, Night, General, Last10
}

// MARK: - Data Provider
struct DataProvider {
    
    // MARK: - 114 Surahs
    static let surahs: [Surah] = [
        Surah(id: 1, arabicName: "الفاتحة", frenchName: "L'Ouverture", englishName: "Al-Fatiha", phonetic: "Al-Fâtiha", verseCount: 7, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 2, arabicName: "البقرة", frenchName: "La Vache", englishName: "Al-Baqara", phonetic: "Al-Baqara", verseCount: 286, revelationType: "Médinoise", isRamadanRecommended: true),
        Surah(id: 3, arabicName: "آل عمران", frenchName: "La Famille d'Imran", englishName: "Ali 'Imran", phonetic: "Âl 'Imrân", verseCount: 200, revelationType: "Médinoise", isRamadanRecommended: true),
        Surah(id: 4, arabicName: "النساء", frenchName: "Les Femmes", englishName: "An-Nisa", phonetic: "An-Nisâ'", verseCount: 176, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 5, arabicName: "المائدة", frenchName: "La Table Servie", englishName: "Al-Ma'ida", phonetic: "Al-Mâ'ida", verseCount: 120, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 6, arabicName: "الأنعام", frenchName: "Les Bestiaux", englishName: "Al-An'am", phonetic: "Al-An'âm", verseCount: 165, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 7, arabicName: "الأعراف", frenchName: "Les Murailles", englishName: "Al-A'raf", phonetic: "Al-A'râf", verseCount: 206, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 8, arabicName: "الأنفال", frenchName: "Le Butin", englishName: "Al-Anfal", phonetic: "Al-Anfâl", verseCount: 75, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 9, arabicName: "التوبة", frenchName: "Le Repentir", englishName: "At-Tawba", phonetic: "At-Tawba", verseCount: 129, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 10, arabicName: "يونس", frenchName: "Jonas", englishName: "Yunus", phonetic: "Yûnus", verseCount: 109, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 11, arabicName: "هود", frenchName: "Hud", englishName: "Hud", phonetic: "Hûd", verseCount: 123, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 12, arabicName: "يوسف", frenchName: "Joseph", englishName: "Yusuf", phonetic: "Yûsuf", verseCount: 111, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 13, arabicName: "الرعد", frenchName: "Le Tonnerre", englishName: "Ar-Ra'd", phonetic: "Ar-Ra'd", verseCount: 43, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 14, arabicName: "إبراهيم", frenchName: "Abraham", englishName: "Ibrahim", phonetic: "Ibrâhîm", verseCount: 52, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 15, arabicName: "الحجر", frenchName: "Al-Hijr", englishName: "Al-Hijr", phonetic: "Al-Hijr", verseCount: 99, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 16, arabicName: "النحل", frenchName: "Les Abeilles", englishName: "An-Nahl", phonetic: "An-Nahl", verseCount: 128, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 17, arabicName: "الإسراء", frenchName: "Le Voyage Nocturne", englishName: "Al-Isra", phonetic: "Al-Isrâ'", verseCount: 111, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 18, arabicName: "الكهف", frenchName: "La Caverne", englishName: "Al-Kahf", phonetic: "Al-Kahf", verseCount: 110, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 19, arabicName: "مريم", frenchName: "Marie", englishName: "Maryam", phonetic: "Maryam", verseCount: 98, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 20, arabicName: "طه", frenchName: "Ta-Ha", englishName: "Ta-Ha", phonetic: "Tâ-Hâ", verseCount: 135, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 21, arabicName: "الأنبياء", frenchName: "Les Prophètes", englishName: "Al-Anbiya", phonetic: "Al-Anbiyâ'", verseCount: 112, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 22, arabicName: "الحج", frenchName: "Le Pèlerinage", englishName: "Al-Hajj", phonetic: "Al-Hajj", verseCount: 78, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 23, arabicName: "المؤمنون", frenchName: "Les Croyants", englishName: "Al-Mu'minun", phonetic: "Al-Mu'minûn", verseCount: 118, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 24, arabicName: "النور", frenchName: "La Lumière", englishName: "An-Nur", phonetic: "An-Nûr", verseCount: 64, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 25, arabicName: "الفرقان", frenchName: "Le Discernement", englishName: "Al-Furqan", phonetic: "Al-Furqân", verseCount: 77, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 26, arabicName: "الشعراء", frenchName: "Les Poètes", englishName: "Ash-Shu'ara", phonetic: "Ash-Shu'arâ'", verseCount: 227, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 27, arabicName: "النمل", frenchName: "Les Fourmis", englishName: "An-Naml", phonetic: "An-Naml", verseCount: 93, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 28, arabicName: "القصص", frenchName: "Le Récit", englishName: "Al-Qasas", phonetic: "Al-Qasas", verseCount: 88, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 29, arabicName: "العنكبوت", frenchName: "L'Araignée", englishName: "Al-Ankabut", phonetic: "Al-'Ankabût", verseCount: 69, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 30, arabicName: "الروم", frenchName: "Les Romains", englishName: "Ar-Rum", phonetic: "Ar-Rûm", verseCount: 60, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 31, arabicName: "لقمان", frenchName: "Luqman", englishName: "Luqman", phonetic: "Luqmân", verseCount: 34, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 32, arabicName: "السجدة", frenchName: "La Prosternation", englishName: "As-Sajda", phonetic: "As-Sajda", verseCount: 30, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 33, arabicName: "الأحزاب", frenchName: "Les Coalisés", englishName: "Al-Ahzab", phonetic: "Al-Ahzâb", verseCount: 73, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 34, arabicName: "سبأ", frenchName: "Saba", englishName: "Saba", phonetic: "Saba'", verseCount: 54, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 35, arabicName: "فاطر", frenchName: "Le Créateur", englishName: "Fatir", phonetic: "Fâtir", verseCount: 45, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 36, arabicName: "يس", frenchName: "Ya-Sin", englishName: "Ya-Sin", phonetic: "Yâ-Sîn", verseCount: 83, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 37, arabicName: "الصافات", frenchName: "Les Rangés", englishName: "As-Saffat", phonetic: "As-Sâffât", verseCount: 182, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 38, arabicName: "ص", frenchName: "Sad", englishName: "Sad", phonetic: "Sâd", verseCount: 88, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 39, arabicName: "الزمر", frenchName: "Les Groupes", englishName: "Az-Zumar", phonetic: "Az-Zumar", verseCount: 75, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 40, arabicName: "غافر", frenchName: "Le Pardonneur", englishName: "Ghafir", phonetic: "Ghâfir", verseCount: 85, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 41, arabicName: "فصلت", frenchName: "Les Versets Détaillés", englishName: "Fussilat", phonetic: "Fussilat", verseCount: 54, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 42, arabicName: "الشورى", frenchName: "La Consultation", englishName: "Ash-Shura", phonetic: "Ash-Shûrâ", verseCount: 53, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 43, arabicName: "الزخرف", frenchName: "L'Ornement", englishName: "Az-Zukhruf", phonetic: "Az-Zukhruf", verseCount: 89, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 44, arabicName: "الدخان", frenchName: "La Fumée", englishName: "Ad-Dukhan", phonetic: "Ad-Dukhân", verseCount: 59, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 45, arabicName: "الجاثية", frenchName: "L'Agenouillée", englishName: "Al-Jathiya", phonetic: "Al-Jâthiya", verseCount: 37, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 46, arabicName: "الأحقاف", frenchName: "Al-Ahqaf", englishName: "Al-Ahqaf", phonetic: "Al-Ahqâf", verseCount: 35, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 47, arabicName: "محمد", frenchName: "Muhammad", englishName: "Muhammad", phonetic: "Muhammad", verseCount: 38, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 48, arabicName: "الفتح", frenchName: "La Victoire Éclatante", englishName: "Al-Fath", phonetic: "Al-Fath", verseCount: 29, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 49, arabicName: "الحجرات", frenchName: "Les Appartements", englishName: "Al-Hujurat", phonetic: "Al-Hujurât", verseCount: 18, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 50, arabicName: "ق", frenchName: "Qaf", englishName: "Qaf", phonetic: "Qâf", verseCount: 45, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 51, arabicName: "الذاريات", frenchName: "Qui Éparpillent", englishName: "Adh-Dhariyat", phonetic: "Adh-Dhâriyât", verseCount: 60, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 52, arabicName: "الطور", frenchName: "Le Mont", englishName: "At-Tur", phonetic: "At-Tûr", verseCount: 49, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 53, arabicName: "النجم", frenchName: "L'Étoile", englishName: "An-Najm", phonetic: "An-Najm", verseCount: 62, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 54, arabicName: "القمر", frenchName: "La Lune", englishName: "Al-Qamar", phonetic: "Al-Qamar", verseCount: 55, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 55, arabicName: "الرحمن", frenchName: "Le Tout Miséricordieux", englishName: "Ar-Rahman", phonetic: "Ar-Rahmân", verseCount: 78, revelationType: "Médinoise", isRamadanRecommended: true),
        Surah(id: 56, arabicName: "الواقعة", frenchName: "L'Événement", englishName: "Al-Waqi'a", phonetic: "Al-Wâqi'a", verseCount: 96, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 57, arabicName: "الحديد", frenchName: "Le Fer", englishName: "Al-Hadid", phonetic: "Al-Hadîd", verseCount: 29, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 58, arabicName: "المجادلة", frenchName: "La Discussion", englishName: "Al-Mujadila", phonetic: "Al-Mujâdila", verseCount: 22, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 59, arabicName: "الحشر", frenchName: "L'Exode", englishName: "Al-Hashr", phonetic: "Al-Hashr", verseCount: 24, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 60, arabicName: "الممتحنة", frenchName: "L'Éprouvée", englishName: "Al-Mumtahina", phonetic: "Al-Mumtahina", verseCount: 13, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 61, arabicName: "الصف", frenchName: "Le Rang", englishName: "As-Saff", phonetic: "As-Saff", verseCount: 14, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 62, arabicName: "الجمعة", frenchName: "Le Vendredi", englishName: "Al-Jumu'a", phonetic: "Al-Jumu'a", verseCount: 11, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 63, arabicName: "المنافقون", frenchName: "Les Hypocrites", englishName: "Al-Munafiqun", phonetic: "Al-Munâfiqûn", verseCount: 11, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 64, arabicName: "التغابن", frenchName: "La Grande Perte", englishName: "At-Taghabun", phonetic: "At-Taghâbun", verseCount: 18, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 65, arabicName: "الطلاق", frenchName: "Le Divorce", englishName: "At-Talaq", phonetic: "At-Talâq", verseCount: 12, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 66, arabicName: "التحريم", frenchName: "L'Interdiction", englishName: "At-Tahrim", phonetic: "At-Tahrîm", verseCount: 12, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 67, arabicName: "الملك", frenchName: "La Royauté", englishName: "Al-Mulk", phonetic: "Al-Mulk", verseCount: 30, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 68, arabicName: "القلم", frenchName: "La Plume", englishName: "Al-Qalam", phonetic: "Al-Qalam", verseCount: 52, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 69, arabicName: "الحاقة", frenchName: "Celle qui Montre la Vérité", englishName: "Al-Haqqa", phonetic: "Al-Hâqqa", verseCount: 52, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 70, arabicName: "المعارج", frenchName: "Les Voies d'Ascension", englishName: "Al-Ma'arij", phonetic: "Al-Ma'ârij", verseCount: 44, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 71, arabicName: "نوح", frenchName: "Noé", englishName: "Nuh", phonetic: "Nûh", verseCount: 28, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 72, arabicName: "الجن", frenchName: "Les Djinns", englishName: "Al-Jinn", phonetic: "Al-Jinn", verseCount: 28, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 73, arabicName: "المزمل", frenchName: "L'Enveloppé", englishName: "Al-Muzzammil", phonetic: "Al-Muzzammil", verseCount: 20, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 74, arabicName: "المدثر", frenchName: "Le Revêtu d'un Manteau", englishName: "Al-Muddathir", phonetic: "Al-Muddathir", verseCount: 56, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 75, arabicName: "القيامة", frenchName: "La Résurrection", englishName: "Al-Qiyama", phonetic: "Al-Qiyâma", verseCount: 40, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 76, arabicName: "الإنسان", frenchName: "L'Homme", englishName: "Al-Insan", phonetic: "Al-Insân", verseCount: 31, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 77, arabicName: "المرسلات", frenchName: "Les Envoyés", englishName: "Al-Mursalat", phonetic: "Al-Mursalât", verseCount: 50, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 78, arabicName: "النبأ", frenchName: "La Nouvelle", englishName: "An-Naba", phonetic: "An-Naba'", verseCount: 40, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 79, arabicName: "النازعات", frenchName: "Les Anges qui Arrachent", englishName: "An-Nazi'at", phonetic: "An-Nâzi'ât", verseCount: 46, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 80, arabicName: "عبس", frenchName: "Il S'est Renfrogné", englishName: "Abasa", phonetic: "'Abasa", verseCount: 42, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 81, arabicName: "التكوير", frenchName: "L'Obscurcissement", englishName: "At-Takwir", phonetic: "At-Takwîr", verseCount: 29, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 82, arabicName: "الانفطار", frenchName: "La Rupture", englishName: "Al-Infitar", phonetic: "Al-Infitâr", verseCount: 19, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 83, arabicName: "المطففين", frenchName: "Les Fraudeurs", englishName: "Al-Mutaffifin", phonetic: "Al-Mutaffifîn", verseCount: 36, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 84, arabicName: "الانشقاق", frenchName: "La Déchirure", englishName: "Al-Inshiqaq", phonetic: "Al-Inshiqâq", verseCount: 25, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 85, arabicName: "البروج", frenchName: "Les Constellations", englishName: "Al-Buruj", phonetic: "Al-Burûj", verseCount: 22, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 86, arabicName: "الطارق", frenchName: "L'Astre Nocturne", englishName: "At-Tariq", phonetic: "At-Târiq", verseCount: 17, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 87, arabicName: "الأعلى", frenchName: "Le Très-Haut", englishName: "Al-A'la", phonetic: "Al-A'lâ", verseCount: 19, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 88, arabicName: "الغاشية", frenchName: "L'Enveloppante", englishName: "Al-Ghashiya", phonetic: "Al-Ghâshiya", verseCount: 26, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 89, arabicName: "الفجر", frenchName: "L'Aube", englishName: "Al-Fajr", phonetic: "Al-Fajr", verseCount: 30, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 90, arabicName: "البلد", frenchName: "La Cité", englishName: "Al-Balad", phonetic: "Al-Balad", verseCount: 20, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 91, arabicName: "الشمس", frenchName: "Le Soleil", englishName: "Ash-Shams", phonetic: "Ash-Shams", verseCount: 15, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 92, arabicName: "الليل", frenchName: "La Nuit", englishName: "Al-Layl", phonetic: "Al-Layl", verseCount: 21, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 93, arabicName: "الضحى", frenchName: "Le Jour Montant", englishName: "Ad-Duha", phonetic: "Ad-Duhâ", verseCount: 11, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 94, arabicName: "الشرح", frenchName: "L'Ouverture", englishName: "Ash-Sharh", phonetic: "Ash-Sharh", verseCount: 8, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 95, arabicName: "التين", frenchName: "Le Figuier", englishName: "At-Tin", phonetic: "At-Tîn", verseCount: 8, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 96, arabicName: "العلق", frenchName: "L'Adhérence", englishName: "Al-Alaq", phonetic: "Al-'Alaq", verseCount: 19, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 97, arabicName: "القدر", frenchName: "La Destinée", englishName: "Al-Qadr", phonetic: "Al-Qadr", verseCount: 5, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 98, arabicName: "البينة", frenchName: "La Preuve", englishName: "Al-Bayyina", phonetic: "Al-Bayyina", verseCount: 8, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 99, arabicName: "الزلزلة", frenchName: "La Secousse", englishName: "Az-Zalzala", phonetic: "Az-Zalzala", verseCount: 8, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 100, arabicName: "العاديات", frenchName: "Les Coursiers", englishName: "Al-Adiyat", phonetic: "Al-'Âdiyât", verseCount: 11, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 101, arabicName: "القارعة", frenchName: "Le Fracas", englishName: "Al-Qari'a", phonetic: "Al-Qâri'a", verseCount: 11, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 102, arabicName: "التكاثر", frenchName: "La Course aux Richesses", englishName: "At-Takathur", phonetic: "At-Takâthur", verseCount: 8, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 103, arabicName: "العصر", frenchName: "Le Temps", englishName: "Al-Asr", phonetic: "Al-'Asr", verseCount: 3, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 104, arabicName: "الهمزة", frenchName: "Les Calomniateurs", englishName: "Al-Humaza", phonetic: "Al-Humaza", verseCount: 9, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 105, arabicName: "الفيل", frenchName: "L'Éléphant", englishName: "Al-Fil", phonetic: "Al-Fîl", verseCount: 5, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 106, arabicName: "قريش", frenchName: "Quraych", englishName: "Quraysh", phonetic: "Quraysh", verseCount: 4, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 107, arabicName: "الماعون", frenchName: "L'Ustensile", englishName: "Al-Ma'un", phonetic: "Al-Mâ'ûn", verseCount: 7, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 108, arabicName: "الكوثر", frenchName: "L'Abondance", englishName: "Al-Kawthar", phonetic: "Al-Kawthar", verseCount: 3, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 109, arabicName: "الكافرون", frenchName: "Les Infidèles", englishName: "Al-Kafirun", phonetic: "Al-Kâfirûn", verseCount: 6, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 110, arabicName: "النصر", frenchName: "Le Secours", englishName: "An-Nasr", phonetic: "An-Nasr", verseCount: 3, revelationType: "Médinoise", isRamadanRecommended: false),
        Surah(id: 111, arabicName: "المسد", frenchName: "Les Fibres", englishName: "Al-Masad", phonetic: "Al-Masad", verseCount: 5, revelationType: "Mecquoise", isRamadanRecommended: false),
        Surah(id: 112, arabicName: "الإخلاص", frenchName: "Le Monothéisme Pur", englishName: "Al-Ikhlas", phonetic: "Al-Ikhlâs", verseCount: 4, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 113, arabicName: "الفلق", frenchName: "L'Aube Naissante", englishName: "Al-Falaq", phonetic: "Al-Falaq", verseCount: 5, revelationType: "Mecquoise", isRamadanRecommended: true),
        Surah(id: 114, arabicName: "الناس", frenchName: "Les Hommes", englishName: "An-Nas", phonetic: "An-Nâs", verseCount: 6, revelationType: "Mecquoise", isRamadanRecommended: true)
    ]
    
    // MARK: - Duaas
    static let duaas: [Duaa] = [
        // Matin
        Duaa(id: "d1", title: "Au réveil", arabicText: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ", transliteration: "Al-hamdu lillahi alladhi ahyana ba'da ma amatana wa ilayhi an-nushur", translation: "Louange à Allah qui nous a redonné la vie après nous avoir fait mourir et vers Lui est le retour.", source: "Bukhari", category: .matin),
        Duaa(id: "d2", title: "Adhkar du matin", arabicText: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", transliteration: "Asbahna wa asbahal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah", translation: "Nous voilà au matin et la royauté appartient à Allah. Louange à Allah. Il n'y a de divinité qu'Allah, Seul, sans associé.", source: "Muslim", category: .matin),
        // Soir
        Duaa(id: "d3", title: "Adhkar du soir", arabicText: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", transliteration: "Amsayna wa amsal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah", translation: "Nous voilà au soir et la royauté appartient à Allah. Louange à Allah. Il n'y a de divinité qu'Allah, Seul, sans associé.", source: "Muslim", category: .soir),
        Duaa(id: "d4", title: "Avant de dormir", arabicText: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا", transliteration: "Bismika Allahumma amutu wa ahya", translation: "C'est en Ton nom, ô Allah, que je meurs et que je vis.", source: "Bukhari", category: .soir),
        // Prière
        Duaa(id: "d5", title: "Entrée à la mosquée", arabicText: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ", transliteration: "Allahumma iftah li abwaba rahmatik", translation: "Ô Allah, ouvre-moi les portes de Ta miséricorde.", source: "Muslim", category: .priere),
        Duaa(id: "d6", title: "Après la prière", arabicText: "أَسْتَغْفِرُ اللَّهَ أَسْتَغْفِرُ اللَّهَ أَسْتَغْفِرُ اللَّهَ", transliteration: "Astaghfirullah, Astaghfirullah, Astaghfirullah", translation: "Je demande pardon à Allah (3 fois).", source: "Muslim", category: .priere),
        // Protection
        Duaa(id: "d7", title: "Protection divine", arabicText: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ", transliteration: "Bismillahi alladhi la yadurru ma'a ismihi shay'un fil-ardi wa la fis-sama'i wa huwas-Sami'ul-'Alim", translation: "Au nom d'Allah, avec le nom de Qui rien ne peut nuire sur terre ni dans le ciel, et Il est l'Audient, l'Omniscient.", source: "Abu Dawud, Tirmidhi", category: .protection),
        // Pardon
        Duaa(id: "d8", title: "Demande de pardon", arabicText: "رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ", transliteration: "Rabbana zalamna anfusana wa in lam taghfir lana wa tarhamna lanakounanna minal-khasirin", translation: "Seigneur ! Nous nous sommes fait du tort à nous-mêmes. Si Tu ne nous pardonnes pas et ne nous fais pas miséricorde, nous serons parmi les perdants.", source: "Coran 7:23", category: .pardon),
        Duaa(id: "d9", title: "Sayyid al-Istighfar", arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَىٰ عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ", transliteration: "Allahumma anta Rabbi la ilaha illa anta, khalaqtani wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mastata'tu", translation: "Ô Allah, Tu es mon Seigneur. Il n'y a de divinité que Toi. Tu m'as créé et je suis Ton serviteur. Je respecte Ton pacte et Ta promesse autant que je le peux.", source: "Bukhari", category: .pardon),
        // Quotidien
        Duaa(id: "d10", title: "Avant de manger", arabicText: "بِسْمِ اللَّهِ", transliteration: "Bismillah", translation: "Au nom d'Allah.", source: "Muslim", category: .quotidien),
        Duaa(id: "d11", title: "Après avoir mangé", arabicText: "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَٰذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ", transliteration: "Al-hamdu lillahi alladhi at'amani hadha wa razaqaniihi min ghayri hawlin minni wa la quwwah", translation: "Louange à Allah qui m'a nourri de cela et m'a accordé cette subsistance sans effort ni force de ma part.", source: "Tirmidhi", category: .quotidien),
        Duaa(id: "d12", title: "En sortant de chez soi", arabicText: "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", transliteration: "Bismillah, tawakkaltu 'alallah, wa la hawla wa la quwwata illa billah", translation: "Au nom d'Allah, je place ma confiance en Allah. Il n'y a de force ni de puissance qu'en Allah.", source: "Abu Dawud, Tirmidhi", category: .quotidien)
    ]
    
    // MARK: - Enseignements
    static let enseignements: [Enseignement] = [
        Enseignement(id: "e1", title: "Prière sur le mort", subtitle: "Salat al-Janaza", icon: "🕌", sections: [
            EnseignementSection(title: "Définition", content: "La prière funéraire (Salat al-Janaza) est une obligation communautaire (Fard Kifaya). Si un groupe de musulmans l'accomplit, l'obligation est levée pour les autres. Elle se compose de 4 Takbirs (Allahu Akbar) sans inclinaison ni prosternation.", arabicReference: "صَلَاةُ الْجَنَازَةِ", hadithReference: nil),
            EnseignementSection(title: "Les 4 Takbirs", content: "1er Takbir : Réciter Al-Fatiha\n2ème Takbir : Prière sur le Prophète ﷺ (Salat Ibrahimiya)\n3ème Takbir : Invocation pour le défunt\n4ème Takbir : Invocation puis Salam", arabicReference: nil, hadithReference: "Rapporté par Muslim"),
            EnseignementSection(title: "Invocation pour le défunt", content: "Ô Allah, pardonne-lui et accorde-lui Ta miséricorde. Accorde-lui le salut et le pardon. Honore son séjour et élargis sa tombe. Lave-le avec l'eau, la neige et la grêle.", arabicReference: "اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ وَعَافِهِ وَاعْفُ عَنْهُ", hadithReference: "Muslim")
        ]),
        Enseignement(id: "e2", title: "Purification", subtitle: "Wudu, Ghusl, Tayammum", icon: "💧", sections: [
            EnseignementSection(title: "Le Wudu (Ablutions)", content: "Le Wudu est obligatoire avant la prière. Il comprend : l'intention, le lavage des mains (3x), le rinçage de la bouche (3x), le rinçage du nez (3x), le lavage du visage (3x), le lavage des bras jusqu'aux coudes (3x), le passage des mains mouillées sur la tête, le lavage des pieds jusqu'aux chevilles (3x).", arabicReference: "الوُضُوء", hadithReference: nil),
            EnseignementSection(title: "Le Ghusl (Bain rituel)", content: "Le Ghusl est obligatoire après les rapports conjugaux, les menstrues, les lochies et l'émission de liquide séminal. Il consiste à laver tout le corps avec l'intention de purification.", arabicReference: "الغُسْل", hadithReference: nil),
            EnseignementSection(title: "Le Tayammum (Ablution sèche)", content: "Autorisé en l'absence d'eau ou en cas de maladie. On frappe la terre propre avec les deux mains, puis on passe sur le visage et les mains.", arabicReference: "التَّيَمُّم", hadithReference: nil)
        ]),
        Enseignement(id: "e3", title: "La prière", subtitle: "Piliers, conditions, annulants", icon: "🧎", sections: [
            EnseignementSection(title: "Les conditions de la prière", content: "L'Islam, la raison, l'âge de discernement, la purification rituelle, l'entrée du temps prescrit, couvrir la 'awra, faire face à la Qibla, l'intention.", arabicReference: "شُرُوطُ الصَّلَاة", hadithReference: nil),
            EnseignementSection(title: "Les piliers de la prière", content: "Se tenir debout (si capable), le Takbir d'ouverture, réciter Al-Fatiha, l'inclinaison (Ruku'), le redressement, la prosternation (Sujud), s'asseoir entre les deux prosternations, le dernier Tashahhud, le Salam final.", arabicReference: "أَرْكَانُ الصَّلَاة", hadithReference: nil),
            EnseignementSection(title: "Les annulants de la prière", content: "Parler volontairement, rire, manger ou boire, perdre les ablutions, se détourner de la Qibla, découvrir la 'awra, faire beaucoup de mouvements consécutifs inutiles.", arabicReference: nil, hadithReference: nil)
        ]),
        Enseignement(id: "e4", title: "Le jeûne", subtitle: "Ramadan et jeûne surérogatoire", icon: "🌙", sections: [
            EnseignementSection(title: "L'obligation du jeûne", content: "Le jeûne du mois de Ramadan est le 4ème pilier de l'Islam. Il est obligatoire pour tout musulman pubère, sain d'esprit et en capacité de jeûner.", arabicReference: "يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ", hadithReference: "Coran 2:183"),
            EnseignementSection(title: "Ce qui annule le jeûne", content: "Manger ou boire volontairement, les rapports conjugaux, les vomissements provoqués volontairement, les menstrues ou les lochies.", arabicReference: nil, hadithReference: nil),
            EnseignementSection(title: "Les jeûnes surérogatoires", content: "Les 6 jours de Shawwal, les lundis et jeudis, les 3 jours blancs de chaque mois (13, 14, 15), le jour de 'Arafat (pour le non-pèlerin), le jour de 'Achoura.", arabicReference: nil, hadithReference: nil)
        ]),
        Enseignement(id: "e5", title: "La Zakat", subtitle: "Aumône obligatoire", icon: "💰", sections: [
            EnseignementSection(title: "Définition", content: "La Zakat est le 3ème pilier de l'Islam. C'est une aumône obligatoire prélevée sur les biens qui atteignent le Nissab (seuil minimum) après une année lunaire complète.", arabicReference: "الزَّكَاة", hadithReference: nil),
            EnseignementSection(title: "Le Nissab", content: "Le seuil de la Zakat est l'équivalent de 85 grammes d'or ou 595 grammes d'argent. Le taux est de 2,5% sur l'épargne qui atteint ce seuil.", arabicReference: nil, hadithReference: nil),
            EnseignementSection(title: "Les bénéficiaires", content: "Les 8 catégories mentionnées dans le Coran : les pauvres, les nécessiteux, ceux qui collectent la Zakat, ceux dont le cœur est à gagner, l'affranchissement des esclaves, les endettés, dans le sentier d'Allah, le voyageur en détresse.", arabicReference: "إِنَّمَا الصَّدَقَاتُ لِلْفُقَرَاءِ", hadithReference: "Coran 9:60")
        ]),
        Enseignement(id: "e6", title: "Le Hajj", subtitle: "Pèlerinage à La Mecque", icon: "🕋", sections: [
            EnseignementSection(title: "L'obligation du Hajj", content: "Le Hajj est le 5ème pilier de l'Islam. Il est obligatoire une fois dans la vie pour tout musulman qui en a les moyens physiques et financiers.", arabicReference: "وَلِلَّهِ عَلَى النَّاسِ حِجُّ الْبَيْتِ مَنِ اسْتَطَاعَ إِلَيْهِ سَبِيلًا", hadithReference: "Coran 3:97"),
            EnseignementSection(title: "Les piliers du Hajj", content: "L'Ihram (sacralisation), la station à 'Arafat, le Tawaf al-Ifada (circumambulation), le Sa'y entre Safa et Marwa.", arabicReference: nil, hadithReference: nil)
        ]),
        Enseignement(id: "e7", title: "Les piliers de la foi", subtitle: "Iman et croyance", icon: "❤️", sections: [
            EnseignementSection(title: "Les 6 piliers de la foi", content: "1. La croyance en Allah\n2. La croyance en Ses anges\n3. La croyance en Ses livres\n4. La croyance en Ses messagers\n5. La croyance au Jour dernier\n6. La croyance au destin, bon ou mauvais", arabicReference: "أَرْكَانُ الإِيمَان", hadithReference: "Hadith de Jibril - Muslim"),
            EnseignementSection(title: "La croyance en Allah", content: "Croire en l'existence d'Allah, en Sa seigneurie (Rububiyyah), en Sa divinité (Uluhiyyah) et en Ses noms et attributs (Asma wa Sifat).", arabicReference: nil, hadithReference: nil)
        ])
    ]
    
    // MARK: - Quiz Questions
    static let quizQuestions: [QuizQuestion] = [
        // Facile
        QuizQuestion(id: "q1", question: "Combien y a-t-il de sourates dans le Coran ?", options: ["100", "114", "120", "130"], correctIndex: 1, explanation: "Le Coran contient 114 sourates.", difficulty: .facile, category: "Coran"),
        QuizQuestion(id: "q2", question: "Quel est le premier pilier de l'Islam ?", options: ["La prière", "Le jeûne", "La Shahada", "La Zakat"], correctIndex: 2, explanation: "La Shahada (attestation de foi) est le premier pilier de l'Islam.", difficulty: .facile, category: "Piliers"),
        QuizQuestion(id: "q3", question: "Quelle est la première sourate du Coran ?", options: ["Al-Baqara", "Al-Fatiha", "Al-Ikhlas", "An-Nas"], correctIndex: 1, explanation: "Al-Fatiha (L'Ouverture) est la première sourate du Coran.", difficulty: .facile, category: "Coran"),
        QuizQuestion(id: "q4", question: "Combien de prières obligatoires par jour ?", options: ["3", "4", "5", "6"], correctIndex: 2, explanation: "Il y a 5 prières obligatoires par jour : Fajr, Dhuhr, Asr, Maghrib et Isha.", difficulty: .facile, category: "Prière"),
        QuizQuestion(id: "q5", question: "Quel mois est le mois du jeûne ?", options: ["Muharram", "Rajab", "Sha'ban", "Ramadan"], correctIndex: 3, explanation: "Le Ramadan est le 9ème mois du calendrier islamique, mois du jeûne.", difficulty: .facile, category: "Jeûne"),
        QuizQuestion(id: "q6", question: "Qui est le dernier prophète en Islam ?", options: ["Issa (Jésus)", "Moussa (Moïse)", "Ibrahim (Abraham)", "Muhammad ﷺ"], correctIndex: 3, explanation: "Muhammad ﷺ est le dernier prophète et messager d'Allah.", difficulty: .facile, category: "Prophètes"),
        QuizQuestion(id: "q7", question: "Quel est le livre sacré de l'Islam ?", options: ["La Torah", "L'Évangile", "Le Coran", "Les Psaumes"], correctIndex: 2, explanation: "Le Coran est le livre sacré de l'Islam, révélé au Prophète Muhammad ﷺ.", difficulty: .facile, category: "Coran"),
        QuizQuestion(id: "q8", question: "Vers quelle ville les musulmans prient-ils ?", options: ["Médine", "Jérusalem", "La Mecque", "Le Caire"], correctIndex: 2, explanation: "Les musulmans prient en direction de La Mecque (la Kaaba).", difficulty: .facile, category: "Prière"),
        
        // Moyen
        QuizQuestion(id: "q9", question: "Quelle sourate est appelée 'le cœur du Coran' ?", options: ["Al-Baqara", "Ya-Sin", "Al-Mulk", "Ar-Rahman"], correctIndex: 1, explanation: "Sourate Ya-Sin est souvent appelée 'le cœur du Coran'.", difficulty: .moyen, category: "Coran"),
        QuizQuestion(id: "q10", question: "Combien d'anges principaux sont mentionnés ?", options: ["2", "3", "4", "6"], correctIndex: 2, explanation: "4 anges principaux : Jibril, Mikail, Israfil et 'Izrail.", difficulty: .moyen, category: "Croyance"),
        QuizQuestion(id: "q11", question: "Quel prophète a construit l'Arche ?", options: ["Adam", "Nuh (Noé)", "Ibrahim", "Moussa"], correctIndex: 1, explanation: "Le prophète Nuh (Noé) a construit l'Arche sur ordre d'Allah.", difficulty: .moyen, category: "Prophètes"),
        QuizQuestion(id: "q12", question: "Quel est le Nissab de la Zakat en or ?", options: ["50g", "72g", "85g", "100g"], correctIndex: 2, explanation: "Le Nissab de la Zakat est l'équivalent de 85 grammes d'or.", difficulty: .moyen, category: "Zakat"),
        QuizQuestion(id: "q13", question: "Quelle nuit vaut mieux que 1000 mois ?", options: ["Nuit du 15 Sha'ban", "Nuit du Destin", "Nuit du Mi'raj", "Nuit du 1er Muharram"], correctIndex: 1, explanation: "Laylat al-Qadr (la Nuit du Destin) est meilleure que 1000 mois (Coran 97:3).", difficulty: .moyen, category: "Coran"),
        QuizQuestion(id: "q14", question: "Combien de versets contient Sourate Al-Baqara ?", options: ["200", "256", "286", "300"], correctIndex: 2, explanation: "Sourate Al-Baqara contient 286 versets, c'est la plus longue sourate.", difficulty: .moyen, category: "Coran"),
        QuizQuestion(id: "q15", question: "Quel prophète a parlé au berceau ?", options: ["Muhammad ﷺ", "Moussa", "Issa (Jésus)", "Yahya"], correctIndex: 2, explanation: "Le prophète Issa (Jésus) a parlé au berceau pour défendre sa mère Maryam.", difficulty: .moyen, category: "Prophètes"),
        QuizQuestion(id: "q16", question: "Quelle est la plus courte sourate du Coran ?", options: ["Al-Ikhlas", "Al-Kawthar", "Al-Asr", "Al-Fil"], correctIndex: 1, explanation: "Sourate Al-Kawthar avec 3 versets est la plus courte sourate du Coran.", difficulty: .moyen, category: "Coran"),
        
        // Difficile
        QuizQuestion(id: "q17", question: "Combien de fois le mot 'Sabr' apparaît dans le Coran ?", options: ["Environ 50", "Environ 70", "Environ 90", "Environ 110"], correctIndex: 2, explanation: "Le mot Sabr et ses dérivés apparaissent environ 90 fois dans le Coran.", difficulty: .difficile, category: "Coran"),
        QuizQuestion(id: "q18", question: "Quel compagnon est surnommé 'As-Siddiq' ?", options: ["Omar ibn Al-Khattab", "Abu Bakr", "Othman ibn Affan", "Ali ibn Abi Talib"], correctIndex: 1, explanation: "Abu Bakr as-Siddiq est surnommé 'Le Véridique' pour sa foi immédiate.", difficulty: .difficile, category: "Histoire"),
        QuizQuestion(id: "q19", question: "En quelle année a eu lieu l'Hégire ?", options: ["610", "613", "622", "632"], correctIndex: 2, explanation: "L'Hégire (migration du Prophète ﷺ à Médine) a eu lieu en 622.", difficulty: .difficile, category: "Histoire"),
        QuizQuestion(id: "q20", question: "Quel est le verset le plus long du Coran ?", options: ["Ayat Al-Kursi (2:255)", "Al-Baqara 2:282", "Al-Baqara 2:286", "An-Nisa 4:12"], correctIndex: 1, explanation: "Le verset 282 de Sourate Al-Baqara (le verset de la dette) est le plus long.", difficulty: .difficile, category: "Coran"),
        QuizQuestion(id: "q21", question: "Combien de prophètes sont nommés dans le Coran ?", options: ["20", "25", "30", "40"], correctIndex: 1, explanation: "25 prophètes sont nommés explicitement dans le Coran.", difficulty: .difficile, category: "Prophètes"),
        QuizQuestion(id: "q22", question: "Quelle bataille est mentionnée dans Sourate Al-Anfal ?", options: ["Uhud", "Badr", "Khandaq", "Tabuk"], correctIndex: 1, explanation: "Sourate Al-Anfal traite principalement de la bataille de Badr.", difficulty: .difficile, category: "Histoire"),
        QuizQuestion(id: "q23", question: "Quel prophète est mentionné le plus dans le Coran ?", options: ["Muhammad ﷺ", "Ibrahim", "Moussa", "Issa"], correctIndex: 2, explanation: "Le prophète Moussa (Moïse) est mentionné environ 136 fois dans le Coran.", difficulty: .difficile, category: "Coran"),
        QuizQuestion(id: "q24", question: "Combien de Juz' (parties) contient le Coran ?", options: ["20", "25", "30", "40"], correctIndex: 2, explanation: "Le Coran est divisé en 30 Juz' (parties) pour faciliter sa lecture.", difficulty: .difficile, category: "Coran")
    ]
    
    // MARK: - Mosque Fundraisers
    static let mosqueFundraisers: [MosqueFundraiser] = [
        MosqueFundraiser(id: "m1", name: "Mosquée As-Salam", location: "Asnières-sur-Seine", distance: "2.3 km", project: "Rénovation de la salle de prière", collected: 6500, goal: 10000, icon: "🕌"),
        MosqueFundraiser(id: "m2", name: "Mosquée Al-Fath", location: "Gennevilliers", distance: "4.1 km", project: "École coranique pour enfants", collected: 3500, goal: 10000, icon: "🕌"),
        MosqueFundraiser(id: "m3", name: "Mosquée Ar-Rahma", location: "Colombes", distance: "5.2 km", project: "Agrandissement de l'espace femmes", collected: 8200, goal: 15000, icon: "🕌"),
        MosqueFundraiser(id: "m4", name: "Mosquée Al-Hidaya", location: "Clichy", distance: "3.0 km", project: "Installation de climatisation", collected: 2000, goal: 5000, icon: "🕌")
    ]
    
    // MARK: - Ramadan Duaas
    static let ramadanDuaas: [RamadanDuaa] = [
        RamadanDuaa(id: "rd1", title: "Intention du jeûne", arabicText: "نَوَيْتُ صَوْمَ غَدٍ عَنْ أَدَاءِ فَرْضِ شَهْرِ رَمَضَانَ هَذِهِ السَّنَةِ لِلَّهِ تَعَالَى", phonetic: "Nawaytu sawma ghadin 'an ada'i fardi shahri Ramadana hadhihi as-sanati lillahi ta'ala", translation: "J'ai l'intention de jeûner demain pour accomplir l'obligation du mois de Ramadan de cette année, pour Allah le Très-Haut.", context: "À dire la veille ou avant le Fajr", category: "Suhoor"),
        RamadanDuaa(id: "rd2", title: "Du'a du Suhoor", arabicText: "اللَّهُمَّ إِنِّي أَسْأَلُكَ بِرَحْمَتِكَ الَّتِي وَسِعَتْ كُلَّ شَيْءٍ أَنْ تَغْفِرَ لِي", phonetic: "Allahumma inni as'aluka bi rahmatika allati wasi'at kulla shay'in an taghfira li", translation: "Ô Allah, je Te demande par Ta miséricorde qui englobe toute chose, de me pardonner.", context: "Au moment du Suhoor", category: "Suhoor"),
        RamadanDuaa(id: "rd3", title: "Rupture du jeûne", arabicText: "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ", phonetic: "Dhahaba adh-dhama'u wabtallatil-'uruqu wa thabatal-ajru in sha Allah", translation: "La soif est partie, les veines sont humidifiées et la récompense est confirmée si Allah le veut.", context: "Au moment de l'Iftar", category: "Iftar"),
        RamadanDuaa(id: "rd4", title: "Invocation de Laylat al-Qadr", arabicText: "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي", phonetic: "Allahumma innaka 'Afuwwun tuhibbul-'afwa fa'fu 'anni", translation: "Ô Allah, Tu es le Pardonneur, Tu aimes le pardon, alors pardonne-moi.", context: "Les nuits impaires des 10 dernières nuits", category: "Last10"),
        RamadanDuaa(id: "rd5", title: "Du'a de la nuit", arabicText: "رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ", phonetic: "Rabbana taqabbal minna innaka antas-Sami'ul-'Alim", translation: "Seigneur ! Accepte de nous, Tu es l'Audient, l'Omniscient.", context: "Pendant les prières de nuit (Tarawih/Qiyam)", category: "Night")
    ]
    
    // MARK: - Adhkar Categories (COMPLETS - FR / Phonétique / AR)
    static let adhkarCategories: [AdhkarCategory] = [

        // ─── MATIN ───────────────────────────────────────────────────────────
        AdhkarCategory(id: "ak1", title: "Adhkar du matin", subtitle: "À réciter après Fajr", icon: "🌅", adhkars: [

            Dhikr(id: "dh1", title: "Ayat Al-Kursi",
                  arabicText: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ",
                  transliteration: "Allahu la ilaha illa Huwa, Al-Hayyul-Qayyum. La ta'khudhuhu sinatun wa la nawm. Lahu ma fis-samawati wa ma fil-ard. Man dhalladhi yashfa'u 'indahu illa bi-idhnih. Ya'lamu ma bayna aydihim wa ma khalfahum. Wa la yuhituna bi-shay'in min 'ilmihi illa bima sha'. Wasi'a kursiyyuhus-samawati wal-ard, wa la ya'uduhu hifdhuhuma. Wa Huwal-'Aliyyul-'Adhim.",
                  translation: "Allah ! Il n'y a de divinité que Lui, le Vivant, le Subsistant. Ni somnolence ni sommeil ne Le saisissent. À Lui appartient tout ce qui est dans les cieux et la terre. Qui peut intercéder auprès de Lui sans Sa permission ? Il sait ce qui est devant eux et ce qui est derrière eux. Ils n'embrassent de Son savoir que ce qu'Il veut. Son Trône s'étend sur les cieux et la terre, dont la garde ne Lui coûte aucune peine. C'est Lui le Très Haut, le Très Grand.",
                  repetitions: 1, source: "Bukhari n°2311", reward: "Protection jusqu'au soir"),

            Dhikr(id: "dh2", title: "Sourate Al-Ikhlas",
                  arabicText: "قُلْ هُوَ اللَّهُ أَحَدٌ اللَّهُ الصَّمَدُ لَمْ يَلِدْ وَلَمْ يُولَدْ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ",
                  transliteration: "Qul huwa Allahu ahad. Allahus-Samad. Lam yalid wa lam yulad. Wa lam yakun lahu kufuwan ahad.",
                  translation: "Dis : Il est Allah, l'Unique. Allah, le Seul à être imploré. Il n'a pas engendré et n'a pas été engendré. Et nul n'est égal à Lui.",
                  repetitions: 3, source: "Abu Dawud n°5082", reward: "Protection contre tout mal, équivaut à 1/3 du Coran"),

            Dhikr(id: "dh2b", title: "Sourate Al-Falaq",
                  arabicText: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ مِن شَرِّ مَا خَلَقَ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ",
                  transliteration: "Qul a'udhu bi-Rabbil-falaq. Min sharri ma khalaq. Wa min sharri ghasiqin idha waqab. Wa min sharrin-naffathati fil-'uqad. Wa min sharri hasidin idha hasad.",
                  translation: "Dis : Je cherche refuge auprès du Seigneur de l'aube naissante, contre le mal de ce qu'Il a créé, le mal de l'obscurité quand elle s'étend, le mal de celles qui soufflent sur les nœuds, et le mal de l'envieux quand il envie.",
                  repetitions: 3, source: "Abu Dawud n°5082", reward: "Protection contre la sorcellerie et l'envie"),

            Dhikr(id: "dh2c", title: "Sourate An-Nas",
                  arabicText: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ مَلِكِ النَّاسِ إِلَٰهِ النَّاسِ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ مِنَ الْجِنَّةِ وَالنَّاسِ",
                  transliteration: "Qul a'udhu bi-Rabbin-nas. Malikin-nas. Ilahin-nas. Min sharril-waswasil-khannas. Alladhi yuwaswisu fi sudurin-nas. Minal-jinnati wan-nas.",
                  translation: "Dis : Je cherche refuge auprès du Seigneur des hommes, du Roi des hommes, de la Divinité des hommes, contre le mal du diable tentateur qui se retire, qui souffle le mal dans les poitrines des hommes, qu'il soit djinn ou homme.",
                  repetitions: 3, source: "Abu Dawud n°5082", reward: "Protection contre les mauvaises pensées et le shaytan"),

            Dhikr(id: "dh_matin_tasbih", title: "SubhanAllah wa bihamdihi",
                  arabicText: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
                  transliteration: "SubhanAllahi wa bihamdihi",
                  translation: "Gloire à Allah et Sa louange.",
                  repetitions: 100, source: "Bukhari n°6405", reward: "Efface les péchés comme l'écume de la mer"),

            Dhikr(id: "dh_matin_sayyid", title: "Sayyid al-Istighfar",
                  arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
                  transliteration: "Allahumma anta Rabbi la ilaha illa anta, khalaqtani wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mastata'tu, a'udhu bika min sharri ma sana'tu, abu'u laka bini'matika 'alayya, wa abu'u bidhanbi, faghfir li fa-innahu la yaghfirudh-dhunuba illa ant",
                  translation: "Ô Allah, Tu es mon Seigneur. Il n'y a de divinité que Toi. Tu m'as créé et je suis Ton serviteur. Je respecte Ton pacte et Ta promesse autant que je le peux. Je cherche refuge en Toi contre le mal de ce que j'ai commis. Je reconnais Tes bienfaits sur moi et je reconnais mon péché. Pardonne-moi, car personne ne pardonne les péchés sauf Toi.",
                  repetitions: 1, source: "Bukhari n°6306", reward: "Mourir au Paradis si dit le matin avec conviction")
        ]),

        // ─── SOIR ────────────────────────────────────────────────────────────
        AdhkarCategory(id: "ak2", title: "Adhkar du soir", subtitle: "À réciter après Asr/Maghrib", icon: "🌙", adhkars: [

            Dhikr(id: "dh3", title: "Souveraineté d'Allah (soir)",
                  arabicText: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                  transliteration: "Amsayna wa amsal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa 'ala kulli shay'in qadir",
                  translation: "Nous voilà au soir et la royauté appartient à Allah. Louange à Allah. Il n'y a de divinité qu'Allah Seul, sans associé. La royauté Lui appartient, la louange Lui revient, et Il est Omnipotent.",
                  repetitions: 1, source: "Muslim n°2723", reward: nil),

            Dhikr(id: "dh3b", title: "Ayat Al-Kursi (soir)",
                  arabicText: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ",
                  transliteration: "Allahu la ilaha illa Huwa, Al-Hayyul-Qayyum. La ta'khudhuhu sinatun wa la nawm. Lahu ma fis-samawati wa ma fil-ard. Man dhalladhi yashfa'u 'indahu illa bi-idhnih. Ya'lamu ma bayna aydihim wa ma khalfahum. Wa la yuhituna bi-shay'in min 'ilmihi illa bima sha'. Wasi'a kursiyyuhus-samawati wal-ard. Wa la ya'uduhu hifdhuhuma. Wa Huwal-'Aliyyul-'Adhim.",
                  translation: "Allah ! Il n'y a de divinité que Lui, le Vivant, le Subsistant. Ni somnolence ni sommeil ne Le saisissent. À Lui appartient tout ce qui est dans les cieux et la terre. Qui peut intercéder auprès de Lui sans Sa permission ? Il sait ce qui est devant eux et ce qui est derrière eux. Ils n'embrassent de Son savoir que ce qu'Il veut. Son Trône s'étend sur les cieux et la terre, dont la garde ne Lui coûte aucune peine. C'est Lui le Très Haut, le Très Grand.",
                  repetitions: 1, source: "Bukhari n°2311", reward: "Protection jusqu'au matin"),

            Dhikr(id: "dh3c", title: "Sayyid al-Istighfar (soir)",
                  arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
                  transliteration: "Allahumma anta Rabbi la ilaha illa anta, khalaqtani wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mastata'tu, a'udhu bika min sharri ma sana'tu, abu'u laka bini'matika 'alayya, wa abu'u bidhanbi, faghfir li fa-innahu la yaghfirudh-dhunuba illa ant",
                  translation: "Ô Allah, Tu es mon Seigneur. Il n'y a de divinité que Toi. Tu m'as créé et je suis Ton serviteur. Je respecte Ton pacte et Ta promesse autant que je le peux. Je cherche refuge en Toi contre le mal de ce que j'ai commis. Je reconnais Tes bienfaits sur moi et je reconnais mon péché. Pardonne-moi, car personne ne pardonne les péchés sauf Toi.",
                  repetitions: 1, source: "Bukhari n°6306", reward: "Mourir au Paradis si dit le soir avec conviction"),

            Dhikr(id: "dh_soir_ikhlas", title: "Al-Ikhlas, Al-Falaq, An-Nas (soir)",
                  arabicText: "قُلْ هُوَ اللَّهُ أَحَدٌ اللَّهُ الصَّمَدُ لَمْ يَلِدْ وَلَمْ يُولَدْ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ",
                  transliteration: "Qul huwa Allahu ahad. Allahus-Samad. Lam yalid wa lam yulad. Wa lam yakun lahu kufuwan ahad.",
                  translation: "Dis : Il est Allah, l'Unique. Allah, le Seul à être imploré. Il n'a pas engendré et n'a pas été engendré. Et nul n'est égal à Lui. (Lire aussi Al-Falaq et An-Nas, 3 fois chacune)",
                  repetitions: 3, source: "Abu Dawud n°5082, Tirmidhi", reward: "Protection pour toute la nuit")
        ]),

        // ─── APRÈS LA PRIÈRE ────────────────────────────────────────────────
        AdhkarCategory(id: "ak3", title: "Après la prière", subtitle: "Tasbih, Tahmid, Takbir...", icon: "🕌", adhkars: [

            Dhikr(id: "dh4", title: "SubhanAllah",
                  arabicText: "سُبْحَانَ اللَّهِ",
                  transliteration: "SubhanAllah",
                  translation: "Gloire à Allah",
                  repetitions: 33, source: "Muslim n°597", reward: "Expiation des péchés"),

            Dhikr(id: "dh5", title: "Alhamdulillah",
                  arabicText: "الْحَمْدُ لِلَّهِ",
                  transliteration: "Alhamdulillah",
                  translation: "Louange à Allah",
                  repetitions: 33, source: "Muslim n°597", reward: nil),

            Dhikr(id: "dh6", title: "Allahu Akbar",
                  arabicText: "اللَّهُ أَكْبَرُ",
                  transliteration: "Allahu Akbar",
                  translation: "Allah est le Plus Grand",
                  repetitions: 34, source: "Muslim n°597", reward: nil),

            Dhikr(id: "dh6b", title: "La ilaha illallah (après prière)",
                  arabicText: "لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                  transliteration: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa 'ala kulli shay'in qadir",
                  translation: "Il n'y a de divinité qu'Allah Seul, sans associé. La royauté Lui appartient, la louange Lui revient, et Il est Omnipotent.",
                  repetitions: 1, source: "Muslim n°597", reward: "Pardonne les péchés même comme l'écume de la mer"),

            Dhikr(id: "dh6c", title: "Ayat Al-Kursi (après prière)",
                  arabicText: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ",
                  transliteration: "Allahu la ilaha illa Huwa, Al-Hayyul-Qayyum. La ta'khudhuhu sinatun wa la nawm. Lahu ma fis-samawati wa ma fil-ard. Man dhalladhi yashfa'u 'indahu illa bi-idhnih. Ya'lamu ma bayna aydihim wa ma khalfahum. Wa la yuhituna bi-shay'in min 'ilmihi illa bima sha'. Wasi'a kursiyyuhus-samawati wal-ard. Wa la ya'uduhu hifdhuhuma. Wa Huwal-'Aliyyul-'Adhim.",
                  translation: "Allah ! Il n'y a de divinité que Lui, le Vivant, le Subsistant. Ni somnolence ni sommeil ne Le saisissent. À Lui appartient tout ce qui est dans les cieux et la terre. Qui peut intercéder auprès de Lui sans Sa permission ? Il sait ce qui est devant eux et ce qui est derrière eux. Ils n'embrassent de Son savoir que ce qu'Il veut. Son Trône s'étend sur les cieux et la terre, dont la garde ne Lui coûte aucune peine. C'est Lui le Très Haut, le Très Grand.",
                  repetitions: 1, source: "Nasa'i, Al-Albani (sahih)", reward: "Entrée directe au Paradis à la mort")
        ]),

        // ─── DHIKRS GÉNÉRAUX ────────────────────────────────────────────────
        AdhkarCategory(id: "ak4", title: "Dhikrs généraux", subtitle: "À tout moment", icon: "💕", adhkars: [

            Dhikr(id: "dh7", title: "La ilaha illAllah",
                  arabicText: "لَا إِلَٰهَ إِلَّا اللَّهُ",
                  transliteration: "La ilaha illAllah",
                  translation: "Il n'y a de divinité qu'Allah",
                  repetitions: 100, source: "Bukhari n°6403, Muslim n°2691", reward: "Meilleure parole que l'on puisse dire"),

            Dhikr(id: "dh8", title: "Istighfar",
                  arabicText: "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ",
                  transliteration: "Astaghfirullaha wa atubu ilayh",
                  translation: "Je demande pardon à Allah et je me repens à Lui",
                  repetitions: 100, source: "Bukhari n°6307", reward: "Le Prophète ﷺ en faisait 100 par jour"),

            Dhikr(id: "dh8b", title: "Hawqala",
                  arabicText: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
                  transliteration: "La hawla wa la quwwata illa billah",
                  translation: "Il n'y a de force ni de puissance qu'en Allah",
                  repetitions: 33, source: "Bukhari, Muslim", reward: "Trésor du Paradis"),

            Dhikr(id: "dh8c", title: "Salawat sur le Prophète ﷺ",
                  arabicText: "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ",
                  transliteration: "Allahumma salli wa sallim 'ala Nabiyyina Muhammad",
                  translation: "Ô Allah, prie et salue notre Prophète Muhammad ﷺ",
                  repetitions: 10, source: "Muslim n°408", reward: "Allah envoie 10 bénédictions en retour")
        ]),

        // ─── SITUATIONNELS ──────────────────────────────────────────────────
        AdhkarCategory(id: "ak5", title: "Invocations situationnelles", subtitle: "Voyage, maladie, difficulté...", icon: "🤲", adhkars: [

            Dhikr(id: "dh9", title: "En cas de difficulté",
                  arabicText: "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ",
                  transliteration: "HasbunAllahu wa ni'mal-Wakil",
                  translation: "Allah nous suffit, Il est le meilleur des garants.",
                  repetitions: 7, source: "Bukhari n°4563", reward: "Soutien d'Allah dans l'épreuve"),

            Dhikr(id: "dh10", title: "En voyage",
                  arabicText: "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنقَلِبُونَ",
                  transliteration: "Subhana-alladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila Rabbina lamunqalibun",
                  translation: "Gloire à Celui qui a mis ceci à notre service alors que nous n'étions pas en mesure de le maîtriser, et c'est vers notre Seigneur que nous retournerons.",
                  repetitions: 1, source: "Coran 43:13-14, Muslim", reward: nil),

            Dhikr(id: "dh11", title: "En cas de tristesse / anxiété",
                  arabicText: "اللَّهُمَّ إِنِّي عَبْدُكَ ابْنُ عَبْدِكَ ابْنُ أَمَتِكَ نَاصِيَتِي بِيَدِكَ مَاضٍ فِيَّ حُكْمُكَ عَدْلٌ فِيَّ قَضَاؤُكَ أَسْأَلُكَ بِكُلِّ اسْمٍ هُوَ لَكَ سَمَّيْتَ بِهِ نَفْسَكَ أَوْ أَنْزَلْتَهُ فِي كِتَابِكَ أَوْ عَلَّمْتَهُ أَحَدًا مِنْ خَلْقِكَ أَوِ اسْتَأْثَرْتَ بِهِ فِي عِلْمِ الْغَيْبِ عِنْدَكَ أَنْ تَجْعَلَ الْقُرْآنَ رَبِيعَ قَلْبِي وَنُورَ صَدْرِي وَجَلَاءَ حُزْنِي وَذَهَابَ هَمِّي",
                  transliteration: "Allahumma inni 'abduka, ibnu 'abdika, ibnu amatika, nasiyati biyadika, madin fiyya hukmuka, 'adlun fiyya qada'uka, as'aluka bi-kulli ismin huwa laka, sammayta bihi nafsaka, aw anzaltahu fi kitabika, aw 'allamtahu ahadan min khalqika, awista'tharta bihi fi 'ilmil-ghaybi 'indaka, an taj'alal-Qurana rabbi'a qalbi, wa nura sadri, wa jala'a huzni, wa dhahaba hammi",
                  translation: "Ô Allah, je suis Ton serviteur, fils de Ton serviteur, fils de Ta servante. Mon destin est entre Tes mains. Ton jugement s'exerce sur moi. Ta décision est juste. Je Te supplie par chacun de Tes noms de faire du Coran le printemps de mon cœur, la lumière de ma poitrine, et la dissipation de ma tristesse et de mon anxiété.",
                  repetitions: 1, source: "Ahmad n°3704", reward: "Allah remplace la tristesse par la joie"),

            Dhikr(id: "dh12", title: "Duaa de Yunus ﷺ",
                  arabicText: "لَا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ",
                  transliteration: "La ilaha illa anta subhanaka inni kuntu minaz-zalimin",
                  translation: "Il n'y a de divinité que Toi, gloire à Toi, j'ai en effet été du nombre des injustes.",
                  repetitions: 40, source: "Tirmidhi n°3505", reward: "Allah exauce la duaa comme pour Yunus alayhissalam"),

            Dhikr(id: "dh13", title: "Protection pour la famille",
                  arabicText: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
                  transliteration: "A'udhu bi-kalimatillahit-tammati min sharri ma khalaq",
                  translation: "Je cherche refuge dans les paroles parfaites d'Allah contre le mal de ce qu'Il a créé.",
                  repetitions: 3, source: "Muslim n°2708", reward: "Protection contre tout mal")
        ])
    ]
}
