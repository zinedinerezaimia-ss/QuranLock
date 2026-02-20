import SwiftUI

// MARK: - Main View
struct ArabicCoursesView: View {
    @EnvironmentObject var courseManager: ArabicCourseManager
    @State private var selectedCourse: ArabicCourse?
    @State private var showPlacementTest = false
    @State private var showDailyQuiz = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {

                        // Daily quiz banner
                        if courseManager.showDailyQuiz && !courseManager.completedLessonIds.isEmpty {
                            dailyQuizBanner
                        }

                        // Pas encore fait le test de niveau
                        if !courseManager.hasCompletedPlacementTest {
                            placementTestCard
                        } else {
                            // Rythme non choisi
                            if courseManager.selectedRhythm == nil {
                                rhythmSelectionCard
                            } else {
                                rhythmInfoCard
                                progressCard
                                modulesSection
                            }
                        }
                    }
                    .padding(.horizontal, 16).padding(.bottom, 20)
                }
            }
            .navigationTitle("🎓 Apprendre l'Arabe")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedCourse) { course in
                CourseDetailView(course: course)
                    .environmentObject(courseManager)
            }
            .sheet(isPresented: $showPlacementTest) {
                PlacementTestView()
                    .environmentObject(courseManager)
            }
            .sheet(isPresented: $showDailyQuiz) {
                DailyQuizView()
                    .environmentObject(courseManager)
            }
        }
    }

    // MARK: - Daily Quiz Banner
    var dailyQuizBanner: some View {
        Button(action: { showDailyQuiz = true }) {
            HStack(spacing: 14) {
                Text("📝").font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Quiz du jour disponible !").font(.headline).foregroundColor(.white)
                    Text("Révise les leçons d'hier pour consolider tes acquis").font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(Theme.gold)
            }
            .cardStyle()
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.gold.opacity(0.4), lineWidth: 1.5))
        }
    }

    // MARK: - Placement Test Card
    var placementTestCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("🎯").font(.system(size: 56))
                Text("Test de niveau").font(.title2.bold()).foregroundColor(Theme.gold)
                Text("10 questions pour identifier ton niveau et te proposer le bon module de départ.")
                    .font(.subheadline).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center)
                Text("⏱ Environ 3 minutes").font(.caption).foregroundColor(Theme.accent)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Ce que le test évalue :").font(.caption.bold()).foregroundColor(.white)
                testPoint("Reconnaissance des lettres arabes")
                testPoint("Compréhension des mots coraniques")
                testPoint("Connaissance des voyelles")
                testPoint("Vocabulaire islamique de base")
            }
            .padding(14).background(Theme.secondaryBg).cornerRadius(12)

            Button(action: { showPlacementTest = true }) {
                Text("Commencer le test →").goldButton()
            }

            Button(action: {
                courseManager.completePlacementTest(score: 0, total: 10)
                courseManager.recommendedModule = 1
                courseManager.savedRecommendedModule = 1
            }) {
                Text("Commencer depuis le début (Module 1)").font(.caption).foregroundColor(Theme.textSecondary)
            }
        }
        .padding(20)
        .background(Theme.cardBg).cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.cardBorder, lineWidth: 1))
    }

    func testPoint(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success).font(.caption)
            Text(text).font(.caption).foregroundColor(Theme.textSecondary)
        }
    }

    // MARK: - Rhythm Selection
    var rhythmSelectionCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 6) {
                Text("⚡").font(.system(size: 40))
                Text("Choisis ton rythme").font(.title2.bold()).foregroundColor(Theme.gold).multilineTextAlignment(.center)
                Text("Module recommandé : \(courseManager.recommendedModule)").font(.subheadline).foregroundColor(Theme.accent)
            }
            ForEach(LearningRhythm.allCases, id: \.rawValue) { rhythm in
                Button(action: { courseManager.selectRhythm(rhythm) }) {
                    HStack(spacing: 16) {
                        Text(rhythm.icon).font(.system(size: 32))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(rhythm.rawValue).font(.headline).foregroundColor(.white)
                            Text(rhythm.description).font(.caption).foregroundColor(Theme.textSecondary)
                            Text("\(rhythm.lessonsPerWeek) leçons/semaine").font(.caption2).foregroundColor(Theme.accent)
                        }
                        Spacer()
                        Image(systemName: "chevron.right.circle.fill").foregroundColor(Theme.gold).font(.title3)
                    }
                    .padding(16).background(Theme.cardBg).cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.cardBorder, lineWidth: 1))
                }
            }
        }
        .padding(16)
    }

    var rhythmInfoCard: some View {
        HStack {
            Text(courseManager.selectedRhythm?.icon ?? "📚").font(.title2)
            VStack(alignment: .leading) {
                Text("Rythme : \(courseManager.selectedRhythm?.rawValue ?? "")").font(.subheadline.bold()).foregroundColor(.white)
                Text(courseManager.selectedRhythm?.description ?? "").font(.caption).foregroundColor(Theme.textSecondary)
            }
            Spacer()
            Button("Changer") { courseManager.selectedRhythm = nil }.font(.caption).foregroundColor(Theme.gold)
        }
        .cardStyle()
    }

    var progressCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Ma Progression").font(.headline).foregroundColor(.white)
                Spacer()
                Text("\(Int(courseManager.overallProgress * 100))%").font(.headline).foregroundColor(Theme.gold)
            }
            ProgressView(value: courseManager.overallProgress).tint(Theme.gold)
            Text("\(courseManager.completedLessonIds.count) leçons complétées • Module recommandé : \(courseManager.recommendedModule)")
                .font(.caption).foregroundColor(Theme.textSecondary)
        }
        .cardStyle()
    }

    // MARK: - Modules Section
    var modulesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📚 Les 5 modules").font(.headline).foregroundColor(.white)
            ForEach(courseManager.courses) { course in
                ModuleCard(course: course, isUnlocked: courseManager.isModuleUnlocked(course.moduleNumber), isRecommended: course.moduleNumber == courseManager.recommendedModule)
                    .onTapGesture {
                        if courseManager.isModuleUnlocked(course.moduleNumber) {
                            selectedCourse = course
                        }
                    }
            }
        }
    }
}

