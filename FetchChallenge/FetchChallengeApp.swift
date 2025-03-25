import SwiftUI

@main
struct Fetch_ChallengeApp: App {
    @StateObject private var homeViewModel = HomeViewModel(networkService: DefaultNetworkService())
    @State private var forcePlaceholder = false

    var body: some Scene {
        WindowGroup {
            NavigationView {
                SelectionView(
                    homeViewModel: homeViewModel,
                    forcePlaceholder: $forcePlaceholder
                )
            }
            .environment(\.forcePlaceholder, forcePlaceholder)
        }
    }
}
