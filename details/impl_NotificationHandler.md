# Impl: Notification Handler
- **shortcut**: `impl_NotificationHandler`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
//
//  NotificationHandler.swift
//  CommonComponents
//
//  Created by Grzegorz Maciak on 28.10.2018.
//  Copyright © 2019 kodelit. All rights reserved.
//  This code is distributed under the terms and conditions of the MIT license.
//  See: https://opensource.org/licenses/MIT

import Foundation

open class NotificationHandler {
    public typealias NotificationObserver = ((Notification) -> Void)

    private var handle: NSObjectProtocol?
    private var queue: OperationQueue?
    public let center: NotificationCenter
    public let notificationName: Notification.Name
    public var notificationObserver: NotificationObserver? = nil {
        didSet {
            if notificationObserver == nil {
                unregister()
            } else {
                register()
            }
        }
    }

    /// - parameter notificationName: The name of the notification for which to register the observer; that is, only notifications with this name are used to add the closure to the operation queue.
    /// - parameter observer: closure to handle the notification, can be set later.
    /// - parameter queue: The operation queue to which closure should be added. If you pass `nil`, the closure is run synchronously on the posting thread. Default queue is `OperationQueue.main`
    /// - parameter center: The notification center to be observed. Default center is `NotificationCenter.default`
    public init(notificationName: Notification.Name,
                queue: OperationQueue? = .main,
                center: NotificationCenter = .default,
                observer: NotificationObserver? = nil) {
        self.queue = queue
        self.center = center
        self.notificationName = notificationName
        self.notificationObserver = observer
        register()
    }

    private func register() {
        guard notificationObserver != nil, handle == nil else { return }
        handle = center.addObserver(forName: notificationName, object: nil, queue: queue) { [weak self] (note) in
            guard let self = self else { return }
            guard let observer = self.notificationObserver else {
                assertionFailure("Observer for notification name '\(self.notificationName.rawValue)' not set!")
                return
            }
            observer(note)
        }
    }

    private func unregister() {
        guard let handle = handle else { return }
        center.removeObserver(handle)
        self.handle = nil
    }

    deinit {
        unregister()
    }
}

//public class UIContentSizeCategoryDidChangeHandler: NotificationHandler {
//    public typealias ContentSizeCategoryChangeObserver = ((UIContentSizeCategory) -> Void)
//    public var categoryObserver: ContentSizeCategoryChangeObserver? {
//        didSet { reset() }
//    }
//
//    public convenience init(observer: ContentSizeCategoryChangeObserver? = nil) {
//        self.init(notificationName: UIContentSizeCategory.didChangeNotification)
//        self.categoryObserver = observer
//        register()
//    }
//
//    private func register() {
//        guard categoryObserver != nil else { return }
//        notificationObserver = { [weak self] note in
//            guard let self = self else { return }
//            guard let category = note.userInfo?[UIContentSizeCategory.newValueUserInfoKey] as? UIContentSizeCategory else {
//                return
//            }
//            guard let observer = self.categoryObserver else {
//                assertionFailure("Observer for notification name '\(self.notificationName.rawValue)' not set!")
//                return
//            }
//            observer(category)
//        }
//    }
//
//    private func reset() {
//        guard categoryObserver != nil else {
//            notificationObserver = nil
//            return
//        }
//        register()
//    }
//}
//
///// Handler for notification `UIAccessibility.voiceOverStatusDidChangeNotification`
/////
///// Observer is invoked always on the `.main` operation queue.
//public class VoiceOverStatusDidChangeHandler: NotificationHandler {
//    /// - parameter observer: closure to handle the notification. Can be set later.
//    public init(observer: NotificationObserver? = nil) {
//        super.init(notificationName: UIAccessibility.voiceOverStatusDidChangeNotification, observer: observer)
//    }
//}

```