# Combine: Notifier Property Subject
- **shortcut**: `rxc_notifierPropertySubject`
- **language**: Swift
- **platform**: 

## Summary
A publiser to notify about event

## Code:
```swift
private static var <#didDoSometing#>Subject = PassthroughSubject<Void, Never>()
var <#didDoSometing#>Publisher: AnyPublisher<Void, Never> { Self.<#didDoSometing#>Subject.eraseToAnyPublisher() }
```