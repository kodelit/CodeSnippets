# Extension Property
- **shortcut**: `prop_WithAssociatedObject`
- **language**: Swift
- **platform**: 

## Summary
Associated Object Property

## Code:
```swift
private static var <#propertyName#>AssociationKey: Int = 0
    var <#propertyName#>:<#ClassName#>? {
        get { return objc_getAssociatedObject(self, &<#ClassName#>.<#propertyName#>AssociationKey) as? <#ClassName#> }
        set { objc_setAssociatedObject(self, &<#ClassName#>.<#propertyName#>AssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
```