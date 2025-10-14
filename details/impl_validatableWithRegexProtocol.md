# Impl: Validatable with Regext Protocol
- **shortcut**: `impl_validatableWithRegexProtocol`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
public protocol Validatable {
    var isValid: Bool { get }
}

public protocol ValidatableWithRegex: Validatable {
    var validationPattern: String { get }
}

public extension ValidatableWithRegex {
    func validate(_ value: String) throws -> Bool {
        let regex = try Regex(validationPattern)
        return try regex.firstMatch(in: value) != nil
    }
}

public extension ValidatableWithRegex where Self: RawRepresentable, RawValue == String {
    var isValid: Bool {
        do {
            return try validate(rawValue)
        } catch {
            assertionFailure("Invalid regex pattern, error: \(error)")
            return false
        }
    }
}

//extension Regex: @retroactive ExpressibleByExtendedGraphemeClusterLiteral {}
//extension Regex: @retroactive ExpressibleByUnicodeScalarLiteral {}
//extension Regex: @retroactive ExpressibleByStringLiteral {
//    public typealias StringLiteralType = String
//
//    public init(stringLiteral value: String) {
//        guard let regex = try? Self(value) else {
//            fatalError("Validation regex failed to compile.")
//        }
//        self = regex
//    }
//}
```