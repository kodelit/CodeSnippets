# Ext: UIView + Find first/all
- **shortcut**: `ext_UIView+findFirstOrAll`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
extension UIView {
    func first(where condition: (UIView) -> Bool) -> UIView? {
        if condition(self) {
            return self
        }
        
        for subview in subviews {
            if let foundView = subview.first(where: condition) {
                return foundView
            }
        }
        return nil
    }

    func all(where condition: (UIView) -> Bool) -> [UIView] {
        var views: [UIView] = []
        if condition(self) {
            views.append(self)
        }
        for subview in subviews {
            views.append(contentsOf: subview.all(where: condition))
        }
        return views
    }
}
```