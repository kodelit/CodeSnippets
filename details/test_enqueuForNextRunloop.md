# Tests: Enqueue for next runloop
- **shortcut**: `test_enqueuForNextRunloop`
- **language**: Swift
- **platform**: 

## Summary
Enqueue the next step in order to allow the updates to finish propagating through the publishers first.

## Code:
```swift
        // Enqueue the next step in order to allow the updates to finish propagating through the publishers first.
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                <#code to perform#>
                continuation.resume(returning: ())
            }
        }
```