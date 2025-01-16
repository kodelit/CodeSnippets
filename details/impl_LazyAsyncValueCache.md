# Impl: LazyAsyncValueCache
- **shortcut**: `impl_LazyAsyncValueCache`
- **language**: Swift
- **platform**: 

## Summary
Lazy loaded value, removed on memory warning, denends on LazyAsyncValue implementation

## Code:
```swift
import Foundation
#if os(iOS)
import UIKit
// Depends on: LazyAsyncValue

/// Wrapper for laizly and asychronously loaded value.
///
/// An instance requires to define the loading closure which loads data asynchronously, then caches it.
///
/// - warning: Cache will be reset when application will receive a memory warning, and is going to try to load the value again when needed/requested.
@available(iOS 15, *)
final class LazyAsyncValueCache<T: Sendable> {
    private let value: LazyAsyncValue<T>
    private let observer: Task<Void, Never>?

    init(preloadedValue: T? = nil, loader: @escaping @Sendable () async throws -> T) {
        let value = LazyAsyncValue(preloadedValue: preloadedValue, loader: loader)
        self.value = value
        self.observer = Task(priority: .utility) {
            let notificationsSequence = NotificationCenter.default.notifications(named: UIApplication.didReceiveMemoryWarningNotification)
            for await _ in notificationsSequence {
                await value.invalidateValue()
            }
        }
    }

    deinit {
        observer?.cancel()
    }
}

@available(iOS 15, *)
extension LazyAsyncValueCache: AsyncValueLoading {
    func getValue(defaultValue: T) async -> T {
        await value.getValue(defaultValue: defaultValue)
    }

    @discardableResult
    func getValue() async throws -> T {
        try await value.getValue()
    }
    
    func invalidateValue() async {
        await value.invalidateValue()
    }

    @discardableResult
    func reloadValue() async throws -> T {
        try await value.reloadValue()
    }
}
#endif

```