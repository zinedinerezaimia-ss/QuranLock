import SwiftUI

// MARK: - Models

struct ArabicCourse: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let moduleNumber: Int
    let lessons: [ArabicLesson]

    var progress: Double {
        guard !lessons.isEmpty else { return 0 }
        return Double(lessons.filter { $0.isCompleted }.count) / Double(lessons.count)
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
        case letter, vowel, word, rule, verse, dialogue, pronunciation
    }
}

struct RevisionCard: Identifiable {
    let id = UUID().uuidString
    let front: String
    let frontSub: String
    let back: String
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

// MARK: - Placement Test Questions
struct PlacementQuestion: Identifiable {
    let id = UUID().uuidString
    let question: String
    let options: [String]
    let correctIndex: Int
    let points: Int // 1 = basique, 2 = intermédiaire, 3 = avancé
}

// MARK: - Manager

class ArabicCourseManager: ObservableObject {
    @Published var selectedRhythm: LearningRhythm?
    @Published var courses: [ArabicCourse] = []
    @Published var overallProgress: Double = 0
    @Published var hasCompletedPlacementTest: Bool = false
    @Published var recommendedModule: Int = 1
    @Published var showDailyQuiz: Bool = false
    @Published var dailyQuizQuestions: [LessonQuiz] = []

    @AppStorage("arabicLearningRhythm") var savedRhythm: String = ""
    @AppStorage("completedArabicLessons") var completedLessonsData: String = "[]"
    @AppStorage("arabicPlacementDone") var placementDone: Bool = false
    @AppStorage("arabicRecommendedModule") var savedRecommendedModule: Int = 1
    @AppStorage("arabicLastQuizDate") var lastQuizDate: String = ""

