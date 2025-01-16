# Impl: Struct raw Int replresentable, Equatable, Codable
- **shortcut**: `impl_RawIntRepresentableStruct`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
        public struct <#Name#>: Codable, Hashable, RawRepresentable, Equatable, ExpressibleByIntegerLiteral {
            
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            public init(integerLiteral value: RawValue) { self.init(rawValue: value) }
        }
```