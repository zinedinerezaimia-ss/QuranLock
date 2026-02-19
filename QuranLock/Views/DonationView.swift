import SwiftUI

struct DonationView: View {
    var body: some View {
        ZStack {
            Theme.primaryBg.ignoresSafeArea()
            Text("Dons")
                .foregroundColor(.white)
                .font(.title)
        }
    }
}
