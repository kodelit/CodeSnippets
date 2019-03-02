# Rx: Property with Source subject
- **shortcut**: `rx_prop_WithSource`
- **language**: Swift
- **platform**: 

## Summary
Declaration of property backed with BehaviorRelay, and source PublishSubject as a additional reactive source

## Code:
```swift
fileprivate lazy var _<#propertyName#>Source = PublishSubject<Observable<<#Type#>>>()
fileprivate lazy var _<#propertyName#>:BehaviorRelay<<#Type#>> = {
let subject = BehaviorRelay<<#Type#>>(value: <#initialValue#>)
_<#propertyName#>Source.switchLatest().bind(to: subject).disposed(by: <#disposeBag#>)
return subject
}()
var <#propertyName#>: <#type#> {
get { return _<#propertyName#>.value }
    set { _<#propertyName#>.accept(newValue) }
        }
```