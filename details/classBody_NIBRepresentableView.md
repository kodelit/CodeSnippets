# Class Body: NIBRepresentable view
- **shortcut**: `classBody_NIBRepresentableView`
- **language**: Swift
- **platform**: iphoneos


## Code:
```swift
@IBOutlet public var contentView: UIView?

@IBInspectable public var nibName:String? = nil
open var customNibName:String? { return nibName }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInitFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInitFromNib()
    }
    
    public func customInitFromNib() {
    if self.contentView == nil {
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
    }
}

//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
//    }
```