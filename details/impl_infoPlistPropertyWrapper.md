# Impl: InfoPlistPropertyWrapper
- **shortcut**: `impl_infoPlistPropertyWrapper`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
//
//  InfoPlistPropertyWrapper.swift
//
//  Created by Grzegorz Maciak on 26/11/2020.
//  Copyright © 2020 Grzegorz Maciak. All rights reserved.
//  Copyright © 2020 Andrzej Jacak. All rights reserved.
//  This code is distributed under the terms and conditions of the MIT license.
//  See: https://opensource.org/licenses/MIT
//

import Foundation

// MARK: - PropertyKey

public enum PropertyKey: ExpressibleByStringLiteral, Sendable {
    /// Valid and fixed String key
    case fixed(String)

    /// Key cannot be set at wrapper `init` method and have to be provided later.
    ///
    /// Example: Creating may require `self` to be constructed, therefore it cannot be passed in wrapper `init` but have to be provided later
    /// ```swift
    /// class A {
    ///     let someId: String
    ///
    ///     @UserDefault(key: .notSetYet, defaultValue: false)
    ///     var myProperty: Bool
    ///
    ///     init(someId: String) {
    ///     self.someId  = someId
    ///         _myProperty.key = .fixed("key \(someId)")
    ///     }
    ///     // ...
    /// }
    /// ```
    /// - warning: Only key with value `.notSetYet` can be set this way, and when key is set to `.fixed(String)` it cannot be changed again.
    case notSetYet

    var rawKey: String? {
        if case let .fixed(key) = self {
            return key
        }
        return nil
    }

    public init(stringLiteral value: String) {
        self = value.isEmpty ? .notSetYet : .fixed(value)
    }
}

// MARK: - InfoPlistValue

/// Access to the Info.plist values with check of their existence
@propertyWrapper
public struct InfoPlistValue<T> {
    public let wrappedValue: T

    public init(key: PropertyKey, subkey: PropertyKey? = nil, defaultValue: T, bundle: Bundle? = nil) {
        guard let rawKey = key.rawKey, !rawKey.isEmpty else {
            assertionFailure("Property key not set!")
            self.wrappedValue = defaultValue
            return
        }
        let bundle = bundle ?? Bundle.main
        if let subkey = subkey {
            guard let value = bundle.object(forInfoDictionaryKey: rawKey) as? [String: Any] else {
                assertionFailure("Missing Info.plist entry for key '\(rawKey)'")
                self.wrappedValue = defaultValue
                return
            }
            guard let rawSubkey = subkey.rawKey, !rawSubkey.isEmpty,
                  let subvalue = value[rawSubkey] as? T else {
                assertionFailure("Missing Info.plist entry for key path '\(key).\(subkey)'")
                self.wrappedValue = defaultValue
                return
            }
            self.wrappedValue = subvalue
        } else {
            guard let value = bundle.object(forInfoDictionaryKey: rawKey) as? T else {
                assertionFailure("Missing Info.plist entry for key '\(rawKey)'")
                self.wrappedValue = defaultValue
                return
            }
            self.wrappedValue = value
        }
    }
}

extension InfoPlistValue where T == String {
    public init(key: PropertyKey, subkey: PropertyKey? = nil, bundle: Bundle? = nil) {
        self.init(key: key, subkey: subkey, defaultValue: "", bundle: bundle)
    }
}

// MARK: - Info.plist keys

extension PropertyKey {
    static let bundleShortVersionString: PropertyKey = "CFBundleShortVersionString"
    static let bundleVersionString: PropertyKey = "CFBundleVersion"

    // MARK: Custom
    
    static let appGroupId: PropertyKey = "AppGroupId"
}

// MARK: - Default Info.plist Entries

@MainActor
public struct InfoPlist {
    /// A value for `CFBundleShortVersionString` key, it is the marketing version of the app (without build number), eg. "4.5.9" .
    @InfoPlistValue(key: .bundleShortVersionString)
    static var bundleShortVersionString: String

    /// A value for `CFBundleVersion` key, it is the short version with build number (eg. 4.5.9.7) or in many cases just a single number representing a build number (eg. 7).
    @InfoPlistValue(key: .bundleVersionString)
    static var bundleVersionString: String
}
```