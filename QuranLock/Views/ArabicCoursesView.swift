import SwiftUI

struct ArabicCoursesView: View {
    @EnvironmentObject var courseManager: ArabicCourseManager
    @State private var selectedCourse: ArabicCourse?

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        if courseManager.selectedRhythm == nil {
                            rhythmSelectionCard
                        } else {
                            rhythmInfoCard
                            progressCard
                            coursesSection
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
        }
    }

    // MARK: - Rhythm Selection
    var rhythmSelectionCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 6) {
                Text("🎯").font(.system(size: 50))
                Text("Choisis ton rythme d'apprentissage")
                    .font(.title2.bold()).foregroundColor(Theme.gold).multilineTextAlignment(.center)
                Text("L'application s'adaptera à ton rythme pour t'aider à progresser durablement")
                    .font(.subheadline).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center)
            }
            .padding(.top, 10)

            ForEach(LearningRhythm.allCases, id: \.rawValue) { rhythm in
                Button(action: { courseManager.selectRhythm(rhythm) }) {
                    HStack(spacing: 16) {
                        Text(rhythm.icon).font(.system(size: 36))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(rhythm.rawValue).font(.headline).foregroundColor(.white)
                            Text(rhythm.description).font(.caption).foregroundColor(Theme.textSecondary)
                            Text("\(rhythm.lessonsPerWeek) leçons/semaine").font(.caption2).foregroundColor(Theme.accent)
                        }
                        Spacer()
                        Image(systemName: "chevron.right.circle.fill").foregroundColor(Theme.gold).font(.title3)
                    }
                    .padding(16)
                    .background(Theme.cardBg).cornerRadius(16)
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
                Text("Rythme : \(courseManager.selectedRhythm?.rawValue ?? "")")
                    .font(.subheadline.bold()).foregroundColor(.white)
                Text(courseManager.selectedRhythm?.description ?? "")
                    .font(.caption).foregroundColor(Theme.textSecondary)
            }
            Spacer()
            Button("Changer") { courseManager.selectedRhythm = nil }
                .font(.caption).foregroundColor(Theme.gold)
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
            Text("\(courseManager.completedLessonIds.count) leçons complétées")
                .font(.caption).foregroundColor(Theme.textSecondary)
        }
        .cardStyle()
    }

    var coursesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📚 Cours disponibles").font(.headline).foregroundColor(.white)
            ForEach(courseManager.courses) { course in
                CourseCard(course: course, completedIds: courseManager.completedLessonIds)
                    .onTapGesture { selectedCourse = course }
            }
        }
    }
}

// MARK: - Course Card
struct CourseCard: View {
    let course: ArabicCourse
    let completedIds: [String]

    var completedCount: Int {
        course.lessons.filter { completedIds.contains($0.id) }.count
    }
    var progress: Double {
        guard !course.lessons.isEmpty else { return 0 }
        return Double(completedCount) / Double(course.lessons.count)
    }

    var levelColor: Color {
        switch course.level {
        case .debutant: return Theme.success
        case .intermediaire: return .yellow
        case .avance: return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(course.icon).font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(course.title).font(.headline).foregroundColor(.white)
                    Text(course.description).font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(course.level.rawValue).font(.caption.bold()).foregroundColor(levelColor)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(levelColor.opacity(0.15)).cornerRadius(8)
                    Text(course.duration).font(.caption2).foregroundColor(Theme.textSecondary)
                }
            }

            ProgressView(value: progress).tint(Theme.gold)
            HStack {
                Text("\(completedCount)/\(course.lessons.count) leçons").font(.caption).foregroundColor(Theme.textSecondary)
                Spacer()
                if progress >= 1.0 {
                    Text("✅ Complété").font(.caption.bold()).foregroundColor(Theme.success)
                } else {
                    Text("Commencer →").font(.caption.bold()).foregroundColor(Theme.gold)
                }
            }
        }
        .cardStyle()
    }
}

// MARK: - Course Detail (3 tabs: Cours / Fiches / Quiz)
struct CourseDetailView: View {
    let course: ArabicCourse
    @EnvironmentObject var courseManager: ArabicCourseManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = 0
    @State private var selectedLesson: ArabicLesson?
    @State private var quizActive = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Tab selector
                    HStack(spacing: 0) {
                        tabButton("📚 Cours", index: 0)
                        tabButton("🗂️ Fiches", index: 1)
                        tabButton("✅ Quiz", index: 2)
                    }
                    .background(Theme.secondaryBg)

                    ScrollView {
                        VStack(spacing: 14) {
                            if selectedTab == 0 { lessonsTab }
                            else if selectedTab == 1 { fichesTab }
                            else { quizTab }
                        }
                        .padding(16)
                    }
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

