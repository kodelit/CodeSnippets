# Rx: subscribe(onNext:) with weak self as target
- **shortcut**: `rx_subscribeOnNextWithWeakSelf`
- **language**: Swift
- **platform**: 


## Code:
```swift
subscribe(onNext: { [weak self] (value) in
                guard let target = self else { return }
                <#code#>
            })
```