# Rx: Reactive class override and extension
- **shortcut**: `rx_impl_Class`
- **language**: Swift
- **platform**: 

## Summary
Rx class override and Reactive extension implementation

## Code:
```swift
import RxSwift
import RxCocoa

// uncomment following line if your class does not conforms to ReactiveCompatible protocol
//extension <#ClassName#> : ReactiveCompatible {}

public class Rx<#ClassName#>: <#ClassName#> {
    
    fileprivate lazy var _<#propertyName#> = BehaviorSubject<<#type#>>(value: self.<#propertyName#>)
    <#override#> public var <#propertyName#>: <#type#> = <#value#> {
        didSet {
            _<#propertyName#>.onNext(<#propertyName#>)
        }
    }
}

// MARK: - <#ClassName#>+Rx

extension Reactive where Base: Rx<#ClassName#> {
    
    public var <#propertyName#>: Observable<<#type#>> {
        return base._<#propertyName#>.asObservable()
    }
    
    public var set<#PropertyName#>: Binder<<#type#>> {
        return Binder<<#type#>>(base, binding: { target, value in
            target.<#propertyName#> = value
        })
    }
}
```