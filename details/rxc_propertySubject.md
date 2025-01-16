# Combine: Property Subject 
- **shortcut**: `rxc_propertySubject`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
private var <#name#>Subject = CurrentValueSubject<<#Type#>, Never>(<#value#>)
private var <#name#>: <#Type#> {
    get { <#name#>Subject.value }
    set { <#name#>Subject.send(newValue) }
}
var <#name#>Publisher: AnyPublisher<<#Type#>, Never> { <#name#>Subject.eraseToAnyPublisher() }
```