import SwiftUI

struct ArabicCoursesView: View {
    @EnvironmentObject var courseManager: ArabicCourseManager
    @State private var selectedCourse: ArabicCourse?
    @State private var showRhythmPicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Rhythm selection
                        if courseManager.selectedRhythm == nil {
                            rhythmSelectionCard
                        } else {
                            rhythmInfoCard
                        }
                        
                        // Progress
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Ma Progression")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(Int(courseManager.overallProgress * 100))%")
                                    .font(.headline)
                                    .foregroundColor(Theme.gold)
                            }
                            ProgressView(value: courseManager.overallProgress)
                                .tint(Theme.gold)
                        }
                        .cardStyle()
                        
                        // Course list
                        ForEach(courseManager.courses) { course in
                            CourseCard(course: course)
                                .onTapGesture { selectedCourse = course }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("🎓 Apprendre l'Arabe")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedCourse) { course in
                CourseDetailView(course: course)
            }
        }
    }
    
    var rhythmSelectionCard: some View {
        VStack(spacing: 16) {
            Text("🎯 Choisis ton rythme d'apprentissage")
                .font(.headline)
                .foregroundColor(Theme.gold)
            
            Text("L'app s'adaptera à ton rythme pour t'aider à progresser")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            ForEach(LearningRhythm.allCases, id: \.rawValue) { rhythm in
                Button(action: { courseManager.selectRhythm(rhythm) }) {
                    HStack {
                        Text(rhythm.icon).font(.title2)
                        VStack(alignment: .leading) {
                            Text(rhythm.rawValue)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(rhythm.description)
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Theme.secondaryBg)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                }
            }
        }
        .cardStyle()
    }
    
    var rhythmInfoCard: some View {
        HStack {
            Text(courseManager.selectedRhythm?.icon ?? "📚").font(.title2)
            VStack(alignment: .leading) {
                Text("Rythme : \(courseManager.selectedRhythm?.rawValue ?? "")")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text(courseManager.selectedRhythm?.description ?? "")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            Spacer()
            Button("Modifier") { courseManager.selectedRhythm = nil }
                .font(.caption)
                .foregroundColor(Theme.accent)
        }
        .cardStyle()
    }
}

struct CourseCard: View {
    let course: ArabicCourse
    @EnvironmentObject var courseManager: ArabicCourseManager
    
    var completedCount: Int {
        course.lessons.filter { courseManager.isLessonCompleted($0.id) }.count
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(course.icon)
                .font(.system(size: 36))
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(course.description)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "chart.bar.fill")
                        Text(course.level.rawValue)
                    }
                    .font(.caption)
                    .foregroundColor(Theme.gold)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(course.duration)
                    }
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark")
                        Text("\(completedCount)/\(course.lessons.count)")
                    }
                    .font(.caption)
                    .foregroundColor(Theme.success)
                }
                
                ProgressView(value: course.lessons.isEmpty ? 0 : Double(completedCount) / Double(course.lessons.count))
                    .tint(Theme.gold)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.gold)
        }
        .cardStyle()
    }
}

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
                    VStack(spacing: 16) {
                        Text(course.icon).font(.system(size: 60))
                        Text(course.title)
                            .font(.title2.bold())
                            .foregroundColor(Theme.gold)
                        Text(course.description)
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        ForEach(course.lessons) { lesson in
                            LessonRow(lesson: lesson, isCompleted: courseManager.isLessonCompleted(lesson.id))
                                .onTapGesture { selectedLesson = lesson }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Theme.gold)
                }
            }
            .sheet(item: $selectedLesson) { lesson in
                LessonView(lesson: lesson, courseId: course.id)
            }
        }
    }
}

struct LessonRow: View {
    let lesson: ArabicLesson
    let isCompleted: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isCompleted ? Theme.success : Theme.textSecondary)
            
            VStack(alignment: .leading) {
                Text(lesson.title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text("\(lesson.content.count) éléments • \(lesson.revisionCards.count) fiches • \(lesson.quizQuestions.count) questions")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.gold)
        }
        .cardStyle()
    }
}

