import SwiftUI

struct QuizMainView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDifficulty: QuizDifficulty?
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var showResult = false
    @State private var showExplanation = false
    
    var questions: [QuizQuestion] {
        guard let diff = selectedDifficulty else { return [] }
        return DataProvider.quizQuestions.filter { $0.difficulty == diff }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        if selectedDifficulty == nil {
                            difficultySelection
                        } else if showResult {
                            resultView
                        } else if currentQuestionIndex < questions.count {
                            questionView
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("🧠 Quiz Islamique")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    var difficultySelection: some View {
        VStack(spacing: 16) {
            // High score
            VStack(spacing: 8) {
                Text("🏆 Meilleur Score")
                    .font(.headline)
                    .foregroundColor(Theme.gold)
                Text("\(appState.quizHighScore)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Theme.gold)
            }
            .cardStyle()
            
            Text("Choisis ton niveau")
                .font(.title3.bold())
                .foregroundColor(.white)
            
            ForEach(QuizDifficulty.allCases, id: \.rawValue) { diff in
                Button(action: { startQuiz(diff) }) {
                    HStack {
                        Text(diff.icon).font(.title2)
                        VStack(alignment: .leading) {
                            Text(diff.rawValue)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(diff.description)
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                        Text("\(DataProvider.quizQuestions.filter { $0.difficulty == diff }.count) Q")
                            .font(.caption.bold())
                            .foregroundColor(Theme.gold)
                    }
                    .cardStyle()
                }
            }
        }
    }
    
    var questionView: some View {
        let q = questions[currentQuestionIndex]
        
        return VStack(spacing: 16) {
            // Progress
            HStack {
                Text("Question \(currentQuestionIndex + 1)/\(questions.count)")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                Text("Score: \(score)")
                    .font(.caption.bold())
                    .foregroundColor(Theme.gold)
            }
            
            ProgressView(value: Double(currentQuestionIndex) / Double(questions.count))
                .tint(Theme.gold)
            
            // Category badge
            HStack {
                Text(q.category)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Theme.accent)
                    .cornerRadius(12)
                Spacer()
                Text(q.difficulty.icon)
            }
            
            // Question
            Text(q.question)
                .font(.title3.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.secondaryBg)
                .cornerRadius(16)
            
            // Options
            ForEach(q.options.indices, id: \.self) { i in
                Button(action: { answerQuestion(i) }) {
                    HStack {
                        Text(["A", "B", "C", "D"][i])
                            .font(.headline.bold())
                            .foregroundColor(Theme.gold)
                            .frame(width: 30, height: 30)
                            .background(Theme.gold.opacity(0.2))
                            .cornerRadius(15)
                        
                        Text(q.options[i])
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        if let sel = selectedAnswer {
                            if i == q.correctIndex {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Theme.success)
                            } else if i == sel {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Theme.danger)
                            }
                        }
                    }
                    .padding()
                    .background(answerBackground(for: i, correct: q.correctIndex))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(answerBorder(for: i, correct: q.correctIndex), lineWidth: 1)
                    )
                }
                .disabled(selectedAnswer != nil)
            }
            
            // Explanation
            if showExplanation {
                VStack(spacing: 8) {
                    Text("💡 Explication")
                        .font(.headline)
                        .foregroundColor(Theme.gold)
                    Text(q.explanation)
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .cardStyle()
                
                Button(action: nextQuestion) {
                    Text("Question suivante →").goldButton()
                }
            }
        }
    }
    
    var resultView: some View {
        VStack(spacing: 20) {
            Text(score == questions.count ? "🎉" : score >= questions.count / 2 ? "👏" : "📚")
                .font(.system(size: 80))
            
            Text("Résultat")
                .font(.title.bold())
                .foregroundColor(.white)
            
            Text("\(score)/\(questions.count)")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(Theme.gold)
            
            Text(resultMessage)
                .font(.headline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            Text("+ \(score * 2) hasanat gagnés")
                .font(.subheadline)
                .foregroundColor(Theme.success)
            
            VStack(spacing: 12) {
                Button(action: { startQuiz(selectedDifficulty!) }) {
                    Text("🔄 Recommencer").goldButton()
                }
                
                Button(action: resetQuiz) {
                    Text("Changer de niveau").outlineButton()
                }
            }
        }
        .cardStyle()
    }
    
    var resultMessage: String {
        let pct = Double(score) / Double(questions.count)
        if pct == 1.0 { return "Parfait ! MashaAllah ! 🌟" }
        if pct >= 0.75 { return "Excellent travail ! Continue comme ça !" }
        if pct >= 0.5 { return "Bien joué ! Tu progresses !" }
        return "Continue à apprendre, tu vas y arriver insha'Allah !"
    }
    
    func answerBackground(for index: Int, correct: Int) -> Color {
        guard let sel = selectedAnswer else { return Theme.secondaryBg }
        if index == correct { return Theme.success.opacity(0.2) }
        if index == sel { return Theme.danger.opacity(0.2) }
        return Theme.secondaryBg
    }
    
    func answerBorder(for index: Int, correct: Int) -> Color {
        guard let sel = selectedAnswer else { return Theme.cardBorder }
        if index == correct { return Theme.success }
        if index == sel { return Theme.danger }
        return Theme.cardBorder
    }
    
    func startQuiz(_ difficulty: QuizDifficulty) {
        selectedDifficulty = difficulty
        currentQuestionIndex = 0
        selectedAnswer = nil
        score = 0
        showResult = false
        showExplanation = false
    }
    
    func answerQuestion(_ index: Int) {
        selectedAnswer = index
        if index == questions[currentQuestionIndex].correctIndex {
            score += 1
        }
        showExplanation = true
    }
    
    func nextQuestion() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showExplanation = false
        } else {
            showResult = true
            appState.addHasanat(score * 2)
            if score > appState.quizHighScore {
                appState.quizHighScore = score
            }
        }
    }
    
    func resetQuiz() {
        selectedDifficulty = nil
        showResult = false
    }
}

enum QuizDifficulty: String, CaseIterable {
    case facile = "Facile"
    case moyen = "Moyen"
    case difficile = "Difficile"
    
    var icon: String {
        switch self {
        case .facile: return "🟢"
        case .moyen: return "🟡"
        case .difficile: return "🔴"
        }
    }
    
    var description: String {
        switch self {
        case .facile: return "Questions de base sur l'Islam"
        case .moyen: return "Connaissances intermédiaires"
        case .difficile: return "Pour les connaisseurs"
        }
    }
}
