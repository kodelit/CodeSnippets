# Var: Default runtime TAG of an object
- **shortcut**: `var_DefaultTag`
- **language**: Swift
- **platform**: 


## Code:
```swift
<#fileprivate#> var defaultTag:Int { return ObjectIdentifier(self).hashValue }
```