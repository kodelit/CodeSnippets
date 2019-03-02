# Ext: UIViewController + Presentation ( fileprivate )
- **shortcut**: `ext_UIViewController+Presentation_fileprivate`
- **language**: Swift
- **platform**: 


## Code:
```swift
extension UIViewController {
    fileprivate func present(on presenter:UIViewController? = nil, animated:Bool = false, didShow:((Bool) -> Void)? = nil) {
        var presenter = presenter ?? UIApplication.shared.keyWindow?.rootViewController
        while presenter?.presentedViewController != nil
            && !presenter!.presentedViewController!.isBeingDismissed
        {
            presenter = presenter?.presentedViewController!
            if presenter === self {
                presenter = nil
                break
            }
        }
        
        if let target = presenter {
            target.present(self, animated: animated, completion: {
                didShow?(true)
            })
        }else{
            didShow?(false)
        }
    }
}
```