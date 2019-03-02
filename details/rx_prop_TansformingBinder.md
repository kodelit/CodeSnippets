# Rx: Var: Transforming Binder variable
- **shortcut**: `rx_prop_TansformingBinder`
- **language**: Swift
- **platform**: 


## Code:
```swift
var <#binder#>:((<#ObservableType#>) -> Disposable) {
        return { (source) -> Disposable in
            let transformation = source
            
            return transformation.bind(to: <#targetBinder#>)
        }
    }
```