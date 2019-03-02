# Ext: Memoization
- **shortcut**: `ext_Memoization`
- **language**: Swift
- **platform**: 


## Code:
```swift
//
//  Memoization.swift
//  RxSwiftly
//
//  Created by Bas van Kuijck on 28/07/2017.
//

// This code is distributed under the terms and conditions of the MIT License:

// Copyright © 2017 E-sites. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import RxSwift
import RxCocoa

public protocol Memoization: class { }
extension NSObject: Memoization { }

extension Memoization {
    /// Memoizes the the `lazyCreateClosure`
    ///
    /// [Read this](https://nl.wikipedia.org/wiki/Memoization) for more information about memoization:
    ///
    /// - Notes: Memoization will be stored alongside the &key and the `self`.
    ///
    /// - Parameters:
    ///   - key: The `UnsafeRawPointer` to store the memoized outcome in.
    ///   - lazyCreateClosure: The closure which creates the object
    /// - Returns: The object itself
    public func memoize<T>(key: UnsafeRawPointer, lazyCreateClosure: () -> T) -> T {
        return _memoize(self, key: key, lazyCreateClosure: lazyCreateClosure)
    }
}

extension Reactive {
    /// Memoizes the the `lazyCreateClosure`
    ///
    /// [Read this](https://nl.wikipedia.org/wiki/Memoization) for more information about memoization:
    ///
    /// - Notes: Memoization will be stored alongside the &key and the `self.base` of the Reactive instance.
    ///
    /// - Parameters:
    ///   - key: The `UnsafeRawPointer` to store the memoized outcome in.
    ///   - lazyCreateClosure: The closure which creates the object
    /// - Returns: The object itself
    public func memoize<T>(key: UnsafeRawPointer, lazyCreateClosure: () -> Observable<T>) -> Observable<T> {
        return _memoize(self.base, key: key, lazyCreateClosure: lazyCreateClosure)
    }
}

fileprivate func _memoize<T>(_ object: Any, key: UnsafeRawPointer, lazyCreateClosure: () -> T) -> T {
    objc_sync_enter(object); defer { objc_sync_exit(object) }
    if let instance = objc_getAssociatedObject(object, key) as? T {
        return instance
    }

    let instance = lazyCreateClosure()
    objc_setAssociatedObject(object, key, instance, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    return instance
}


```