// MARK: - Module Card
struct ModuleCard: View {
    let course: ArabicCourse
    let isUnlocked: Bool
    let isRecommended: Bool
    @EnvironmentObject var courseManager: ArabicCourseManager

    var completedCount: Int {
        course.lessons.filter { courseManager.isLessonCompleted($0.id) }.count
    }

    var progress: Double {
        guard !course.lessons.isEmpty else { return 0 }
        return Double(completedCount) / Double(course.lessons.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(course.icon).font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(course.title).font(.headline).foregroundColor(isUnlocked ? .white : Theme.textSecondary)
                        if isRecommended && isUnlocked {
                            Text("★ Recommandé").font(.caption2.bold()).foregroundColor(.black)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Theme.gold).cornerRadius(6)
                        }
                    }
                    Text(course.description).font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                if !isUnlocked {
                    Image(systemName: "lock.fill").foregroundColor(Theme.textSecondary).font(.title3)
                }
            }

            if isUnlocked {
                ProgressView(value: progress).tint(Theme.gold)
                HStack {
                    Text("\(completedCount)/\(course.lessons.count) leçons").font(.caption).foregroundColor(Theme.textSecondary)
                    Spacer()
                    if progress >= 1.0 {
                        Text("✅ Complété").font(.caption.bold()).foregroundColor(Theme.success)
                    } else {
                        Text("Ouvrir →").font(.caption.bold()).foregroundColor(Theme.gold)
                    }
                }
            } else {
                Text("🔒 Complète le module précédent pour débloquer").font(.caption).foregroundColor(Theme.textSecondary)
            }
        }
        .cardStyle()
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}

// MARK: - Placement Test View
struct PlacementTestView: View {
    @EnvironmentObject var courseManager: ArabicCourseManager
    @Environment(\.dismiss) var dismiss
    @State private var currentIdx = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var finished = false

