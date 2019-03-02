# Extending property: ServiceDependency property definition
- **shortcut**: `ext_prop_ServiceDependency`
- **language**: Swift
- **platform**: 

## Summary
Class extension adding new property definition

## Code:
```swift
// MARK: - <#ClassName#>+ServiceDependency

extension ServiceDependency where Dependent:<#ClassName#> {
    public var <#serviceName#>:<#ServiceClassName#> { return <#ServiceClassName#>.shared }
}
```