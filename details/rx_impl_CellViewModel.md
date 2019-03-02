# Rx Impl: CellViewModel Implementation
- **shortcut**: `rx_impl_CellViewModel`
- **language**: Swift
- **platform**: 


## Code:
```swift
class <#CellClassName#>ViewModel: RxViewModel & ReactiveCellViewModel {
    
    func prepareForReuse() {
        // Breaks previous bindings
        self.disposeBag = DisposeBag()
    }
    
    var data:<#CellDataType#>? = nil
    
    /// Sets data
    func reload(with data: <#CellDataType#>) {
        self.data = data
    }
    
    /// Setups new bindings
//    func rebind(<#...#>) {
//        // setup binders if needed
//    }
}
```