    let questions = ArabicCourseManager.placementQuestions

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        if finished {
                            testResult
                        } else {
                            testQuestion
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Test de niveau")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !finished {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Annuler") { dismiss() }.foregroundColor(Theme.textSecondary)
                    }
                }
            }
        }
    }

    var testQuestion: some View {
        let q = questions[currentIdx]
        return VStack(spacing: 20) {
            // Progress
            VStack(spacing: 6) {
                HStack {
                    Text("Question \(currentIdx + 1)/\(questions.count)").font(.caption).foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("Score : \(score)").font(.caption.bold()).foregroundColor(Theme.gold)
                }
                ProgressView(value: Double(currentIdx + 1), total: Double(questions.count)).tint(Theme.gold)
            }

            // Question
            Text(q.question)
                .font(.title3.bold()).foregroundColor(.white).multilineTextAlignment(.center)
                .padding(20).background(Theme.cardBg).cornerRadius(14)
                .frame(maxWidth: .infinity)

            // Options
            ForEach(q.options.indices, id: \.self) { idx in
                Button(action: { selectAnswer(idx, correct: q.correctIndex) }) {
                    HStack {
                        Text(q.options[idx]).font(.subheadline).foregroundColor(.white)
                        Spacer()
                        if let sa = selectedAnswer {
                            if idx == q.correctIndex { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success) }
                            else if idx == sa { Image(systemName: "xmark.circle.fill").foregroundColor(.red) }
                        }
                    }
                    .padding(14)
                    .background(answerBg(idx, correct: q.correctIndex))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(answerBorder(idx, correct: q.correctIndex), lineWidth: 1.5))
                }
                .disabled(selectedAnswer != nil)
            }

            if selectedAnswer != nil {
                Button(action: nextQ) {
                    Text(currentIdx + 1 < questions.count ? "Suivant →" : "Voir mon résultat 🏆").goldButton()
                }
            }
        }
    }

    var testResult: some View {
        VStack(spacing: 24) {
            Text("🏆 Résultat du test").font(.title.bold()).foregroundColor(Theme.gold)

            VStack(spacing: 8) {
                Text("\(score)/\(questions.count)").font(.system(size: 56, weight: .bold)).foregroundColor(Theme.gold)
                Text("bonne(s) réponse(s)").font(.subheadline).foregroundColor(Theme.textSecondary)
            }
            .cardStyle()

            VStack(spacing: 10) {
                let recommended = getRecommendedModule()
                Text("Module recommandé").font(.headline).foregroundColor(.white)
                Text("Module \(recommended)").font(.system(size: 40, weight: .bold)).foregroundColor(Theme.gold)
                Text(moduleDescription(recommended)).font(.subheadline).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center)
            }
            .cardStyle()

            Button(action: {
                courseManager.completePlacementTest(score: score, total: questions.count)
                dismiss()
            }) {
                Text("Commencer à apprendre →").goldButton()
            }
        }
    }

    func getRecommendedModule() -> Int {
        let percent = Double(score) / Double(questions.count)
        if percent < 0.3 { return 1 }
        else if percent < 0.6 { return 2 }
        else if percent < 0.85 { return 3 }
        else { return 4 }
    }

    func moduleDescription(_ n: Int) -> String {
        switch n {
        case 1: return "Tu vas apprendre les bases de l'écriture arabe"
        case 2: return "Tu connais les lettres, on passe aux sons"
        case 3: return "Tu passes directement aux mots et au vocabulaire"
        case 4: return "Excellent ! Tu commences les phrases"
        default: return "Tu peux commencer directement l'arabe coranique"
        }
    }

    func answerBg(_ idx: Int, correct: Int) -> Color {
        guard let sa = selectedAnswer else { return Theme.cardBg }
        if idx == correct { return Theme.success.opacity(0.15) }
        if idx == sa { return Color.red.opacity(0.15) }
        return Theme.cardBg
    }

    func answerBorder(_ idx: Int, correct: Int) -> Color {
        guard let sa = selectedAnswer else { return Theme.cardBorder }
        if idx == correct { return Theme.success }
        if idx == sa { return .red }
        return Theme.cardBorder
    }

    func selectAnswer(_ idx: Int, correct: Int) {
        selectedAnswer = idx
        if idx == correct { score += 1 }
    }

    func nextQ() {
        if currentIdx + 1 < questions.count { currentIdx += 1; selectedAnswer = nil }
        else { finished = true }
    }
}

// MARK: - Daily Quiz View
struct DailyQuizView: View {
    @EnvironmentObject var courseManager: ArabicCourseManager
    @Environment(\.dismiss) var dismiss
    @State private var currentIdx = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var finished = false

