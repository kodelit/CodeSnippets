# Impl: Extended LazyAsyncValue
- **shortcut**: `impl_ExtendedLazyAsyncValue`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
// swiftlint:disable:next file_header
//
//  LazyExtendedAsyncValue.swift
//
//  Created by Grzegorz Maciak on 31/01/2025.
//  Copyright © 2025 Grzegorz Maciak. All rights reserved.
//  This code is distributed under the terms and conditions of the MIT license.
//  See: https://opensource.org/licenses/MIT
//

import Foundation

protocol ExtendedAsyncValueLoading<T>: Actor {
    associatedtype T: Sendable
    typealias PreInvalidationOperation<Success> = @Sendable (T?) async throws -> Success
    typealias Operation<Success> = @Sendable (T) async throws -> Success
    
    /// Returns the value
    ///
    /// The method returns the value or default value if loading will fail:
    /// - from the cache if it's already loaded
    /// - loads it first if not loaded
    func getValue(defaultValue: T) async -> T
    
    /// Returns the value
    ///
    /// The method returns the value:
    /// - from the cache if it's already loaded
    /// - loads it first if not loaded
    @discardableResult func getValue() async throws -> T
    
    /// Invalidates and loads the value again.
    @discardableResult func reloadValue() async throws -> T
    
    /// Invalidates the value so it might be loaded again when needed.
    func invalidateValue() async
    
    /// Blocks the value or value loading for the time of operation and invalidates the value if already loaded after operation is done.
    func invalidateValue<Success>(after operation: @escaping PreInvalidationOperation<Success>) async throws -> Success
    
    /// Blocks the value or value loading for the time of operation.
    ///
    /// Performs the operation on the value blocking the value from being change during the operation but not blocking the actor itself.
    /// It allows to delay changing the value therefore other operations on the value and value update operation have to wait.
    @discardableResult
    func perform<Success>(operation: @escaping Operation<Success>) async throws -> Success
}

//extension ExtendedAsyncValueLoading {
//    func invalidateValue(after operation: PreInvalidationOperation<Void>) async throws {
//        let _: Void = try await invalidateValue(after: operation)
//    }
//}

