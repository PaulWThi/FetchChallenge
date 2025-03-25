import XCTest
@testable import FetchChallenge

final class HomeViewModelTests: XCTestCase {
    private var sut: HomeViewModel!

    override func setUpWithError() throws {
        sut = MainActor.assumeIsolated { HomeViewModel() }
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_init() throws {
        XCTAssertNotNil(sut)
    }

    func test_onAppear_success() async throws {
        let mockResponse = try loadMock("recipes_success", as: RecipesResponse.self)
        let mockService = MockNetworkService(recipesResponse: mockResponse)
        let sut = await HomeViewModel(networkService: mockService)

        try await sut.onAppear()

        await MainActor.run {
            XCTAssertTrue(mockService.fetchRecipesCalled)
            XCTAssertEqual(sut.homeState, .loaded(mockResponse.recipes))
            XCTAssertEqual(sut.toastState, .success("Recipes Fetched"))
        }
    }

    func test_onAppear_error() async throws {
        do {
            _ = try loadMock("recipes_malformed", as: RecipesResponse.self)
            XCTFail("Expected loadMock to throw, but it succeeded")
        } catch {
            let mockError = NetworkError.decodingError
            let mockService = MockNetworkService(recipesResponse: nil, error: mockError)
            let sut = await HomeViewModel(networkService: mockService)

            try await sut.onAppear()

            await MainActor.run {
                XCTAssertTrue(mockService.fetchRecipesCalled)
                XCTAssertEqual(sut.homeState, .error(mockError))
                XCTAssertEqual(sut.toastState, .error("Something went wrong"))
            }
        }
    }

    func test_onAppear_empty() async throws {
        let mockResponse = try loadMock("recipes_empty", as: RecipesResponse.self)
        let mockService = MockNetworkService(recipesResponse: mockResponse)
        let sut = await HomeViewModel(networkService: mockService)

        try await sut.onAppear()

        await MainActor.run {
            XCTAssertTrue(mockService.fetchRecipesCalled)
            XCTAssertEqual(sut.homeState, .empty)
            XCTAssertEqual(sut.toastState, .success("No recipes found"))
        }
    }
}

extension HomeViewModelTests {
    func loadMock<T: Decodable>(_ filename: String, as type: T.Type) throws -> T {
        let bundle = Bundle(for: HomeViewModelTests.self)

        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Missing mock file: \(filename).json")
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
