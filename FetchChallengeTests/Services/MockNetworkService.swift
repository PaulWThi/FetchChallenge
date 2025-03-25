import XCTest
@testable import FetchChallenge

class MockNetworkService: NetworkService {
    private(set) var fetchRecipesCalled = false
    private let recipesResponse: RecipesResponse?
    private let error: Error?

    init(recipesResponse: RecipesResponse?, error: Error? = nil) {
        self.recipesResponse = recipesResponse
        self.error = error
    }

    func fetchRecipes() async throws -> RecipesResponse? {
        fetchRecipesCalled = true
        if let error {
            throw error
        }
        return recipesResponse
    }
}
