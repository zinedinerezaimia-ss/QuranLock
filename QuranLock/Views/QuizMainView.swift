import SwiftUI

struct QuizMainView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDifficulty: QuizQuestion.QuizDifficulty?
    @State private var isMixed = false
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var showResult = false
    @State private var showExplanation = false

    var questions: [QuizQuestion] {
        if isMixed {
            return Array(DataProvider.quizQuestions.shuffled().prefix(10))
        }
        guard let diff = selectedDifficulty else { return [] }
        return DataProvider.quizQuestions.filter { $0.difficulty == diff }
    }

    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        if selectedDifficulty == nil && !isMixed {
                            difficultySelection
                        } else if showResult {
                            resultView
                        } else if let q = currentQuestion {
                            questionView(q)
                        }
                    }
                    .padding(.horizontal, 16).padding(.bottom, 20)
                }
            }
            .navigationTitle("🧠 Quiz Islamique")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Difficulty Selection
    var difficultySelection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("🏆 Meilleur Score").font(.headline).foregroundColor(Theme.gold)
                Text("\(appState.quizHighScore)").font(.system(size: 48, weight: .bold)).foregroundColor(Theme.gold)
            }
            .cardStyle()

            Text("Choisis ton niveau").font(.title3.bold()).foregroundColor(.white)

            difficultyButton(.facile, icon: "🟢", desc: "Questions de base sur l'Islam")
            difficultyButton(.moyen, icon: "🟡", desc: "Connaissances intermédiaires")
            difficultyButton(.difficile, icon: "🔴", desc: "Pour les connaisseurs")
            mixedButton()
        }
    }

    func difficultyButton(_ diff: QuizQuestion.QuizDifficulty, icon: String, desc: String) -> some View {
        let count = DataProvider.quizQuestions.filter { $0.difficulty == diff }.count
        return Button(action: { startQuiz(diff) }) {
            HStack {
                Text(icon).font(.title2)
                VStack(alignment: .leading) {
                    Text(diff.rawValue).font(.headline).foregroundColor(.white)
                    Text(desc).font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Text("\(count) Q").font(.caption.bold()).foregroundColor(Theme.gold)
            }
            .cardStyle()
        }
    }

    func mixedButton() -> some View {
        Button(action: { startMixed() }) {
            HStack {
                Text("🎲").font(.title2)
                VStack(alignment: .leading) {
                    Text("Mixte").font(.headline).foregroundColor(.white)
                    Text("Mélange de tous les niveaux — 10 questions aléatoires").font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Text("10 Q").font(.caption.bold()).foregroundColor(Theme.gold)
            }
            .padding()
            .background(LinearGradient(colors: [Theme.ramadanPurple.opacity(0.5), Theme.cardBg], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.gold.opacity(0.5), lineWidth: 1))
        }
    }

    // MARK: - Question View
    func questionView(_ q: QuizQuestion) -> some View {
        VStack(spacing: 16) {
            // Progress
            HStack {
                Text("Question \(currentQuestionIndex + 1)/\(questions.count)").font(.caption).foregroundColor(Theme.textSecondary)
                Spacer()
                Text("Score: \(score)").font(.caption.bold()).foregroundColor(Theme.gold)
            }
            ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count)).tint(Theme.gold)

            // Difficulty badge
            HStack {
                diffBadge(q.difficulty)
                Text(q.category).font(.caption).foregroundColor(Theme.textSecondary)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Theme.secondaryBg).cornerRadius(8)
                Spacer()
            }

            // Question
            Text(q.question)
                .font(.headline).foregroundColor(.white).multilineTextAlignment(.center)
                .padding().background(Theme.cardBg).cornerRadius(14)
                .frame(maxWidth: .infinity)

            // Options
            ForEach(q.options.indices, id: \.self) { idx in
                Button(action: { selectAnswer(idx, for: q) }) {
                    HStack {
                        Text(["A", "B", "C", "D"][idx])
                            .font(.caption.bold()).foregroundColor(.black)
                            .frame(width: 24, height: 24)
                            .background(optionColor(idx, correct: q.correctIndex).opacity(0.8))
                            .cornerRadius(12)
                        Text(q.options[idx]).font(.subheadline).foregroundColor(.white)
                        Spacer()
                        if let sa = selectedAnswer {
                            if idx == q.correctIndex { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.success) }
                            else if idx == sa && sa != q.correctIndex { Image(systemName: "xmark.circle.fill").foregroundColor(.red) }
                        }
                    }
                    .padding()
                    .background(optionBg(idx, correct: q.correctIndex))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(optionBorder(idx, correct: q.correctIndex), lineWidth: 1.5))
                }
                .disabled(selectedAnswer != nil)
            }

            // Explanation
            if showExplanation {
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedAnswer == q.correctIndex ? "✅ Correct ! Barakallahu fik" : "❌ Pas tout à fait...")
                        .font(.subheadline.bold())
                        .foregroundColor(selectedAnswer == q.correctIndex ? Theme.success : .red)
                    Text(q.explanation).font(.subheadline).foregroundColor(.white)
                }
                .padding().background(Theme.secondaryBg).cornerRadius(12)

                Button(action: nextQuestion) {
                    Text(currentQuestionIndex + 1 < questions.count ? "Question suivante →" : "Voir les résultats 🏆")
                        .goldButton()
                }
            }
        }
    }

    func optionColor(_ idx: Int, correct: Int) -> Color {
        guard let sa = selectedAnswer else { return Theme.gold }
        if idx == correct { return Theme.success }
        if idx == sa { return .red }
        return Theme.gold
    }

    func optionBg(_ idx: Int, correct: Int) -> Color {
        guard let sa = selectedAnswer else { return Theme.cardBg }
        if idx == correct { return Theme.success.opacity(0.15) }
        if idx == sa { return Color.red.opacity(0.15) }
        return Theme.cardBg
    }

    func optionBorder(_ idx: Int, correct: Int) -> Color {
        guard let sa = selectedAnswer else { return Theme.cardBorder }
        if idx == correct { return Theme.success }
        if idx == sa { return .red }
        return Theme.cardBorder
    }

    func diffBadge(_ diff: QuizQuestion.QuizDifficulty) -> some View {
        let (icon, color): (String, Color) = switch diff {
            case .facile: ("🟢", Theme.success)
            case .moyen: ("🟡", .yellow)
            case .difficile: ("🔴", .red)
        }
        return Text("\(icon) \(diff.rawValue)")
            .font(.caption.bold()).foregroundColor(color)
            .padding(.horizontal, 10).padding(.vertical, 4)
            .background(color.opacity(0.15)).cornerRadius(10)
    }

    // MARK: - Result View
    var resultView: some View {
        VStack(spacing: 20) {
            Text(score >= questions.count / 2 ? "🏆 Excellent !" : "📚 Continue à apprendre !")
                .font(.title.bold()).foregroundColor(Theme.gold)

            VStack(spacing: 8) {
                Text("\(score) / \(questions.count)")
                    .font(.system(size: 60, weight: .bold)).foregroundColor(Theme.gold)
                Text("bonnes réponses").font(.subheadline).foregroundColor(Theme.textSecondary)
            }
            .cardStyle()

            let pct = Int(Double(score) / Double(questions.count) * 100)
            Text(resultMessage(pct)).font(.subheadline).foregroundColor(.white)
                .multilineTextAlignment(.center).padding().background(Theme.cardBg).cornerRadius(12)

            Button(action: resetQuiz) {
                Text("Rejouer").goldButton()
            }
            Button(action: { selectedDifficulty = nil; isMixed = false; resetQuiz() }) {
                Text("Choisir un autre niveau").font(.subheadline).foregroundColor(Theme.textSecondary)
            }
        }
    }

    func resultMessage(_ pct: Int) -> String {
        switch pct {
        case 90...100: return "SubhanAllah ! Tu maîtrises parfaitement. Qu'Allah te bénisse dans ta quête de connaissance. 🌟"
        case 70...89: return "MashaAllah ! Très bon résultat. Continue à apprendre et à te perfectionner. 📖"
        case 50...69: return "Bien ! Il te reste encore des choses à découvrir. L'apprentissage est une ibadah. 🤲"
        default: return "Ne te décourage pas ! Chaque question est une opportunité d'apprendre. InshaAllah tu progresseras. 💪"
        }
    }

    // MARK: - Actions
    func startQuiz(_ diff: QuizQuestion.QuizDifficulty) {
        selectedDifficulty = diff
        isMixed = false
        currentQuestionIndex = 0
        score = 0
        selectedAnswer = nil
        showResult = false
        showExplanation = false
    }

    func startMixed() {
        isMixed = true
        selectedDifficulty = nil
        currentQuestionIndex = 0
        score = 0
        selectedAnswer = nil
        showResult = false
        showExplanation = false
    }

    func selectAnswer(_ idx: Int, for q: QuizQuestion) {
        selectedAnswer = idx
        showExplanation = true
        if idx == q.correctIndex {
            score += 1
            appState.addHasanat(2)
        }
    }

    func nextQuestion() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showExplanation = false
        } else {
            if score > appState.quizHighScore { appState.quizHighScore = score }
            showResult = true
        }
    }

    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        selectedAnswer = nil
        showResult = false
        showExplanation = false
    }
}
