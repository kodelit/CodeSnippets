# Class Body: View common Init
- **shortcut**: `classBody_ViewCommonInit`
- **language**: Swift
- **platform**: 


## Code:
```swift
@IBOutlet public var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public func commonInit() {
        
    }
```