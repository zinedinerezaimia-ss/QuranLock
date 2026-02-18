import SwiftUI

struct ArabicCourse: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let level: CourseLevel
    let duration: String
    let lessons: [ArabicLesson]
    var completedLessons: Int = 0
    
    var progress: Double {
        guard !lessons.isEmpty else { return 0 }
        return Double(completedLessons) / Double(lessons.count)
    }
    
    enum CourseLevel: String {
        case debutant = "Débutant"
        case intermediaire = "Intermédiaire"
        case avance = "Avancé"
    }
}

struct ArabicLesson: Identifiable {
    let id: String
    let title: String
    let content: [LessonContent]
    let revisionCards: [RevisionCard]
    let quizQuestions: [LessonQuiz]
    var isCompleted: Bool = false
}

struct LessonContent: Identifiable {
    let id = UUID().uuidString
    let type: ContentType
    let title: String
    let arabicText: String
    let transliteration: String
    let translation: String
    let explanation: String
    
    enum ContentType {
        case letter, vowel, word, rule, verse
    }
}

struct RevisionCard: Identifiable {
    let id = UUID().uuidString
    let front: String       // Arabic
    let frontSub: String    // Transliteration
    let back: String        // Translation/Explanation
    let category: String
}

struct LessonQuiz: Identifiable {
    let id = UUID().uuidString
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

enum LearningRhythm: String, CaseIterable {
    case relaxed = "Détendu"
    case regular = "Régulier"
    case intensive = "Intensif"
    
    var description: String {
        switch self {
        case .relaxed: return "15 min/jour • 2-3 leçons/semaine"
        case .regular: return "30 min/jour • 1 leçon/jour"
        case .intensive: return "1h/jour • 2 leçons/jour"
        }
    }
    
    var icon: String {
        switch self {
        case .relaxed: return "🌱"
        case .regular: return "📚"
        case .intensive: return "🚀"
        }
    }
    
    var lessonsPerWeek: Int {
        switch self {
        case .relaxed: return 3
        case .regular: return 7
        case .intensive: return 14
        }
    }
}

class ArabicCourseManager: ObservableObject {
    @Published var selectedRhythm: LearningRhythm?
    @Published var courses: [ArabicCourse] = []
    @Published var overallProgress: Double = 0
    @AppStorage("arabicLearningRhythm") var savedRhythm: String = ""
    @AppStorage("completedArabicLessons") var completedLessonsData: String = "[]"
    
    init() {
        if !savedRhythm.isEmpty {
            selectedRhythm = LearningRhythm(rawValue: savedRhythm)
        }
        loadCourses()
    }
    
    var completedLessonIds: [String] {
        get {
            guard let data = completedLessonsData.data(using: .utf8),
                  let ids = try? JSONDecoder().decode([String].self, from: data) else { return [] }
            return ids
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                completedLessonsData = string
            }
        }
    }
    
    func selectRhythm(_ rhythm: LearningRhythm) {
        selectedRhythm = rhythm
        savedRhythm = rhythm.rawValue
    }
    
    func completeLesson(_ lessonId: String) {
        var ids = completedLessonIds
        if !ids.contains(lessonId) {
            ids.append(lessonId)
            completedLessonIds = ids
            updateProgress()
        }
    }
    
    func isLessonCompleted(_ lessonId: String) -> Bool {
        completedLessonIds.contains(lessonId)
    }
    
    func updateProgress() {
        let totalLessons = courses.reduce(0) { $0 + $1.lessons.count }
        guard totalLessons > 0 else { return }
        overallProgress = Double(completedLessonIds.count) / Double(totalLessons)
    }
    
