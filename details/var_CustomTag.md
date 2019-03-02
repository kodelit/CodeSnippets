# Var: Custom runtime TAG 
- **shortcut**: `var_CustomTag`
- **language**: Swift
- **platform**: 

## Summary
Used to identify owned objects or view in hierarchy somehow associated  with `self`

## Code:
```swift
<#fileprivate#> var <#ownedObjectName#>RuntimeTag:Int {
        return "\(ObjectIdentifier(self).hashValue)_<#ownedObjectName#>".hashValue
    }
```