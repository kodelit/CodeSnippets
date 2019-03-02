# Rx: Binder variable
- **shortcut**: `rx_prop_Binder`
- **language**: Swift
- **platform**: 


## Code:
```swift
var <#binder#>: Binder<<#type#>> {
        return Binder<<#type#>>(base, binding: { target, value in
            <#binding code#>
        })
    }
```