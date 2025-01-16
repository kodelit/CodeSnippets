# Impl: AsyncSVGImage
- **shortcut**: `impl_AsyncSVGImage`
- **language**: Swift
- **platform**: 

## Summary
AsyncImage view supporting also SVG images.

## Code:
```swift
import SwiftUI
#if canImport(Alamofire)
import Alamofire
#endif
// Depends on: AsyncContentDownloader, UIImage+SVG

/// AsyncImage wrapper supprting also SVG images.
///
/// The `AsyncSVGImage` firstly will try to load the image from the given URL and display it using native AsyncImage view.
/// If that will fail then as a fallback, the  data are going to be downloaded and the view will try to load the image again directly form the data, and if that fails also it will try to load SVG image from the data.
struct AsyncSVGImage<Content, Placeholder>: View where Content: View, Placeholder: View {
    let url: URL?
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder
    
    @StateObject var imageDownloader: AsyncImageDownloader
    
    init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        self._imageDownloader = StateObject(wrappedValue: AsyncImageDownloader(url: url))
    }
    
    var body: some View {
        if let image = imageDownloader.image {
            content(Image(uiImage: image))
        } else {
#if canImport(Alamofire)
            // Download image with Alamofire
            placeholder()
                .task {
                    await imageDownloader.loadValueIfNeeded()
                }
#else
            // Try to load the image with AsyncImage, if it failed try to download the data and decode as SVG image.
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    placeholder()
                case .success(let image):
                    content(image)
                case .failure(let error):
                    //let _ = log.error("Could not load AsyncImage from url: '\(url?.absoluteString ?? "nil")', error: \(error)")
                    placeholder()
                        .task {
                            await imageDownloader.loadValueIfNeeded()
                        }
                @unknown default:
                    placeholder()
                }
            }
#endif
        }
    }
}

final class AsyncImageDownloader: AsyncContentDownloader<UIImage> {
    var image: UIImage? { value }
    
    /// - Parameters:
    ///   - url: URL of the image to download
    ///   - loader: **For tests only** to mock the download request.
    ///
    /// - warning: `loader` param is for tests only and should remain `nil` in order download the image from the URL.
    /// If `loader` is assigned it will replace the whole download logic. By assigning the `loader` you may mock the download request.
    init(url: URL?, loader: (@Sendable () async throws -> UIImage?)? = nil) {
        super.init {
            if let loader { return try await loader() }
            return try await Self.download(from: url)
        }
    }
    
#if canImport(Alamofire)
    private static func download(from url: URL?) async throws -> UIImage? {
        guard let url else { return nil }
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url).responseImage { response in
                switch response.result {
                case .success(let uiImage):
                    continuation.resume(returning: uiImage)
                case .failure(let error):
                    var dataAsString: String?
                    if let data = response.data {
                        if let uiImage = UIImage.with(svg: data) {
                            return continuation.resume(returning: uiImage)
                        }
                        
                        // If could not render image with the response data throw received error
                        dataAsString = String(data: data, encoding: .utf8)
                    }
                    else {
                        //log.error("failed to load image from url: \(url), error: \(error), data: \(dataAsString ?? "nil")")
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
#else
    private static func download(from url: URL?) async throws -> UIImage? {
        guard let url else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage.with(svg: data)
    }
#endif
}
```