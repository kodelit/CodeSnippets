# Ipml: TCA: Dependency Interface
- **shortcut**: `impl_tca_dependencyInterface`
- **language**: Swift
- **platform**: 

## Summary
Dependency in CoposableArchitecture

## Code:
```swift
import ComposableArchitecture
import Foundation

public struct <#InterfaceName#> {

}

extension <#InterfaceName#>: DependencyKey {
    public static let liveValue: <#InterfaceName#> = {
        // Dependencies

        return <#InterfaceName#>(

        )
    }()
}

extension DependencyValues {
    var <#dependencyName#>: <#InterfaceName#> {
        get { self[<#InterfaceName#>.self] }
        set { self[<#InterfaceName#>.self] = newValue }
    }
}
```