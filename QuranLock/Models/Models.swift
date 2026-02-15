import Foundation

// MARK: - Surah Model
struct Surah: Identifiable, Codable {
    let id: Int
    let name: String        // Arabic name
    let nameFr: String      // French name
    let nameEn: String      // English name
    let versesCount: Int
    let revelationType: String  // "Mecquoise" or "Médinoise"
    let phonetic: String    // Phonetic transcription (first verse or sample)
    
    var isRecommendedRamadan: Bool {
        [2, 36, 67].contains(id) // Al-Baqara, Ya-Sin, Al-Mulk
    }
}

// MARK: - QA Item
struct QAItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let source: String
    let category: String
}

// MARK: - Ramadan Duaa
struct RamadanDuaa: Identifiable {
    let id = UUID()
    let title: String
    let arabic: String
    let phonetic: String
    let translation: String
    let context: String     // When to say it
    let category: DuaaCategory
    
    enum DuaaCategory: String, CaseIterable {
        case suhoor = "Suhoor (Avant l'aube)"
        case iftar = "Iftar (Rupture)"
        case night = "Prière de nuit"
        case general = "Général Ramadan"
        case lastTenNights = "10 dernières nuits"
    }
}

// MARK: - Ramadan Night Info
struct RamadanNight: Identifiable {
    let id: Int             // Night number (1-30)
    let date: Date
    let isOdd: Bool
    let isLastTen: Bool
    let specialNote: String?
    
    var isLaylatAlQadr: Bool {
        isLastTen && isOdd
    }
}

// MARK: - Recommended Surah Detail
struct RecommendedSurah: Identifiable {
    let id: Int
    let name: String
    let arabicName: String
    let versesCount: Int
    let theme: String
    let whyRead: String
    let keyVerses: [KeyVerse]
    let reward: String
}

struct KeyVerse: Identifiable {
    let id = UUID()
    let verseNumber: Int
    let arabic: String
    let translation: String
    let explanation: String
}

// MARK: - Donation Info
struct DonationInfo {
    static let url = "https://buymeacoffee.com/quranlock"
    static let developerShare = 50
    static let charityShare = 50
    static let description = "50% des dons iront aux développeurs\n50% à des causes humanitaires"
}