struct LessonView: View {
    let lesson: ArabicLesson
    let courseId: String
    @EnvironmentObject var courseManager: ArabicCourseManager
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var currentTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Tab selector
                    HStack(spacing: 0) {
                        TabButton(title: "📚 Cours", isSelected: currentTab == 0) { currentTab = 0 }
                        TabButton(title: "🃏 Fiches", isSelected: currentTab == 1) { currentTab = 1 }
                        TabButton(title: "✅ Quiz", isSelected: currentTab == 2) { currentTab = 2 }
                    }
                    .padding(.horizontal)
                    
                    TabView(selection: $currentTab) {
                        lessonContent.tag(0)
                        revisionCards.tag(1)
                        lessonQuiz.tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .navigationTitle(lesson.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Theme.gold)
                }
            }
        }
    }
    
    var lessonContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(lesson.content) { item in
                    VStack(spacing: 10) {
                        Text(item.arabicText)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Theme.gold)
                        
                        Text(item.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(item.transliteration)
                            .font(.subheadline)
                            .foregroundColor(Theme.accent)
                        
                        Text(item.explanation)
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .cardStyle()
                }
            }
            .padding()
        }
    }
    
    var revisionCards: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Swipe pour voir les fiches")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                
                ForEach(lesson.revisionCards) { card in
                    RevisionCardView(card: card)
                }
            }
            .padding()
        }
    }
    
    var lessonQuiz: some View {
        LessonQuizView(questions: lesson.quizQuestions, onComplete: {
            courseManager.completeLesson(lesson.id)
            appState.addHasanat(5)
            dismiss()
        })
    }
}

struct RevisionCardView: View {
    let card: RevisionCard
    @State private var isFlipped = false
    
    var body: some View {
        VStack(spacing: 12) {
            if !isFlipped {
                Text(card.front)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Theme.gold)
                Text(card.frontSub)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Appuie pour retourner")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            } else {
                Text(card.back)
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text(card.category)
                    .font(.caption)
                    .foregroundColor(Theme.accent)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .cardStyle()
        .onTapGesture { withAnimation(.spring()) { isFlipped.toggle() } }
    }
}

struct LessonQuizView: View {
    let questions: [LessonQuiz]
    let onComplete: () -> Void
    @State private var currentIndex = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var showResult = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if showResult {
                    VStack(spacing: 16) {
                        Text(score == questions.count ? "🎉" : "📊")
                            .font(.system(size: 60))
                        Text("Résultat : \(score)/\(questions.count)")
                            .font(.title.bold())
                            .foregroundColor(Theme.gold)
                        
                        if score == questions.count {
                            Text("Parfait ! Leçon complétée ✅")
                                .foregroundColor(Theme.success)
                        } else {
                            Text("Continue à t'entraîner !")
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Button(action: onComplete) {
                            Text("Terminer").goldButton()
                        }
                    }
                    .padding()
                } else if currentIndex < questions.count {
                    let q = questions[currentIndex]
                    
                    Text("Question \(currentIndex + 1)/\(questions.count)")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    
                    Text(q.question)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    ForEach(q.options.indices, id: \.self) { i in
                        Button(action: {
                            selectedAnswer = i
                            if i == q.correctIndex { score += 1 }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                if currentIndex + 1 < questions.count {
                                    currentIndex += 1
                                    selectedAnswer = nil
                                } else {
                                    showResult = true
                                }
                            }
                        }) {
                            HStack {
                                Text(q.options[i])
                                    .foregroundColor(.white)
                                Spacer()
                                if let sel = selectedAnswer {
                                    if i == q.correctIndex {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success)
                                    } else if i == sel {
                                        Image(systemName: "xmark.circle.fill").foregroundColor(Theme.danger)
                                    }
                                }
                            }
                            .padding()
                            .background(selectedAnswer == i ? (i == q.correctIndex ? Theme.success.opacity(0.2) : Theme.danger.opacity(0.2)) : Theme.secondaryBg)
                            .cornerRadius(12)
                        }
                        .disabled(selectedAnswer != nil)
                    }
                    
                    if let sel = selectedAnswer, sel != q.correctIndex {
                        Text(q.explanation)
                            .font(.caption)
                            .foregroundColor(Theme.gold)
                            .padding()
                            .background(Theme.cardBg)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(isSelected ? Theme.gold : Theme.textSecondary)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Theme.gold.opacity(0.1) : Color.clear)
                .cornerRadius(8)
        }
    }
}
