import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingError
}

protocol NetworkService {
    func fetchRecipes() async throws -> RecipesResponse?
}

class DefaultNetworkService: NetworkService {
    var endpoint: String

    init(endpoint: String = "") {
        self.endpoint = endpoint
    }

    func fetchRecipes() async throws -> RecipesResponse? {
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.requestFailed
            }

            let decodedResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
            return decodedResponse
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw NetworkError.decodingError
        } catch {
            print("Network error: \(error)")
            throw NetworkError.requestFailed
        }
    }
}