    func tabButton(_ title: String, index: Int) -> some View {
        Button(action: { selectedTab = index }) {
            Text(title).font(.caption.bold())
                .foregroundColor(selectedTab == index ? .black : Theme.textSecondary)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(selectedTab == index ? Theme.gold : Color.clear)
        }
    }

    // MARK: Lessons Tab
    var lessonsTab: some View {
        VStack(spacing: 12) {
            ForEach(course.lessons) { lesson in
                let isCompleted = courseManager.completedLessonIds.contains(lesson.id)
                Button(action: { selectedLesson = lesson }) {
                    HStack {
                        ZStack {
                            Circle().fill(isCompleted ? Theme.success : Theme.secondaryBg).frame(width: 36, height: 36)
                            if isCompleted {
                                Image(systemName: "checkmark").font(.caption.bold()).foregroundColor(.white)
                            } else {
                                Text("\(course.lessons.firstIndex(where: { $0.id == lesson.id })! + 1)")
                                    .font(.caption.bold()).foregroundColor(Theme.gold)
                            }
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(lesson.title).font(.subheadline.bold()).foregroundColor(.white)
                            Text("\(lesson.content.count) éléments • \(lesson.revisionCards.count) fiches • \(lesson.quizQuestions.count) questions")
                                .font(.caption).foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(Theme.textSecondary)
                    }
                    .padding(14).background(Theme.cardBg).cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(isCompleted ? Theme.success.opacity(0.4) : Theme.cardBorder, lineWidth: 1))
                }
            }
        }
    }

    // MARK: Fiches Tab
    var fichesTab: some View {
        VStack(spacing: 12) {
            let allCards = course.lessons.flatMap { $0.revisionCards }
            if allCards.isEmpty {
                Text("Complete les leçons pour débloquer les fiches de révision.")
                    .font(.subheadline).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center).padding()
            } else {
                ForEach(allCards) { card in
                    FlashCard(card: card)
                }
            }
        }
    }

    // MARK: Quiz Tab
    var quizTab: some View {
        let allQuiz = course.lessons.flatMap { $0.quizQuestions }
        return VStack(spacing: 14) {
            if allQuiz.isEmpty {
                Text("Complete les leçons pour débloquer le quiz final.")
                    .font(.subheadline).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center).padding()
            } else {
                LessonQuizView(questions: allQuiz)
            }
        }
    }
}

// MARK: - Flash Card (tap to reveal)
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

// MARK: - Lesson View
struct LessonView: View {
    let lesson: ArabicLesson
    let courseId: String
    @EnvironmentObject var courseManager: ArabicCourseManager
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0

    enum LessonPage: Int, CaseIterable { case cours = 0, fiches = 1, quiz = 2 }

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
                        Text(item.explanation).font(.subheadline).foregroundColor(.white).lineSpacing(4)
                    }
                }
                .padding(14).background(Theme.cardBg).cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
            }

            Button(action: {
                courseManager.completedLessonIds = courseManager.completedLessonIds + (courseManager.completedLessonIds.contains(lesson.id) ? [] : [lesson.id])
                courseManager.updateProgress()
            }) {
                Text(courseManager.completedLessonIds.contains(lesson.id) ? "✅ Leçon complétée" : "Marquer comme terminée")
                    .goldButton()
            }
            .disabled(courseManager.completedLessonIds.contains(lesson.id))
            .opacity(courseManager.completedLessonIds.contains(lesson.id) ? 0.6 : 1)
        }
    }

    var revisionCards: some View {
        VStack(spacing: 12) {
            if lesson.revisionCards.isEmpty {
                Text("Pas de fiches pour cette leçon.").font(.subheadline).foregroundColor(Theme.textSecondary).padding()
            } else {
                Text("Appuie sur une fiche pour voir la réponse").font(.caption).foregroundColor(Theme.textSecondary)
                ForEach(lesson.revisionCards) { card in FlashCard(card: card) }
            }
        }
    }

    var quizSection: some View {
        VStack(spacing: 12) {
            if lesson.quizQuestions.isEmpty {
                Text("Pas de quiz pour cette leçon.").font(.subheadline).foregroundColor(Theme.textSecondary).padding()
            } else {
                LessonQuizView(questions: lesson.quizQuestions)
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

                if let _ = selectedAnswer {
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
            Text("\(score)/\(questions.count)").font(.system(size: 48, weight: .bold)).foregroundColor(Theme.gold)
                .cardStyle()
            Button(action: {
                currentIdx = 0; score = 0; selectedAnswer = nil; finished = false
            }) { Text("Recommencer").goldButton() }
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
