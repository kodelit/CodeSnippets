# Combine: Static Property Subject
- **shortcut**: `rxc_staticPropertySubject`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
    private static var <#name#>Subject = CurrentValueSubject<<#Type#>, Never>(<#value#>)
    private var <#name#>: <#Type#> {
        get { Self.<#name#>Subject.value }
        set { Self.<#name#>Subject.send(newValue) }
    }
    var <#name#>Publisher: AnyPublisher<<#Type#>, Never> { Self.<#name#>Subject.eraseToAnyPublisher() }
```