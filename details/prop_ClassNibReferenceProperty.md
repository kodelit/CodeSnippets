# Prop: Static NIB file reference property
- **shortcut**: `prop_ClassNibReferenceProperty`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
static var nib:UINib {
        return UINib(nibName: NSStringFromClass(self).components(separatedBy: ".").last!, bundle: Bundle(for: self))
    }
```