# Rx: subscribeNext(...) with weak self as target
- **shortcut**: `rx_subscribeNext`
- **language**: Swift
- **platform**: 


## Code:
```swift
subscribeNext(weak: self, { (target) -> (<#Type#>) -> Void in
    return { value in
        <#code#>
    }
    })
```