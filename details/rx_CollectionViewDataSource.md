# Rx: CollectionViewDataSoruce
- **shortcut**: `rx_CollectionViewDataSource`
- **language**: Swift
- **platform**: 

## Summary
RxCollectionViewSectionedReloadDataSource

## Code:
```swift
typealias Section = SectionModel<String, <#cell data class#>>
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<Section>(configureCell: { (ds, collectionView, indexPath, data) -> UICollectionViewCell in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: <#cell id#>, for: indexPath) as! <#cell class#>
        let cellData = ds[indexPath]
        
        // configure
        
        return cell
    }, configureSupplementaryView: { (ds, collectionView, kind, indexPath) -> UICollectionReusableView in
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: <#supplementary view id#>, for: indexPath) as! <#supplementary view class#>
        let section = ds[indexPath.section]
        
        // configure
        
        return view
    })
```