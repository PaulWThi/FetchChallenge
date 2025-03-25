import Foundation

struct RecipesResponse: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable, Equatable {
    let cuisine: String
    let name: String
    let photoURLLarge: URL?
    let photoURLSmall: URL?
    let sourceURL: URL?
    let uuid: String
    let youtubeURL: URL?

    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
}
