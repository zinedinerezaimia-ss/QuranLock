import SwiftUI
import MapKit
import CoreLocation

// MARK: - Mosque Model

struct Mosque: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    var distanceMeters: Double = 0
    var walkingMinutes: Int?
    var drivingMinutes: Int?
}

// MARK: - MosqueFinderView

struct MosqueFinderView: View {
    let userLocation: CLLocation
    let prayerTimes: PrayerTimes?
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: MosqueFinderViewModel
    @State private var selectedMosque: Mosque?

    init(userLocation: CLLocation, prayerTimes: PrayerTimes? = nil) {
        self.userLocation = userLocation
        self.prayerTimes = prayerTimes
        _viewModel = StateObject(wrappedValue: MosqueFinderViewModel(
            userLocation: userLocation,
            prayerTimes: prayerTimes
        ))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D1A").ignoresSafeArea()

                if viewModel.isLoading {
                    loadingView
                } else if viewModel.mosques.isEmpty {
                    emptyView
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            if let next = viewModel.nextPrayer {
                                nextPrayerBanner(prayer: next)
                            }

                            ForEach(viewModel.mosques) { mosque in
                                mosqueCard(mosque: mosque)
                                    .onTapGesture {
                                        selectedMosque = mosque
                                    }
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Mosquées proches")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Color(hex: "C9A84C"))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        Task { await viewModel.searchMosques() }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Color(hex: "C9A84C"))
                    }
                }
            }
            .sheet(item: $selectedMosque) { mosque in
                MosqueDetailView(mosque: mosque, userLocation: userLocation, nextPrayer: viewModel.nextPrayer)
            }
            .task {
                await viewModel.searchMosques()
            }
        }
    }

    // MARK: - Subviews

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(Color(hex: "C9A84C"))
                .scaleEffect(1.5)
            Text("Recherche des mosquées...")
                .foregroundColor(Color(hex: "9090A0"))
        }
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Text("🕌")
                .font(.system(size: 50))
            Text("Aucune mosquée trouvée")
                .font(.headline)
                .foregroundColor(.white)
            Text("Vérifiez votre connexion internet")
                .font(.subheadline)
                .foregroundColor(Color(hex: "9090A0"))
            Button("Réessayer") {
                Task { await viewModel.searchMosques() }
            }
            .foregroundColor(Color(hex: "C9A84C"))
        }
    }

    private func nextPrayerBanner(prayer: (name: String, arabic: String, time: Date)) -> some View {
        let remaining = prayer.time.timeIntervalSince(Date())
        let hours = Int(remaining) / 3600
        let minutes = Int(remaining) % 3600 / 60

        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Prochaine prière : \(prayer.name)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(hours > 0 ? "Dans \(hours)h \(minutes)min" : "Dans \(minutes) min")
                    .font(.title2.bold())
                    .foregroundColor(remaining < 900 ? .red : Color(hex: "C9A84C"))
            }
            Spacer()
            Text(prayer.arabic)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "C9A84C"))
        }
        .padding(16)
        .background(Color(hex: "1A1A2E"))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "C9A84C").opacity(0.4), lineWidth: 1))
    }

    private func mosqueCard(mosque: Mosque) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🕌")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(mosque.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Text(mosque.address)
                        .font(.caption)
                        .foregroundColor(Color(hex: "9090A0"))
                        .lineLimit(1)
                }
                Spacer()
                Text(formatDistance(mosque.distanceMeters))
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "C9A84C"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "C9A84C").opacity(0.15))
                    .cornerRadius(8)
            }

            HStack(spacing: 16) {
                if let walk = mosque.walkingMinutes {
                    HStack(spacing: 4) {
                        Image(systemName: "figure.walk")
                            .font(.caption)
                        Text("\(walk) min")
                            .font(.subheadline.bold())
                    }
                    .foregroundColor(.white)
                }

                if let drive = mosque.drivingMinutes {
                    HStack(spacing: 4) {
                        Image(systemName: "car.fill")
                            .font(.caption)
                        Text("\(drive) min")
                            .font(.subheadline.bold())
                    }
                    .foregroundColor(.white)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text("Détails")
                        .font(.caption.bold())
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                .foregroundColor(Color(hex: "7C3AED"))
            }

            // Alert if should leave now
            if let next = viewModel.nextPrayer, let walk = mosque.walkingMinutes {
                let remaining = next.time.timeIntervalSince(Date())
                let remainingMin = Int(remaining) / 60
                let shouldLeaveNow = remainingMin <= walk + 5

                if shouldLeaveNow && remaining > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(remainingMin <= walk ? "⚠️ Partez maintenant pour \(next.name) !" : "Partez dans \(remainingMin - walk) min")
                            .font(.caption.bold())
                            .foregroundColor(remainingMin <= walk ? .red : .orange)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color(hex: "1A1A2E"))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.05), lineWidth: 1))
    }

    private func formatDistance(_ meters: Double) -> String {
        if meters < 1000 {
            return "\(Int(meters))m"
        } else {
            return String(format: "%.1fkm", meters / 1000)
        }
    }
}

