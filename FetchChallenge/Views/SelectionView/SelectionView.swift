import SwiftUI

/// This view is mostly for testing purposes to allow for user to test multiple end points and also force an image placeholder to simulate recipes that have no image.
struct SelectionView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @Binding var forcePlaceholder: Bool

    var body: some View {
        VStack(spacing: 32) {
            Toggle(isOn: $forcePlaceholder) {
                Text("Force Placeholder")
                    .font(.headline)
            }
            VStack(spacing: 16) {
                NavigationButtonView(title: "Success Response") {
                    HomeView(viewModel: HomeViewModel(networkService: DefaultNetworkService(endpoint: Endpoint.recipesSuccess)))
                }

                NavigationButtonView(title: "Failure Response") {
                    HomeView(viewModel: HomeViewModel(networkService: DefaultNetworkService(endpoint: Endpoint.recipesMalformed)))
                }

                NavigationButtonView(title: "Empty Response") {
                    HomeView(viewModel: HomeViewModel(networkService: DefaultNetworkService(endpoint: Endpoint.recipesEmpty)))
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Selections")
    }
}
