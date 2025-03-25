import SwiftUI

private class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let url: URL
    private var task: URLSessionDataTask?

    init(url: URL) {
        self.url = url
        load()
    }

    private func load() {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad

        if let cached = URLCache.shared.cachedResponse(for: request),
           let image = UIImage(data: cached.data) {
            self.image = image
            return
        }

        task = URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data,
                  let response = response,
                  let image = UIImage(data: data) else { return }

            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)

            DispatchQueue.main.async {
                self.image = image
            }
        }

        task?.resume()
    }

    deinit {
        task?.cancel()
    }
}

struct CachedAsyncImage: View {
    @Environment(\.forcePlaceholder) private var forcePlaceholder
    @StateObject private var loader: ImageLoader

    init(url: URL) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        Group {
            if let uiImage = loader.image, !forcePlaceholder {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("placeholder-image")
                    .resizable()
                    .scaledToFill()
            }
        }
    }
}

struct ForcePlaceholderKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var forcePlaceholder: Bool {
        get { self[ForcePlaceholderKey.self] }
        set { self[ForcePlaceholderKey.self] = newValue }
    }
}
