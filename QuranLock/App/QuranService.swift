import Foundation
import SwiftUI

// MARK: - Models

struct QuranVerse: Codable, Identifiable {
    let id: Int
    let number: Int
    let arabic: String
    let french: String
    let phonetic: String
}

struct QuranSurah: Codable, Identifiable {
    let id: Int
    let number: Int
    let nameArabic: String
    let nameFrench: String
    let nameTranslit: String
    let verseCount: Int
    let revelationType: String
    var verses: [QuranVerse]
    var isLoaded: Bool
}

// MARK: - API Response Models

private struct AlquranEditionResponse: Codable {
    let code: Int
    let data: AlquranSurahData
}

private struct AlquranSurahData: Codable {
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let revelationType: String
    let ayahs: [AlquranAyah]
}

private struct AlquranAyah: Codable {
    let number: Int
    let numberInSurah: Int
    let text: String
}

// MARK: - QuranService

@MainActor
class QuranService: ObservableObject {

    static let shared = QuranService()

    @Published var surahs: [QuranSurah] = []
    @Published var isLoading = false
    @Published var isDownloading = false
    @Published var downloadProgress: Double = 0
    @Published var downloadMessage = ""
    @Published var isFullyLoaded = false
    @Published var isOffline = false
    @Published var needsDownload = false

