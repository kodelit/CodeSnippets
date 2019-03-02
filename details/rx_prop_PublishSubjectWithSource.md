# Rx: PublishSubject with additional soruce
- **shortcut**: `rx_prop_PublishSubjectWithSource`
- **language**: Swift
- **platform**: 


## Code:
```swift
fileprivate lazy var _<#propertyName#>Source = PublishSubject<Observable<<#Type#>>>()
    fileprivate lazy var _<#propertyName#>:PublishSubject<<#Type#>> = {
        let subject = PublishSubject<<#Type#>>()
    _<#propertyName#>Source.switchLatest().bind(to: subject).disposed(by: <#disposeBag#>)
        return subject
    }()
```