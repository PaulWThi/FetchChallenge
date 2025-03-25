import SwiftUI

enum HomeViewState: Equatable {
    case empty
    case loading
    case loaded([Recipe])
    case error(Error)


    static func == (lhs: HomeViewState, rhs: HomeViewState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty), (.loading, .loading):
            return true
        case (.loaded(let lhsRecipes), .loaded(let rhsRecipes)):
            return lhsRecipes == rhsRecipes
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}


@MainActor
public class HomeViewModel: ObservableObject {
    private let networkService: NetworkService

    @Published var homeState: HomeViewState = .empty
    @Published var toastState: ToastState = .none

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }

    func onAppear() async throws {
        self.homeState = .loading
        self.toastState = .none

        do {
            let response = try await networkService.fetchRecipes()
            if let recipes = response?.recipes, !recipes.isEmpty {
                self.homeState = .loaded(recipes)
                self.toastState = .success("Recipes Fetched")
            } else {
                self.homeState = .empty
                self.toastState = .success("No recipes found")
            }
        } catch {
            self.homeState = .error(error)
            self.toastState = .error("Something went wrong")
        }
    }
}

