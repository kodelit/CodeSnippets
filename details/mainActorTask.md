# My Code Snippet
- **shortcut**: `mainActorTask`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
Task { @MainActor [weak self] in
    guard let self else { return }
    <#code#>
}
```