# Impl: LazyAsyncValue
- **shortcut**: `impl_LazyAsyncValue`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import Foundation

protocol AsyncValueLoading<T> {
    associatedtype T: Sendable
    /// Returns the value
    ///
    /// The method returns the value:
    /// - from the cache if it's already loaded
    /// - loads it first if not loaded
    func getValue(defaultValue: T) async -> T
    @discardableResult func getValue() async throws -> T
    /// Invalidates the value so it might be loaded again when needed.
    func invalidateValue() async
    /// Invalidates and loads the value again.
    @discardableResult func reloadValue() async throws -> T
    /// Performs the operation on the value blocking the value from being change during the operation.
    ///
    /// It allows to delay changing the value therefore other opearations on the value and value update operation have to wait.
    func perform<Success>(opearation: @Sendable @escaping (T) async throws -> Success) async throws -> Success
}

/// Stores data of any type fetched on demand and cached until the value is removed or reset.
///
/// The wrapped value is not removed in case of memory warning. If you would like it to be removed in such case please use ``LazyAsynchValueCache``
/// - note: Inspared by: https://stackoverflow.com/a/70586582/1776859
actor LazyAsyncValue<T: Sendable>: AsyncValueLoading {
    private enum Status {
        case notLoaded
        case loading(Task<T, Error>)
        case working(completion: () async -> Void)
        case ready(T)
    }

    private var status: Status = .notLoaded
    var loader: () async throws -> T
    
    /// - Parameters:
    ///   - preloadedValue: convenience parameter for preset value to use in corner cases when we already have the value.
    ///   - loader: A closure providing the requested result.
    init(preloadedValue: T? = nil, loader: @escaping @Sendable () async throws -> T) {
        if let preloadedValue {
            status = .ready(preloadedValue)
        }
        self.loader = loader
    }
    
    func getValue(defaultValue: T) async -> T {
        (try? await getValue()) ?? defaultValue
    }

    @discardableResult
    func getValue() async throws -> T {
        switch status {
        case let .ready(value):
            return value
        case let .loading(task):
            return try await task.value
        case let .working(completion):
            await completion()
            // In order to avoid the case when some other task could start using the value let's go through the state check again.
            return try await getValue()
        case .notLoaded:
            break
        }

        let task = Task<T, Error> {
            try await loader()
        }

        status = .loading(task)
        do {
            let value = try await task.value
            status = .ready(value)
            return value
        } catch {
            status = .notLoaded
            throw error
        }
    }

    func invalidateValue() async {
        if case let .working(completion) = status {
            // If there is some work being performed on the value, just wait until it's done to avoid interfering.
            await completion()
            // Start again in order to verifying if the status is not changed to `.working` again by some other task
            await invalidateValue()
            return
        }
        guard case .ready = status else {
            return
        }
        status = .notLoaded
    }

    @discardableResult
    func reloadValue() async throws -> T {
        await invalidateValue()
        return try await getValue()
    }
    
    func perform<Success>(opearation: @Sendable @escaping (T) async throws -> Success) async throws -> Success {
        let value = try await getValue()
        
        // In order to avoid reentrency problem the state will be replaced by the task which will return the state when it's not used anymore
        let task: Task<Success, Error> = Task {
            try await opearation(value)
        }
        status = .working(completion: { _ = try? await task.value })
        do {
            let taskValue = try await task.value
            status = .ready(value)
            return taskValue
        } catch {
            status = .ready(value)
            throw error
        }
    }
}


```