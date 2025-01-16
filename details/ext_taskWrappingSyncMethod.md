# Ext: Task + Wrapping sync method and perorming on main thread
- **shortcut**: `ext_taskWrappingSyncMethod`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
extension Task where Failure == Never {
    static func performOnMain(priority: TaskPriority? = nil, _ operation: @autoclosure @escaping () -> Success) async -> Success {
        let task = Task.init(priority: priority, operation: { @MainActor in
            operation()
        })
        return await task.value
    }
}
```