# Impl: URL Opening protocol and Worker implementation
- **shortcut**: `impl_urlOpenningProtocolAndWorker`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import UIKit

/// - warning: Use `ExternalUrlOpener` instead of conforming to the ``UrlOpening`` protocol when possible.
/// Using this protocol directly in code is highly discouraged but for implementing workers.
/// In order to support Dependency Injection we need workers which might be mocked, replaced and injected when needed.
/// The protocol has default implementations of the methods which if not implemented in the mock will use APIs not suitable for testing.
/// That is why conforming to the protocol outside the worker implementation might cause the code depandant on real types and APIs which cannot be mocked making the code less testable.
public protocol UrlOpening {
    @MainActor
    func canOpen(url: String) -> Bool

    @MainActor
    func canOpen(url: URL) -> Bool

    func open(url: String, completion: (@MainActor @Sendable (Bool) -> Void)?)
    func open(url: URL, completion: (@MainActor @Sendable (Bool) -> Void)?)
    func open(systemUrl: SystemUrl, completion: (@MainActor @Sendable (Bool) -> Void)?)

    @MainActor
    @discardableResult
    func open(url: String) async -> Bool

    @MainActor
    @discardableResult
    func open(url: URL) async -> Bool

    @MainActor
    @discardableResult
    func open(systemUrl: SystemUrl) async -> Bool
}

public struct SystemUrl: StringRepresentable, Sendable {
    /// Param for the ``ExternalUrlOpener/open(systemUrl:)``
    static let settingsUrl: Self = .init(rawValue: UIApplication.openSettingsURLString)

    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
    public init(stringLiteral value: String) { self.init(rawValue: value) }
}

@MainActor
public extension UrlOpening {
    // MARK: - Opening URL provided as a String
    func canOpen(url string: String) -> Bool {
        guard !string.isEmpty,
              let url = URL(string: string) else {
            print("\(#function): Invalid URL string: \(string)")
            return false
        }
        return canOpen(url: url)
    }

    @discardableResult
    func open(url string: String) async -> Bool {
        guard !string.isEmpty,
              let url = URL(string: string) else {
            print("\(#function): Invalid URL string: \(string)")
            return false
        }
        return canOpen(url: url)
    }

    // MARK: - Opening URL
    func canOpen(url: URL) -> Bool {
        UIApplication.shared.canOpenURL(url)
    }

    @discardableResult
    func open(url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }

    @discardableResult
    func open(systemUrl: SystemUrl) async -> Bool {
        await open(url: systemUrl.rawValue)
    }
}

public extension UrlOpening {
    func open(url string: String, completion: (@MainActor @Sendable (Bool) -> Void)?) {
        guard !string.isEmpty,
              let url = URL(string: string) else {
            print("\(#function): Invalid URL string: \(string)")
            return
        }
        open(url: url, completion: completion)
    }

    func open(url: URL, completion: (@MainActor @Sendable (Bool) -> Void)?) {
        Task { @MainActor in
            guard UIApplication.shared.canOpenURL(url) else {
                print("\(#function): Could not open url: \(url)")
                guard let completion else { return }
                completion(false)
                return
            }
            UIApplication.shared.open(url, completionHandler: completion)
        }
    }

    func open(systemUrl: SystemUrl, completion: (@MainActor @Sendable (Bool) -> Void)?) {
        open(url: systemUrl.rawValue, completion: completion)
    }
}

public struct ExternalUrlOpener: UrlOpening {
    public init() {}
}

```