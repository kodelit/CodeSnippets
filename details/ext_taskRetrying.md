# Ext: Task + Retrying
- **shortcut**: `ext_taskRetrying`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import Foundation

extension Task where Failure == Error {
    /// [Source](https://www.swiftbysundell.com/articles/retrying-an-async-swift-task/)
    @discardableResult static func retrying(
        priority: TaskPriority? = nil,
        maxRetryCount: Int = 3,
        retryDelay: TimeInterval = 1,
        operation: @Sendable @escaping () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            for _ in 0..<maxRetryCount {
                do {
                    return try await operation()
                } catch {
                    let oneSecond = TimeInterval(1_000_000_000)
                    let delay = UInt64(oneSecond * retryDelay)
                    try await Task<Never, Never>.sleep(nanoseconds: delay)
                }
            }
            
            try Task<Never, Never>.checkCancellation()
            return try await operation()
        }
    }
}
```