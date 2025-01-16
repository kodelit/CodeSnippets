# Impl: AsyncContentView and AsyncContentDwonloader
- **shortcut**: `impl_AsyncContentView_AsyncContentDwonloader`
- **language**: Swift
- **platform**: 

## Summary
View which is presenting placeholder untill the content is downloaded.

## Code:
```swift
import Combine
import SwiftUICore
// Depends on: LazyAsyncValueCache

/// Protocol defining the interface for downloader allowing to (re)load the data on demand and cache it.
///
/// Describes interface of the object ment to be used in tandem with ``AsyncContentView``, the wrapper for the lazily loaded content which requires data to be loaded first.
/// It's similar to the ``RefreshableView`` but it's state depends on the ``AsyncContentDownloader`` value loading which is a single activity
/// instead of depending on ``ActivityController`` which may represent several activites.
protocol AsyncContentDownloading<ContentModel>: ObservableObject {
    associatedtype ContentModel
    @MainActor var value: ContentModel? { get set }
    
    /// Returns value form the cache or loads it if it's not loaded yet.
    func loadValueIfNeeded(animated: Bool) async
    /// Resets the cache and loads the value again.
    func reloadValue(animated: Bool) async
}

/// View wrapping the lazily loaded content which requires data to be loaded first.
///
/// AsyncContentView depends on the ``AsyncContentDownloading`` interface implementation which is responsible for loading the data for the view.
/// When data are being (re)load, the view will display the placeholder view untill the data are ready.
struct AsyncContentView<T, Content, Placeholder>: View where Content: View, Placeholder: View {
    private let asyncContentDowlnoader: any AsyncContentDownloading<T>
    @ViewBuilder let content: (_ data: T) -> Content
    @ViewBuilder let indicator: () -> Placeholder
    
    init(
        asyncContentDowlnoader: any AsyncContentDownloading<T>,
        @ViewBuilder content: @escaping (_ data: T) -> Content,
        @ViewBuilder indicator: @escaping () -> Placeholder
    ) {
        self.asyncContentDowlnoader = asyncContentDowlnoader
        self.content = content
        self.indicator = indicator
    }
    
    var body: some View {
        if let data = asyncContentDowlnoader.value {
            content(data)
        } else {
            indicator()
        }
    }
}

/// Default implementation of the protocol ``AsyncContentDownloading``, allowing to (re)load the data on demand and cache it.
///
/// This object is ment to be used in tandem with ``AsyncContentView``, the wrapper for the lazily loaded content which requires data to be loaded first.
@MainActor class AsyncContentDownloader<T>: ObservableObject, AsyncContentDownloading {
    private var cache: LazyAsyncValueCache<T?>
    @Published var value: T?
    
    init(preloadedValue: T? = nil, loader: @escaping @Sendable () async throws -> T?) {
        cache = .init(loader: loader)
    }
    
    func loadValueIfNeeded(animated: Bool = true) async {
        await reload(animated: animated, value: cache.getValue)
    }
    
    func reloadValue(animated: Bool = true) async {
        await reload(animated: animated, value: cache.reloadValue)
    }
    
    private func reload(animated: Bool = true, functionName: StaticString = #function, value: @escaping () async throws -> T?) async {
        //try? await Task.sleep(nanoseconds: 3_000_000_000)
        do {
            guard let value = try await value() else {
                log.debug("Failed to (re)load `\(T.self)` with `\(functionName)`, content is not available.")
                return
            }
            log.debug("Did (re)load `\(T.self)` with `\(functionName)`.")
            if animated {
                withAnimation {
                    self.value = value
                }
            } else {
                self.value = value
            }
        } catch {
            log.error("Could not (re)load `\(T.self)` with `\(functionName)`, error: \(error)")
        }
    }
}

```