// MARK: - Sample Surahs (114)
struct SurahData {
    static let allSurahs: [Surah] = [
        Surah(id: 1, name: "الفاتحة", nameFr: "L'Ouverture", nameEn: "Al-Fatiha", versesCount: 7, revelationType: "Mecquoise", phonetic: "Bismillahi ar-rahmani ar-rahim"),
        Surah(id: 2, name: "البقرة", nameFr: "La Vache", nameEn: "Al-Baqara", versesCount: 286, revelationType: "Médinoise", phonetic: "Alif Lam Mim"),
        Surah(id: 3, name: "آل عمران", nameFr: "La Famille d'Imran", nameEn: "Aal-Imran", versesCount: 200, revelationType: "Médinoise", phonetic: "Alif Lam Mim"),
        Surah(id: 4, name: "النساء", nameFr: "Les Femmes", nameEn: "An-Nisa", versesCount: 176, revelationType: "Médinoise", phonetic: "Ya ayyuha an-nasu"),
        Surah(id: 5, name: "المائدة", nameFr: "La Table Servie", nameEn: "Al-Ma'ida", versesCount: 120, revelationType: "Médinoise", phonetic: "Ya ayyuha alladhina amanu"),
        Surah(id: 6, name: "الأنعام", nameFr: "Les Bestiaux", nameEn: "Al-An'am", versesCount: 165, revelationType: "Mecquoise", phonetic: "Alhamdu lillahi alladhi khalaqa"),
        Surah(id: 7, name: "الأعراف", nameFr: "Les Murailles", nameEn: "Al-A'raf", versesCount: 206, revelationType: "Mecquoise", phonetic: "Alif Lam Mim Sad"),
        Surah(id: 8, name: "الأنفال", nameFr: "Le Butin", nameEn: "Al-Anfal", versesCount: 75, revelationType: "Médinoise", phonetic: "Yas'alunaka 'anil anfal"),
        Surah(id: 9, name: "التوبة", nameFr: "Le Repentir", nameEn: "At-Tawba", versesCount: 129, revelationType: "Médinoise", phonetic: "Bara'atun mina Allahi"),
        Surah(id: 10, name: "يونس", nameFr: "Jonas", nameEn: "Yunus", versesCount: 109, revelationType: "Mecquoise", phonetic: "Alif Lam Ra"),
        Surah(id: 11, name: "هود", nameFr: "Hud", nameEn: "Hud", versesCount: 123, revelationType: "Mecquoise", phonetic: "Alif Lam Ra"),
        Surah(id: 12, name: "يوسف", nameFr: "Joseph", nameEn: "Yusuf", versesCount: 111, revelationType: "Mecquoise", phonetic: "Alif Lam Ra"),
        Surah(id: 13, name: "الرعد", nameFr: "Le Tonnerre", nameEn: "Ar-Ra'd", versesCount: 43, revelationType: "Médinoise", phonetic: "Alif Lam Mim Ra"),
        Surah(id: 14, name: "إبراهيم", nameFr: "Abraham", nameEn: "Ibrahim", versesCount: 52, revelationType: "Mecquoise", phonetic: "Alif Lam Ra"),
        Surah(id: 15, name: "الحجر", nameFr: "Al-Hijr", nameEn: "Al-Hijr", versesCount: 99, revelationType: "Mecquoise", phonetic: "Alif Lam Ra"),
        Surah(id: 16, name: "النحل", nameFr: "Les Abeilles", nameEn: "An-Nahl", versesCount: 128, revelationType: "Mecquoise", phonetic: "Ata amru Allahi"),
        Surah(id: 17, name: "الإسراء", nameFr: "Le Voyage Nocturne", nameEn: "Al-Isra", versesCount: 111, revelationType: "Mecquoise", phonetic: "Subhana alladhi asra"),
        Surah(id: 18, name: "الكهف", nameFr: "La Caverne", nameEn: "Al-Kahf", versesCount: 110, revelationType: "Mecquoise", phonetic: "Alhamdu lillahi alladhi"),
        Surah(id: 19, name: "مريم", nameFr: "Marie", nameEn: "Maryam", versesCount: 98, revelationType: "Mecquoise", phonetic: "Kaf Ha Ya 'Ayn Sad"),
        Surah(id: 20, name: "طه", nameFr: "Ta-Ha", nameEn: "Ta-Ha", versesCount: 135, revelationType: "Mecquoise", phonetic: "Ta Ha"),
        Surah(id: 21, name: "الأنبياء", nameFr: "Les Prophètes", nameEn: "Al-Anbiya", versesCount: 112, revelationType: "Mecquoise", phonetic: "Iqtaraba linnasi"),
        Surah(id: 22, name: "الحج", nameFr: "Le Pèlerinage", nameEn: "Al-Hajj", versesCount: 78, revelationType: "Médinoise", phonetic: "Ya ayyuha an-nasu"),
        Surah(id: 23, name: "المؤمنون", nameFr: "Les Croyants", nameEn: "Al-Mu'minun", versesCount: 118, revelationType: "Mecquoise", phonetic: "Qad aflaha al-mu'minun"),
        Surah(id: 24, name: "النور", nameFr: "La Lumière", nameEn: "An-Nur", versesCount: 64, revelationType: "Médinoise", phonetic: "Suratun anzalnaha"),
        Surah(id: 25, name: "الفرقان", nameFr: "Le Discernement", nameEn: "Al-Furqan", versesCount: 77, revelationType: "Mecquoise", phonetic: "Tabaraka alladhi"),
        Surah(id: 26, name: "الشعراء", nameFr: "Les Poètes", nameEn: "Ash-Shu'ara", versesCount: 227, revelationType: "Mecquoise", phonetic: "Ta Sin Mim"),
        Surah(id: 27, name: "النمل", nameFr: "Les Fourmis", nameEn: "An-Naml", versesCount: 93, revelationType: "Mecquoise", phonetic: "Ta Sin"),
        Surah(id: 28, name: "القصص", nameFr: "Le Récit", nameEn: "Al-Qasas", versesCount: 88, revelationType: "Mecquoise", phonetic: "Ta Sin Mim"),
        Surah(id: 29, name: "العنكبوت", nameFr: "L'Araignée", nameEn: "Al-Ankabut", versesCount: 69, revelationType: "Mecquoise", phonetic: "Alif Lam Mim"),
        Surah(id: 30, name: "الروم", nameFr: "Les Romains", nameEn: "Ar-Rum", versesCount: 60, revelationType: "Mecquoise", phonetic: "Alif Lam Mim"),
        Surah(id: 31, name: "لقمان", nameFr: "Luqman", nameEn: "Luqman", versesCount: 34, revelationType: "Mecquoise", phonetic: "Alif Lam Mim"),
        Surah(id: 32, name: "السجدة", nameFr: "La Prosternation", nameEn: "As-Sajda", versesCount: 30, revelationType: "Mecquoise", phonetic: "Alif Lam Mim"),
        Surah(id: 33, name: "الأحزاب", nameFr: "Les Coalisés", nameEn: "Al-Ahzab", versesCount: 73, revelationType: "Médinoise", phonetic: "Ya ayyuha an-nabiyyu"),
        Surah(id: 34, name: "سبأ", nameFr: "Saba", nameEn: "Saba", versesCount: 54, revelationType: "Mecquoise", phonetic: "Alhamdu lillahi"),
        Surah(id: 35, name: "فاطر", nameFr: "Le Créateur", nameEn: "Fatir", versesCount: 45, revelationType: "Mecquoise", phonetic: "Alhamdu lillahi fatiri"),
        Surah(id: 36, name: "يس", nameFr: "Ya-Sin", nameEn: "Ya-Sin", versesCount: 83, revelationType: "Mecquoise", phonetic: "Ya Sin"),
        Surah(id: 37, name: "الصافات", nameFr: "Les Rangés", nameEn: "As-Saffat", versesCount: 182, revelationType: "Mecquoise", phonetic: "Wa as-saffati saffan"),
        Surah(id: 38, name: "ص", nameFr: "Sad", nameEn: "Sad", versesCount: 88, revelationType: "Mecquoise", phonetic: "Sad wa al-Qur'ani"),
        Surah(id: 39, name: "الزمر", nameFr: "Les Groupes", nameEn: "Az-Zumar", versesCount: 75, revelationType: "Mecquoise", phonetic: "Tanzilu al-kitabi"),
        Surah(id: 40, name: "غافر", nameFr: "Le Pardonneur", nameEn: "Ghafir", versesCount: 85, revelationType: "Mecquoise", phonetic: "Ha Mim"),
        Surah(id: 41, name: "فصلت", nameFr: "Les Versets Détaillés", nameEn: "Fussilat", versesCount: 54, revelationType: "Mecquoise", phonetic: "Ha Mim"),
        Surah(id: 42, name: "الشورى", nameFr: "La Consultation", nameEn: "Ash-Shura", versesCount: 53, revelationType: "Mecquoise", phonetic: "Ha Mim"),
        Surah(id: 43, name: "الزخرف", nameFr: "L'Ornement", nameEn: "Az-Zukhruf", versesCount: 89, revelationType: "Mecquoise", phonetic: "Ha Mim"),
        Surah(id: 44, name: "الدخان", nameFr: "La Fumée", nameEn: "Ad-Dukhan", versesCount: 59, revelationType: "Mecquoise", phonetic: "Ha Mim"),
        Surah(id: 45, name: "الجاثية", nameFr: "L'Agenouillée", nameEn: "Al-Jathiya", versesCount: 37, revelationType: "Mecquoise", phonetic: "Ha Mim"),
        Surah(id: 46, name: "الأحقاف", nameFr: "Les Dunes", nameEn: "Al-Ahqaf", versesCount: 35, revelationType: "Mecquoise", phonetic: "Ha Mim"),
        Surah(id: 47, name: "محمد", nameFr: "Muhammad", nameEn: "Muhammad", versesCount: 38, revelationType: "Médinoise", phonetic: "Alladhina kafaru"),
        Surah(id: 48, name: "الفتح", nameFr: "La Victoire Éclatante", nameEn: "Al-Fath", versesCount: 29, revelationType: "Médinoise", phonetic: "Inna fatahna laka"),
        Surah(id: 49, name: "الحجرات", nameFr: "Les Appartements", nameEn: "Al-Hujurat", versesCount: 18, revelationType: "Médinoise", phonetic: "Ya ayyuha alladhina"),
        Surah(id: 50, name: "ق", nameFr: "Qaf", nameEn: "Qaf", versesCount: 45, revelationType: "Mecquoise", phonetic: "Qaf wa al-Qur'ani"),
        Surah(id: 51, name: "الذاريات", nameFr: "Qui Éparpillent", nameEn: "Adh-Dhariyat", versesCount: 60, revelationType: "Mecquoise", phonetic: "Wa adh-dhariyati"),
        Surah(id: 52, name: "الطور", nameFr: "Le Mont", nameEn: "At-Tur", versesCount: 49, revelationType: "Mecquoise", phonetic: "Wa at-turi"),
        Surah(id: 53, name: "النجم", nameFr: "L'Étoile", nameEn: "An-Najm", versesCount: 62, revelationType: "Mecquoise", phonetic: "Wa an-najmi idha hawa"),
        Surah(id: 54, name: "القمر", nameFr: "La Lune", nameEn: "Al-Qamar", versesCount: 55, revelationType: "Mecquoise", phonetic: "Iqtarabati as-sa'atu"),
        Surah(id: 55, name: "الرحمن", nameFr: "Le Tout Miséricordieux", nameEn: "Ar-Rahman", versesCount: 78, revelationType: "Médinoise", phonetic: "Ar-Rahmanu"),
        Surah(id: 56, name: "الواقعة", nameFr: "L'Événement", nameEn: "Al-Waqi'a", versesCount: 96, revelationType: "Mecquoise", phonetic: "Idha waqa'ati al-waqi'a"),
        Surah(id: 57, name: "الحديد", nameFr: "Le Fer", nameEn: "Al-Hadid", versesCount: 29, revelationType: "Médinoise", phonetic: "Sabbaha lillahi"),
        Surah(id: 58, name: "المجادلة", nameFr: "La Discussion", nameEn: "Al-Mujadila", versesCount: 22, revelationType: "Médinoise", phonetic: "Qad sami'a Allahu"),
        Surah(id: 59, name: "الحشر", nameFr: "L'Exode", nameEn: "Al-Hashr", versesCount: 24, revelationType: "Médinoise", phonetic: "Sabbaha lillahi"),
        Surah(id: 60, name: "الممتحنة", nameFr: "L'Éprouvée", nameEn: "Al-Mumtahina", versesCount: 13, revelationType: "Médinoise", phonetic: "Ya ayyuha alladhina"),
        Surah(id: 61, name: "الصف", nameFr: "Le Rang", nameEn: "As-Saff", versesCount: 14, revelationType: "Médinoise", phonetic: "Sabbaha lillahi"),
        Surah(id: 62, name: "الجمعة", nameFr: "Le Vendredi", nameEn: "Al-Jumu'a", versesCount: 11, revelationType: "Médinoise", phonetic: "Yusabbihu lillahi"),
        Surah(id: 63, name: "المنافقون", nameFr: "Les Hypocrites", nameEn: "Al-Munafiqun", versesCount: 11, revelationType: "Médinoise", phonetic: "Idha ja'aka al-munafiquna"),
        Surah(id: 64, name: "التغابن", nameFr: "La Grande Perte", nameEn: "At-Taghabun", versesCount: 18, revelationType: "Médinoise", phonetic: "Yusabbihu lillahi"),
        Surah(id: 65, name: "الطلاق", nameFr: "Le Divorce", nameEn: "At-Talaq", versesCount: 12, revelationType: "Médinoise", phonetic: "Ya ayyuha an-nabiyyu"),
        Surah(id: 66, name: "التحريم", nameFr: "L'Interdiction", nameEn: "At-Tahrim", versesCount: 12, revelationType: "Médinoise", phonetic: "Ya ayyuha an-nabiyyu"),
        Surah(id: 67, name: "الملك", nameFr: "La Royauté", nameEn: "Al-Mulk", versesCount: 30, revelationType: "Mecquoise", phonetic: "Tabaraka alladhi biyadihi al-mulk"),
        Surah(id: 68, name: "القلم", nameFr: "La Plume", nameEn: "Al-Qalam", versesCount: 52, revelationType: "Mecquoise", phonetic: "Nun wa al-qalami"),
        Surah(id: 69, name: "الحاقة", nameFr: "Celle qui Montre la Vérité", nameEn: "Al-Haqqa", versesCount: 52, revelationType: "Mecquoise", phonetic: "Al-haqqatu"),
        Surah(id: 70, name: "المعارج", nameFr: "Les Voies d'Ascension", nameEn: "Al-Ma'arij", versesCount: 44, revelationType: "Mecquoise", phonetic: "Sa'ala sa'ilun"),
        Surah(id: 71, name: "نوح", nameFr: "Noé", nameEn: "Nuh", versesCount: 28, revelationType: "Mecquoise", phonetic: "Inna arsalna Nuhan"),
        Surah(id: 72, name: "الجن", nameFr: "Les Djinns", nameEn: "Al-Jinn", versesCount: 28, revelationType: "Mecquoise", phonetic: "Qul uhiya ilayya"),
        Surah(id: 73, name: "المزمل", nameFr: "L'Enveloppé", nameEn: "Al-Muzzammil", versesCount: 20, revelationType: "Mecquoise", phonetic: "Ya ayyuha al-muzzammilu"),
        Surah(id: 74, name: "المدثر", nameFr: "Le Revêtu d'un Manteau", nameEn: "Al-Muddathir", versesCount: 56, revelationType: "Mecquoise", phonetic: "Ya ayyuha al-muddathiru"),
        Surah(id: 75, name: "القيامة", nameFr: "La Résurrection", nameEn: "Al-Qiyama", versesCount: 40, revelationType: "Mecquoise", phonetic: "La uqsimu bi yawmi"),
        Surah(id: 76, name: "الإنسان", nameFr: "L'Homme", nameEn: "Al-Insan", versesCount: 31, revelationType: "Médinoise", phonetic: "Hal ata 'ala al-insani"),
        Surah(id: 77, name: "المرسلات", nameFr: "Les Envoyés", nameEn: "Al-Mursalat", versesCount: 50, revelationType: "Mecquoise", phonetic: "Wa al-mursalati 'urfan"),
        Surah(id: 78, name: "النبأ", nameFr: "La Nouvelle", nameEn: "An-Naba", versesCount: 40, revelationType: "Mecquoise", phonetic: "'Amma yatasa'alun"),
        Surah(id: 79, name: "النازعات", nameFr: "Les Anges qui Arrachent", nameEn: "An-Nazi'at", versesCount: 46, revelationType: "Mecquoise", phonetic: "Wa an-nazi'ati gharqan"),
        Surah(id: 80, name: "عبس", nameFr: "Il s'est Renfrogné", nameEn: "Abasa", versesCount: 42, revelationType: "Mecquoise", phonetic: "'Abasa wa tawalla"),
        Surah(id: 81, name: "التكوير", nameFr: "L'Obscurcissement", nameEn: "At-Takwir", versesCount: 29, revelationType: "Mecquoise", phonetic: "Idha ash-shamsu kuwwirat"),
        Surah(id: 82, name: "الانفطار", nameFr: "La Rupture", nameEn: "Al-Infitar", versesCount: 19, revelationType: "Mecquoise", phonetic: "Idha as-sama'u infatarat"),
        Surah(id: 83, name: "المطففين", nameFr: "Les Fraudeurs", nameEn: "Al-Mutaffifin", versesCount: 36, revelationType: "Mecquoise", phonetic: "Waylun lil-mutaffifin"),
        Surah(id: 84, name: "الانشقاق", nameFr: "La Déchirure", nameEn: "Al-Inshiqaq", versesCount: 25, revelationType: "Mecquoise", phonetic: "Idha as-sama'u inshaqqat"),
        Surah(id: 85, name: "البروج", nameFr: "Les Constellations", nameEn: "Al-Buruj", versesCount: 22, revelationType: "Mecquoise", phonetic: "Wa as-sama'i dhati al-buruj"),
        Surah(id: 86, name: "الطارق", nameFr: "L'Astre Nocturne", nameEn: "At-Tariq", versesCount: 17, revelationType: "Mecquoise", phonetic: "Wa as-sama'i wa at-tariqi"),
        Surah(id: 87, name: "الأعلى", nameFr: "Le Très-Haut", nameEn: "Al-A'la", versesCount: 19, revelationType: "Mecquoise", phonetic: "Sabbihi isma rabbika al-a'la"),
        Surah(id: 88, name: "الغاشية", nameFr: "L'Enveloppante", nameEn: "Al-Ghashiya", versesCount: 26, revelationType: "Mecquoise", phonetic: "Hal ataka hadithu al-ghashiyah"),
        Surah(id: 89, name: "الفجر", nameFr: "L'Aube", nameEn: "Al-Fajr", versesCount: 30, revelationType: "Mecquoise", phonetic: "Wa al-fajri"),
        Surah(id: 90, name: "البلد", nameFr: "La Cité", nameEn: "Al-Balad", versesCount: 20, revelationType: "Mecquoise", phonetic: "La uqsimu bi hadha al-balad"),
        Surah(id: 91, name: "الشمس", nameFr: "Le Soleil", nameEn: "Ash-Shams", versesCount: 15, revelationType: "Mecquoise", phonetic: "Wa ash-shamsi wa duhaha"),
        Surah(id: 92, name: "الليل", nameFr: "La Nuit", nameEn: "Al-Layl", versesCount: 21, revelationType: "Mecquoise", phonetic: "Wa al-layli idha yaghsha"),
        Surah(id: 93, name: "الضحى", nameFr: "Le Jour Montant", nameEn: "Ad-Duha", versesCount: 11, revelationType: "Mecquoise", phonetic: "Wa ad-duha"),
        Surah(id: 94, name: "الشرح", nameFr: "L'Ouverture", nameEn: "Ash-Sharh", versesCount: 8, revelationType: "Mecquoise", phonetic: "Alam nashrah laka sadrak"),
        Surah(id: 95, name: "التين", nameFr: "Le Figuier", nameEn: "At-Tin", versesCount: 8, revelationType: "Mecquoise", phonetic: "Wa at-tini wa az-zaytun"),
        Surah(id: 96, name: "العلق", nameFr: "L'Adhérence", nameEn: "Al-Alaq", versesCount: 19, revelationType: "Mecquoise", phonetic: "Iqra' bismi rabbika alladhi khalaq"),
        Surah(id: 97, name: "القدر", nameFr: "La Destinée", nameEn: "Al-Qadr", versesCount: 5, revelationType: "Mecquoise", phonetic: "Inna anzalnahu fi laylati al-qadr"),
        Surah(id: 98, name: "البينة", nameFr: "La Preuve", nameEn: "Al-Bayyina", versesCount: 8, revelationType: "Médinoise", phonetic: "Lam yakuni alladhina kafaru"),
        Surah(id: 99, name: "الزلزلة", nameFr: "La Secousse", nameEn: "Az-Zalzala", versesCount: 8, revelationType: "Médinoise", phonetic: "Idha zulzilati al-ardu"),
        Surah(id: 100, name: "العاديات", nameFr: "Les Coursiers", nameEn: "Al-Adiyat", versesCount: 11, revelationType: "Mecquoise", phonetic: "Wa al-'adiyati dabhan"),
        Surah(id: 101, name: "القارعة", nameFr: "Le Fracas", nameEn: "Al-Qari'a", versesCount: 11, revelationType: "Mecquoise", phonetic: "Al-qari'atu"),
        Surah(id: 102, name: "التكاثر", nameFr: "La Course aux Richesses", nameEn: "At-Takathur", versesCount: 8, revelationType: "Mecquoise", phonetic: "Alhakumu at-takathur"),
        Surah(id: 103, name: "العصر", nameFr: "Le Temps", nameEn: "Al-Asr", versesCount: 3, revelationType: "Mecquoise", phonetic: "Wa al-'asri"),
        Surah(id: 104, name: "الهمزة", nameFr: "Les Calomniateurs", nameEn: "Al-Humaza", versesCount: 9, revelationType: "Mecquoise", phonetic: "Waylun likulli humazatin"),
        Surah(id: 105, name: "الفيل", nameFr: "L'Éléphant", nameEn: "Al-Fil", versesCount: 5, revelationType: "Mecquoise", phonetic: "Alam tara kayfa fa'ala"),
        Surah(id: 106, name: "قريش", nameFr: "Quraych", nameEn: "Quraysh", versesCount: 4, revelationType: "Mecquoise", phonetic: "Li-ilafi Quraysh"),
        Surah(id: 107, name: "الماعون", nameFr: "L'Ustensile", nameEn: "Al-Ma'un", versesCount: 7, revelationType: "Mecquoise", phonetic: "Ara'ayta alladhi yukadhdhibu"),
        Surah(id: 108, name: "الكوثر", nameFr: "L'Abondance", nameEn: "Al-Kawthar", versesCount: 3, revelationType: "Mecquoise", phonetic: "Inna a'taynaka al-kawthar"),
        Surah(id: 109, name: "الكافرون", nameFr: "Les Infidèles", nameEn: "Al-Kafirun", versesCount: 6, revelationType: "Mecquoise", phonetic: "Qul ya ayyuha al-kafirun"),
        Surah(id: 110, name: "النصر", nameFr: "Le Secours", nameEn: "An-Nasr", versesCount: 3, revelationType: "Médinoise", phonetic: "Idha ja'a nasru Allahi"),
        Surah(id: 111, name: "المسد", nameFr: "Les Fibres", nameEn: "Al-Masad", versesCount: 5, revelationType: "Mecquoise", phonetic: "Tabbat yada Abi Lahabin"),
        Surah(id: 112, name: "الإخلاص", nameFr: "Le Monothéisme Pur", nameEn: "Al-Ikhlas", versesCount: 4, revelationType: "Mecquoise", phonetic: "Qul huwa Allahu ahad"),
        Surah(id: 113, name: "الفلق", nameFr: "L'Aube Naissante", nameEn: "Al-Falaq", versesCount: 5, revelationType: "Mecquoise", phonetic: "Qul a'udhu bi rabbi al-falaq"),
        Surah(id: 114, name: "الناس", nameFr: "Les Hommes", nameEn: "An-Nas", versesCount: 6, revelationType: "Mecquoise", phonetic: "Qul a'udhu bi rabbi an-nas")
    ]
}