    func loadCourses() {
        courses = [
            ArabicCourse(
                id: "alphabet",
                title: "L'Alphabet Arabe",
                description: "Maîtrisez les 28 lettres de l'alphabet arabe",
                icon: "abc",
                level: .debutant,
                duration: "2 semaines",
                lessons: [
                    ArabicLesson(
                        id: "alph_1",
                        title: "Les premières lettres : أ ب ت ث",
                        content: [
                            LessonContent(type: .letter, title: "Alif", arabicText: "أ", transliteration: "a", translation: "Première lettre", explanation: "L'Alif est la première lettre de l'alphabet arabe. C'est une lettre verticale qui peut porter différentes voyelles. Elle sert souvent de support pour la hamza."),
                            LessonContent(type: .letter, title: "Ba", arabicText: "ب", transliteration: "b", translation: "Deuxième lettre", explanation: "Le Ba se prononce comme le 'b' français. Il a un point en dessous. En début de mot, il s'attache à la lettre suivante."),
                            LessonContent(type: .letter, title: "Ta", arabicText: "ت", transliteration: "t", translation: "Troisième lettre", explanation: "Le Ta se prononce comme le 't' français. Il a deux points au-dessus. Sa forme ressemble au Ba mais avec les points en haut."),
                            LessonContent(type: .letter, title: "Tha", arabicText: "ث", transliteration: "th", translation: "Quatrième lettre", explanation: "Le Tha se prononce comme le 'th' anglais dans 'think'. Il a trois points au-dessus.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "أ", frontSub: "Alif", back: "Première lettre de l'alphabet. Se prononce 'a'. Support de voyelles.", category: "Lettres"),
                            RevisionCard(front: "ب", frontSub: "Ba", back: "Se prononce 'b'. Un point en dessous.", category: "Lettres"),
                            RevisionCard(front: "ت", frontSub: "Ta", back: "Se prononce 't'. Deux points au-dessus.", category: "Lettres"),
                            RevisionCard(front: "ث", frontSub: "Tha", back: "Se prononce 'th' (comme think). Trois points au-dessus.", category: "Lettres")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Quelle lettre a un point en dessous ?", options: ["أ", "ب", "ت", "ث"], correctIndex: 1, explanation: "Le Ba (ب) a un seul point en dessous."),
                            LessonQuiz(question: "Comment se prononce ث ?", options: ["b", "t", "th", "a"], correctIndex: 2, explanation: "Le Tha (ث) se prononce comme le 'th' anglais dans 'think'."),
                            LessonQuiz(question: "Combien de points a la lettre ت ?", options: ["0", "1", "2", "3"], correctIndex: 2, explanation: "Le Ta (ت) a deux points au-dessus.")
                        ]
                    ),
                    ArabicLesson(
                        id: "alph_2",
                        title: "Les lettres : ج ح خ",
                        content: [
                            LessonContent(type: .letter, title: "Jim", arabicText: "ج", transliteration: "j", translation: "Cinquième lettre", explanation: "Le Jim se prononce comme le 'j' français. Il a un point au milieu de sa courbe."),
                            LessonContent(type: .letter, title: "Ha", arabicText: "ح", transliteration: "ḥ", translation: "Sixième lettre", explanation: "Le Ha est un son guttural qui n'existe pas en français. C'est un 'h' aspiré profond venant de la gorge."),
                            LessonContent(type: .letter, title: "Kha", arabicText: "خ", transliteration: "kh", translation: "Septième lettre", explanation: "Le Kha se prononce comme la 'jota' espagnole ou le 'ch' allemand dans 'Bach'. Il a un point au-dessus.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "ج", frontSub: "Jim", back: "Se prononce 'j'. Un point au milieu.", category: "Lettres"),
                            RevisionCard(front: "ح", frontSub: "Ha", back: "Son guttural, H aspiré profond. Pas de point.", category: "Lettres"),
                            RevisionCard(front: "خ", frontSub: "Kha", back: "Se prononce 'kh'. Un point au-dessus.", category: "Lettres")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Quelle lettre n'a pas de point ?", options: ["ج", "ح", "خ"], correctIndex: 1, explanation: "Le Ha (ح) n'a pas de point."),
                            LessonQuiz(question: "Comment se prononce خ ?", options: ["j", "h", "kh", "d"], correctIndex: 2, explanation: "Le Kha (خ) se prononce 'kh' comme la jota espagnole.")
                        ]
                    )
                ]
            ),
            ArabicCourse(
                id: "vowels",
                title: "Les Voyelles (Harakat)",
                description: "Apprenez les voyelles courtes et longues",
                icon: "🔤",
                level: .debutant,
                duration: "1 semaine",
                lessons: [
                    ArabicLesson(
                        id: "vow_1",
                        title: "Les voyelles courtes : Fatha, Kasra, Damma",
                        content: [
                            LessonContent(type: .vowel, title: "Fatha", arabicText: "بَ", transliteration: "ba", translation: "Voyelle 'a'", explanation: "La Fatha est un petit trait diagonal placé AU-DESSUS de la lettre. Elle donne le son 'a'. Exemple : بَ = ba"),
                            LessonContent(type: .vowel, title: "Kasra", arabicText: "بِ", transliteration: "bi", translation: "Voyelle 'i'", explanation: "La Kasra est un petit trait diagonal placé EN-DESSOUS de la lettre. Elle donne le son 'i'. Exemple : بِ = bi"),
                            LessonContent(type: .vowel, title: "Damma", arabicText: "بُ", transliteration: "bu", translation: "Voyelle 'ou'", explanation: "La Damma est un petit و miniature placé AU-DESSUS de la lettre. Elle donne le son 'ou'. Exemple : بُ = bu")
                        ],
                        revisionCards: [
                            RevisionCard(front: "بَ", frontSub: "Fatha", back: "Son 'a' — trait au-dessus", category: "Voyelles"),
                            RevisionCard(front: "بِ", frontSub: "Kasra", back: "Son 'i' — trait en-dessous", category: "Voyelles"),
                            RevisionCard(front: "بُ", frontSub: "Damma", back: "Son 'ou' — petit waw au-dessus", category: "Voyelles")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Quel son produit la Fatha ?", options: ["i", "a", "ou", "an"], correctIndex: 1, explanation: "La Fatha produit le son 'a'."),
                            LessonQuiz(question: "Où se place la Kasra ?", options: ["Au-dessus", "En-dessous", "À côté", "Devant"], correctIndex: 1, explanation: "La Kasra se place en-dessous de la lettre.")
                        ]
                    )
                ]
            ),
            ArabicCourse(
                id: "reading",
                title: "Lecture Coranique",
                description: "Apprenez à lire le Coran avec les règles de base du Tajwid",
                icon: "📖",
                level: .debutant,
                duration: "4 semaines",
                lessons: [
                    ArabicLesson(
                        id: "read_1",
                        title: "Introduction au Tajwid",
                        content: [
                            LessonContent(type: .rule, title: "Qu'est-ce que le Tajwid ?", arabicText: "تَجْوِيد", transliteration: "Tajwīd", translation: "Embellissement", explanation: "Le Tajwid signifie littéralement 'embellissement'. C'est l'art de réciter le Coran correctement en respectant les règles de prononciation. C'est une obligation pour tout musulman qui lit le Coran."),
                            LessonContent(type: .rule, title: "Les points d'articulation (Makharij)", arabicText: "مَخَارِج الحُرُوف", transliteration: "Makhārij al-Ḥurūf", translation: "Points d'articulation des lettres", explanation: "Chaque lettre arabe a un point de sortie spécifique dans la bouche, la gorge ou le nez. Maîtriser ces points est essentiel pour une récitation correcte.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "تَجْوِيد", frontSub: "Tajwīd", back: "Art de réciter le Coran correctement. Obligation pour tout lecteur du Coran.", category: "Tajwid"),
                            RevisionCard(front: "مَخَارِج", frontSub: "Makhārij", back: "Points d'articulation des lettres arabes.", category: "Tajwid")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Que signifie Tajwid ?", options: ["Rapidité", "Embellissement", "Mémorisation", "Traduction"], correctIndex: 1, explanation: "Tajwid signifie 'embellissement' de la récitation.")
                        ]
                    )
                ]
            ),
            ArabicCourse(
                id: "vocabulary",
                title: "Vocabulaire Islamique",
                description: "Les mots essentiels pour comprendre l'Islam",
                icon: "📗",
                level: .debutant,
                duration: "3 semaines",
                lessons: [
                    ArabicLesson(
                        id: "vocab_1",
                        title: "Les mots fondamentaux",
                        content: [
                            LessonContent(type: .word, title: "Allah", arabicText: "الله", transliteration: "Allāh", translation: "Dieu", explanation: "Le nom propre de Dieu en arabe. Utilisé par les musulmans, les chrétiens arabes et les juifs arabophones."),
                            LessonContent(type: .word, title: "Islam", arabicText: "إِسْلَام", transliteration: "Islām", translation: "Soumission à Dieu", explanation: "Vient de la racine S-L-M qui signifie paix et soumission. L'Islam est la soumission volontaire à la volonté de Dieu."),
                            LessonContent(type: .word, title: "Salaam", arabicText: "سَلَام", transliteration: "Salām", translation: "Paix", explanation: "De la même racine que Islam. Le salut islamique 'As-Salamu Alaykum' signifie 'Que la paix soit sur vous'."),
                            LessonContent(type: .word, title: "Iman", arabicText: "إِيمَان", transliteration: "Īmān", translation: "Foi", explanation: "La foi intérieure du croyant. Comprend la croyance en Allah, Ses anges, Ses livres, Ses messagers, le Jour dernier et le destin.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "الله", frontSub: "Allāh", back: "Dieu — Le nom propre de Dieu", category: "Fondamentaux"),
                            RevisionCard(front: "إِسْلَام", frontSub: "Islām", back: "Soumission volontaire à Dieu", category: "Fondamentaux"),
                            RevisionCard(front: "سَلَام", frontSub: "Salām", back: "Paix", category: "Fondamentaux"),
                            RevisionCard(front: "إِيمَان", frontSub: "Īmān", back: "Foi intérieure du croyant", category: "Fondamentaux")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Que signifie إِسْلَام ?", options: ["Paix", "Foi", "Soumission à Dieu", "Prière"], correctIndex: 2, explanation: "Islam signifie soumission volontaire à la volonté de Dieu."),
                            LessonQuiz(question: "Quelle racine partagent Islam et Salaam ?", options: ["S-L-M", "A-L-H", "I-M-N", "Q-R-A"], correctIndex: 0, explanation: "Islam et Salaam partagent la racine S-L-M (paix/soumission).")
                        ]
                    )
                ]
            ),
            ArabicCourse(
                id: "grammar",
                title: "Grammaire Arabe",
                description: "Introduction à la grammaire arabe (Nahw)",
                icon: "✏️",
                level: .intermediaire,
                duration: "6 semaines",
                lessons: [
                    ArabicLesson(
                        id: "gram_1",
                        title: "La phrase nominale (Al-Jumla Al-Ismiyya)",
                        content: [
                            LessonContent(type: .rule, title: "Structure de base", arabicText: "الجُمْلَة الاسْمِيَّة", transliteration: "Al-Jumla Al-Ismiyya", translation: "Phrase nominale", explanation: "En arabe, la phrase nominale commence par un nom (Mubtada') suivi d'un attribut (Khabar). Exemple : الكِتَابُ جَمِيلٌ (Le livre est beau)."),
                            LessonContent(type: .rule, title: "Le Mubtada' (Sujet)", arabicText: "المُبْتَدَأ", transliteration: "Al-Mubtada'", translation: "Le sujet", explanation: "C'est le premier élément de la phrase nominale. Il est toujours au cas nominatif (marfou')."),
                            LessonContent(type: .rule, title: "Le Khabar (Attribut)", arabicText: "الخَبَر", transliteration: "Al-Khabar", translation: "L'attribut/prédicat", explanation: "C'est ce qu'on dit à propos du sujet. Il est aussi au cas nominatif.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "المُبْتَدَأ", frontSub: "Al-Mubtada'", back: "Le sujet de la phrase nominale. Toujours au cas nominatif.", category: "Grammaire"),
                            RevisionCard(front: "الخَبَر", frontSub: "Al-Khabar", back: "L'attribut/prédicat. Ce qu'on dit du sujet.", category: "Grammaire")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Par quoi commence une phrase nominale ?", options: ["Un verbe", "Un nom", "Une préposition", "Un adverbe"], correctIndex: 1, explanation: "La phrase nominale (Jumla Ismiyya) commence toujours par un nom (Mubtada').")
                        ]
                    )
                ]
            )
        ]
        updateProgress()
    }
}
