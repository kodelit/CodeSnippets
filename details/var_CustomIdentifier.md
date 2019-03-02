# Var: Custom runtime Identifier
- **shortcut**: `var_CustomIdentifier`
- **language**: Swift
- **platform**: 


## Code:
```swift
<#fileprivate#> var <#ownedObjectName#>RuntimeIdentifier:String {
        return "\(ObjectIdentifier(self).hashValue)_<#ownedObjectName#>"
    }
```