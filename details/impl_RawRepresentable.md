# Impl: Struct RawReplresentable, Equatable
- **shortcut**: `impl_RawRepresentable`
- **language**: Swift
- **platform**: 


## Code:
```swift
public struct <#Name#>:Hashable, RawRepresentable, Equatable {
    public var rawValue: String
    
    public init(_ rawValue:String) {
        self.rawValue = rawValue
    }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
```