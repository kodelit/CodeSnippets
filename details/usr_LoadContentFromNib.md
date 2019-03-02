# Load content view from nib
- **shortcut**: `usr_LoadContentFromNib`
- **language**: Swift
- **platform**: iphoneos


## Code:
```swift
UINib(nibName: self.customNibName ?? NSStringFromClass(type(of: self)).components(separatedBy: ".").last!,
      bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil)
if let view = contentView {
    view.frame = self.bounds
    
    // first approach
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(view)
    
    // second approach
    /*
     view.translatesAutoresizingMaskIntoConstraints = false
     self.addSubview(view)
     
     NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": view]))
     NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": view]))
     */
}
```