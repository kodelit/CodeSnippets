# Rx: Reactive delegate (proxy) property
- **shortcut**: `rx_prop_ReactiveDelegate`
- **language**: Swift
- **platform**: 


## Code:
```swift
/// Reactive delegate proxy
    public var delegate: DelegateProxy<<#ClassName#>, <#ClassName#>Delegate> {
        return Rx<#ClassName#>DelegateProxy.proxy(for: base)
    }
```