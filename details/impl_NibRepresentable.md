# Impl: NIBRepresentable protocol
- **shortcut**: `impl_NibRepresentable`
- **language**: Swift
- **platform**: 

## Summary
NIBRepresentable protocol implementation for view

## Code:
```swift
@IBOutlet public var contentView: UIView?

@IBInspectable public var nibName:String? = nil
open var customNibName:String? { return nibName }

public required override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInitFromNib()
}

public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInitFromNib()
}

override var intrinsicContentSize: CGSize {
    return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
}
```