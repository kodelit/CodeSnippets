# Rx: Observable Test
- **shortcut**: `rx_TestObservable`
- **language**: Swift
- **platform**: 


## Code:
```swift
do(onNext: { item in
    print(" onNext: \(String(describing: item))")
}, onError: { (error) in
    print(" onError: \(error)")
}, onCompleted: {
    print(" onCompleted")
}, onSubscribe: {
    print(" onSubscribe")
}, onSubscribed: {
    print(" onSubscribed")
}, onDispose: {
    print(" onDispose")
})
```