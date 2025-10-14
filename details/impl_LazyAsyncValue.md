# Impl: LazyAsyncValue
- **shortcut**: `impl_LazyAsyncValue`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
// swiftlint:disable:next file_header
//
//  LazyAsyncValue.swift
//
//  Created by Grzegorz Maciak on 31/01/2025.
//  Copyright © 2025 Grzegorz Maciak. All rights reserved.
//  This code is distributed under the terms and conditions of the MIT license.
//  See: https://opensource.org/licenses/MIT
//

import Foundation

public protocol AsyncValueLoading<T> {
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
}

/// Stores data of any type fetched on demand and cached until the value is removed or reset.
///
/// The wrapped value is not removed in case of memory warning. If you would like it to be removed in such case please use ``LazyAsynchValueCache``
/// - note: Inspared by: https://stackoverflow.com/a/70586582/1776859
public actor LazyAsyncValue<T: Sendable>: AsyncValueLoading {
    private enum Status {
        case notLoaded
        case loading(Task<T, Error>)
        case ready(T)
    }
    
    private var status: Status = .notLoaded
    public var loader: () async throws -> T
    
    /// - Parameters:
    ///   - preloadedValue: convenience parameter for preset value to use in corner cases when we already have the value.
    ///   - loader: A closure providing the requested result.
    public init(preloadedValue: T? = nil, loader: @escaping @Sendable () async throws -> T) {
        if let preloadedValue {
            status = .ready(preloadedValue)
        }
        self.loader = loader
    }
    
    public func getValue(defaultValue: T) async -> T {
        (try? await getValue()) ?? defaultValue
    }
    
    @discardableResult
    public func getValue() async throws -> T {
        switch status {
        case let .ready(value):
            return value
        case let .loading(task):
            return try await task.value
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
    
    public func invalidateValue() async {
        guard case .ready = status else {
            return
        }
        status = .notLoaded
    }
    
    @discardableResult
    public func reloadValue() async throws -> T {
        await invalidateValue()
        return try await getValue()
    }
}

// MARK: - LazyAsyncValueCache

import Foundation
#if os(iOS)
import UIKit
// Depends on: LazyAsyncValue

/// Wrapper for laizly and asychronously loaded value.
///
/// An instance requires to define the loading closure which loads data asynchronously, then caches it.
///
/// - warning: Cache will be reset when application will receive a memory warning, and is going to try to load the value again when needed/requested.
@available(iOS 15, *)
public final class LazyAsyncValueCache<T: Sendable> {
    private let value: LazyAsyncValue<T>
    private let observer: Task<Void, Never>?
    
    public init(preloadedValue: T? = nil, loader: @escaping @Sendable () async throws -> T) {
        let value = LazyAsyncValue(preloadedValue: preloadedValue, loader: loader)
        self.value = value
        self.observer = Task(priority: .utility) {
            let notificationsSequence = NotificationCenter.default.notifications(named: UIApplication.didReceiveMemoryWarningNotification)
            for await _ in notificationsSequence {
                await value.invalidateValue()
            }
        }
    }
    
    deinit {
        observer?.cancel()
    }
}

@available(iOS 15, *)
extension LazyAsyncValueCache: AsyncValueLoading {
    public func getValue(defaultValue: T) async -> T {
        await value.getValue(defaultValue: defaultValue)
    }
    
    @discardableResult
    public func getValue() async throws -> T {
        try await value.getValue()
    }
    
    public func invalidateValue() async {
        await value.invalidateValue()
    }
    
    @discardableResult
    public func reloadValue() async throws -> T {
        try await value.reloadValue()
    }
}
#endif
```