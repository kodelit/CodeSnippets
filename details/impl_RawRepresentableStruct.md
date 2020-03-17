# Impl: Struct RawReplresentable, Equatable
- **shortcut**: `impl_RawRepresentableStruct`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
public struct <#Name#>: Hashable, RawRepresentable, Equatable, ExpressibleByStringLiteral {
    public var rawValue: String

    public init(_ rawValue: String) { self.rawValue = rawValue }
    public init(rawValue: String) { self.rawValue = rawValue }
    public init(stringLiteral value: String) { self.rawValue = value }
}
```