/// Stores data of any type fetched on demand and cached until the value is removed or reset.
///
/// The wrapped value is not removed in case of memory warning. If you would like it to be removed in such case please use ``LazyAsynchValueCache``
/// - note: Inspared by: https://stackoverflow.com/a/70586582/1776859
///
/// - warning: For security reasons `preloadedValue` cannot be provided when `sourceOfTruth` is provided because providing `sourceOfTruth` indicates that the value should be stored outside the actor, and only accessed through ``LazyExtendedAsyncValue``.
/// - warning: `sourceOfTruth` if provided should exist along with `didUpdateValue` closure in which we should update the source of thruth (value storage).
actor LazyExtendedAsyncValue<T: Sendable>: ExtendedAsyncValueLoading {
    typealias ValueObtainer = @Sendable () async throws -> T
    typealias PreInvalidationOperation<Success> = @Sendable (T?) async throws -> Success
    typealias Operation<Success> = @Sendable (T) async throws -> Success
    
    private enum Status {
        case notLoaded
        case loading(Task<T, Error>)
        case working(untilDone: @Sendable () async -> Void)
        case ready(obtainValue: ValueObtainer)
        
        var valueSource: ValueObtainer? {
            guard case let .ready(obtainValue) = self else {
                return nil
            }
            return obtainValue
        }
    }
    
    private var status: Status = .notLoaded
    var loader: @Sendable () async throws -> T
    var sourceOfTruth: ValueObtainer?
    var didUpdateValue: (@Sendable (T) async throws -> Void)?
    
    /// - Parameters:
    ///   - preloadedValue: convenience parameter for preset value to use in corner cases when we already have the value.
    ///   - loader: A closure providing the requested result.
    init(
        preloadedValue: T? = nil,
        loader: @escaping @Sendable () async throws -> T
    ) {
        if let preloadedValue, sourceOfTruth == nil {
            status = .ready(obtainValue: { preloadedValue })
        }
        self.loader = loader
    }
    
    /// - Parameters:
    ///   - sourceOfTruth: loading method returning value on demand form the "source of true". When you don't want to store the value in memory like values which should be stored in the keychain and obtained only when needed, you may provide this closure which will load the value on demand.
    ///   - loader: A closure providing the requested result.
    ///   - didUpdateValue: closure updating the source of truth or other words the value store.
    init(
        sourceOfTruth: @escaping ValueObtainer,
        loader: @escaping @Sendable () async throws -> T,
        didUpdateValue: @escaping @Sendable (_ value: T) async throws -> Void
    ) {
        self.loader = loader
        self.sourceOfTruth = sourceOfTruth
        self.didUpdateValue = didUpdateValue
    }
    
    // MARK: - Value management
    
    func getValue(defaultValue: T) async -> T {
        (try? await getValue()) ?? defaultValue
    }
    
    @discardableResult
    func getValue() async throws -> T {
        try await getValue(ignoreWorkingState: false)
    }
    
    private func getValue(ignoreWorkingState: Bool) async throws -> T {
        switch status {
        case let .ready(source):
            return try await source()
        case let .loading(task):
            return try await task.value
        case let .working(untilDone):
            if ignoreWorkingState {
                break
            }
            await untilDone()
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
            try await didUpdateValue?(value)
            status = .ready(obtainValue: valueObtainer(for: value))
            return value
        } catch {
            status = .notLoaded
            throw error
        }
    }
    
    @discardableResult
    func reloadValue() async throws -> T {
        await invalidateValue()
        return try await getValue()
    }
    
    func invalidateValue() async {
        if case let .working(completion) = status {
            // If there is some work being performed on the value, just wait until it's done to avoid interfering.
            await completion()
            // Start again in order to verifying if the status is not changed to `.working` again by some other task
            return await invalidateValue()
        }
        guard case .ready = status else {
            return
        }
        status = .notLoaded
    }
    
    func invalidateValue<Success>(after operation: @escaping PreInvalidationOperation<Success>) async throws -> Success where Success: Sendable {
        let operationStatus = preInvalidationOperation()
        var valueSource: ValueObtainer?
        switch operationStatus {
        case .noValue:
            break
        case .pending(let completion):
            try await completion()
            return try await invalidateValue(after: operation)
        case .ready(let valueObtainer):
            valueSource = valueObtainer
        }
        let oldStatus = status
        let task: Task<Success, Error> = Task {
            let value = try await valueSource?()
            return try await operation(value)
        }
        
        status = .working(untilDone: { _ = try? await task.value })
        do {
            let value = try await task.value
            status = .notLoaded
            return value
        } catch {
            status = oldStatus
            throw error
        }
    }
    
    // MARK: - Operation on value
    
    @discardableResult
    func perform<Success>(operation: @escaping Operation<Success>) async throws -> Success where Success: Sendable {
        let operationStatus = operationStatus()
        switch operationStatus {
        case .pending(let completion):
            try await completion()
            return try await perform(operation: operation)
        case .ready(let valueSource):
            let oldStatus = status
            let task: Task<Success, Error> = Task {
                let value = try await valueSource()
                return try await operation(value)
            }
            
            status = .working(untilDone: { _ = try? await task.value })
            do {
                let operationResult = try await task.value
                status = oldStatus
                return operationResult
            } catch {
                status = oldStatus
                throw error
            }
        }
    }
}

// MARK: - Private helpers

private extension LazyExtendedAsyncValue {
    enum PreInvalidationOperationStatus {
        case noValue
        case pending(completion: () async throws -> Void)
        case ready(valueSource: ValueObtainer)
    }
    
    func preInvalidationOperation(loadValueIfNotReady: Bool = true) -> PreInvalidationOperationStatus {
        switch status {
        case .notLoaded:
            return .noValue
        case .loading(let task):
            return .pending(completion: { _ = try await task.value })
        case .working(let completion):
            return .pending(completion: { await completion() })
        case .ready(obtainValue: let obtainValue):
            return .ready(valueSource: obtainValue)
        }
    }
    
    enum OperationStatus {
        case pending(completion: () async throws -> Void)
        case ready(valueSource: ValueObtainer)
    }
    
    func operationStatus(loadValueIfNotReady: Bool = true) -> OperationStatus {
        switch status {
        case .notLoaded:
            guard loadValueIfNotReady else {
                return .ready(valueSource: { fatalError() })
            }
            return .pending(completion: { [weak self] in try await self?.getValue() })
        case .loading(let task):
            return .pending(completion: { _ = try await task.value })
        case .working(let completion):
            return .pending(completion: { await completion() })
        case .ready(obtainValue: let obtainValue):
            return .ready(valueSource: obtainValue)
        }
    }
    
    func valueObtainer(for value: T) -> ValueObtainer {
        guard let sourceOfTruth else {
            return { value }
        }
        return sourceOfTruth
    }
}
```