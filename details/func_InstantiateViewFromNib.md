# Func: Instantiate view from nib
- **shortcut**: `func_InstantiateViewFromNib`
- **language**: Swift
- **platform**: 

## Summary
Implementation of method for instantiating views from nib.

## Code:
```swift
static func instantiate<T>(nibName:String? = nil, bundle:Bundle? = nil) -> T? where T:<#ClassName#> {
        let targetBundle = bundle ?? Bundle(for: self)
        let targetNibName = nibName != nil && !nibName!.isEmpty ? nibName! : NSStringFromClass(self).components(separatedBy: ".").last!
        if let view = targetBundle.loadNibNamed(targetNibName, owner: nil, options: nil)?.first as? T {
            return view
        }
        return nil
    }
```