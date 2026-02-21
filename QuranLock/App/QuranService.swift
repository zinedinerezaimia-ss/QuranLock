import Foundation
import Combine

struct QuranVerse: Identifiable, Codable {
    let id: Int
    let arabic: String
    let french: String
    let phonetic: String
}

struct QuranSurah: Identifiable, Codable {
    let id: Int
    let nameArabic: String
    let nameFrench: String
    let nameTranslit: String
    let revelationType: String
    let verseCount: Int
    let verses: [QuranVerse]
    var isLoaded: Bool { true }
}

class QuranService: ObservableObject {
    static let shared = QuranService()
    
    @Published var surahs: [QuranSurah] = []
    @Published var isLoading = false
    @Published var isFullyLoaded = false
    @Published var downloadProgress: Double = 0
    @Published var isDownloading = false

    init() {
        loadFromBundle()
    }

    func loadFromBundle() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = Bundle.main.url(forResource: "quran_complete", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let surahs = try? JSONDecoder().decode([QuranSurah].self, from: data) else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            DispatchQueue.main.async {
                self.surahs = surahs
                self.isFullyLoaded = true
                self.isLoading = false
                self.downloadProgress = 1.0
            }
        }
    }

    func downloadAllSurahs() {
        // Plus nécessaire - tout est dans le bundle
        isFullyLoaded = true
        downloadProgress = 1.0
    }
}
