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
            
            let cachedData = loadFromCache(url: url)
            if cachedData == nil {
                URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                    if let data = data, data.count > 0 {
                        self.data = data
                        self.state = .success
                        self.saveToCache(url: url, data: data)
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
        
        func saveToCache(url: String, data: Data) {
            let cachePath = cachePathFromUrl(url: url)
            try? data.write(to: cachePath)
        }
        func loadFromCache(url: String) -> Data? {
            let cachePath = cachePathFromUrl(url: url)
            do{
                let imageData = try Data(contentsOf: cachePath)
                return imageData
            } catch {
                return nil
            }
        }
        func cachePathFromUrl(url: String) -> URL {
            let urlHash = SHA256.hash(data: Data(url.utf8)).description
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            return cachesDirectory.appendingPathComponent(urlHash)
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
