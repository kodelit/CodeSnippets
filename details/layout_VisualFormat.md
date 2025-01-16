# Layout: VisualFormat
- **shortcut**: `layout_VisualFormat`
- **language**: Swift
- **platform**: 

## Summary
Constraints declaration in visual format

## Code:
```swift
         <#viewName#>.translatesAutoresizingMaskIntoConstraints = false
         self.addSubview(<#viewName#>)
         
         NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": <#viewName#>]))
         NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": <#viewName#>]))
```