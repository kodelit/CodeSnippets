# Prop: Static NIB file reference property
- **shortcut**: `prop_ClassNibReferenceProperty`
- **language**: Generic
- **platform**: 


## Code:
```generic
static var nib:UINib {
        return UINib(nibName: NSStringFromClass(self).components(separatedBy: ".").last!, bundle: Bundle(for: self))
    }
```