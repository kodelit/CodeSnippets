# Impl: Struct raw String replresentable, Equatable, Codable
- **shortcut**: `impl_RawStringRepresentableStruct`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
public struct <#Name#>: Codable, Hashable, RawRepresentable, Equatable, ExpressibleByStringLiteral {
    
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
    public init(stringLiteral value: String) { self.init(rawValue: value) }
}
```