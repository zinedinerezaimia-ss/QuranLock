import SwiftUI

struct EnseignementsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTopic: Enseignement?
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12) {
                        Text("📚 Enseignements Islamiques")
                            .font(.title2.bold())
                            .foregroundColor(Theme.gold)
                        
                        Text("Apprends les bases de l'Islam avec des sources authentiques")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        ForEach(DataProvider.enseignements) { topic in
                            Button(action: { selectedTopic = topic }) {
                                HStack(spacing: 12) {
                                    Text(topic.icon)
                                        .font(.system(size: 32))
                                        .frame(width: 44)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(topic.title)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("\(topic.sections.count) sections")
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
            .sheet(item: $selectedTopic) { topic in
                EnseignementDetailView(topic: topic)
            }
        }
    }
}

struct EnseignementDetailView: View {
    let topic: Enseignement
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        Text(topic.icon)
                            .font(.system(size: 60))
                        
                        Text(topic.title)
                            .font(.title.bold())
                            .foregroundColor(Theme.gold)
                        
                        ForEach(topic.sections.indices, id: \.self) { i in
                            let section = topic.sections[i]
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("\(i + 1)")
                                        .font(.caption.bold())
                                        .foregroundColor(.black)
                                        .frame(width: 24, height: 24)
                                        .background(Theme.gold)
                                        .cornerRadius(12)
                                    
                                    Text(section.title)
                                        .font(.headline)
                                        .foregroundColor(Theme.gold)
                                }
                                
                                Text(section.content)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                if let arabic = section.arabicReference {
                                    Text(arabic)
                                        .font(.system(size: 16))
                                        .foregroundColor(Theme.accent)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                
                                if let hadith = section.hadithReference {
                                    HStack(alignment: .top) {
                                        Image(systemName: "book.fill")
                                            .foregroundColor(Theme.gold)
                                            .font(.caption)
                                        Text(hadith)
                                            .font(.caption)
                                            .foregroundColor(Theme.gold)
                                            .italic()
                                    }
                                    .padding(10)
                                    .background(Theme.gold.opacity(0.08))
                                    .cornerRadius(8)
                                }
                            }
                            .cardStyle()
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
        }
    }
}