    var questions: [LessonQuiz] { courseManager.dailyQuizQuestions }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        if finished {
                            quizResult
                        } else if !questions.isEmpty && currentIdx < questions.count {
                            quizHeader
                            quizContent
                        } else {
                            Text("Aucune question disponible.").foregroundColor(Theme.textSecondary)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("📝 Quiz du jour")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Passer") {
                        courseManager.completeDailyQuiz()
                        dismiss()
                    }.foregroundColor(Theme.textSecondary)
                }
            }
        }
    }

    var quizHeader: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Question \(currentIdx + 1)/\(questions.count)").font(.caption).foregroundColor(Theme.textSecondary)
                Spacer()
                Text("Score : \(score)").font(.caption.bold()).foregroundColor(Theme.gold)
            }
            ProgressView(value: Double(currentIdx + 1), total: Double(questions.count)).tint(Theme.gold)
        }
    }

    var quizContent: some View {
        let q = questions[currentIdx]
        return VStack(spacing: 14) {
            Text(q.question).font(.headline).foregroundColor(.white).multilineTextAlignment(.center)
                .padding().background(Theme.cardBg).cornerRadius(12).frame(maxWidth: .infinity)

            ForEach(q.options.indices, id: \.self) { idx in
                Button(action: { selectAnswer(idx, correct: q.correctIndex) }) {
                    HStack {
                        Text(q.options[idx]).font(.subheadline).foregroundColor(.white)
                        Spacer()
                        if let sa = selectedAnswer {
                            if idx == q.correctIndex { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success) }
                            else if idx == sa { Image(systemName: "xmark.circle.fill").foregroundColor(.red) }
                        }
                    }
                    .padding()
                    .background(answerBg(idx, correct: q.correctIndex))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(answerBorder(idx, correct: q.correctIndex), lineWidth: 1.5))
                }
                .disabled(selectedAnswer != nil)
            }

            if selectedAnswer != nil {
                Text(q.explanation).font(.subheadline).foregroundColor(.white)
                    .padding().background(Theme.secondaryBg).cornerRadius(12)
                Button(action: nextQ) {
                    Text(currentIdx + 1 < questions.count ? "Suivant →" : "Voir le résultat 🏆").goldButton()
                }
            }
        }
    }

    var quizResult: some View {
        VStack(spacing: 20) {
            Text("✅ Quiz terminé !").font(.title.bold()).foregroundColor(Theme.gold)
            Text("\(score)/\(questions.count)").font(.system(size: 48, weight: .bold)).foregroundColor(Theme.gold).cardStyle()
            Text(score == questions.count ? "Parfait ! Toutes les bonnes réponses 🌟" : "Continue comme ça, tu progresses !").font(.subheadline).foregroundColor(Theme.textSecondary)
            Button(action: {
                courseManager.completeDailyQuiz()
                dismiss()
            }) {
                Text("Continuer mes cours →").goldButton()
            }
        }
    }

    func answerBg(_ idx: Int, correct: Int) -> Color {
        guard let sa = selectedAnswer else { return Theme.cardBg }
        if idx == correct { return Theme.success.opacity(0.15) }
        if idx == sa { return Color.red.opacity(0.15) }
        return Theme.cardBg
    }

    func answerBorder(_ idx: Int, correct: Int) -> Color {
        guard let sa = selectedAnswer else { return Theme.cardBorder }
        if idx == correct { return Theme.success }
        if idx == sa { return .red }
        return Theme.cardBorder
    }

    func selectAnswer(_ idx: Int, correct: Int) {
        selectedAnswer = idx
        if idx == correct { score += 1 }
    }

    func nextQ() {
        if currentIdx + 1 < questions.count { currentIdx += 1; selectedAnswer = nil }
        else { finished = true }
    }
}

