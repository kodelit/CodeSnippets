# Rx: ReactiveDetailViewModel protocol implementation
- **shortcut**: `rx_RefreshableViewModel`
- **language**: Swift
- **platform**: 


## Code:
```swift
// MARK: ReactiveRefreshableViewModel
    
    var data: <#DataType#>? = nil
    
func reload(with data: <#DataType#>) {
        // remove previous binding
        self.disposeBag = DisposeBag()
        self.data = data
        
    }

/// Rebinds with binders and observers of the view as params
//func rebind(...) {
//    
//}
```