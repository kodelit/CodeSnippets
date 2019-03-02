# Example: Rx ControlProperty
- **shortcut**: `rx_example_ControlProperty`
- **language**: Generic
- **platform**: 


## Code:
```generic
extension Reactive where Base: UISearchBar {
    /// Reactive wrapper for `text` property.
    public var value: ControlProperty<String?> {
        let source: Observable<String?> = Observable.deferred { [weak searchBar = self.base as UISearchBar] () -> Observable<String?> in
            let text = searchBar?.text
            
            return (searchBar?.rx.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBar(_:textDidChange:))) ?? Observable.empty())
            .map { a in
                return a[1] as? String
            }
            .startWith(text)
        }
        
        let bindingObserver = UIBindingObserver(UIElement: self.base) { (searchBar, text: String?) in
            searchBar.text = text
        }
        
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}

extension Reactive where Base: UISegmentedControl {
        /// Reactive wrapper for `selectedSegmentIndex` property.
        public var selectedSegmentIndex: ControlProperty<Int> {
            return value
        }
        
        /// Reactive wrapper for `selectedSegmentIndex` property.
        public var value: ControlProperty<Int> {
            return UIControl.rx.value(
                self.base,
                getter: { segmentedControl in
                    segmentedControl.selectedSegmentIndex
            }, setter: { segmentedControl, value in
                segmentedControl.selectedSegmentIndex = value
            }
            )
        }
    }
```