// MARK: - Course Detail View
struct CourseDetailView: View {
    let course: ArabicCourse
    @EnvironmentObject var courseManager: ArabicCourseManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedLesson: ArabicLesson?

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 14) {
                        // Module header
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(course.icon) \(course.title)").font(.title2.bold()).foregroundColor(Theme.gold)
                            Text(course.description).font(.subheadline).foregroundColor(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cardStyle()

                        Text("📚 Leçons").font(.headline).foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(Array(course.lessons.enumerated()), id: \.element.id) { index, lesson in
                            let isCompleted = courseManager.isLessonCompleted(lesson.id)
                            let isUnlocked = courseManager.isLessonUnlocked(lesson, in: course)

                            Button(action: {
                                if isUnlocked { selectedLesson = lesson }
                            }) {
                                HStack {
                                    ZStack {
                                        Circle().fill(isCompleted ? Theme.success : (isUnlocked ? Theme.secondaryBg : Theme.cardBg)).frame(width: 40, height: 40)
                                        if isCompleted {
                                            Image(systemName: "checkmark").font(.caption.bold()).foregroundColor(.white)
                                        } else if !isUnlocked {
                                            Image(systemName: "lock.fill").font(.caption).foregroundColor(Theme.textSecondary)
                                        } else {
                                            Text("\(index + 1)").font(.caption.bold()).foregroundColor(Theme.gold)
                                        }
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(lesson.title).font(.subheadline.bold())
                                            .foregroundColor(isUnlocked ? .white : Theme.textSecondary)
                                        Text("\(lesson.content.count) éléments • \(lesson.revisionCards.count) fiches • \(lesson.quizQuestions.count) questions")
                                            .font(.caption).foregroundColor(Theme.textSecondary)
                                    }
                                    Spacer()
                                    if isUnlocked && !isCompleted {
                                        Image(systemName: "chevron.right").foregroundColor(Theme.gold)
                                    } else if !isUnlocked {
                                        Text("🔒").font(.caption)
                                    }
                                }
                                .padding(14).background(Theme.cardBg).cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(isCompleted ? Theme.success.opacity(0.4) : Theme.cardBorder, lineWidth: 1))
                                .opacity(isUnlocked ? 1 : 0.5)
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle(course.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }.foregroundColor(Theme.gold)
                }
            }
            .sheet(item: $selectedLesson) { lesson in
                LessonView(lesson: lesson, courseId: course.id)
                    .environmentObject(courseManager)
            }
        }
    }
}

