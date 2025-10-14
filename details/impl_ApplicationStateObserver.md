# Impl: ApplicationStateObserver
- **shortcut**: `impl_ApplicationStateObserver`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
//
//  ApplicationStateObserver.swift
//
//  Created by Grzegorz Maciak on 10/11/2020.
//  Copyright © 2020 kodelit. All rights reserved.
//  This code is distributed under the terms and conditions of the MIT license.
//  See: https://opensource.org/licenses/MIT
//

import Foundation
import UIKit

enum Application {
    enum TransitionKind {
        case didFinishLaunching
        case willEnterForeground
        case didBecomeActive
        case willResignActive
        case didEnterBackground
        case willTerminate
    }

    enum State {
        case active
        case inactive
        case background
        case killed

        /// Should never occure but might if there will be some new `UIApplication.State` case
        case unknown

        init(_ state: UIApplication.State) {
            switch state {
            case .active: self = .active
            case .inactive: self = .inactive
            case .background: self = .background
            @unknown default: self = .unknown
            }
        }
    }

    struct StateChange {
        let prevState: State
        let nextState: State
        let transition: TransitionKind?

        var isAppActive: Bool { nextState == .active }
        var isAppInBackground: Bool { nextState == .background }
    }
}

protocol ApplicationStateObserving: AnyObject {
    var applicationStateDidChange: ((Application.StateChange) -> Void)? { get set }
}

extension Application {
    class StateObserver: ApplicationStateObserving {
        private let appWillEnterForeground: NotificationHandler
        private let appDidEnterBackground: NotificationHandler
        private let appDidBecomeActive: NotificationHandler
        private let appWillResignActive: NotificationHandler
        private let appWillTerminate: NotificationHandler
        private var lastStateChange = StateChange(prevState: .killed, nextState: .killed, transition: nil) {
            didSet {
                self.applicationStateDidChange?(lastStateChange)
            }
        }
        private var didFinishLaunchingObserver: NSObjectProtocol?
        let label: String?
        var applicationStateDidChange: ((StateChange) -> Void)?

        /// - parameter label: optional debug label displayed in the debug logs helping to identify the observer.
        /// - parameter center: observed notification center. By default this value is `NotificationCenter.default`.
        /// Parameter `center` should be set only in unit tests. In other cases should have a default value,
        /// because observer utilizes notifications which are posted to the default center by the application itself
        /// - warning: Always use the default `center` parameter. The only exeption are unit tests.
        public init(label: String? = #file, observationQueue: OperationQueue? = nil, unitTestingNotificationCenter center: NotificationCenter = .default) {
            self.label = label
            appWillEnterForeground = NotificationHandler(notificationName: UIApplication.willEnterForegroundNotification, center: center)
            appDidEnterBackground = NotificationHandler(notificationName: UIApplication.didEnterBackgroundNotification, center: center)
            appDidBecomeActive = NotificationHandler(notificationName: UIApplication.didBecomeActiveNotification, center: center)
            appWillResignActive = NotificationHandler(notificationName: UIApplication.willResignActiveNotification, center: center)
            appWillTerminate = NotificationHandler(notificationName: UIApplication.willTerminateNotification, center: center)
            appWillTerminate.notificationObserver = stateUpdateHandler(for: .willTerminate)

            didFinishLaunchingObserver = NotificationCenter.default
                .addObserver(forName: UIApplication.didFinishLaunchingNotification,
                             object: nil,
                             queue: observationQueue) { [weak self] notification in
                    // handler is created here because if this observer will naver
                    // be fired there is no need to store created handler for whole application lifecycle
                    let handler = self?.stateUpdateHandler(for: .didFinishLaunching)
                    handler?(notification)
                    guard let observer = self?.didFinishLaunchingObserver else { return }
                    NotificationCenter.default.removeObserver(observer)
                }

            // handles application notifications about entering background and comming back foreground
            appWillEnterForeground.notificationObserver = stateUpdateHandler(for: .willEnterForeground)
            appDidEnterBackground.notificationObserver = stateUpdateHandler(for: .didEnterBackground)

            // handles application notifications about becoming active/inactive
            appDidBecomeActive.notificationObserver = stateUpdateHandler(for: .didBecomeActive)
            appWillResignActive.notificationObserver = stateUpdateHandler(for: .willResignActive)
        }

        private typealias NotificationObserver = NotificationHandler.NotificationObserver
        private func stateUpdateHandler(for transition: TransitionKind) -> NotificationObserver {
            { [weak self] _ in
                guard let self = self else { return }
                var prevState = self.lastStateChange.nextState
                var nextState: State
                switch transition {
                case .didFinishLaunching: nextState = .init(UIApplication.shared.applicationState)
                case .didBecomeActive:
                    nextState = .active
                    // handling the case when the observer was created after `.didFinishLaunchingNotification` is sent
                    if prevState == .killed { prevState = .inactive }
                case .willResignActive, .willEnterForeground: nextState = .inactive
                case .didEnterBackground: nextState = .background
                case .willTerminate: nextState = .killed
                }
                let change = StateChange(prevState: self.lastStateChange.nextState,
                                                    nextState: nextState,
                                                    transition: transition)
                self.lastStateChange = change
            }
        }
    }
}

extension UIApplication.State: @retroactive CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .active: return "UIApplicationState.active"
        case .inactive: return "UIApplicationState.inactive"
        case .background: return "UIApplicationState.background"
        @unknown default: return "UIApplicationState unknown"
        }
    }
}

```