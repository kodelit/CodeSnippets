# Example: Rx ControlEvent
- **shortcut**: `rx_example_ControlEvent`
- **language**: Generic
- **platform**: 


## Code:
```generic
public extension Reactive where Base: UIViewController {
    
    /// Reactive wrapper for `viewDidLoad` message `UIViewController:viewDidLoad:`.
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `viewWillAppear` message `UIViewController:viewWillAppear:`.
    public var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:)))
        .map { a in
            return a[0] as! Bool
        }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UICollectionView {
    
    /// Reactive wrapper for `delegate` message `collectionView:didSelectItemAtIndexPath:`.
    public var itemSelected: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
            .map { a in
                return a[1] as! IndexPath
        }
        
        return ControlEvent(events: source)
    }
}
```