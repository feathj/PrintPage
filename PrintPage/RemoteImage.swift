import SwiftUI
import CryptoKit

struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading
        
        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }
            
            let cachedData = loadFromCache(cacheKey: url)
            if cachedData == nil {
                URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                    if let data = data, data.count > 0 {
                        self.data = data
                        self.state = .success
                        saveToCache(cacheKey: url, data: data)
                    } else {
                        self.state = .failure
                    }

                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }.resume()
            } else {
                self.data = cachedData!
                self.state = .success
            }
        }
    }

    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image
    var scaledTo: CGSize?

    var body: some View {
        selectImage()
            .resizable()
    }

    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle"), scaledTo: CGSize? = nil) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
        self.scaledTo = scaledTo
    }
    
    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = NSImage(data: loader.data) {
                if self.scaledTo != nil {
                    return Image(nsImage: image.scaled(to: self.scaledTo!))
                } else {
                    return Image(nsImage: image)
                }
            } else {
                return failure
            }
        }
    }
}
