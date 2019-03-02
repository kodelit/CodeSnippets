# Rx: Property with RxSwift Subject
- **shortcut**: `rx_prop_BackedWithRxVariable`
- **language**: Swift
- **platform**: 

## Summary
Declaration of property backed with BehaviorRelay

## Code:
```swift
fileprivate lazy var _<#propertyName#> = BehaviorRelay<<#type#>>(value: <#initialValue#>)
var <#propertyName#>: <#type#> {
    get { return _<#propertyName#>.value }
    set { _<#propertyName#>.accept(newValue) }
}
```