# Rx: Get single item or observe changes of the Firebase value
- **shortcut**: `rx_FirebaseGetOrObserve`
- **language**: Swift
- **platform**: 


## Code:
```swift
func <#observerName#>(observe:Bool) -> Observable<<#ResultType#>> {
        return Observable<<#ResultType#>>.create { (observer) -> Disposable in
            
            let ref = UserDataService.dbRoot.child(<#...#>)
            
            let handler:(DataSnapshot) -> Void = { (snapshot) in
                let result = <#result#>
                observer.onNext(result)
                if !observe {
                    observer.onCompleted()
                }
            }
            
            if observe {
                let handle = ref.observe(.value, with: handler)
                return Disposables.create {
                    ref.removeObserver(withHandle: handle)
                }
            }
            ref.observeSingleEvent(of: .value, with: handler)
            return Disposables.create()
        }
    }
```