    private let cacheFileName = "quran_complete_v3.json"
    private var cacheURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(cacheFileName)
    }

    // All 114 surahs metadata
    let surahsMeta: [(id: Int, arabic: String, french: String, translit: String, verseCount: Int, type: String)] = [
        (1, "الفاتحة", "L'Ouverture", "Al-Fatiha", 7, "Mecquoise"),
        (2, "البقرة", "La Vache", "Al-Baqara", 286, "Médinoise"),
        (3, "آل عمران", "La Famille d'Imran", "Al-Imran", 200, "Médinoise"),
        (4, "النساء", "Les Femmes", "An-Nisa", 176, "Médinoise"),
        (5, "المائدة", "La Table Servie", "Al-Ma'ida", 120, "Médinoise"),
        (6, "الأنعام", "Les Bestiaux", "Al-An'am", 165, "Mecquoise"),
        (7, "الأعراف", "Les Murailles", "Al-A'raf", 206, "Mecquoise"),
        (8, "الأنفال", "Le Butin", "Al-Anfal", 75, "Médinoise"),
        (9, "التوبة", "Le Repentir", "At-Tawba", 129, "Médinoise"),
        (10, "يونس", "Jonas", "Yunus", 109, "Mecquoise"),
        (11, "هود", "Houd", "Hud", 123, "Mecquoise"),
        (12, "يوسف", "Joseph", "Yusuf", 111, "Mecquoise"),
        (13, "الرعد", "Le Tonnerre", "Ar-Ra'd", 43, "Médinoise"),
        (14, "إبراهيم", "Abraham", "Ibrahim", 52, "Mecquoise"),
        (15, "الحجر", "Al-Hijr", "Al-Hijr", 99, "Mecquoise"),
        (16, "النحل", "Les Abeilles", "An-Nahl", 128, "Mecquoise"),
        (17, "الإسراء", "Le Voyage Nocturne", "Al-Isra", 111, "Mecquoise"),
        (18, "الكهف", "La Caverne", "Al-Kahf", 110, "Mecquoise"),
        (19, "مريم", "Marie", "Maryam", 98, "Mecquoise"),
        (20, "طه", "Ta-Ha", "Ta-Ha", 135, "Mecquoise"),
        (21, "الأنبياء", "Les Prophètes", "Al-Anbiya", 112, "Mecquoise"),
        (22, "الحج", "Le Pèlerinage", "Al-Hajj", 78, "Médinoise"),
        (23, "المؤمنون", "Les Croyants", "Al-Mu'minun", 118, "Mecquoise"),
        (24, "النور", "La Lumière", "An-Nur", 64, "Médinoise"),
        (25, "الفرقان", "Le Discernement", "Al-Furqan", 77, "Mecquoise"),
        (26, "الشعراء", "Les Poètes", "Ash-Shu'ara", 227, "Mecquoise"),
        (27, "النمل", "Les Fourmis", "An-Naml", 93, "Mecquoise"),
        (28, "القصص", "Le Récit", "Al-Qasas", 88, "Mecquoise"),
        (29, "العنكبوت", "L'Araignée", "Al-'Ankabut", 69, "Mecquoise"),
        (30, "الروم", "Les Byzantins", "Ar-Rum", 60, "Mecquoise"),
        (31, "لقمان", "Luqman", "Luqman", 34, "Mecquoise"),
        (32, "السجدة", "La Prosternation", "As-Sajda", 30, "Mecquoise"),
        (33, "الأحزاب", "Les Coalisés", "Al-Ahzab", 73, "Médinoise"),
        (34, "سبأ", "Saba", "Saba", 54, "Mecquoise"),
        (35, "فاطر", "Le Créateur", "Fatir", 45, "Mecquoise"),
        (36, "يس", "Ya-Sin", "Ya-Sin", 83, "Mecquoise"),
        (37, "الصافات", "Ceux qui se rangent en rangs", "As-Saffat", 182, "Mecquoise"),
        (38, "ص", "Sad", "Sad", 88, "Mecquoise"),
        (39, "الزمر", "Les Groupes", "Az-Zumar", 75, "Mecquoise"),
        (40, "غافر", "Le Pardonneur", "Ghafir", 85, "Mecquoise"),
        (41, "فصلت", "Exposés en détail", "Fussilat", 54, "Mecquoise"),
        (42, "الشورى", "La Consultation", "Ash-Shura", 53, "Mecquoise"),
        (43, "الزخرف", "Les Ornements", "Az-Zukhruf", 89, "Mecquoise"),
        (44, "الدخان", "La Fumée", "Ad-Dukhan", 59, "Mecquoise"),
        (45, "الجاثية", "L'Agenouillée", "Al-Jathiya", 37, "Mecquoise"),
        (46, "الأحقاف", "Les Dunes", "Al-Ahqaf", 35, "Mecquoise"),
        (47, "محمد", "Muhammad", "Muhammad", 38, "Médinoise"),
        (48, "الفتح", "La Victoire", "Al-Fath", 29, "Médinoise"),
        (49, "الحجرات", "Les Appartements", "Al-Hujurat", 18, "Médinoise"),
        (50, "ق", "Qaf", "Qaf", 45, "Mecquoise"),
        (51, "الذاريات", "Les Vents", "Adh-Dhariyat", 60, "Mecquoise"),
        (52, "الطور", "La Montagne", "At-Tur", 49, "Mecquoise"),
        (53, "النجم", "L'Étoile", "An-Najm", 62, "Mecquoise"),
        (54, "القمر", "La Lune", "Al-Qamar", 55, "Mecquoise"),
        (55, "الرحمن", "Le Tout Miséricordieux", "Ar-Rahman", 78, "Médinoise"),
        (56, "الواقعة", "L'Évènement", "Al-Waqi'a", 96, "Mecquoise"),
        (57, "الحديد", "Le Fer", "Al-Hadid", 29, "Médinoise"),
        (58, "المجادلة", "La Discussion", "Al-Mujadila", 22, "Médinoise"),
        (59, "الحشر", "L'Exode", "Al-Hashr", 24, "Médinoise"),
        (60, "الممتحنة", "L'Éprouvée", "Al-Mumtahana", 13, "Médinoise"),
        (61, "الصف", "Le Rang", "As-Saf", 14, "Médinoise"),
        (62, "الجمعة", "Le Vendredi", "Al-Jumu'a", 11, "Médinoise"),
        (63, "المنافقون", "Les Hypocrites", "Al-Munafiqun", 11, "Médinoise"),
        (64, "التغابن", "La Déception mutuelle", "At-Taghabun", 18, "Médinoise"),
        (65, "الطلاق", "Le Divorce", "At-Talaq", 12, "Médinoise"),
        (66, "التحريم", "L'Interdiction", "At-Tahrim", 12, "Médinoise"),
        (67, "الملك", "La Royauté", "Al-Mulk", 30, "Mecquoise"),
        (68, "القلم", "La Plume", "Al-Qalam", 52, "Mecquoise"),
        (69, "الحاقة", "L'Inévitable", "Al-Haqqa", 52, "Mecquoise"),
        (70, "المعارج", "Les Voies d'Ascension", "Al-Ma'arij", 44, "Mecquoise"),
        (71, "نوح", "Noé", "Nuh", 28, "Mecquoise"),
        (72, "الجن", "Les Djinns", "Al-Jinn", 28, "Mecquoise"),
        (73, "المزمل", "L'Enveloppé", "Al-Muzzammil", 20, "Mecquoise"),
        (74, "المدثر", "Le Revêtu d'un manteau", "Al-Muddaththir", 56, "Mecquoise"),
        (75, "القيامة", "La Résurrection", "Al-Qiyama", 40, "Mecquoise"),
        (76, "الإنسان", "L'Homme", "Al-Insan", 31, "Médinoise"),
        (77, "المرسلات", "Les Envoyés", "Al-Mursalat", 50, "Mecquoise"),
        (78, "النبأ", "La Nouvelle", "An-Naba", 40, "Mecquoise"),
        (79, "النازعات", "Ceux qui arrachent", "An-Nazi'at", 46, "Mecquoise"),
        (80, "عبس", "Il s'est renfrogné", "Abasa", 42, "Mecquoise"),
        (81, "التكوير", "L'Enroulement", "At-Takwir", 29, "Mecquoise"),
        (82, "الانفطار", "Le Déchirement", "Al-Infitar", 19, "Mecquoise"),
        (83, "المطففين", "Les Fraudeurs", "Al-Mutaffifin", 36, "Mecquoise"),
        (84, "الانشقاق", "La Fissuration", "Al-Inshiqaq", 25, "Mecquoise"),
        (85, "البروج", "Les Constellations", "Al-Buruj", 22, "Mecquoise"),
        (86, "الطارق", "L'Astre Nocturne", "At-Tariq", 17, "Mecquoise"),
        (87, "الأعلى", "Le Très Haut", "Al-A'la", 19, "Mecquoise"),
        (88, "الغاشية", "L'Enveloppante", "Al-Ghashiya", 26, "Mecquoise"),
        (89, "الفجر", "L'Aube", "Al-Fajr", 30, "Mecquoise"),
        (90, "البلد", "La Cité", "Al-Balad", 20, "Mecquoise"),
        (91, "الشمس", "Le Soleil", "Ash-Shams", 15, "Mecquoise"),
        (92, "الليل", "La Nuit", "Al-Layl", 21, "Mecquoise"),
        (93, "الضحى", "La Matinée", "Ad-Duha", 11, "Mecquoise"),
        (94, "الشرح", "L'Élargissement", "Ash-Sharh", 8, "Mecquoise"),
        (95, "التين", "Le Figuier", "At-Tin", 8, "Mecquoise"),
        (96, "العلق", "L'Adhérence", "Al-Alaq", 19, "Mecquoise"),
        (97, "القدر", "La Nuit du Destin", "Al-Qadr", 5, "Mecquoise"),
        (98, "البينة", "La Preuve", "Al-Bayyina", 8, "Médinoise"),
        (99, "الزلزلة", "Le Séisme", "Az-Zalzala", 8, "Médinoise"),
        (100, "العاديات", "Ceux qui courent", "Al-Adiyat", 11, "Mecquoise"),
        (101, "القارعة", "L'Assommeuse", "Al-Qari'a", 11, "Mecquoise"),
        (102, "التكاثر", "La Course aux richesses", "At-Takathur", 8, "Mecquoise"),
        (103, "العصر", "Le Temps", "Al-Asr", 3, "Mecquoise"),
        (104, "الهمزة", "Le Calomniateur", "Al-Humaza", 9, "Mecquoise"),
        (105, "الفيل", "L'Éléphant", "Al-Fil", 5, "Mecquoise"),
        (106, "قريش", "Quraysh", "Quraysh", 4, "Mecquoise"),
        (107, "الماعون", "L'Ustensile", "Al-Ma'un", 7, "Mecquoise"),
        (108, "الكوثر", "L'Abondance", "Al-Kawthar", 3, "Mecquoise"),
        (109, "الكافرون", "Les Infidèles", "Al-Kafirun", 6, "Mecquoise"),
        (110, "النصر", "Le Secours", "An-Nasr", 3, "Médinoise"),
        (111, "المسد", "Les Fibres", "Al-Masad", 5, "Mecquoise"),
        (112, "الإخلاص", "Le Monothéisme Pur", "Al-Ikhlas", 4, "Mecquoise"),
        (113, "الفلق", "L'Aube Naissante", "Al-Falaq", 5, "Mecquoise"),
        (114, "الناس", "Les Hommes", "An-Nas", 6, "Mecquoise")
    ]

    init() {
        self.surahs = surahsMeta.map { meta in
            QuranSurah(
                id: meta.id,
                number: meta.id,
                nameArabic: meta.arabic,
                nameFrench: meta.french,
                nameTranslit: meta.translit,
                verseCount: meta.verseCount,
                revelationType: meta.type,
                verses: [],
                isLoaded: false
            )
        }
    }

    // MARK: - Load (called on app launch)

    func loadQuran() async {
        if let cached = loadFromCache() {
            let loadedCount = cached.filter { $0.isLoaded }.count
            for cachedSurah in cached {
                if let idx = surahs.firstIndex(where: { $0.id == cachedSurah.id }) {
                    surahs[idx].verses = cachedSurah.verses
                    surahs[idx].isLoaded = cachedSurah.isLoaded
                }
            }
            isFullyLoaded = loadedCount >= 107
            needsDownload = loadedCount < 10
        } else {
            needsDownload = true
        }
    }

    // MARK: - Download All 114 Surahs

    func downloadFullQuran() async {
        isDownloading = true
        downloadProgress = 0
        downloadMessage = "Téléchargement du Coran complet..."

        var allLoaded: [Int: [QuranVerse]] = [:]

        for (i, surah) in surahs.enumerated() {
            downloadMessage = "Sourate \(i + 1)/114 — \(surah.nameFrench)"
            do {
                let verses = try await fetchSurahVerses(surahId: surah.id)
                allLoaded[surah.id] = verses
                surahs[i].verses = verses
                surahs[i].isLoaded = true
                downloadProgress = Double(i + 1) / 114.0
            } catch {
                // Skip and continue - will retry next time
            }
        }

        saveFullCache(allLoaded)
        isDownloading = false
        isFullyLoaded = allLoaded.count >= 100
        needsDownload = false
        downloadMessage = "Coran téléchargé ✓"
    }

    // MARK: - Load Single Surah

    func loadSurah(_ surahId: Int) async {
        guard let idx = surahs.firstIndex(where: { $0.id == surahId }),
              !surahs[idx].isLoaded else { return }

        isLoading = true
        do {
            let verses = try await fetchSurahVerses(surahId: surahId)
            surahs[idx].verses = verses
            surahs[idx].isLoaded = true
            saveSurahToCache(surahId: surahId, verses: verses)
            isOffline = false
        } catch {
            isOffline = true
        }
        isLoading = false
    }

    // MARK: - API Fetch

    private func fetchSurahVerses(surahId: Int) async throws -> [QuranVerse] {
        async let arabicData = fetchEdition(surahId: surahId, edition: "quran-uthmani")
        async let frenchData = fetchEdition(surahId: surahId, edition: "fr.hamidullah")
        async let phoneticData = fetchEdition(surahId: surahId, edition: "en.transliteration")

        let (arabic, french, phonetic) = try await (arabicData, frenchData, phoneticData)

        return zip(zip(arabic.data.ayahs, french.data.ayahs), phonetic.data.ayahs).map { pair in
            let ((arabicAyah, frenchAyah), phoneticAyah) = pair
            return QuranVerse(
                id: arabicAyah.numberInSurah,
                number: arabicAyah.numberInSurah,
                arabic: arabicAyah.text,
                french: frenchAyah.text,
                phonetic: phoneticAyah.text
            )
        }
    }

    private func fetchEdition(surahId: Int, edition: String) async throws -> AlquranEditionResponse {
        let url = URL(string: "https://api.alquran.cloud/v1/surah/\(surahId)/\(edition)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(AlquranEditionResponse.self, from: data)
    }

    // MARK: - Cache

    private func loadFromCache() -> [QuranSurah]? {
        guard FileManager.default.fileExists(atPath: cacheURL.path),
              let data = try? Data(contentsOf: cacheURL),
              let cached = try? JSONDecoder().decode([QuranSurah].self, from: data) else { return nil }
        return cached
    }

    private func saveFullCache(_ allVerses: [Int: [QuranVerse]]) {
        var toSave = surahs
        for (id, verses) in allVerses {
            if let idx = toSave.firstIndex(where: { $0.id == id }) {
                toSave[idx].verses = verses
                toSave[idx].isLoaded = true
            }
        }
        if let data = try? JSONEncoder().encode(toSave) {
            try? data.write(to: cacheURL)
        }
    }

    private func saveSurahToCache(surahId: Int, verses: [QuranVerse]) {
        var cached = loadFromCache() ?? surahs
        if let idx = cached.firstIndex(where: { $0.id == surahId }) {
            cached[idx].verses = verses
            cached[idx].isLoaded = true
        }
        if let data = try? JSONEncoder().encode(cached) {
            try? data.write(to: cacheURL)
        }
    }

    // MARK: - Clear Cache (for debug)
    func clearCache() {
        try? FileManager.default.removeItem(at: cacheURL)
        needsDownload = true
        isFullyLoaded = false
        for i in surahs.indices {
            surahs[i].verses = []
            surahs[i].isLoaded = false
        }
    }
}