// MARK: - Lesson View
struct LessonView: View {
    let lesson: ArabicLesson
    let courseId: String
    @EnvironmentObject var courseManager: ArabicCourseManager
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        pageTab("📚 Cours", page: 0)
                        pageTab("🗂️ Fiches", page: 1)
                        pageTab("✅ Quiz", page: 2)
                    }
                    .background(Theme.secondaryBg)

                    ScrollView {
                        VStack(spacing: 14) {
                            if currentPage == 0 { lessonContent }
                            else if currentPage == 1 { revisionCards }
                            else { quizSection }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle(lesson.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }

    func pageTab(_ title: String, page: Int) -> some View {
        Button(action: { currentPage = page }) {
            Text(title).font(.caption.bold())
                .foregroundColor(currentPage == page ? .black : Theme.textSecondary)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(currentPage == page ? Theme.gold : Color.clear)
        }
    }

    var lessonContent: some View {
        VStack(spacing: 14) {
            ForEach(lesson.content) { item in
                VStack(alignment: .leading, spacing: 12) {
                    Text(item.title).font(.headline).foregroundColor(Theme.gold)
                    if !item.arabicText.isEmpty {
                        Text(item.arabicText)
                            .font(.system(size: 28, weight: .bold)).foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding().background(Theme.secondaryBg).cornerRadius(10)
                    }
                    if !item.transliteration.isEmpty {
                        Text("📢 \(item.transliteration)").font(.subheadline).foregroundColor(Theme.accent)
                    }
                    if !item.translation.isEmpty {
                        Text("🇫🇷 \(item.translation)").font(.subheadline).foregroundColor(Theme.textSecondary)
                    }
                    if !item.explanation.isEmpty {
                        Text(item.explanation).font(.subheadline).foregroundColor(.white).lineSpacing(5)
                    }
                }
                .padding(14).background(Theme.cardBg).cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
            }

            let isCompleted = courseManager.isLessonCompleted(lesson.id)
            Button(action: {
                if !isCompleted {
                    courseManager.completeLesson(lesson.id)
                }
            }) {
                Text(isCompleted ? "✅ Leçon complétée" : "Marquer comme terminée").goldButton()
            }
            .disabled(isCompleted)
            .opacity(isCompleted ? 0.6 : 1)
        }
    }

    var revisionCards: some View {
        VStack(spacing: 12) {
            if lesson.revisionCards.isEmpty {
                Text("Pas de fiches pour cette leçon.").foregroundColor(Theme.textSecondary).padding()
            } else {
                Text("Appuie pour voir la réponse").font(.caption).foregroundColor(Theme.textSecondary)
                ForEach(lesson.revisionCards) { card in FlashCard(card: card) }
            }
        }
    }

    var quizSection: some View {
        VStack(spacing: 12) {
            if lesson.quizQuestions.isEmpty {
                Text("Pas de quiz pour cette leçon.").foregroundColor(Theme.textSecondary).padding()
            } else {
                LessonQuizView(questions: lesson.quizQuestions)
            }
        }
    }
}

// MARK: - Flash Card
struct FlashCard: View {
    let card: RevisionCard
    @State private var flipped = false

    var body: some View {
        Button(action: { withAnimation(.spring()) { flipped.toggle() } }) {
            ZStack {
                if flipped {
                    VStack(spacing: 8) {
                        Text("✅ \(card.category)").font(.caption).foregroundColor(Theme.success)
                        Text(card.back).font(.title3.bold()).foregroundColor(.white).multilineTextAlignment(.center)
                        Text("Appuie pour revenir").font(.caption2).foregroundColor(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity).padding(20).background(Theme.success.opacity(0.1))
                    .cornerRadius(14).overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.success.opacity(0.4), lineWidth: 1))
                } else {
                    VStack(spacing: 8) {
                        Text(card.front).font(.system(size: 36, weight: .bold)).foregroundColor(Theme.gold)
                        Text(card.frontSub).font(.subheadline).foregroundColor(Theme.textSecondary)
                        Text("Appuie pour voir la réponse").font(.caption2).foregroundColor(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity).padding(20).background(Theme.cardBg)
                    .cornerRadius(14).overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
                }
            }
        }
    }
}

// MARK: - Lesson Quiz View
struct LessonQuizView: View {
    let questions: [LessonQuiz]
    @State private var currentIdx = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var finished = false

    var body: some View {
        if finished {
            quizResult
        } else if currentIdx < questions.count {
            let q = questions[currentIdx]
            VStack(spacing: 14) {
                HStack {
                    Text("Question \(currentIdx + 1)/\(questions.count)").font(.caption).foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("Score: \(score)").font(.caption.bold()).foregroundColor(Theme.gold)
                }
                ProgressView(value: Double(currentIdx + 1), total: Double(questions.count)).tint(Theme.gold)

                Text(q.question).font(.headline).foregroundColor(.white).multilineTextAlignment(.center)
                    .padding().background(Theme.cardBg).cornerRadius(12).frame(maxWidth: .infinity)

                ForEach(q.options.indices, id: \.self) { idx in
                    Button(action: { selectAnswer(idx, correctIndex: q.correctIndex) }) {
                        HStack {
                            Text(q.options[idx]).font(.subheadline).foregroundColor(.white)
                            Spacer()
                            if let sa = selectedAnswer {
                                if idx == q.correctIndex { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success) }
                                else if idx == sa { Image(systemName: "xmark.circle.fill").foregroundColor(.red) }
                            }
                        }
                        .padding()
                        .background(answerBg(idx, correct: q.correctIndex))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(answerBorder(idx, correct: q.correctIndex), lineWidth: 1.5))
                    }
                    .disabled(selectedAnswer != nil)
                }

                if selectedAnswer != nil {
                    Text(q.explanation).font(.subheadline).foregroundColor(.white)
                        .padding().background(Theme.secondaryBg).cornerRadius(12)
                    Button(action: nextQ) {
                        Text(currentIdx + 1 < questions.count ? "Suivant →" : "Résultats 🏆").goldButton()
                    }
                }
            }
        }
    }

    var quizResult: some View {
        VStack(spacing: 16) {
            Text("🏆 Résultat").font(.title.bold()).foregroundColor(Theme.gold)
            Text("\(score)/\(questions.count)").font(.system(size: 48, weight: .bold)).foregroundColor(Theme.gold).cardStyle()
            Button(action: { currentIdx = 0; score = 0; selectedAnswer = nil; finished = false }) {
                Text("Recommencer").goldButton()
            }
        }
    }

    func answerBg(_ idx: Int, correct: Int) -> Color {
        guard let sa = selectedAnswer else { return Theme.cardBg }
        if idx == correct { return Theme.success.opacity(0.15) }
        if idx == sa { return Color.red.opacity(0.15) }
        return Theme.cardBg
    }

    func answerBorder(_ idx: Int, correct: Int) -> Color {
        guard let sa = selectedAnswer else { return Theme.cardBorder }
        if idx == correct { return Theme.success }
        if idx == sa { return .red }
        return Theme.cardBorder
    }

    func selectAnswer(_ idx: Int, correctIndex: Int) {
        selectedAnswer = idx
        if idx == correctIndex { score += 1 }
    }

    func nextQ() {
        if currentIdx + 1 < questions.count { currentIdx += 1; selectedAnswer = nil }
        else { finished = true }
    }
}
