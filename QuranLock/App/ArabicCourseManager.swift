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

class ArabicCourseManager: ObservableObject {
    @Published var selectedRhythm: LearningRhythm?
    @Published var courses: [ArabicCourse] = []
    @Published var overallProgress: Double = 0
    @AppStorage("arabicLearningRhythm") var savedRhythm: String = ""
    @AppStorage("completedArabicLessons") var completedLessonsData: String = "[]"

    init() {
        if !savedRhythm.isEmpty { selectedRhythm = LearningRhythm(rawValue: savedRhythm) }
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
               let string = String(data: data, encoding: .utf8) { completedLessonsData = string }
        }
    }

    func selectRhythm(_ rhythm: LearningRhythm) { selectedRhythm = rhythm; savedRhythm = rhythm.rawValue }

    func completeLesson(_ lessonId: String) {
        var ids = completedLessonIds
        if !ids.contains(lessonId) { ids.append(lessonId); completedLessonIds = ids; updateProgress() }
    }

    func isLessonCompleted(_ lessonId: String) -> Bool { completedLessonIds.contains(lessonId) }

    func updateProgress() {
        let total = courses.reduce(0) { $0 + $1.lessons.count }
        guard total > 0 else { return }
        overallProgress = Double(completedLessonIds.count) / Double(total)
    }

    // MARK: - Load All Courses

    func loadCourses() {
        courses = [alphabetCourse, vowelsCourse, readingCourse, vocabularyCourse, grammarCourse]
        updateProgress()
    }

    // MARK: - ALPHABET COURSE (ALL 28 LETTERS)

    var alphabetCourse: ArabicCourse {
        ArabicCourse(
            id: "alphabet", title: "L'Alphabet Arabe", description: "Maîtrisez les 28 lettres de l'alphabet arabe",
            icon: "abc", level: .debutant, duration: "3 semaines",
            lessons: [alphabetL1, alphabetL2, alphabetL3, alphabetL4, alphabetL5, alphabetL6, alphabetL7, alphabetL8]
        )
    }

    var alphabetL1: ArabicLesson {
        ArabicLesson(id: "alph_1", title: "أ ب ت ث — Les premières lettres", content: [
            LessonContent(type: .letter, title: "Alif", arabicText: "أ", transliteration: "a / â", translation: "1ère lettre", explanation: "L'Alif est la première lettre de l'alphabet arabe. C'est une lettre verticale qui peut porter différentes voyelles. Elle sert souvent de support pour la hamza (ء). Seule, elle se prononce comme un 'a' long."),
            LessonContent(type: .letter, title: "Bâ'", arabicText: "ب", transliteration: "b", translation: "2ème lettre", explanation: "Le Bâ' se prononce comme le 'b' français. Il a UN point en dessous. En début de mot il s'attache à la lettre suivante : بـ. Formes : isolée ب, initiale بـ, médiane ـبـ, finale ـب."),
            LessonContent(type: .letter, title: "Tâ'", arabicText: "ت", transliteration: "t", translation: "3ème lettre", explanation: "Le Tâ' se prononce comme le 't' français. Il a DEUX points au-dessus. Même forme de base que le Bâ'. Formes : isolée ت, initiale تـ, médiane ـتـ, finale ـت."),
            LessonContent(type: .letter, title: "Thâ'", arabicText: "ث", transliteration: "th", translation: "4ème lettre", explanation: "Le Thâ' se prononce comme le 'th' anglais de 'think'. Il a TROIS points au-dessus. Même forme de base que Bâ' et Tâ'. On place la langue entre les dents.")
        ], revisionCards: [
            RevisionCard(front: "أ", frontSub: "Alif", back: "1ère lettre, son 'a'. Support de voyelles et de hamza.", category: "Lettres"),
            RevisionCard(front: "ب", frontSub: "Bâ'", back: "Son 'b'. UN point en dessous.", category: "Lettres"),
            RevisionCard(front: "ت", frontSub: "Tâ'", back: "Son 't'. DEUX points au-dessus.", category: "Lettres"),
            RevisionCard(front: "ث", frontSub: "Thâ'", back: "Son 'th' (think). TROIS points au-dessus.", category: "Lettres")
        ], quizQuestions: [
            LessonQuiz(question: "Combien de points a la lettre ب ?", options: ["0", "1", "2", "3"], correctIndex: 1, explanation: "Le Bâ' (ب) a un seul point en dessous."),
            LessonQuiz(question: "Comment se prononce ث ?", options: ["b", "t", "th", "s"], correctIndex: 2, explanation: "Le Thâ' (ث) se prononce comme le 'th' anglais dans 'think'."),
            LessonQuiz(question: "Quelle lettre a deux points au-dessus ?", options: ["أ", "ب", "ت", "ث"], correctIndex: 2, explanation: "Le Tâ' (ت) a deux points au-dessus."),
            LessonQuiz(question: "Quelle est la première lettre de l'alphabet arabe ?", options: ["ب", "أ", "ت", "ع"], correctIndex: 1, explanation: "L'Alif (أ) est la première lettre de l'alphabet arabe.")
        ])
    }

    var alphabetL2: ArabicLesson {
        ArabicLesson(id: "alph_2", title: "ج ح خ — Les gutturales", content: [
            LessonContent(type: .letter, title: "Jîm", arabicText: "ج", transliteration: "j", translation: "5ème lettre", explanation: "Le Jîm se prononce comme le 'j' français. Il a un point au milieu de sa courbe. Forme arrondie caractéristique."),
            LessonContent(type: .letter, title: "Hâ'", arabicText: "ح", transliteration: "ḥ", translation: "6ème lettre", explanation: "Le Hâ' est un son guttural profond venant de la gorge. Ce n'est PAS le 'h' français. C'est un 'h' aspiré très fort. Pas de point. Même forme que Jîm et Khâ'."),
            LessonContent(type: .letter, title: "Khâ'", arabicText: "خ", transliteration: "kh", translation: "7ème lettre", explanation: "Le Khâ' se prononce comme le 'ch' allemand dans 'Bach' ou la 'jota' espagnole. Un point AU-DESSUS. Le son vient du fond de la gorge.")
        ], revisionCards: [
            RevisionCard(front: "ج", frontSub: "Jîm", back: "Son 'j'. Un point au milieu.", category: "Lettres"),
            RevisionCard(front: "ح", frontSub: "Hâ'", back: "H aspiré guttural profond. Aucun point.", category: "Lettres"),
            RevisionCard(front: "خ", frontSub: "Khâ'", back: "Son 'kh'. Un point au-dessus.", category: "Lettres")
        ], quizQuestions: [
            LessonQuiz(question: "Quelle lettre n'a aucun point ?", options: ["ج", "ح", "خ"], correctIndex: 1, explanation: "Le Hâ' (ح) n'a aucun point."),
            LessonQuiz(question: "Comment se prononce خ ?", options: ["j", "h aspiré", "kh", "sh"], correctIndex: 2, explanation: "Le Khâ' (خ) se prononce 'kh'."),
            LessonQuiz(question: "Quel son produit ح ?", options: ["h français", "j", "h aspiré guttural", "k"], correctIndex: 2, explanation: "Le Hâ' (ح) est un h aspiré guttural profond, différent du h français.")
        ])
    }

    var alphabetL3: ArabicLesson {
        ArabicLesson(id: "alph_3", title: "د ذ ر ز — Lettres non-liantes", content: [
            LessonContent(type: .letter, title: "Dâl", arabicText: "د", transliteration: "d", translation: "8ème lettre", explanation: "Le Dâl se prononce comme le 'd' français. Pas de point. Lettre NON-LIANTE : elle ne s'attache pas à la lettre qui suit."),
            LessonContent(type: .letter, title: "Dhâl", arabicText: "ذ", transliteration: "dh", translation: "9ème lettre", explanation: "Le Dhâl se prononce comme le 'th' anglais de 'the' (sonore). Un point au-dessus. Même forme que Dâl. Non-liante."),
            LessonContent(type: .letter, title: "Râ'", arabicText: "ر", transliteration: "r", translation: "10ème lettre", explanation: "Le Râ' est un 'r' roulé, comme en espagnol ou en arabe dialectal. Pas de point. Non-liante."),
            LessonContent(type: .letter, title: "Zây", arabicText: "ز", transliteration: "z", translation: "11ème lettre", explanation: "Le Zây se prononce comme le 'z' français. Un point au-dessus. Même forme que Râ'. Non-liante.")
        ], revisionCards: [
            RevisionCard(front: "د", frontSub: "Dâl", back: "Son 'd'. Pas de point. Non-liante.", category: "Lettres"),
            RevisionCard(front: "ذ", frontSub: "Dhâl", back: "Son 'dh' (the). Un point. Non-liante.", category: "Lettres"),
            RevisionCard(front: "ر", frontSub: "Râ'", back: "R roulé. Pas de point. Non-liante.", category: "Lettres"),
            RevisionCard(front: "ز", frontSub: "Zây", back: "Son 'z'. Un point. Non-liante.", category: "Lettres")
        ], quizQuestions: [
            LessonQuiz(question: "Quelle est la particularité de د ذ ر ز ?", options: ["Elles ont des points", "Elles sont gutturales", "Elles ne s'attachent pas à gauche", "Elles sont muettes"], correctIndex: 2, explanation: "Ces lettres sont non-liantes : elles ne s'attachent pas à la lettre qui les suit."),
            LessonQuiz(question: "Quelle est la différence entre ر et ز ?", options: ["La forme", "Un point au-dessus", "La taille", "Rien"], correctIndex: 1, explanation: "Le Zây (ز) a un point au-dessus, le Râ' (ر) n'en a pas."),
            LessonQuiz(question: "Comment se prononce ذ ?", options: ["d", "dh comme 'the'", "z", "r"], correctIndex: 1, explanation: "Le Dhâl (ذ) se prononce comme le 'th' anglais dans 'the'.")
        ])
    }

    var alphabetL4: ArabicLesson {
        ArabicLesson(id: "alph_4", title: "س ش ص ض — Les sifflantes", content: [
            LessonContent(type: .letter, title: "Sîn", arabicText: "س", transliteration: "s", translation: "12ème lettre", explanation: "Le Sîn se prononce comme le 's' français. Forme avec trois dents ﺳ. Pas de point."),
            LessonContent(type: .letter, title: "Shîn", arabicText: "ش", transliteration: "sh / ch", translation: "13ème lettre", explanation: "Le Shîn se prononce comme le 'ch' français. Même forme que Sîn mais avec TROIS points au-dessus."),
            LessonContent(type: .letter, title: "Sâd", arabicText: "ص", transliteration: "ṣ", translation: "14ème lettre", explanation: "Le Sâd est un 's' emphatique. On le prononce en creusant la langue et en ouvrant la bouche. Son lourd et grave. Pas de point."),
            LessonContent(type: .letter, title: "Dâd", arabicText: "ض", transliteration: "ḍ", translation: "15ème lettre", explanation: "Le Dâd est un 'd' emphatique unique à l'arabe. L'arabe est appelé 'la langue du Dâd'. Un point au-dessus. Son très grave et profond.")
        ], revisionCards: [
            RevisionCard(front: "س", frontSub: "Sîn", back: "Son 's'. Trois dents, pas de point.", category: "Lettres"),
            RevisionCard(front: "ش", frontSub: "Shîn", back: "Son 'ch/sh'. Trois points au-dessus.", category: "Lettres"),
            RevisionCard(front: "ص", frontSub: "Sâd", back: "S emphatique grave. Pas de point.", category: "Lettres"),
            RevisionCard(front: "ض", frontSub: "Dâd", back: "D emphatique, unique à l'arabe. Un point.", category: "Lettres")
        ], quizQuestions: [
            LessonQuiz(question: "Pourquoi l'arabe est appelé 'la langue du Dâd' ?", options: ["C'est la lettre la plus fréquente", "Le Dâd est unique à l'arabe", "C'est la plus belle lettre", "Elle est la plus ancienne"], correctIndex: 1, explanation: "Le Dâd (ض) est un son emphatique unique à la langue arabe."),
            LessonQuiz(question: "Quelle lettre se prononce comme le 'ch' français ?", options: ["س", "ش", "ص", "ض"], correctIndex: 1, explanation: "Le Shîn (ش) se prononce comme le 'ch' français."),
            LessonQuiz(question: "Quelle est la différence entre س et ص ?", options: ["Points", "ص est emphatique", "Forme", "Rien"], correctIndex: 1, explanation: "Le Sâd (ص) est la version emphatique du Sîn (س), prononcé plus grave et lourd.")
        ])
    }

    var alphabetL5: ArabicLesson {
        ArabicLesson(id: "alph_5", title: "ط ظ ع غ — Emphatiques et gutturales", content: [
            LessonContent(type: .letter, title: "Tâ' emphatique", arabicText: "ط", transliteration: "ṭ", translation: "16ème lettre", explanation: "Le Tâ' emphatique se prononce comme un 't' grave et lourd. Pas de point. Ne pas confondre avec ت (Tâ' léger)."),
            LessonContent(type: .letter, title: "Dhâ' emphatique", arabicText: "ظ", transliteration: "ẓ", translation: "17ème lettre", explanation: "Le Dhâ' emphatique se prononce comme le 'dh' de 'the' mais en version emphatique grave. Un point au-dessus."),
            LessonContent(type: .letter, title: "'Ayn", arabicText: "ع", transliteration: "'a", translation: "18ème lettre", explanation: "Le 'Ayn est une lettre gutturale sans équivalent en français. C'est une contraction de la gorge. Lettre essentielle en arabe, présente dans des mots comme عِلم (science), عَرَبي (arabe)."),
            LessonContent(type: .letter, title: "Ghayn", arabicText: "غ", transliteration: "gh", translation: "19ème lettre", explanation: "Le Ghayn ressemble au 'r' grasseyé parisien. Un point au-dessus. Comme le son du gargarisme.")
        ], revisionCards: [
            RevisionCard(front: "ط", frontSub: "Tâ' emphatique", back: "T lourd et grave. Pas de point.", category: "Lettres"),
            RevisionCard(front: "ظ", frontSub: "Dhâ' emphatique", back: "Dh emphatique grave. Un point.", category: "Lettres"),
            RevisionCard(front: "ع", frontSub: "'Ayn", back: "Contraction gutturale unique. Pas de point.", category: "Lettres"),
            RevisionCard(front: "غ", frontSub: "Ghayn", back: "R grasseyé / gargarisme. Un point.", category: "Lettres")
        ], quizQuestions: [
            LessonQuiz(question: "Le 'Ayn (ع) a-t-il un équivalent en français ?", options: ["Oui, le 'a'", "Oui, le 'h'", "Non, aucun", "Oui, le 'r'"], correctIndex: 2, explanation: "Le 'Ayn est une contraction gutturale unique sans équivalent en français."),
            LessonQuiz(question: "À quel son français ressemble le Ghayn (غ) ?", options: ["Le 'g'", "Le 'r' grasseyé parisien", "Le 'k'", "Le 'n'"], correctIndex: 1, explanation: "Le Ghayn ressemble au 'r' grasseyé parisien ou au son du gargarisme."),
            LessonQuiz(question: "Quelle lettre est la version emphatique de ت ?", options: ["ط", "ظ", "ث", "د"], correctIndex: 0, explanation: "Le Tâ' emphatique (ط) est la version lourde du Tâ' léger (ت).")
        ])
    }

    var alphabetL6: ArabicLesson {
        ArabicLesson(id: "alph_6", title: "ف ق ك ل — Les consonnes courantes", content: [
            LessonContent(type: .letter, title: "Fâ'", arabicText: "ف", transliteration: "f", translation: "20ème lettre", explanation: "Le Fâ' se prononce comme le 'f' français. Un point au-dessus. Sa forme a une boucle arrondie."),
            LessonContent(type: .letter, title: "Qâf", arabicText: "ق", transliteration: "q", translation: "21ème lettre", explanation: "Le Qâf est un 'k' guttural profond prononcé depuis la luette. Deux points au-dessus. Ne pas confondre avec le 'k' normal (ك)."),
            LessonContent(type: .letter, title: "Kâf", arabicText: "ك", transliteration: "k", translation: "22ème lettre", explanation: "Le Kâf se prononce comme le 'k' français. Il a un petit trait (hamza) à l'intérieur dans sa forme isolée."),
            LessonContent(type: .letter, title: "Lâm", arabicText: "ل", transliteration: "l", translation: "23ème lettre", explanation: "Le Lâm se prononce comme le 'l' français. C'est l'une des lettres les plus fréquentes en arabe (الـ = al, l'article défini).")
        ], revisionCards: [
            RevisionCard(front: "ف", frontSub: "Fâ'", back: "Son 'f'. Un point au-dessus.", category: "Lettres"),
            RevisionCard(front: "ق", frontSub: "Qâf", back: "K guttural profond. Deux points au-dessus.", category: "Lettres"),
            RevisionCard(front: "ك", frontSub: "Kâf", back: "Son 'k'. Petit trait intérieur.", category: "Lettres"),
            RevisionCard(front: "ل", frontSub: "Lâm", back: "Son 'l'. Très fréquent (article الـ).", category: "Lettres")
        ], quizQuestions: [
            LessonQuiz(question: "Quelle est la différence entre ق et ك ?", options: ["Juste les points", "ق est guttural profond, ك est normal", "Aucune", "La taille"], correctIndex: 1, explanation: "Le Qâf (ق) est un k guttural venant de la luette, le Kâf (ك) est un k normal."),
            LessonQuiz(question: "Combien de points a le Qâf (ق) ?", options: ["0", "1", "2", "3"], correctIndex: 2, explanation: "Le Qâf (ق) a deux points au-dessus."),
            LessonQuiz(question: "Quelle lettre forme l'article défini 'al' (الـ) ?", options: ["ف", "ق", "ك", "ل"], correctIndex: 3, explanation: "Le Lâm (ل) combiné avec l'Alif forme l'article défini الـ (al-).")
        ])
    }

    var alphabetL7: ArabicLesson {
        ArabicLesson(id: "alph_7", title: "م ن ه — Nasales et finale", content: [
            LessonContent(type: .letter, title: "Mîm", arabicText: "م", transliteration: "m", translation: "24ème lettre", explanation: "Le Mîm se prononce comme le 'm' français. Forme arrondie avec une queue descendante."),
            LessonContent(type: .letter, title: "Nûn", arabicText: "ن", transliteration: "n", translation: "25ème lettre", explanation: "Le Nûn se prononce comme le 'n' français. Un point au-dessus. Forme en demi-cercle. Lettre importante dans les règles du Tajwid (Idgham, Ikhfa, etc.)."),
            LessonContent(type: .letter, title: "Hâ'", arabicText: "ه", transliteration: "h", translation: "26ème lettre", explanation: "Le Hâ' est un 'h' léger expiré. Ne pas confondre avec le Hâ' guttural (ح). Son doux, comme un souffle léger.")
        ], revisionCards: [
            RevisionCard(front: "م", frontSub: "Mîm", back: "Son 'm'. Forme arrondie.", category: "Lettres"),
            RevisionCard(front: "ن", frontSub: "Nûn", back: "Son 'n'. Un point au-dessus. Clé du Tajwid.", category: "Lettres"),
            RevisionCard(front: "ه", frontSub: "Hâ'", back: "H léger expiré. ≠ ح (guttural).", category: "Lettres")
        ], quizQuestions: [
            LessonQuiz(question: "Quelle est la différence entre ه et ح ?", options: ["Rien", "ه est léger, ح est guttural", "ح est léger, ه est guttural", "Les points"], correctIndex: 1, explanation: "Le Hâ' (ه) est un h léger expiré, tandis que le Hâ' (ح) est un h guttural profond."),
            LessonQuiz(question: "Pourquoi le Nûn (ن) est important en Tajwid ?", options: ["C'est la plus fréquente", "Il provoque des règles spéciales (Idgham, Ikhfa)", "Il est muet", "Il change de forme"], correctIndex: 1, explanation: "Le Nûn avec tanwin provoque des règles essentielles de Tajwid."),
            LessonQuiz(question: "Combien de lettres 'h' distinctes existent en arabe ?", options: ["1", "2", "3", "4"], correctIndex: 1, explanation: "L'arabe a deux h : ه (léger) et ح (guttural profond).")
        ])
    }

    var alphabetL8: ArabicLesson {
        ArabicLesson(id: "alph_8", title: "و ي — Les semi-voyelles + Récap", content: [
            LessonContent(type: .letter, title: "Wâw", arabicText: "و", transliteration: "w / û", translation: "27ème lettre", explanation: "Le Wâw se prononce comme le 'w' anglais ou le 'ou' français. Il peut servir de consonne ('w') ou de voyelle longue ('û'). Non-liante."),
            LessonContent(type: .letter, title: "Yâ'", arabicText: "ي", transliteration: "y / î", translation: "28ème lettre", explanation: "Le Yâ' se prononce comme le 'y' de 'yaourt' ou le 'i' long. Deux points en dessous. C'est la dernière lettre de l'alphabet arabe. Il peut être consonne ('y') ou voyelle longue ('î')."),
            LessonContent(type: .rule, title: "Récapitulatif", arabicText: "أ ب ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل م ن ه و ي", transliteration: "Alif Bâ Tâ Thâ Jîm Hâ Khâ Dâl Dhâl Râ Zây Sîn Shîn Sâd Dâd Tâ Dhâ 'Ayn Ghayn Fâ Qâf Kâf Lâm Mîm Nûn Hâ Wâw Yâ", translation: "Les 28 lettres", explanation: "Bravo ! Tu connais maintenant les 28 lettres de l'alphabet arabe. 6 lettres sont non-liantes (أ د ذ ر ز و) : elles ne s'attachent pas à la lettre suivante. Les lettres emphatiques (ص ض ط ظ) se prononcent avec un son grave et lourd.")
        ], revisionCards: [
            RevisionCard(front: "و", frontSub: "Wâw", back: "Son 'w/ou'. Consonne ou voyelle longue. Non-liante.", category: "Lettres"),
            RevisionCard(front: "ي", frontSub: "Yâ'", back: "Son 'y/î'. Deux points en dessous. Dernière lettre.", category: "Lettres")
        ], quizQuestions: [
            LessonQuiz(question: "Combien de lettres a l'alphabet arabe ?", options: ["24", "26", "28", "30"], correctIndex: 2, explanation: "L'alphabet arabe compte 28 lettres."),
            LessonQuiz(question: "Combien de lettres sont non-liantes ?", options: ["4", "6", "8", "10"], correctIndex: 1, explanation: "6 lettres non-liantes : أ د ذ ر ز و — elles ne s'attachent pas à la lettre suivante."),
            LessonQuiz(question: "Le Wâw (و) peut être :", options: ["Seulement consonne", "Seulement voyelle", "Consonne ou voyelle longue", "Muet"], correctIndex: 2, explanation: "Le Wâw peut être consonne ('w') ou voyelle longue ('û').")
        ])
    }

    // MARK: - VOWELS COURSE

    var vowelsCourse: ArabicCourse {
        ArabicCourse(
            id: "vowels", title: "Les Voyelles (Harakat)", description: "Voyelles courtes, longues, tanwin et sukun",
            icon: "🔤", level: .debutant, duration: "2 semaines",
            lessons: [vowelsL1, vowelsL2, vowelsL3]
        )
    }

    var vowelsL1: ArabicLesson {
        ArabicLesson(id: "vow_1", title: "Les voyelles courtes : Fatha, Kasra, Damma", content: [
            LessonContent(type: .vowel, title: "Fatha", arabicText: "بَ", transliteration: "ba", translation: "Voyelle 'a'", explanation: "La Fatha est un petit trait diagonal AU-DESSUS de la lettre. Elle donne le son 'a'. Exemples : بَ = ba, تَ = ta, سَ = sa."),
            LessonContent(type: .vowel, title: "Kasra", arabicText: "بِ", transliteration: "bi", translation: "Voyelle 'i'", explanation: "La Kasra est un petit trait diagonal EN-DESSOUS de la lettre. Elle donne le son 'i'. Exemples : بِ = bi, تِ = ti, سِ = si."),
            LessonContent(type: .vowel, title: "Damma", arabicText: "بُ", transliteration: "bu", translation: "Voyelle 'ou'", explanation: "La Damma est un petit و miniature AU-DESSUS de la lettre. Elle donne le son 'ou'. Exemples : بُ = bu, تُ = tu, سُ = su.")
        ], revisionCards: [
            RevisionCard(front: "بَ", frontSub: "Fatha", back: "Son 'a' — trait au-dessus", category: "Voyelles"),
            RevisionCard(front: "بِ", frontSub: "Kasra", back: "Son 'i' — trait en-dessous", category: "Voyelles"),
            RevisionCard(front: "بُ", frontSub: "Damma", back: "Son 'ou' — petit waw au-dessus", category: "Voyelles")
        ], quizQuestions: [
            LessonQuiz(question: "Quel son produit la Fatha ?", options: ["i", "a", "ou", "an"], correctIndex: 1, explanation: "La Fatha produit le son 'a'."),
            LessonQuiz(question: "Où se place la Kasra ?", options: ["Au-dessus", "En-dessous", "À côté", "Devant"], correctIndex: 1, explanation: "La Kasra se place en-dessous de la lettre."),
            LessonQuiz(question: "Comment se lit تُ ?", options: ["ta", "ti", "tu", "tan"], correctIndex: 2, explanation: "La Damma donne le son 'ou', donc تُ = tu.")
        ])
    }

    var vowelsL2: ArabicLesson {
        ArabicLesson(id: "vow_2", title: "Sukun et Shadda", content: [
            LessonContent(type: .vowel, title: "Sukun", arabicText: "بْ", transliteration: "b (muet)", translation: "Absence de voyelle", explanation: "Le Sukun est un petit cercle au-dessus de la lettre. Il indique l'ABSENCE de voyelle. La lettre est prononcée seule. Exemple : مَكْتَب (mak-tab = bureau)."),
            LessonContent(type: .vowel, title: "Shadda", arabicText: "بَّ", transliteration: "bb (doublé)", translation: "Gémination", explanation: "La Shadda ressemble à un petit 'w'. Elle double la consonne. Exemple : كَبَّرَ (kab-ba-ra). C'est essentiel pour la bonne prononciation du Coran."),
            LessonContent(type: .vowel, title: "Tanwin Fath", arabicText: "ـًا", transliteration: "-an", translation: "Nounation 'an'", explanation: "Le Tanwin est un redoublement de voyelle en fin de mot. Fatha doublée (ً) = son 'an'. Exemple : كِتَابًا (kitâban).")
        ], revisionCards: [
            RevisionCard(front: "بْ", frontSub: "Sukun", back: "Cercle : absence de voyelle. Lettre muette.", category: "Voyelles"),
            RevisionCard(front: "بَّ", frontSub: "Shadda", back: "Double la consonne. Petit w au-dessus.", category: "Voyelles"),
            RevisionCard(front: "ـًا", frontSub: "Tanwin", back: "Nounation : an/in/un en fin de mot.", category: "Voyelles")
        ], quizQuestions: [
            LessonQuiz(question: "Que signifie le Sukun sur une lettre ?", options: ["Son 'a'", "Absence de voyelle", "Doublement", "Son nasal"], correctIndex: 1, explanation: "Le Sukun indique l'absence de voyelle."),
            LessonQuiz(question: "Que fait la Shadda ?", options: ["Allonge la voyelle", "Supprime la voyelle", "Double la consonne", "Rend la lettre muette"], correctIndex: 2, explanation: "La Shadda double la consonne sur laquelle elle se trouve."),
            LessonQuiz(question: "Comment se lit كِتَابًا ?", options: ["kitâba", "kitâban", "kitâbi", "kitâbu"], correctIndex: 1, explanation: "Le Tanwin Fath donne le son 'an' en fin de mot.")
        ])
    }

    var vowelsL3: ArabicLesson {
        ArabicLesson(id: "vow_3", title: "Les voyelles longues : â, î, û", content: [
            LessonContent(type: .vowel, title: "Alif long (â)", arabicText: "بَا", transliteration: "bâ", translation: "A long", explanation: "Fatha + Alif = voyelle longue 'â'. On allonge le 'a' sur deux temps. Exemples : كَاتِب (kâtib = écrivain), بَاب (bâb = porte)."),
            LessonContent(type: .vowel, title: "Yâ' long (î)", arabicText: "بِي", transliteration: "bî", translation: "I long", explanation: "Kasra + Yâ' = voyelle longue 'î'. On allonge le 'i' sur deux temps. Exemples : كَبِير (kabîr = grand), جَمِيل (jamîl = beau)."),
            LessonContent(type: .vowel, title: "Wâw long (û)", arabicText: "بُو", transliteration: "bû", translation: "OU long", explanation: "Damma + Wâw = voyelle longue 'û'. On allonge le 'ou' sur deux temps. Exemples : نُور (nûr = lumière), رَسُول (rasûl = messager).")
        ], revisionCards: [
            RevisionCard(front: "بَا", frontSub: "Fatha + Alif", back: "Voyelle longue â (2 temps)", category: "Voyelles"),
            RevisionCard(front: "بِي", frontSub: "Kasra + Yâ'", back: "Voyelle longue î (2 temps)", category: "Voyelles"),
            RevisionCard(front: "بُو", frontSub: "Damma + Wâw", back: "Voyelle longue û (2 temps)", category: "Voyelles")
        ], quizQuestions: [
            LessonQuiz(question: "Comment forme-t-on un 'â' long ?", options: ["Fatha + Wâw", "Fatha + Alif", "Kasra + Alif", "Damma + Alif"], correctIndex: 1, explanation: "Fatha + Alif = voyelle longue â."),
            LessonQuiz(question: "Que signifie نُور (nûr) ?", options: ["Feu", "Eau", "Lumière", "Terre"], correctIndex: 2, explanation: "نُور (nûr) signifie 'lumière'."),
            LessonQuiz(question: "Combien de temps dure une voyelle longue ?", options: ["1 temps", "2 temps", "3 temps", "4 temps"], correctIndex: 1, explanation: "Une voyelle longue se prononce sur 2 temps, contre 1 pour une courte.")
        ])
    }

    // MARK: - READING / TAJWID COURSE

    var readingCourse: ArabicCourse {
        ArabicCourse(
            id: "reading", title: "Lecture Coranique & Tajwid", description: "Règles de base pour lire le Coran correctement",
            icon: "📖", level: .debutant, duration: "4 semaines",
            lessons: [readingL1, readingL2]
        )
    }

    var readingL1: ArabicLesson {
        ArabicLesson(id: "read_1", title: "Introduction au Tajwid", content: [
            LessonContent(type: .rule, title: "Qu'est-ce que le Tajwid ?", arabicText: "تَجْوِيد", transliteration: "Tajwîd", translation: "Embellissement", explanation: "Le Tajwid signifie 'embellissement'. C'est l'art de réciter le Coran correctement en respectant les règles de prononciation. C'est une obligation pour tout musulman."),
            LessonContent(type: .rule, title: "Makharij al-Huruf", arabicText: "مَخَارِج الحُرُوف", transliteration: "Makhârij al-Hurûf", translation: "Points d'articulation", explanation: "Chaque lettre arabe a un point de sortie dans la bouche, la gorge ou le nez. Les 5 zones : la gorge (حلق), la langue (لسان), les lèvres (شفتان), le nez (خيشوم), la cavité buccale (جوف)."),
            LessonContent(type: .rule, title: "Les lettres solaires et lunaires", arabicText: "الحُرُوف الشَّمْسِيَّة وَالقَمَرِيَّة", transliteration: "Al-hurûf ash-shamsiyya wal-qamariyya", translation: "Lettres solaires et lunaires", explanation: "Avec l'article 'al' (الـ) : les lettres solaires assimilent le Lâm (on ne prononce pas le 'l'). Exemple : الشَّمس (ash-shams, pas al-shams). Les lettres lunaires gardent le 'l'. Exemple : القَمَر (al-qamar).")
        ], revisionCards: [
            RevisionCard(front: "تَجْوِيد", frontSub: "Tajwîd", back: "Art de réciter le Coran correctement.", category: "Tajwid"),
            RevisionCard(front: "مَخَارِج", frontSub: "Makhârij", back: "Points d'articulation des lettres.", category: "Tajwid")
        ], quizQuestions: [
            LessonQuiz(question: "Que signifie Tajwid ?", options: ["Rapidité", "Embellissement", "Mémorisation", "Traduction"], correctIndex: 1, explanation: "Tajwid signifie 'embellissement' de la récitation."),
            LessonQuiz(question: "Comment se prononce الشَّمس ?", options: ["al-shams", "ash-shams", "a-shams", "el-shams"], correctIndex: 1, explanation: "Le Shîn est une lettre solaire, le Lâm est assimilé : ash-shams.")
        ])
    }

    var readingL2: ArabicLesson {
        ArabicLesson(id: "read_2", title: "Règles du Nûn et Tanwin", content: [
            LessonContent(type: .rule, title: "Idghâm", arabicText: "إِدْغَام", transliteration: "Idghâm", translation: "Fusion", explanation: "Si un Nûn sakina ou Tanwin est suivi de ي ن م و ل ر, la lettre fusionne. Avec ghunna (nasalisation) pour ي ن م و, sans ghunna pour ل ر."),
            LessonContent(type: .rule, title: "Ikhfâ'", arabicText: "إِخْفَاء", transliteration: "Ikhfâ'", translation: "Dissimulation", explanation: "Si un Nûn sakina ou Tanwin est suivi de 15 lettres spécifiques (ت ث ج د ذ ز س ش ص ض ط ظ ف ق ك), le son est dissimulé avec nasalisation."),
            LessonContent(type: .rule, title: "Izhar", arabicText: "إِظْهَار", transliteration: "Izhâr", translation: "Manifestation claire", explanation: "Si un Nûn sakina ou Tanwin est suivi de أ ه ع ح غ خ (lettres de la gorge), le Nûn est prononcé clairement.")
        ], revisionCards: [
            RevisionCard(front: "إِدْغَام", frontSub: "Idghâm", back: "Fusion du Nûn avec certaines lettres.", category: "Tajwid"),
            RevisionCard(front: "إِخْفَاء", frontSub: "Ikhfâ'", back: "Dissimulation nasalisée du Nûn.", category: "Tajwid"),
            RevisionCard(front: "إِظْهَار", frontSub: "Izhâr", back: "Prononciation claire du Nûn (lettres de gorge).", category: "Tajwid")
        ], quizQuestions: [
            LessonQuiz(question: "Quand applique-t-on l'Izhâr ?", options: ["Avec les lettres de la gorge", "Avec toutes les lettres", "Avec ي ن م و", "Jamais"], correctIndex: 0, explanation: "L'Izhâr s'applique quand le Nûn sakina est suivi d'une lettre de la gorge (أ ه ع ح غ خ)."),
            LessonQuiz(question: "Combien de lettres provoquent l'Ikhfâ' ?", options: ["5", "10", "15", "20"], correctIndex: 2, explanation: "15 lettres spécifiques provoquent l'Ikhfâ' du Nûn sakina.")
        ])
    }

    // MARK: - VOCABULARY COURSE

    var vocabularyCourse: ArabicCourse {
        ArabicCourse(
            id: "vocabulary", title: "Vocabulaire Islamique", description: "Les mots essentiels pour comprendre l'Islam",
            icon: "📗", level: .debutant, duration: "3 semaines",
            lessons: [vocabL1, vocabL2]
        )
    }

    var vocabL1: ArabicLesson {
        ArabicLesson(id: "vocab_1", title: "Les mots fondamentaux", content: [
            LessonContent(type: .word, title: "Allah", arabicText: "الله", transliteration: "Allâh", translation: "Dieu", explanation: "Le nom propre de Dieu en arabe. Utilisé par les musulmans, chrétiens arabes et juifs arabophones."),
            LessonContent(type: .word, title: "Islam", arabicText: "إِسْلَام", transliteration: "Islâm", translation: "Soumission à Dieu", explanation: "Racine S-L-M = paix et soumission. L'Islam est la soumission volontaire à la volonté de Dieu."),
            LessonContent(type: .word, title: "Salaam", arabicText: "سَلَام", transliteration: "Salâm", translation: "Paix", explanation: "Même racine qu'Islam. Le salut 'As-Salamu Alaykum' = Que la paix soit sur vous."),
            LessonContent(type: .word, title: "Iman", arabicText: "إِيمَان", transliteration: "Îmân", translation: "Foi", explanation: "La foi intérieure. Comprend la croyance en Allah, Ses anges, Ses livres, Ses messagers, le Jour dernier et le destin.")
        ], revisionCards: [
            RevisionCard(front: "الله", frontSub: "Allâh", back: "Dieu — Le nom propre de Dieu", category: "Fondamentaux"),
            RevisionCard(front: "إِسْلَام", frontSub: "Islâm", back: "Soumission volontaire à Dieu. Racine S-L-M.", category: "Fondamentaux"),
            RevisionCard(front: "سَلَام", frontSub: "Salâm", back: "Paix", category: "Fondamentaux"),
            RevisionCard(front: "إِيمَان", frontSub: "Îmân", back: "Foi intérieure du croyant", category: "Fondamentaux")
        ], quizQuestions: [
            LessonQuiz(question: "Que signifie إِسْلَام ?", options: ["Paix", "Foi", "Soumission à Dieu", "Prière"], correctIndex: 2, explanation: "Islam signifie soumission volontaire à la volonté de Dieu."),
            LessonQuiz(question: "Quelle racine partagent Islam et Salaam ?", options: ["S-L-M", "A-L-H", "I-M-N", "Q-R-A"], correctIndex: 0, explanation: "Islam et Salaam partagent la racine S-L-M (paix/soumission).")
        ])
    }

    var vocabL2: ArabicLesson {
        ArabicLesson(id: "vocab_2", title: "Vocabulaire de la prière", content: [
            LessonContent(type: .word, title: "Salat", arabicText: "صَلَاة", transliteration: "Salât", translation: "Prière", explanation: "Le 2ème pilier de l'Islam. 5 prières obligatoires par jour."),
            LessonContent(type: .word, title: "Ruku'", arabicText: "رُكُوع", transliteration: "Rukû'", translation: "Inclinaison", explanation: "L'inclinaison dans la prière, les mains sur les genoux."),
            LessonContent(type: .word, title: "Sujud", arabicText: "سُجُود", transliteration: "Sujûd", translation: "Prosternation", explanation: "Se prosterner face au sol. Le moment le plus proche d'Allah."),
            LessonContent(type: .word, title: "Qibla", arabicText: "قِبْلَة", transliteration: "Qibla", translation: "Direction de prière", explanation: "La direction de La Mecque (la Ka'ba) vers laquelle les musulmans prient.")
        ], revisionCards: [
            RevisionCard(front: "صَلَاة", frontSub: "Salât", back: "Prière — 2ème pilier de l'Islam", category: "Prière"),
            RevisionCard(front: "رُكُوع", frontSub: "Rukû'", back: "Inclinaison dans la prière", category: "Prière"),
            RevisionCard(front: "سُجُود", frontSub: "Sujûd", back: "Prosternation — moment le plus proche d'Allah", category: "Prière"),
            RevisionCard(front: "قِبْلَة", frontSub: "Qibla", back: "Direction de La Mecque", category: "Prière")
        ], quizQuestions: [
            LessonQuiz(question: "Que signifie سُجُود ?", options: ["Inclinaison", "Prosternation", "Debout", "Assis"], correctIndex: 1, explanation: "Sujûd signifie prosternation face au sol."),
            LessonQuiz(question: "Vers quelle direction pointe la Qibla ?", options: ["Médine", "Jérusalem", "La Mecque", "Le Caire"], correctIndex: 2, explanation: "La Qibla pointe vers La Mecque (la Ka'ba).")
        ])
    }

    // MARK: - GRAMMAR COURSE

    var grammarCourse: ArabicCourse {
        ArabicCourse(
            id: "grammar", title: "Grammaire Arabe (Nahw)", description: "Introduction à la grammaire arabe",
            icon: "✏️", level: .intermediaire, duration: "6 semaines",
            lessons: [grammarL1]
        )
    }

    var grammarL1: ArabicLesson {
        ArabicLesson(id: "gram_1", title: "La phrase nominale", content: [
            LessonContent(type: .rule, title: "Structure de base", arabicText: "الجُمْلَة الاسْمِيَّة", transliteration: "Al-Jumla Al-Ismiyya", translation: "Phrase nominale", explanation: "En arabe, la phrase nominale commence par un nom (Mubtada') suivi d'un attribut (Khabar). Exemple : الكِتَابُ جَمِيلٌ (Le livre est beau). Pas de verbe 'être' au présent."),
            LessonContent(type: .rule, title: "Le Mubtada' (Sujet)", arabicText: "المُبْتَدَأ", transliteration: "Al-Mubtada'", translation: "Le sujet", explanation: "Premier élément de la phrase nominale. Toujours au cas nominatif (marfou')."),
            LessonContent(type: .rule, title: "Le Khabar (Attribut)", arabicText: "الخَبَر", transliteration: "Al-Khabar", translation: "L'attribut", explanation: "Ce qu'on dit à propos du sujet. Aussi au cas nominatif.")
        ], revisionCards: [
            RevisionCard(front: "المُبْتَدَأ", frontSub: "Al-Mubtada'", back: "Sujet de la phrase nominale. Cas nominatif.", category: "Grammaire"),
            RevisionCard(front: "الخَبَر", frontSub: "Al-Khabar", back: "Attribut/prédicat. Ce qu'on dit du sujet.", category: "Grammaire")
        ], quizQuestions: [
            LessonQuiz(question: "Par quoi commence une phrase nominale ?", options: ["Un verbe", "Un nom", "Une préposition", "Un adverbe"], correctIndex: 1, explanation: "La phrase nominale commence toujours par un nom (Mubtada').")
        ])
    }
}
