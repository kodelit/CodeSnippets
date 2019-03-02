# Controller presentation method implementation
- **shortcut**: `usr_PresentController`
- **language**: Swift
- **platform**: iphoneos

## Summary
Implementation of the method to handle different controller presentation issues

## Code:
```swift
/// Controller presentation helper
public func present(_ controller:UIViewController, on presenter:UIViewController?, didShowOn:((UIViewController) -> Void)? = nil) {
    var presenter = presenter ?? UIApplication.shared.keyWindow?.rootViewController
    while presenter?.presentedViewController != nil {
        presenter = presenter?.presentedViewController!
        if presenter === self {
            presenter = nil
            break
        }
    }
    
    if let target = presenter {
        target.present(controller, animated: true, completion: {
            didShowOn?(target)
        })
    }
}
```