    init() {
        if !savedRhythm.isEmpty {
            selectedRhythm = LearningRhythm(rawValue: savedRhythm)
        }
        hasCompletedPlacementTest = placementDone
        recommendedModule = savedRecommendedModule
        loadCourses()
        checkDailyQuiz()
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

    // Vérifie si une leçon est accessible (la précédente doit être complétée)
    func isLessonUnlocked(_ lesson: ArabicLesson, in course: ArabicCourse) -> Bool {
        guard let idx = course.lessons.firstIndex(where: { $0.id == lesson.id }) else { return false }
        if idx == 0 {
            // Première leçon du cours : vérifier que le module précédent est complété
            return isModuleUnlocked(course.moduleNumber)
        }
        let previous = course.lessons[idx - 1]
        return isLessonCompleted(previous.id)
    }

    func isModuleUnlocked(_ moduleNumber: Int) -> Bool {
        if moduleNumber == 1 { return true }
        // Le module N est débloqué si le module N-1 est entièrement complété
        let previousModule = courses.first { $0.moduleNumber == moduleNumber - 1 }
        guard let prev = previousModule else { return false }
        return prev.lessons.allSatisfy { isLessonCompleted($0.id) }
    }

    func completePlacementTest(score: Int, total: Int) {
        let percent = Double(score) / Double(total)
        if percent < 0.3 {
            recommendedModule = 1
        } else if percent < 0.6 {
            recommendedModule = 2
        } else if percent < 0.85 {
            recommendedModule = 3
        } else {
            recommendedModule = 4
        }
        savedRecommendedModule = recommendedModule
        hasCompletedPlacementTest = true
        placementDone = true
    }

    func checkDailyQuiz() {
        let today = ArabicCourseManager.dateString(from: Date())
        guard lastQuizDate != today else { return }
        // Collecter des questions des leçons complétées
        let completedIds = completedLessonIds
        var questions: [LessonQuiz] = []
        for course in courses {
            for lesson in course.lessons where completedIds.contains(lesson.id) {
                questions.append(contentsOf: lesson.quizQuestions)
            }
        }
        if !questions.isEmpty {
            dailyQuizQuestions = Array(questions.shuffled().prefix(5))
            showDailyQuiz = true
        }
    }

    func completeDailyQuiz() {
        lastQuizDate = ArabicCourseManager.dateString(from: Date())
        showDailyQuiz = false
    }

    static func dateString(from date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; return f.string(from: date)
    }

    func updateProgress() {
        let totalLessons = courses.reduce(0) { $0 + $1.lessons.count }
        guard totalLessons > 0 else { return }
        overallProgress = Double(completedLessonIds.count) / Double(totalLessons)
    }

    // MARK: - Placement Test Data
    static let placementQuestions: [PlacementQuestion] = [
        PlacementQuestion(question: "Quelle est cette lettre ? أ", options: ["Ba", "Alif", "Ta", "Jim"], correctIndex: 1, points: 1),
        PlacementQuestion(question: "Quelle est cette lettre ? ب", options: ["Alif", "Nun", "Ba", "Ya"], correctIndex: 2, points: 1),
        PlacementQuestion(question: "Que signifie بِسْمِ اللَّهِ ?", options: ["Louange à Allah", "Au nom d'Allah", "Allah est grand", "Paix sur toi"], correctIndex: 1, points: 1),
        PlacementQuestion(question: "Que signifie الْحَمْدُ لِلَّهِ ?", options: ["Au nom d'Allah", "Il n'y a qu'un Dieu", "Louange à Allah", "Seigneur des mondes"], correctIndex: 2, points: 1),
        PlacementQuestion(question: "Comment se prononce بَ ?", options: ["bi", "ba", "bu", "b"], correctIndex: 1, points: 2),
        PlacementQuestion(question: "La Fatha donne quel son ?", options: ["i", "ou", "a", "an"], correctIndex: 2, points: 2),
        PlacementQuestion(question: "Que signifie كِتَاب ?", options: ["Maison", "Livre", "École", "Mosquée"], correctIndex: 1, points: 2),
        PlacementQuestion(question: "Combien de lettres dans l'alphabet arabe ?", options: ["26", "28", "30", "22"], correctIndex: 1, points: 2),
        PlacementQuestion(question: "Que signifie الله أَكْبَرُ ?", options: ["Allah pardonne", "Allah guide", "Allah est le Plus Grand", "Allah est Unique"], correctIndex: 2, points: 3),
        PlacementQuestion(question: "Quelle racine donne Islam et Salam ?", options: ["A-L-H", "S-L-M", "Q-R-A", "K-T-B"], correctIndex: 1, points: 3)
    ]

    // MARK: - Load Courses (5 modules)
    func loadCourses() {
        courses = [
            // =====================
            // MODULE 1 — L'écriture
            // =====================
            ArabicCourse(
                id: "module1",
                title: "Module 1 — L'écriture",
                description: "Les lettres, leur forme et comment les écrire",
                icon: "✏️",
                moduleNumber: 1,
                lessons: [
                    ArabicLesson(id: "m1_l1", title: "Les lettres أ ب ت ث",
                        content: [
                            LessonContent(type: .letter, title: "Alif — أ", arabicText: "أ", transliteration: "a", translation: "Première lettre", explanation: "L'Alif est la 1ère lettre. Forme verticale. Elle ne se connecte pas à la lettre suivante. Elle peut porter une hamza."),
                            LessonContent(type: .letter, title: "Ba — ب", arabicText: "ب ﺑ ﺐ", transliteration: "b", translation: "Deuxième lettre", explanation: "Ba se prononce comme 'b'. 1 point en dessous. Formes : isolée ب • début ﺑ • milieu ﺒ • fin ﺐ"),
                            LessonContent(type: .letter, title: "Ta — ت", arabicText: "ت ﺗ ﺖ", transliteration: "t", translation: "Troisième lettre", explanation: "Ta se prononce comme 't'. 2 points au-dessus. Même forme que Ba mais points en haut."),
                            LessonContent(type: .letter, title: "Tha — ث", arabicText: "ث ﺛ ﺚ", transliteration: "th", translation: "Quatrième lettre", explanation: "Tha se prononce comme 'th' anglais (think). 3 points au-dessus.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "أ", frontSub: "Alif", back: "Son 'a' — ne se connecte pas — 1ère lettre", category: "Lettres"),
                            RevisionCard(front: "ب", frontSub: "Ba", back: "Son 'b' — 1 point en dessous", category: "Lettres"),
                            RevisionCard(front: "ت", frontSub: "Ta", back: "Son 't' — 2 points au-dessus", category: "Lettres"),
                            RevisionCard(front: "ث", frontSub: "Tha", back: "Son 'th' (think) — 3 points au-dessus", category: "Lettres")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Quelle lettre a UN point en dessous ?", options: ["أ", "ب", "ت", "ث"], correctIndex: 1, explanation: "Ba (ب) a un seul point en dessous."),
                            LessonQuiz(question: "Comment se prononce ث ?", options: ["b", "t", "th", "a"], correctIndex: 2, explanation: "Tha (ث) se prononce 'th' comme dans 'think'."),
                            LessonQuiz(question: "Combien de points a ت ?", options: ["0", "1", "2", "3"], correctIndex: 2, explanation: "Ta (ت) a 2 points au-dessus.")
                        ]
                    ),
                    ArabicLesson(id: "m1_l2", title: "Les lettres ج ح خ",
                        content: [
                            LessonContent(type: .letter, title: "Jim — ج", arabicText: "ج ﺟ ﺞ", transliteration: "j", translation: "5ème lettre", explanation: "Jim se prononce 'j'. 1 point au milieu de sa courbe."),
                            LessonContent(type: .letter, title: "Ha — ح", arabicText: "ح ﺣ ﺢ", transliteration: "ḥ", translation: "6ème lettre", explanation: "Ha guttural — son profond de la gorge. Pas de point. Ne pas confondre avec خ et ج."),
                            LessonContent(type: .letter, title: "Kha — خ", arabicText: "خ ﺧ ﺦ", transliteration: "kh", translation: "7ème lettre", explanation: "Kha se prononce 'kh' comme la jota espagnole. 1 point AU-DESSUS de ح.\n\n⚠️ Prononciation : Ces 3 lettres (ج ح خ) ont la même forme de base, seuls les points changent !")
                        ],
                        revisionCards: [
                            RevisionCard(front: "ج", frontSub: "Jim", back: "Son 'j' — 1 point AU MILIEU", category: "Lettres"),
                            RevisionCard(front: "ح", frontSub: "Ha", back: "Son guttural 'ḥ' — AUCUN point", category: "Lettres"),
                            RevisionCard(front: "خ", frontSub: "Kha", back: "Son 'kh' — 1 point AU-DESSUS", category: "Lettres")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Quelle lettre n'a AUCUN point ?", options: ["ج", "ح", "خ"], correctIndex: 1, explanation: "Ha (ح) n'a pas de point."),
                            LessonQuiz(question: "Comment se prononce خ ?", options: ["j", "h", "kh", "d"], correctIndex: 2, explanation: "Kha (خ) se prononce 'kh'.")
                        ]
                    ),
                    ArabicLesson(id: "m1_l3", title: "Les lettres د ذ ر ز",
                        content: [
                            LessonContent(type: .letter, title: "Dal — د", arabicText: "د", transliteration: "d", translation: "8ème lettre", explanation: "Dal se prononce 'd'. Forme simple sans points. Ne se connecte pas à la lettre suivante."),
                            LessonContent(type: .letter, title: "Dhal — ذ", arabicText: "ذ", transliteration: "dh", translation: "9ème lettre", explanation: "Dhal se prononce 'dh' comme 'th' anglais dans 'this'. 1 point au-dessus de Dal."),
                            LessonContent(type: .letter, title: "Ra — ر", arabicText: "ر", transliteration: "r", translation: "10ème lettre", explanation: "Ra se prononce 'r' roulé. Ne se connecte pas à la lettre suivante."),
                            LessonContent(type: .letter, title: "Zayn — ز", arabicText: "ز", transliteration: "z", translation: "11ème lettre", explanation: "Zayn se prononce 'z'. Même forme que Ra avec 1 point au-dessus.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "د", frontSub: "Dal", back: "Son 'd' — pas de connexion à droite", category: "Lettres"),
                            RevisionCard(front: "ذ", frontSub: "Dhal", back: "Son 'dh' (this) — 1 point", category: "Lettres"),
                            RevisionCard(front: "ر", frontSub: "Ra", back: "Son 'r' roulé — pas de connexion", category: "Lettres"),
                            RevisionCard(front: "ز", frontSub: "Zayn", back: "Son 'z' — Ra avec 1 point", category: "Lettres")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Quelle lettre se prononce 'dh' comme dans 'this' ?", options: ["د", "ذ", "ر", "ز"], correctIndex: 1, explanation: "Dhal (ذ) se prononce 'dh'."),
                            LessonQuiz(question: "Quelle est la différence entre ر et ز ?", options: ["Aucune", "ز a un point au-dessus", "ر a un point", "Ils n'ont pas la même forme"], correctIndex: 1, explanation: "Zayn (ز) est comme Ra mais avec un point au-dessus.")
                        ]
                    )
                ]
            ),

            // =====================
            // MODULE 2 — Les sons
            // =====================
            ArabicCourse(
                id: "module2",
                title: "Module 2 — Les sons",
                description: "Entendre et prononcer l'arabe correctement",
                icon: "🔊",
                moduleNumber: 2,
                lessons: [
                    ArabicLesson(id: "m2_l1", title: "Les voyelles courtes (Harakat)",
                        content: [
                            LessonContent(type: .vowel, title: "Fatha — بَ", arabicText: "بَ", transliteration: "ba", translation: "Son 'a'", explanation: "La Fatha est un petit trait diagonal AU-DESSUS de la lettre → son 'a'\nبَ = ba  •  تَ = ta  •  كَ = ka"),
                            LessonContent(type: .vowel, title: "Kasra — بِ", arabicText: "بِ", transliteration: "bi", translation: "Son 'i'", explanation: "La Kasra est un petit trait diagonal EN-DESSOUS de la lettre → son 'i'\nبِ = bi  •  تِ = ti  •  كِ = ki"),
                            LessonContent(type: .vowel, title: "Damma — بُ", arabicText: "بُ", transliteration: "bu", translation: "Son 'ou'", explanation: "La Damma est un petit waw (و) AU-DESSUS de la lettre → son 'ou'\nبُ = bu  •  تُ = tu  •  كُ = ku"),
                            LessonContent(type: .vowel, title: "Sukun — بْ", arabicText: "بْ", transliteration: "b (sans voyelle)", translation: "Consonne pure", explanation: "Le Sukun est un petit cercle AU-DESSUS de la lettre → pas de voyelle, la lettre est prononcée seule\nبْتَ = bta")
                        ],
                        revisionCards: [
                            RevisionCard(front: "بَ", frontSub: "Fatha", back: "Son 'a' — trait AU-DESSUS", category: "Voyelles"),
                            RevisionCard(front: "بِ", frontSub: "Kasra", back: "Son 'i' — trait EN-DESSOUS", category: "Voyelles"),
                            RevisionCard(front: "بُ", frontSub: "Damma", back: "Son 'ou' — petit waw AU-DESSUS", category: "Voyelles"),
                            RevisionCard(front: "بْ", frontSub: "Sukun", back: "Consonne pure — cercle au-dessus", category: "Voyelles")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "La Fatha donne quel son ?", options: ["i", "a", "ou", "an"], correctIndex: 1, explanation: "La Fatha donne le son 'a'."),
                            LessonQuiz(question: "Où se place la Kasra ?", options: ["Au-dessus", "En-dessous", "À gauche", "À droite"], correctIndex: 1, explanation: "La Kasra se place en-dessous de la lettre."),
                            LessonQuiz(question: "Que signifie le Sukun ?", options: ["Son 'a'", "Son 'i'", "Consonne sans voyelle", "Son 'ou'"], correctIndex: 2, explanation: "Le Sukun indique qu'il n'y a pas de voyelle.")
                        ]
                    ),
                    ArabicLesson(id: "m2_l2", title: "Sons difficiles — La gorge",
                        content: [
                            LessonContent(type: .pronunciation, title: "ع — 'Ayn", arabicText: "عَ", transliteration: "'a", translation: "Son guttural profond", explanation: "Le 'Ayn est le son le plus difficile pour les francophones. C'est une constriction du fond de la gorge. Comme si tu essayais de faire 'a' depuis le fond de la gorge.\n\nExercice : pose la main sur ta gorge et fais vibrer profondément."),
                            LessonContent(type: .pronunciation, title: "غ — Ghayn", arabicText: "غَ", transliteration: "gh", translation: "Son 'r' parisien guttural", explanation: "Le Ghayn ressemble au 'r' parisien mais plus profond dans la gorge. Comme le gargarisme.\n\nMot exemple : غَفَر (ghafarа) = pardonner"),
                            LessonContent(type: .pronunciation, title: "ح — Ha guttural", arabicText: "حَ", transliteration: "ḥ", translation: "Souffle chaud de la gorge", explanation: "Le Ha guttural est comme un souffle chaud sortant du fond de la gorge. Imagine que tu essaies de réchauffer tes mains avec ton haleine, mais plus profondément.\n\n⚠️ Différent du خ (Kha) qui est plus rauque."),
                            LessonContent(type: .pronunciation, title: "⚠️ Note importante", arabicText: "", transliteration: "", translation: "", explanation: "Pour parfectionner ta prononciation, tu dois :\n\n🎧 Écouter des récitateurs du Coran (Sheikh Al-Husary, Mishary Rashid...)\n🎙️ T'enregistrer et comparer\n👨‍🏫 Pratiquer avec un locuteur natif si possible\n\nL'application te donne les bases — le reste vient avec la pratique et l'écoute.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "ع", frontSub: "'Ayn", back: "Son guttural profond — constriction du fond de gorge", category: "Sons"),
                            RevisionCard(front: "غ", frontSub: "Ghayn", back: "Son 'gh' — r parisien guttural", category: "Sons"),
                            RevisionCard(front: "ح", frontSub: "Ha", back: "Souffle chaud de la gorge", category: "Sons")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Le son ع vient de :", options: ["Les lèvres", "La langue", "Le fond de la gorge", "Le nez"], correctIndex: 2, explanation: "Le 'Ayn est une constriction du fond de la gorge."),
                            LessonQuiz(question: "Le Ghayn ressemble à :", options: ["Le 'b' français", "Le 'r' parisien guttural", "Le 's' français", "Le 'n' nasal"], correctIndex: 1, explanation: "Le Ghayn ressemble au 'r' parisien mais plus guttural.")
                        ]
                    ),
                    ArabicLesson(id: "m2_l3", title: "Sons emphatiques — ص ض ط ظ",
                        content: [
                            LessonContent(type: .pronunciation, title: "ص — Sad", arabicText: "صَ", transliteration: "ṣ", translation: "S emphatique", explanation: "Le Sad est un 'S' prononcé avec la gorge serrée et la langue en arrière. Son plus grave que س.\nExemple : صَبْر (sabr) = patience"),
                            LessonContent(type: .pronunciation, title: "ض — Dad", arabicText: "ضَ", transliteration: "ḍ", translation: "D emphatique", explanation: "Le Dad est propre à l'arabe. D prononcé profondément avec la langue plaquée contre le palais.\nExemple : رَمَضَان (Ramadan)"),
                            LessonContent(type: .pronunciation, title: "ط — Ta emphatique", arabicText: "طَ", transliteration: "ṭ", translation: "T emphatique", explanation: "Le Ta emphatique est un 'T' prononcé avec la langue vers le fond.\nExemple : طَيِّب (tayyib) = bon"),
                            LessonContent(type: .pronunciation, title: "ظ — Dha emphatique", arabicText: "ظَ", transliteration: "ẓ", translation: "Dh emphatique", explanation: "Le Dha emphatique est le 'dh' de ذ mais prononcé profondément.\nExemple : ظُلْم (dhulm) = injustice")
                        ],
                        revisionCards: [
                            RevisionCard(front: "ص", frontSub: "Sad", back: "S emphatique — profond et grave", category: "Sons emphatiques"),
                            RevisionCard(front: "ض", frontSub: "Dad", back: "D emphatique — propre à l'arabe", category: "Sons emphatiques"),
                            RevisionCard(front: "ط", frontSub: "Ta", back: "T emphatique", category: "Sons emphatiques"),
                            RevisionCard(front: "ظ", frontSub: "Dha", back: "Dh emphatique", category: "Sons emphatiques")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Quelle lettre est unique à la langue arabe (pas dans les autres) ?", options: ["ص", "ض", "ط", "ظ"], correctIndex: 1, explanation: "Le Dad (ض) est considéré unique à l'arabe classique."),
                            LessonQuiz(question: "رَمَضَان contient quelle lettre emphatique ?", options: ["ص", "ض", "ط", "ظ"], correctIndex: 1, explanation: "Ramadan s'écrit avec un Dad (ض).")
                        ]
                    )
                ]
            ),

            // ==============================
            // MODULE 3 — Les mots
            // ==============================
            ArabicCourse(
                id: "module3",
                title: "Module 3 — Les mots",
                description: "Lire et comprendre le vocabulaire de base",
                icon: "📖",
                moduleNumber: 3,
                lessons: [
                    ArabicLesson(id: "m3_l1", title: "Vocabulaire du quotidien",
                        content: [
                            LessonContent(type: .word, title: "البيت — Maison", arabicText: "الْبَيْت", transliteration: "al-bayt", translation: "La maison", explanation: "Al-Bayt. Utilisé aussi pour 'Baytullah' (la Maison d'Allah = la Kaaba)."),
                            LessonContent(type: .word, title: "الماء — Eau", arabicText: "الْمَاء", transliteration: "al-maa'", translation: "L'eau", explanation: "Al-Maa'. L'eau est mentionnée souvent dans le Coran comme signe d'Allah."),
                            LessonContent(type: .word, title: "الطعام — Nourriture", arabicText: "الطَّعَام", transliteration: "at-ta'am", translation: "La nourriture", explanation: "At-Ta'am. On dit بِسْمِ اللَّهِ avant de manger."),
                            LessonContent(type: .word, title: "الكتاب — Livre", arabicText: "الْكِتَاب", transliteration: "al-kitab", translation: "Le livre", explanation: "Al-Kitab. Ce mot désigne aussi le Coran (الكتاب المقدس)."),
                            LessonContent(type: .word, title: "الأسرة — Famille", arabicText: "الأُسْرَة", transliteration: "al-usra", translation: "La famille", explanation: "Al-Usra. La famille est le pilier de la société islamique."),
                            LessonContent(type: .word, title: "الوقت — Temps", arabicText: "الْوَقْت", transliteration: "al-waqt", translation: "Le temps", explanation: "Al-Waqt. Le temps est sacré en Islam — Sourate Al-Asr.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "الْبَيْت", frontSub: "al-bayt", back: "La maison", category: "Quotidien"),
                            RevisionCard(front: "الْمَاء", frontSub: "al-maa'", back: "L'eau", category: "Quotidien"),
                            RevisionCard(front: "الطَّعَام", frontSub: "at-ta'am", back: "La nourriture", category: "Quotidien"),
                            RevisionCard(front: "الْكِتَاب", frontSub: "al-kitab", back: "Le livre", category: "Quotidien"),
                            RevisionCard(front: "الأُسْرَة", frontSub: "al-usra", back: "La famille", category: "Quotidien")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Que signifie الْكِتَاب ?", options: ["Eau", "Famille", "Livre", "Maison"], correctIndex: 2, explanation: "Al-Kitab signifie le livre."),
                            LessonQuiz(question: "Comment dit-on 'famille' en arabe ?", options: ["الْبَيْت", "الأُسْرَة", "الطَّعَام", "الْوَقْت"], correctIndex: 1, explanation: "La famille se dit Al-Usra (الأُسْرَة)."),
                            LessonQuiz(question: "Al-Bayt signifie :", options: ["L'eau", "La maison", "Le temps", "Le livre"], correctIndex: 1, explanation: "Al-Bayt signifie la maison.")
                        ]
                    ),
                    ArabicLesson(id: "m3_l2", title: "Vocabulaire islamique essentiel",
                        content: [
                            LessonContent(type: .word, title: "الصَّلَاة — La prière", arabicText: "الصَّلَاة", transliteration: "as-salah", translation: "La prière", explanation: "As-Salah. Les 5 prières quotidiennes. Pilier de l'Islam."),
                            LessonContent(type: .word, title: "الصِّيَام — Le jeûne", arabicText: "الصِّيَام", transliteration: "as-siyam", translation: "Le jeûne", explanation: "As-Siyam. Le jeûne du Ramadan est le 4ème pilier."),
                            LessonContent(type: .word, title: "الزَّكَاة — L'aumône", arabicText: "الزَّكَاة", transliteration: "az-zakat", translation: "L'aumône obligatoire", explanation: "Az-Zakat. 3ème pilier de l'Islam. 2,5% de l'épargne."),
                            LessonContent(type: .word, title: "الْحَجّ — Le pèlerinage", arabicText: "الْحَجّ", transliteration: "al-hajj", translation: "Le pèlerinage", explanation: "Al-Hajj. 5ème pilier. Obligatoire une fois si on en a les moyens."),
                            LessonContent(type: .word, title: "الْإِيمَان — La foi", arabicText: "الإِيمَان", transliteration: "al-iman", translation: "La foi", explanation: "Al-Iman. La foi intérieure du croyant."),
                            LessonContent(type: .word, title: "التَّقْوَى — La piété", arabicText: "التَّقْوَى", transliteration: "at-taqwa", translation: "La piété, la crainte d'Allah", explanation: "At-Taqwa. L'un des mots les plus importants du Coran.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "الصَّلَاة", frontSub: "as-salah", back: "La prière — 2ème pilier", category: "Islam"),
                            RevisionCard(front: "الصِّيَام", frontSub: "as-siyam", back: "Le jeûne — 4ème pilier", category: "Islam"),
                            RevisionCard(front: "الزَّكَاة", frontSub: "az-zakat", back: "L'aumône — 3ème pilier", category: "Islam"),
                            RevisionCard(front: "الإِيمَان", frontSub: "al-iman", back: "La foi", category: "Islam"),
                            RevisionCard(front: "التَّقْوَى", frontSub: "at-taqwa", back: "La piété / crainte d'Allah", category: "Islam")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Que signifie التَّقْوَى ?", options: ["La prière", "La piété/crainte d'Allah", "Le pèlerinage", "La foi"], correctIndex: 1, explanation: "At-Taqwa signifie la piété et la crainte d'Allah."),
                            LessonQuiz(question: "الصِّيَام désigne quel pilier ?", options: ["La prière", "L'aumône", "Le jeûne", "Le pèlerinage"], correctIndex: 2, explanation: "As-Siyam désigne le jeûne, 4ème pilier."),
                            LessonQuiz(question: "Comment dit-on 'foi' en arabe ?", options: ["التَّقْوَى", "الصَّلَاة", "الإِيمَان", "الزَّكَاة"], correctIndex: 2, explanation: "La foi se dit Al-Iman (الإِيمَان).")
                        ]
                    ),
                    ArabicLesson(id: "m3_l3", title: "Lire des mots simples",
                        content: [
                            LessonContent(type: .word, title: "بَيْت — Lire ce mot", arabicText: "بَيْت", transliteration: "bayt", translation: "Maison (sans article)", explanation: "بَ = ba • يْ = y (sukun) • ت = t\nLecture : b-ay-t → bayt"),
                            LessonContent(type: .word, title: "كِتَاب — Lire ce mot", arabicText: "كِتَاب", transliteration: "kitab", translation: "Livre (sans article)", explanation: "كِ = ki • تَ = ta • ب = b\nLecture : ki-ta-b → kitab"),
                            LessonContent(type: .word, title: "رَجُل — Lire ce mot", arabicText: "رَجُل", transliteration: "rajul", translation: "Homme", explanation: "رَ = ra • جُ = ju • ل = l\nLecture : ra-jul → rajul"),
                            LessonContent(type: .word, title: "امْرَأَة — Lire ce mot", arabicText: "امْرَأَة", transliteration: "imra'a", translation: "Femme", explanation: "ا = a • مْ = m (sukun) • رَ = ra • أَة = 'a\nLecture : im-ra-'a"),
                            LessonContent(type: .word, title: "وَلَد — Lire ce mot", arabicText: "وَلَد", transliteration: "walad", translation: "Enfant (garçon)", explanation: "وَ = wa • لَ = la • د = d\nLecture : wa-lad → walad")
                        ],
                        revisionCards: [
                            RevisionCard(front: "بَيْت", frontSub: "bayt", back: "Maison", category: "Lecture"),
                            RevisionCard(front: "كِتَاب", frontSub: "kitab", back: "Livre", category: "Lecture"),
                            RevisionCard(front: "رَجُل", frontSub: "rajul", back: "Homme", category: "Lecture"),
                            RevisionCard(front: "وَلَد", frontSub: "walad", back: "Enfant / garçon", category: "Lecture")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Comment se prononce بَيْت ?", options: ["bitay", "bayt", "buyt", "biyt"], correctIndex: 1, explanation: "بَ = ba, يْ = y, ت = t → bayt"),
                            LessonQuiz(question: "كِتَاب signifie ?", options: ["Maison", "Homme", "Livre", "Enfant"], correctIndex: 2, explanation: "Kitab = livre."),
                            LessonQuiz(question: "Comment dit-on 'homme' ?", options: ["وَلَد", "رَجُل", "امْرَأَة", "بَيْت"], correctIndex: 1, explanation: "Homme se dit rajul (رَجُل).")
                        ]
                    )
                ]
            ),

            // ============================
            // MODULE 4 — Les phrases
            // ============================
            ArabicCourse(
                id: "module4",
                title: "Module 4 — Les phrases",
                description: "Construire et comprendre des phrases simples",
                icon: "💬",
                moduleNumber: 4,
                lessons: [
                    ArabicLesson(id: "m4_l1", title: "La phrase nominale (Sujet + Attribut)",
                        content: [
                            LessonContent(type: .rule, title: "Structure de base", arabicText: "الكِتَابُ جَمِيلٌ", transliteration: "al-kitabu jamil", translation: "Le livre est beau", explanation: "En arabe, on peut faire une phrase sans verbe 'être' !\nSujet (المبتدأ) + Attribut (الخبر) = phrase complète\n\nالكِتَابُ جَمِيلٌ = Le livre [est] beau"),
                            LessonContent(type: .rule, title: "Exemples de phrases", arabicText: "الْبَيْتُ كَبِيرٌ", transliteration: "al-baytu kabir", translation: "La maison est grande", explanation: "كَبِير = grand • صَغِير = petit • جَمِيل = beau • طَيِّب = bon\n\nالرَّجُلُ طَيِّبٌ = L'homme est bon\nالمَاءُ بَارِدٌ = L'eau est froide"),
                            LessonContent(type: .rule, title: "Masculin et Féminin", arabicText: "طَالِب — طَالِبَة", transliteration: "talib — taliba", translation: "Étudiant — Étudiante", explanation: "En arabe, le féminin se forme souvent en ajoutant ة (ta marbuta) à la fin.\n\nطَالِب (étudiant) → طَالِبَة (étudiante)\nمُسْلِم (musulman) → مُسْلِمَة (musulmane)\nكَبِير (grand) → كَبِيرَة (grande)")
                        ],
                        revisionCards: [
                            RevisionCard(front: "الكِتَابُ جَمِيلٌ", frontSub: "al-kitabu jamil", back: "Le livre est beau — phrase nominale sans verbe être", category: "Grammaire"),
                            RevisionCard(front: "ة — Ta marbuta", frontSub: "Féminin", back: "Signe du féminin — se prononce 'a' ou 't' selon le contexte", category: "Grammaire")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Que signifie الْبَيْتُ كَبِيرٌ ?", options: ["La maison est petite", "La maison est grande", "La maison est belle", "La maison est froide"], correctIndex: 1, explanation: "Al-baytu kabir = La maison est grande."),
                            LessonQuiz(question: "Comment forme-t-on le féminin en arabe ?", options: ["On change toute la fin", "On ajoute ة (ta marbuta)", "On ajoute ال au début", "On double la dernière lettre"], correctIndex: 1, explanation: "Le féminin se forme en ajoutant ة à la fin.")
                        ]
                    ),
                    ArabicLesson(id: "m4_l2", title: "Dialogues simples",
                        content: [
                            LessonContent(type: .dialogue, title: "Se présenter", arabicText: "أَنَا مُحَمَّد — اسْمِي سَارَة", transliteration: "Ana Muhammad — Ismi Sara", translation: "Je suis Muhammad — Mon nom est Sarah", explanation: "أَنَا (ana) = je / moi\nاسْمِي (ismi) = mon nom\nأَنَا مُسْلِم (ana muslim) = je suis musulman\nأَنَا مِنْ فَرَنْسَا (ana min faransa) = je suis de France"),
                            LessonContent(type: .dialogue, title: "Salutations", arabicText: "السَّلَامُ عَلَيْكُم — وَعَلَيْكُمُ السَّلَام", transliteration: "As-salamu alaykum — Wa alaykumu as-salam", translation: "La paix soit sur vous — Et sur vous la paix", explanation: "السَّلَامُ عَلَيْكُم = Bonjour / La paix soit sur vous\nكَيْفَ حَالُكَ (kayfa haluk) = Comment vas-tu ?\nالحَمْدُ لِلَّه (alhamdulillah) = Bien, grâce à Allah"),
                            LessonContent(type: .dialogue, title: "Mots utiles", arabicText: "نَعَم — لَا — شُكْرًا — مِنْ فَضْلِكَ", transliteration: "Na'am — La — Shukran — Min fadlika", translation: "Oui — Non — Merci — S'il te plaît", explanation: "نَعَم (na'am) = oui\nلَا (la) = non\nشُكْرًا (shukran) = merci\nمِنْ فَضْلِكَ (min fadlika) = s'il te plaît\nعَفْوًا ('afwan) = de rien / pardon")
                        ],
                        revisionCards: [
                            RevisionCard(front: "أَنَا", frontSub: "ana", back: "Je / moi", category: "Dialogue"),
                            RevisionCard(front: "اسْمِي", frontSub: "ismi", back: "Mon nom est", category: "Dialogue"),
                            RevisionCard(front: "شُكْرًا", frontSub: "shukran", back: "Merci", category: "Dialogue"),
                            RevisionCard(front: "كَيْفَ حَالُكَ", frontSub: "kayfa haluk", back: "Comment vas-tu ?", category: "Dialogue")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Comment dit-on 'merci' en arabe ?", options: ["نَعَم", "شُكْرًا", "عَفْوًا", "لَا"], correctIndex: 1, explanation: "Merci = Shukran (شُكْرًا)."),
                            LessonQuiz(question: "أَنَا signifie :", options: ["Toi", "Lui", "Je / Moi", "Nous"], correctIndex: 2, explanation: "Ana (أَنَا) = je / moi."),
                            LessonQuiz(question: "Comment répond-on à As-Salamu Alaykum ?", options: ["Shukran", "Na'am", "Wa alaykumu as-salam", "Alhamdulillah"], correctIndex: 2, explanation: "On répond Wa Alaykumu As-Salam.")
                        ]
                    )
                ]
            ),

            // ================================
            // MODULE 5 — L'arabe coranique
            // ================================
            ArabicCourse(
                id: "module5",
                title: "Module 5 — L'arabe du Coran",
                description: "Comprendre les versets et le vocabulaire coranique",
                icon: "📿",
                moduleNumber: 5,
                lessons: [
                    ArabicLesson(id: "m5_l1", title: "Comprendre Al-Fatiha",
                        content: [
                            LessonContent(type: .verse, title: "Verset 1 — Bismillah", arabicText: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", transliteration: "Bismillāhi ar-raḥmāni ar-raḥīm", translation: "Au nom d'Allah, le Tout Miséricordieux, le Très Miséricordieux", explanation: "بِسْم = au nom de • اللَّه = Allah • الرَّحْمَٰن = le Tout Miséricordieux (grâce générale pour tous) • الرَّحِيم = le Très Miséricordieux (grâce particulière pour les croyants)"),
                            LessonContent(type: .verse, title: "Verset 2 — Al-Hamdulillah", arabicText: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", transliteration: "Al-ḥamdu lillāhi rabbi l-'ālamīn", translation: "Louange à Allah, Seigneur des mondes", explanation: "الحَمْد = la louange • لِلَّه = pour Allah • رَبّ = Seigneur • العَالَمِين = les mondes (toute la création)"),
                            LessonContent(type: .verse, title: "Verset 5 — Iyyaka na'budu", arabicText: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", transliteration: "Iyyāka na'budu wa iyyāka nasta'īn", translation: "C'est Toi [seul] que nous adorons et c'est Toi [seul] dont nous implorons le secours", explanation: "إِيَّاكَ = Toi seul • نَعْبُد = nous adorons • نَسْتَعِين = nous demandons le secours\n\nCe verset est le cœur de la Fatiha — l'adoration exclusive d'Allah."),
                            LessonContent(type: .verse, title: "Verset 6-7 — La guidance", arabicText: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ", transliteration: "Ihdinā aṣ-ṣirāṭa l-mustaqīm", translation: "Guide-nous sur le droit chemin", explanation: "اهْدِنَا = guide-nous • الصِّرَاط = le chemin • المُسْتَقِيم = droit, direct\n\nC'est la doua la plus récitée au monde — 17 fois par jour minimum.")
                        ],
                        revisionCards: [
                            RevisionCard(front: "الرَّحْمَٰن", frontSub: "ar-Rahman", back: "Le Tout Miséricordieux — miséricorde générale pour tous", category: "Noms d'Allah"),
                            RevisionCard(front: "الرَّحِيم", frontSub: "ar-Rahim", back: "Le Très Miséricordieux — miséricorde particulière pour les croyants", category: "Noms d'Allah"),
                            RevisionCard(front: "رَبّ الْعَالَمِين", frontSub: "rabbi l-'alamin", back: "Seigneur des mondes / de toute la création", category: "Coran"),
                            RevisionCard(front: "الصِّرَاط الْمُسْتَقِيم", frontSub: "as-sirat al-mustaqim", back: "Le droit chemin", category: "Coran")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "Que signifie رَبّ الْعَالَمِين ?", options: ["Le Miséricordieux", "Seigneur des mondes", "Guide-nous", "Le droit chemin"], correctIndex: 1, explanation: "Rabbi l-'alamin = Seigneur des mondes."),
                            LessonQuiz(question: "Quelle est la différence entre الرَّحْمَٰن et الرَّحِيم ?", options: ["Aucune", "Al-Rahman est général (tous), Ar-Rahim est particulier (croyants)", "Ar-Rahim est général, Al-Rahman est particulier", "Ce sont des synonymes"], correctIndex: 1, explanation: "Al-Rahman désigne la miséricorde générale, Ar-Rahim la miséricorde particulière."),
                            LessonQuiz(question: "إِيَّاكَ نَعْبُدُ signifie :", options: ["Guide-nous", "Louange à Allah", "C'est Toi seul que nous adorons", "Seigneur des mondes"], correctIndex: 2, explanation: "Iyyaka na'budu = C'est Toi seul que nous adorons.")
                        ]
                    ),
                    ArabicLesson(id: "m5_l2", title: "Racines arabes — La clé du vocabulaire",
                        content: [
                            LessonContent(type: .rule, title: "Le système des racines", arabicText: "ك — ت — ب", transliteration: "K-T-B", translation: "Racine de l'écriture", explanation: "L'arabe fonctionne par RACINES de 3 lettres. De cette racine découlent des dizaines de mots !\n\nRacine K-T-B (écriture) :\nكَتَبَ (kataba) = il a écrit\nكِتَاب (kitab) = livre\nمَكْتَبَة (maktaba) = bibliothèque\nكَاتِب (katib) = écrivain\nمَكْتُوب (maktub) = écrit / lettre"),
                            LessonContent(type: .rule, title: "Racine S-L-M — Paix", arabicText: "س — ل — م", transliteration: "S-L-M", translation: "Racine de la paix et de la soumission", explanation: "Racine S-L-M :\nسَلَام (salam) = paix\nإِسْلَام (Islam) = soumission à Allah\nمُسْلِم (muslim) = soumis = musulman\nاسْتَسْلَمَ (istaslama) = il s'est soumis\nتَسْلِيم (taslim) = le salut (dans la prière)"),
                            LessonContent(type: .rule, title: "Racine '-L-M — Science", arabicText: "ع — ل — م", transliteration: "'A-L-M", translation: "Racine du savoir", explanation: "Racine '-L-M :\nعَلِمَ ('alima) = il a su\nعِلْم ('ilm) = science, connaissance\nعَالَم ('alam) = monde\nعَالِم ('alim) = savant\nمُعَلِّم (mu'allim) = enseignant\nالله أَعْلَم (Allahu a'lam) = Allah sait mieux")
                        ],
                        revisionCards: [
                            RevisionCard(front: "ك-ت-ب", frontSub: "K-T-B", back: "Racine de l'écriture → kitab, kataba, maktaba...", category: "Racines"),
                            RevisionCard(front: "س-ل-م", frontSub: "S-L-M", back: "Racine de la paix → salam, Islam, muslim...", category: "Racines"),
                            RevisionCard(front: "ع-ل-م", frontSub: "'A-L-M", back: "Racine du savoir → 'ilm, 'alim, mu'allim...", category: "Racines")
                        ],
                        quizQuestions: [
                            LessonQuiz(question: "مَكْتَبَة vient de quelle racine ?", options: ["S-L-M", "'A-L-M", "K-T-B", "R-H-M"], correctIndex: 2, explanation: "Maktaba (bibliothèque) vient de la racine K-T-B (écriture)."),
                            LessonQuiz(question: "Islam et Salam partagent quelle racine ?", options: ["K-T-B", "S-L-M", "'A-L-M", "D-R-S"], correctIndex: 1, explanation: "Islam et Salam partagent la racine S-L-M (paix/soumission)."),
                            LessonQuiz(question: "'Alim (savant) vient de la racine :", options: ["K-T-B", "S-L-M", "'A-L-M", "F-Q-H"], correctIndex: 2, explanation: "'Alim vient de 'A-L-M, la racine du savoir.")
                        ]
                    )
                ]
            )
        ]
        updateProgress()
    }
}
