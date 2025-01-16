# Impl: Dynamic CodingKeys
- **shortcut**: `impl_dynamicCodingKeys`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
    struct CodingKeys: CodingKey {
        //static let devicetypes = CodingKeys(stringValue: "devicetypes")
        //static let runtimes = CodingKeys(stringValue: "runtimes")
        //static let devices = CodingKeys(stringValue: "devices")

        var stringValue: String
        init(stringValue: String) {
            self.stringValue = stringValue
        }

        let intValue: Int? = nil
        init?(intValue: Int) {
            return nil
        }
    }
```