// MARK: - Ramadan Duaas Data
struct RamadanDuaasData {
    static let allDuaas: [RamadanDuaa] = [
        // Suhoor
        RamadanDuaa(title: "Intention du jeûne", arabic: "نَوَيْتُ صَوْمَ غَدٍ عَنْ أَدَاءِ فَرْضِ شَهْرِ رَمَضَانَ هَذِهِ السَّنَةِ لِلَّهِ تَعَالَى", phonetic: "Nawaytou sawma ghadin 'an ada'i fardi shahri ramadana hadhihi as-sanati lillahi ta'ala", translation: "J'ai l'intention de jeûner demain pour accomplir l'obligation du mois de Ramadan de cette année, pour Allah le Très-Haut.", context: "Avant le Suhoor ou avant Fajr", category: .suhoor),
        RamadanDuaa(title: "Duaa du Suhoor", arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ وَرَحْمَتِكَ", phonetic: "Allahumma inni as'aluka min fadlika wa rahmatik", translation: "Ô Allah, je Te demande de Ta grâce et de Ta miséricorde.", context: "Pendant le repas du Suhoor", category: .suhoor),
        // Iftar
        RamadanDuaa(title: "Rupture du jeûne", arabic: "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ", phonetic: "Dhahaba adh-dhama'u wabtallati al-'uruqu wa thabata al-ajru in sha'a Allah", translation: "La soif est partie, les veines sont humidifiées et la récompense est confirmée si Allah le veut.", context: "Au moment de rompre le jeûne", category: .iftar),
        RamadanDuaa(title: "Avant de manger l'Iftar", arabic: "اللَّهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ", phonetic: "Allahumma laka sumtu wa 'ala rizqika aftartu", translation: "Ô Allah, c'est pour Toi que j'ai jeûné et c'est avec Ta subsistance que je romps mon jeûne.", context: "Juste avant de manger", category: .iftar),
        RamadanDuaa(title: "Duaa exaucée à l'Iftar", arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ بِرَحْمَتِكَ الَّتِي وَسِعَتْ كُلَّ شَيْءٍ أَنْ تَغْفِرَ لِي", phonetic: "Allahumma inni as'aluka bi rahmatika allati wasi'at kulla shay'in an taghfira li", translation: "Ô Allah, je Te demande par Ta miséricorde qui englobe toute chose de me pardonner.", context: "Moment d'exaucement: juste avant l'Iftar", category: .iftar),
        // Night prayers
        RamadanDuaa(title: "Duaa du Witr", arabic: "اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ وَعَافِنِي فِيمَنْ عَافَيْتَ وَتَوَلَّنِي فِيمَنْ تَوَلَّيْتَ", phonetic: "Allahumma-hdini fiman hadayt, wa 'afini fiman 'afayt, wa tawallani fiman tawallayt", translation: "Ô Allah, guide-moi parmi ceux que Tu as guidés, accorde-moi la santé parmi ceux à qui Tu l'as accordée, et prends-moi en charge parmi ceux dont Tu as pris la charge.", context: "Pendant la prière du Witr (Tarawih)", category: .night),
        RamadanDuaa(title: "Qunut du Ramadan", arabic: "اللَّهُمَّ إِنَّا نَسْتَعِينُكَ وَنَسْتَغْفِرُكَ وَنُؤْمِنُ بِكَ وَنَتَوَكَّلُ عَلَيْكَ", phonetic: "Allahumma inna nasta'inuka wa nastaghfiruka wa nu'minu bika wa natawakkalu 'alayk", translation: "Ô Allah, nous Te demandons aide et pardon, nous croyons en Toi et nous nous en remettons à Toi.", context: "Pendant le Qunut des Tarawih", category: .night),
        // General Ramadan
        RamadanDuaa(title: "Demande de pardon", arabic: "رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ", phonetic: "Rabbana dhalamna anfusana wa in lam taghfir lana wa tarhamna lanakunnanna mina al-khasirin", translation: "Notre Seigneur, nous nous sommes fait du tort à nous-mêmes. Et si Tu ne nous pardonnes pas et ne nous fais pas miséricorde, nous serons certainement du nombre des perdants.", context: "À tout moment du Ramadan", category: .general),
        RamadanDuaa(title: "Acceptation du jeûne", arabic: "اللَّهُمَّ تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ الْعَلِيمُ", phonetic: "Allahumma taqabbal minna innaka anta as-sami'u al-'alim", translation: "Ô Allah, accepte de nous, Tu es certes Celui qui entend tout et sait tout.", context: "Après chaque prière", category: .general),
        // Last 10 nights
        RamadanDuaa(title: "Duaa de Laylat al-Qadr", arabic: "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي", phonetic: "Allahumma innaka 'Afuwwun tuhibbu al-'afwa fa'fu 'anni", translation: "Ô Allah, Tu es Celui qui pardonne, Tu aimes le pardon, alors pardonne-moi.", context: "Les 10 dernières nuits, surtout les nuits impaires (21, 23, 25, 27, 29)", category: .lastTenNights),
        RamadanDuaa(title: "Recherche de Laylat al-Qadr", arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ أَنْ تَجْعَلَنِي مِمَّنْ أَدْرَكَ لَيْلَةَ الْقَدْرِ", phonetic: "Allahumma inni as'aluka an taj'alani mimman adraka Laylata al-Qadr", translation: "Ô Allah, je Te demande de me compter parmi ceux qui ont atteint la Nuit du Destin.", context: "Chaque nuit des 10 dernières nuits", category: .lastTenNights),
    ]
}

// MARK: - Recommended Surahs for Ramadan
struct RecommendedSurahsData {
    static let surahs: [RecommendedSurah] = [
        RecommendedSurah(
            id: 2,
            name: "Al-Baqara (La Vache)",
            arabicName: "البقرة",
            versesCount: 286,
            theme: "La plus longue sourate - Lois, histoires des prophètes, guidance complète",
            whyRead: "Le Prophète (paix sur lui) a dit: 'Lisez la sourate Al-Baqara, car la prendre est une bénédiction et l'abandonner est une cause de regret.' (Muslim). Elle protège la maison du Shaytan pendant 3 jours.",
            keyVerses: [
                KeyVerse(verseNumber: 255, arabic: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ", translation: "Allah! Point de divinité à part Lui, le Vivant, Celui qui subsiste par lui-même.", explanation: "Ayat al-Kursi - Le verset le plus grandiose du Coran. Récité avant de dormir, un ange te protège toute la nuit."),
                KeyVerse(verseNumber: 286, arabic: "لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا", translation: "Allah n'impose à aucune âme une charge supérieure à sa capacité.", explanation: "Réconfort divin: Allah ne te teste jamais au-delà de ce que tu peux supporter.")
            ],
            reward: "Protection contre le Shaytan, bénédiction dans la maison"
        ),
        RecommendedSurah(
            id: 36,
            name: "Ya-Sin (Le Cœur du Coran)",
            arabicName: "يس",
            versesCount: 83,
            theme: "Résurrection, unicité d'Allah, signes dans la création",
            whyRead: "Le Prophète (paix sur lui) a dit: 'Ya-Sin est le cœur du Coran.' (Tirmidhi). Sa lecture apporte la sérénité et facilite les épreuves.",
            keyVerses: [
                KeyVerse(verseNumber: 58, arabic: "سَلَامٌ قَوْلًا مِّن رَّبٍّ رَّحِيمٍ", translation: "'Paix!' Parole d'un Seigneur Très Miséricordieux.", explanation: "La salutation d'Allah aux habitants du Paradis. Un verset qui apporte une immense tranquillité."),
                KeyVerse(verseNumber: 82, arabic: "إِنَّمَا أَمْرُهُ إِذَا أَرَادَ شَيْئًا أَن يَقُولَ لَهُ كُن فَيَكُونُ", translation: "Quand Il veut une chose, Son commandement consiste à dire: 'Sois', et c'est.", explanation: "La puissance absolue d'Allah - rien ne Lui est impossible.")
            ],
            reward: "Sérénité, facilitation des épreuves, intercession le Jour du Jugement"
        ),
        RecommendedSurah(
            id: 67,
            name: "Al-Mulk (La Royauté)",
            arabicName: "الملك",
            versesCount: 30,
            theme: "Puissance d'Allah, signes de Sa création, avertissement",
            whyRead: "Le Prophète (paix sur lui) a dit: 'Une sourate du Coran de 30 versets intercèdera pour son lecteur jusqu'à ce qu'il soit pardonné: Tabaraka alladhi biyadihi al-mulk.' (Tirmidhi, Abu Dawud)",
            keyVerses: [
                KeyVerse(verseNumber: 1, arabic: "تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ", translation: "Béni soit celui dans la main de qui est la royauté, et Il est Omnipotent.", explanation: "Ouverture majestueuse rappelant que tout pouvoir appartient à Allah."),
                KeyVerse(verseNumber: 2, arabic: "الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا", translation: "Celui qui a créé la mort et la vie afin de vous éprouver, lequel de vous est le meilleur en œuvre.", explanation: "Le but de la vie: être testé pour montrer nos meilleures actions.")
            ],
            reward: "Protection dans la tombe, intercession le Jour du Jugement"
        )
    ]
}
