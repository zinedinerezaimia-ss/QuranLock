import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    @State private var userName = ""
    @State private var dailyGoal = 5
    
    var body: some View {
        ZStack {
            Theme.primaryBg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    featuresPage.tag(1)
                    setupPage.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(i == currentPage ? Theme.gold : Theme.cardBorder)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 8)
                
                // Navigation buttons
                VStack(spacing: 12) {
                    if currentPage < 2 {
                        Button(action: { withAnimation { currentPage += 1 } }) {
                            HStack {
                                Text("Suivant")
                                Image(systemName: "arrow.right")
                            }
                            .goldButton()
                        }
                    } else {
                        Button(action: completeOnboarding) {
                            HStack {
                                Text("Bismillah, c'est parti !")
                                Text("🤲")
                            }
                            .goldButton()
                        }
                    }
                    
                    if currentPage < 2 {
                        Button("Passer l'introduction") {
                            withAnimation { currentPage = 2 }
                        }
                        .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
        }
    }
    
    // MARK: - Welcome Page
    var welcomePage: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                Text("🕌")
                    .font(.system(size: 80))
                
                Text("Bienvenue sur Iqra")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Theme.gold)
                    .multilineTextAlignment(.center)
                
                Text("Ton compagnon spirituel quotidien pour lire le Coran, apprendre l'arabe, faire des invocations et progresser dans ta foi.")
                    .font(.body)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Feature grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    FeatureCard(icon: "📖", title: "114 Sourates")
                    FeatureCard(icon: "🎙️", title: "Récitation")
                    FeatureCard(icon: "🤲", title: "Duaas & Adhkar")
                    FeatureCard(icon: "🧠", title: "Quiz islamique")
                    FeatureCard(icon: "🔤", title: "Cours d'arabe")
                    FeatureCard(icon: "🕌", title: "Cagnottes Mosquées")
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Features Page
    var featuresPage: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer().frame(height: 30)
                
                Text("✨ Ce que Iqra t'offre")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Theme.gold)
                
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "📖", title: "Lecture du Coran", desc: "Lis et suis ta progression sur les 114 sourates avec le défi Khatm")
                    FeatureRow(icon: "🔤", title: "Cours d'arabe", desc: "Apprends l'alphabet, les voyelles, le tajwid et la grammaire à ton rythme")
                    FeatureRow(icon: "🤲", title: "Duaas & Adhkar", desc: "Invocations du matin, soir, prière, protection et bien plus")
                    FeatureRow(icon: "🧠", title: "Quiz islamique", desc: "Teste tes connaissances avec 3 niveaux de difficulté")
                    FeatureRow(icon: "👥", title: "Communauté", desc: "Partage tes réflexions, pose des questions et échange avec les autres")
                    FeatureRow(icon: "🎵", title: "Défi Musique", desc: "Remplace la musique par le Coran avec un défi sur mesure")
                    FeatureRow(icon: "🕌", title: "Sadaqa", desc: "Soutiens les mosquées près de chez toi avec les cagnottes")
                    FeatureRow(icon: "🌙", title: "Mode Ramadan", desc: "Fonctionnalités spéciales pendant le mois béni")
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Setup Page
    var setupPage: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                Text("🌟")
                    .font(.system(size: 60))
                
                Text("Personnalise ton expérience")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Theme.gold)
                    .multilineTextAlignment(.center)
                
                // Name input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ton prénom")
                        .foregroundColor(Theme.textSecondary)
                        .font(.subheadline)
                    
                    TextField("Entre ton prénom...", text: $userName)
                        .padding()
                        .background(Theme.cardBg)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.cardBorder, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                
                // Daily goal
                VStack(spacing: 12) {
                    Text("Objectif quotidien de lecture")
                        .foregroundColor(Theme.textSecondary)
                        .font(.subheadline)
                    
                    Text("\(dailyGoal) pages / jour")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.gold)
                    
                    Slider(value: Binding(
                        get: { Double(dailyGoal) },
                        set: { dailyGoal = Int($0) }
                    ), in: 1...30, step: 1)
                    .accentColor(Theme.gold)
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Text("1 page").font(.caption).foregroundColor(Theme.textSecondary)
                        Spacer()
                        Text("30 pages").font(.caption).foregroundColor(Theme.textSecondary)
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
            }
        }
    }
    
    func completeOnboarding() {
        appState.userName = userName.isEmpty ? "User" : userName
        appState.dailyGoal = dailyGoal
        hasCompletedOnboarding = true
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 28))
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.cardBg)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.cardBorder, lineWidth: 1)
        )
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon).font(.system(size: 24))
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(desc)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
}
