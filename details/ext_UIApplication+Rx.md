# Ext: UIApplication+Rx
- **shortcut**: `ext_UIApplication+Rx`
- **language**: Swift
- **platform**: 


## Code:
```swift
//
//  UIApplication+rx.swift
//  UIApplication+rx
//
//  Created by Bas van Kuijck on 31/07/2017.
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
import UIKit

fileprivate var applicationStateKey: UInt8 = 0

extension Reactive where Base: UIApplication {
    /// Observable sequence of the application's state
    ///
    /// This gives you an observable sequence of all possible application states.
    ///
    /// - Warning:
    /// Setting up a Rx KVO on "applicationState" will not work, whereas `applicationState` is not KVO compliant.
    /// That's why we set use a NotificationCenter
    ///
    /// - Returns: Observable sequence of `UIApplicationState`s
    public var applicationState: Observable<UIApplicationState> {
        return memoize(key: &applicationStateKey) {
            let observables = [
                Notification.Name.UIApplicationDidBecomeActive,
                Notification.Name.UIApplicationDidEnterBackground,
                Notification.Name.UIApplicationWillEnterForeground,
                Notification.Name.UIApplicationDidFinishLaunching,
                Notification.Name.UIApplicationWillResignActive,
                Notification.Name.UIApplicationWillTerminate
                ].map {
                    NotificationCenter.default.rx.notification($0)
            }

            return Observable<Notification>.merge(observables)
                .map { _ in UIApplication.shared.applicationState }
                .distinctUntilChanged()
        }
    }
}

```