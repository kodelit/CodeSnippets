# Rx: Reactive extension property (RxSwift)
- **shortcut**: `rx_prop_OfReactiveExtension`
- **language**: Swift
- **platform**: 

## Summary
Reactive extension property declaration (observable and observer)

## Code:
```swift
var <#propertyName#>: Observable<<#type#>> {
        return base._<#propertyName#>.asObservable()
    }
    
    var set<#PropertyName#>: Binder<<#type#>> {
        return Binder<<#type#>>(base, binding: { target, value in
            target.<#propertyName#> = value
        })
    }
```