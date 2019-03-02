# Impl: Service Dependency
- **shortcut**: `impl_ServiceDependency`
- **language**: Swift
- **platform**: 

## Summary
Simplified access to required services

## Code:
```swift
//
//  ServiceDependency.swift
//  ApplicationCoreKit
//
//  Created by Grzegorz Maciak on 05.10.2018.
//  Copyright © 2018 Grzegorz Maciak. All rights reserved.
//

import Foundation

public struct ServiceDependency<Dependent>: Dependency {
    /// Dependent object to extend.
    public let dependent: Dependent
    
    /// Creates extensions with dependent object.
    ///
    /// - parameter base: Dependent object.
    public init(_ dependent: Dependent) {
        self.dependent = dependent
    }
}

public protocol ServiceDependentObject {
    /// Extended type
    associatedtype DependentType
    
    /// Reactive extensions.
    static var service: ServiceDependency<DependentType>.Type { get set }
    
    /// Reactive extensions.
    var service: ServiceDependency<DependentType> { get set }
}

extension ServiceDependentObject {
    /// ServiceDependency extensions.
    public static var service: ServiceDependency<Self>.Type {
        get {
            return ServiceDependency<Self>.self
        }
        set {
            // this enables using Dependency to "mutate" dependent type
        }
    }
    
    /// Reactive extensions.
    public var service: ServiceDependency<Self> {
        get {
            return ServiceDependency(self)
        }
        set {
            // this enables using Dependency to "mutate" dependent object
        }
    }
}

```