import SwiftUI

struct SadaqaView: View {
    @StateObject private var firebase = FirebaseManager.shared
    @State private var showRegisterMosque = false
    @State private var showDonation: RegisteredMosque? = nil

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        VStack(spacing: 8) {
                            Text("🕌").font(.system(size: 50))
                            Text(L.sadaqaTitle)
                                .font(.title2.bold()).foregroundColor(Theme.gold)
                            Text("« Celui qui construit une mosquée pour Allah, Allah lui construit une maison au Paradis. »")
                                .font(.caption).foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                            Text("— Sahih al-Bukhari")
                                .font(.caption).foregroundColor(Theme.accent)
                        }
                        .cardStyle()

                        // Static mosques (hardcoded local ones)
                        ForEach(DataProvider.mosqueFundraisers) { mosque in
                            StaticMosqueCard(mosque: mosque)
                        }

                        // Firebase registered mosques
                        if !firebase.registeredMosques.isEmpty {
                            Text("🕌 Mosquées inscrites")
                                .font(.headline).foregroundColor(Theme.gold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)

                            ForEach(firebase.registeredMosques) { mosque in
                                DynamicMosqueCard(mosque: mosque) {
                                    showDonation = mosque
                                }
                            }
                        }

                        // Register mosque
                        VStack(spacing: 12) {
                            Text(L.manageMosque)
                                .font(.headline).foregroundColor(.white)
                            Text(L.registerMosqueDesc)
                                .font(.caption).foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)

                            Button(action: { showRegisterMosque = true }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text(L.registerMosque)
                                }
                                .goldButton()
                            }
                        }
                        .cardStyle()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Sadaqa")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showRegisterMosque) {
                RegisterMosqueView(firebase: firebase)
            }
            .sheet(item: $showDonation) { mosque in
                DonationDetailView(mosque: mosque)
            }
            .onAppear {
                firebase.fetchMosques()
            }
        }
    }
}

// MARK: - Static Mosque Card (hardcoded)
struct StaticMosqueCard: View {
    let mosque: MosqueFundraiser

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mosque.name).font(.headline).foregroundColor(.white)
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text("\(mosque.location) • \(mosque.distance) km")
                    }
                    .font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Text("🕌").font(.title)
            }

            Text(mosque.project).font(.subheadline).foregroundColor(Theme.accent)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(mosque.collected)€").font(.headline).foregroundColor(Theme.gold)
                    Text("/ \(mosque.goal)€").font(.subheadline).foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("\(Int(mosque.progress * 100))%").font(.subheadline.bold()).foregroundColor(Theme.gold)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(Theme.secondaryBg).frame(height: 8)
                        RoundedRectangle(cornerRadius: 4).fill(Theme.gold)
                            .frame(width: geo.size.width * min(mosque.progress, 1.0), height: 8)
                    }
                }
                .frame(height: 8)
            }
        }
        .cardStyle()
    }
}

// MARK: - Dynamic Mosque Card (Firebase)
struct DynamicMosqueCard: View {
    let mosque: RegisteredMosque
    let onDonate: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mosque.name).font(.headline).foregroundColor(.white)
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(mosque.city)
                    }
                    .font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Text("🕌").font(.title)
            }

            Text(mosque.project).font(.subheadline).foregroundColor(Theme.accent)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(mosque.collected)€").font(.headline).foregroundColor(Theme.gold)
                    Text("/ \(mosque.goal)€").font(.subheadline).foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("\(Int(mosque.progress * 100))%").font(.subheadline.bold()).foregroundColor(Theme.gold)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(Theme.secondaryBg).frame(height: 8)
                        RoundedRectangle(cornerRadius: 4).fill(Theme.gold)
                            .frame(width: geo.size.width * min(mosque.progress, 1.0), height: 8)
                    }
                }
                .frame(height: 8)
            }

            Button(action: onDonate) {
                HStack {
                    Image(systemName: "heart.fill")
                    Text(L.donateToMosque)
                }
                .goldButton()
            }
        }
        .cardStyle()
    }
}

