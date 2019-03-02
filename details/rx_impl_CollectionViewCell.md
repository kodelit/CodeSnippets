# Rx Impl: Collection View Cell implementation
- **shortcut**: `rx_impl_CollectionViewCell`
- **language**: Swift
- **platform**: 


## Code:
```swift
class <#CellClassName#>: UICollectionViewCell, ReactiveCell {
    
    let viewModel = <#CellClassName#>ViewModel()
    
    override func prepareForReuse() {
        self.viewModel.prepareForReuse()
    }
    
    func reload(with data: <#CellDataType#>) {
        self.viewModel.reload(with: data)
        //self.viewModel.rebind(isActive: self.rx.isActive, didUpdate: self.rx.didUpdate)
    }
}
```