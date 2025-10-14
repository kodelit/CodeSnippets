# Impl: Property last update tracking
- **shortcut**: `impl_propertyLastUpdateTracking`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import Foundation

// MARK: - UpdateTracking

protocol UpdateTracking {
    func track(for key: String)
    func lastUpdate(for key: String) -> Date?
}

struct UpdateTracker: UpdateTracking {
    static let formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds]
        return formatter
    }()

    func track(for key: String) {
        Self.track(for: key)
    }

    func lastUpdate(for key: String) -> Date? {
        Self[key]
    }

    fileprivate static func track(for key: String) {
        log.debug("🛠️ Updating tracked property: \(key)")
        self[key] = Date()
    }

    /// A key under which the last update value is stored in the UserDefaults.
    private static func storeKey(for key: String) -> String {
        "lastUpdateOf.\(key)"
    }

    // swiftlint:disable:next strict_fileprivate
    fileprivate static subscript(key: String) -> Date? {
        get {
            guard let lastUpdateDateString = UserDefaults.standard.string(forKey: storeKey(for: key)) else {
                return nil
            }
            return formatter.date(from: lastUpdateDateString)
        }
        set {
            let storeKey = storeKey(for: key)
            guard let newValue else {
                UserDefaults.standard.removeObject(forKey: storeKey)
                return
            }
            let encodedValue = formatter.string(from: newValue)
            UserDefaults.standard.set(encodedValue, forKey: storeKey)
        }
    }
}

// MARK: - PropertyUpdateTracking

protocol PropertyUpdateTracking {
    var propertyName: String { get }
    var lastUpdate: Date? { get set }
    func track()
}

struct PropertyUpdateTracker: PropertyUpdateTracking {
    let tracker = UpdateTracker()
    let propertyName: String

    var lastUpdate: Date? {
        get { UpdateTracker[propertyName] }
        set { UpdateTracker[propertyName] = newValue }
    }

    func track() {
        UpdateTracker.track(for: propertyName)
    }
}

// MARK: - Property Wrapper

@propertyWrapper
struct UpdateTracked<Value: Equatable> {
    private(set) var value: Value
    private var updateTracker: PropertyUpdateTracking

    var wrappedValue: Value {
        get { value }
        set {
            // only update if value actually changes
            if newValue != value {
                value = newValue
                lastUpdate = Date()
            }
        }
    }

    var lastUpdate: Date? {
        get { updateTracker.lastUpdate }
        set { updateTracker.lastUpdate = newValue }
    }

    init(wrappedValue initialValue: Value, propertyName: String) {
        self.value = initialValue
        self.updateTracker = PropertyUpdateTracker(propertyName: propertyName)
    }
}

```