// MARK: - Mosque Detail View

struct MosqueDetailView: View {
    let mosque: Mosque
    let userLocation: CLLocation
    let nextPrayer: (name: String, arabic: String, time: Date)?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D1A").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: mosque.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )), annotationItems: [mosque]) { m in
                            MapMarker(coordinate: m.coordinate, tint: .purple)
                        }
                        .frame(height: 200)
                        .cornerRadius(16)
                        .allowsHitTesting(false)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(mosque.name)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            Text(mosque.address)
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "9090A0"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color(hex: "1A1A2E"))
                        .cornerRadius(16)

                        if let next = nextPrayer {
                            travelTimesCard(nextPrayer: next)
                        }

                        Button(action: openInMaps) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Ouvrir dans Plans")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color(hex: "7C3AED"))
                            .cornerRadius(16)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Color(hex: "C9A84C"))
                }
            }
        }
    }

    private func travelTimesCard(nextPrayer: (name: String, arabic: String, time: Date)) -> some View {
        let remaining = nextPrayer.time.timeIntervalSince(Date())
        let remainingMin = Int(remaining) / 60

        return VStack(spacing: 12) {
            Text("Pour \(nextPrayer.name) — dans \(remainingMin) min")
                .font(.headline)
                .foregroundColor(Color(hex: "C9A84C"))
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                if let walk = mosque.walkingMinutes {
                    let canMakeIt = remainingMin > walk
                    VStack(spacing: 6) {
                        Image(systemName: "figure.walk")
                            .font(.title2)
                            .foregroundColor(canMakeIt ? .green : .red)
                        Text("\(walk) min")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Text("À pied")
                            .font(.caption)
                            .foregroundColor(Color(hex: "9090A0"))
                        Text(canMakeIt ? "✓ Possible" : "⚠️ Trop loin")
                            .font(.caption.bold())
                            .foregroundColor(canMakeIt ? .green : .red)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(canMakeIt ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(12)
                }

                if let drive = mosque.drivingMinutes {
                    let canMakeIt = remainingMin > drive
                    VStack(spacing: 6) {
                        Image(systemName: "car.fill")
                            .font(.title2)
                            .foregroundColor(canMakeIt ? .green : .red)
                        Text("\(drive) min")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Text("En voiture")
                            .font(.caption)
                            .foregroundColor(Color(hex: "9090A0"))
                        Text(canMakeIt ? "✓ Possible" : "⚠️ Trop loin")
                            .font(.caption.bold())
                            .foregroundColor(canMakeIt ? .green : .red)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(canMakeIt ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .background(Color(hex: "1A1A2E"))
        .cornerRadius(16)
    }

    private func openInMaps() {
        let placemark = MKPlacemark(coordinate: mosque.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = mosque.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ])
    }
}

// MARK: - ViewModel

@MainActor
class MosqueFinderViewModel: ObservableObject {
    @Published var mosques: [Mosque] = []
    @Published var isLoading = false
    @Published var nextPrayer: (name: String, arabic: String, time: Date)?

    private let userLocation: CLLocation

    init(userLocation: CLLocation, prayerTimes: PrayerTimes? = nil) {
        self.userLocation = userLocation
        self.nextPrayer = prayerTimes?.nextPrayer
    }

    func searchMosques() async {
        isLoading = true
        mosques = []

        // Search with multiple queries for better coverage
        let queries = ["mosquée", "mosque", "masjid", "salle de prière musulmane"]
        var allResults: [String: Mosque] = [:] // keyed by name to deduplicate

        for query in queries {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = MKCoordinateRegion(
                center: userLocation.coordinate,
                latitudinalMeters: 8000,  // 8km radius
                longitudinalMeters: 8000
            )
            // Filter to only place of worship category when available
            if #available(iOS 16.0, *) {
                request.pointOfInterestFilter = nil // Accept all to not miss any
            }

            if let response = try? await MKLocalSearch(request: request).start() {
                for item in response.mapItems {
                    guard let name = item.name else { continue }
                    // Skip results that are clearly not mosques
                    let lowName = name.lowercased()
                    let isMosque = lowName.contains("mosquée") ||
                                   lowName.contains("mosque") ||
                                   lowName.contains("masjid") ||
                                   lowName.contains("islamique") ||
                                   lowName.contains("musulman") ||
                                   lowName.contains("salle de prière") ||
                                   lowName.contains("association cultuelle") ||
                                   lowName.contains("centre culturel islam") ||
                                   lowName.contains("al-") ||
                                   lowName.contains("el-") ||
                                   query == "mosquée" || query == "mosque" // Trust Apple Maps category for these

                    if isMosque {
                        let coord = item.placemark.coordinate
                        let mosqueLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                        let distance = userLocation.distance(from: mosqueLocation)

                        // Only include mosques within 15km
                        if distance <= 15000 {
                            let key = "\(name)-\(String(format: "%.4f", coord.latitude))"
                            if allResults[key] == nil {
                                allResults[key] = Mosque(
                                    name: name,
                                    address: formatAddress(item.placemark),
                                    coordinate: coord,
                                    distanceMeters: distance
                                )
                            }
                        }
                    }
                }
            }
        }

        // Sort by distance, take closest 15
        var sorted = allResults.values.sorted { $0.distanceMeters < $1.distanceMeters }
        sorted = Array(sorted.prefix(15))

        // Calculate travel times for the 10 closest
        let toCalculate = min(sorted.count, 10)
        for i in 0..<toCalculate {
            let mosqueLocation = CLLocation(
                latitude: sorted[i].coordinate.latitude,
                longitude: sorted[i].coordinate.longitude
            )
            let (walking, driving) = await calculateTravelTimes(to: mosqueLocation)
            sorted[i].walkingMinutes = walking
            sorted[i].drivingMinutes = driving
        }

        self.mosques = sorted
        isLoading = false
    }

    private func formatAddress(_ placemark: MKPlacemark) -> String {
        var parts: [String] = []
        if let street = placemark.thoroughfare {
            if let number = placemark.subThoroughfare {
                parts.append("\(number) \(street)")
            } else {
                parts.append(street)
            }
        }
        if let postal = placemark.postalCode, let city = placemark.locality {
            parts.append("\(postal) \(city)")
        } else if let city = placemark.locality {
            parts.append(city)
        }
        if let country = placemark.country, country != "France" {
            parts.append(country)
        }
        return parts.joined(separator: ", ")
    }

    private func calculateTravelTimes(to destination: CLLocation) async -> (walking: Int?, driving: Int?) {
        let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate)
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)

        async let walkingTime = calculateRoute(from: sourcePlacemark, to: destinationPlacemark, transportType: .walking)
        async let drivingTime = calculateRoute(from: sourcePlacemark, to: destinationPlacemark, transportType: .automobile)

        let (walk, drive) = await (walkingTime, drivingTime)
        return (walk, drive)
    }

    private func calculateRoute(from source: MKPlacemark, to destination: MKPlacemark, transportType: MKDirectionsTransportType) async -> Int? {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = transportType

        guard let route = try? await MKDirections(request: request).calculate().routes.first else { return nil }
        return Int(route.expectedTravelTime / 60) + 1
    }
}