// MARK: - Donation Detail View (shows IBAN)
struct DonationDetailView: View {
    let mosque: RegisteredMosque
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        Text("🕌").font(.system(size: 60))
                        Text(mosque.name).font(.title2.bold()).foregroundColor(Theme.gold)
                        Text(mosque.project).font(.subheadline).foregroundColor(Theme.accent)

                        VStack(alignment: .leading, spacing: 12) {
                            Text(L.donationInstructions)
                                .font(.subheadline).foregroundColor(.white)

                            infoRow("IBAN", mosque.iban)
                            infoRow("BIC/SWIFT", mosque.bic)
                            infoRow("Email", mosque.contactEmail)
                        }
                        .cardStyle()

                        Text("Qu'Allah accepte ta sadaqa et te récompense au-delà de tes espérances 🤲")
                            .font(.caption).foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)

                        // Copy IBAN
                        Button(action: {
                            UIPasteboard.general.string = mosque.iban
                        }) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Copier l'IBAN")
                            }
                            .goldButton()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(L.donateToMosque)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L.close) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
        }
    }

    func infoRow(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundColor(Theme.textSecondary)
            Text(value).font(.subheadline.bold()).foregroundColor(.white)
                .textSelection(.enabled)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.secondaryBg)
        .cornerRadius(10)
    }
}

// MARK: - Register Mosque View
struct RegisterMosqueView: View {
    let firebase: FirebaseManager
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var city = ""
    @State private var project = ""
    @State private var goalStr = ""
    @State private var iban = ""
    @State private var bic = ""
    @State private var email = ""
    @State private var isSubmitting = false
    @State private var showSuccess = false
    @State private var errorMsg: String?

    var isValid: Bool {
        !name.isEmpty && !city.isEmpty && !project.isEmpty && !goalStr.isEmpty && !iban.isEmpty && !email.isEmpty
    }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        Text("🕌").font(.system(size: 50))
                        Text(L.registerMosque).font(.title2.bold()).foregroundColor(Theme.gold)

                        if !firebase.isSignedIn {
                            VStack(spacing: 12) {
                                Text("Connecte-toi d'abord pour inscrire ta mosquée")
                                    .font(.subheadline).foregroundColor(Theme.textSecondary)
                                Button(action: { firebase.signInWithApple() }) {
                                    HStack(spacing: 10) {
                                        Image(systemName: "applelogo").font(.headline)
                                        Text(L.continueWithApple).font(.headline)
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                                    .background(Color.white).cornerRadius(14)
                                }
                            }
                            .cardStyle()
                        } else {
                            formField(L.mosqueName, text: $name)
                            formField(L.mosqueCity, text: $city)
                            formField(L.mosqueProject, text: $project)
                            formField(L.mosqueGoal, text: $goalStr, keyboard: .numberPad)
                            formField(L.mosqueIBAN, text: $iban)
                            formField(L.mosqueBIC, text: $bic)
                            formField(L.mosqueContact, text: $email, keyboard: .emailAddress)

                            if let err = errorMsg {
                                Text(err).font(.caption).foregroundColor(.red)
                            }

                            Button(action: submit) {
                                HStack {
                                    if isSubmitting { ProgressView().tint(.black) }
                                    Text(isSubmitting ? "..." : L.submitMosque)
                                }
                                .goldButton()
                            }
                            .disabled(!isValid || isSubmitting)
                            .opacity(isValid ? 1 : 0.5)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L.cancel) { dismiss() }.foregroundColor(Theme.gold)
                }
            }
            .alert(L.mosqueSubmitted, isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            }
        }
    }

    func formField(_ placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(keyboard)
            .foregroundColor(.white)
            .padding(12)
            .background(Theme.secondaryBg)
            .cornerRadius(10)
    }

    func submit() {
        guard let goal = Int(goalStr), goal > 0 else {
            errorMsg = "L'objectif doit être un nombre positif"
            return
        }
        isSubmitting = true
        errorMsg = nil
        firebase.registerMosque(name: name, city: city, project: project, goal: goal, iban: iban, bic: bic, contactEmail: email) { success in
            isSubmitting = false
            if success { showSuccess = true }
            else { errorMsg = "Erreur lors de l'envoi. Réessaie." }
        }
    }
}
