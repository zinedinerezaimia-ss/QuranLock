import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var name = ""
    @State private var dailyGoal = 5
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Theme.darkBackground.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // Page 1: Welcome
                VStack(spacing: 30) {
                    Spacer()
                    Text("🕌")
                        .font(.system(size: 80))
                    Text("QuranLock")
                        .font(.largeTitle.bold())
                        .foregroundColor(Theme.primaryGreen)
                    Text("Ton compagnon pour le Coran")
                        .font(.title3)
                        .foregroundColor(Theme.textSecondary)
                    
                    if appState.ramadanManager.isRamadan {
                        Text("🌙 Ramadan Mubarak ! 🌙")
                            .font(.title2.bold())
                            .foregroundColor(Theme.ramadanGold)
                            .padding(.top)
                    }
                    
                    Spacer()
                    Button("Commencer") {
                        withAnimation { currentPage = 1 }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.primaryGreen)
                    .cornerRadius(14)
                    .padding(.horizontal, 40)
                }
                .tag(0)
                
                // Page 2: Setup
                VStack(spacing: 24) {
                    Spacer()
                    Text("Personnalise ton expérience")
                        .font(.title2.bold())
                        .foregroundColor(Theme.textPrimary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ton prénom")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        TextField("Prénom", text: $name)
                            .padding()
                            .background(Theme.cardBackground)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)
                    
                    VStack(spacing: 8) {
                        Text("Objectif quotidien: \(dailyGoal) pages")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        Stepper("", value: $dailyGoal, in: 1...30)
                            .labelsHidden()
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    Button("Bismillah, c'est parti !") {
                        appState.completeOnboarding(name: name, goal: dailyGoal)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(name.isEmpty ? Color.gray : Theme.primaryGreen)
                    .cornerRadius(14)
                    .padding(.horizontal, 40)
                    .disabled(name.isEmpty)
                }
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
}
