# DateVariantsStore
- **shortcut**: `impl_dateVariantStore`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
#if DEVELOPMENT
import UIKit

public actor DateVariantsStore {
    var store: Set<String> = []

    init() { }

    /// Method for investingating how many different date formats the app has to handle and what formats it would be.
    nonisolated
    public func enqueueToRegister(variant value: String) {
        Task {
            await register(variant: value)
        }
    }

    public func register(variant value: String) {
        store.insert(value)
    }

    /// Method to use in debug view to share the date formats occuring in the app.
    func share() async {
        let text = store.joined(separator: "\n")
        // swiftlint:disable:next force_unwrapping
        let data = text.data(using: .utf8)!
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString)-DateVariants.txt")
        try? data.write(to: tempURL)
        let activityVC = await UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        await UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true)
    }
}

public let dateVariantsStore: DateVariantsStore = .init()
#endif

```