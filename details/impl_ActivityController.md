# Impl: ActivityController
- **shortcut**: `impl_ActivityController`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import Combine
import SwiftUI

/// Activity controller interface.
///
/// Activity controller allows to manage the loading indicator and guarantee that it wont disappear until all observed activites are done.
/// Interested view may observe ``isLoading()`` publisher for any activity or decide for which activietes the loading indicator should be displayed by observing publisher created with ``isLoading(anyOf:)``.
/// On the other hand the same instance might be utilized by one or more workers which are reporting begining and the end of the activity to the controller with ``willStart(activity:)`` and ``didFinish(activity:)``
///
/// Observed `Activity` type is defined as any implementation of SetAlgebra. It might be regular Set for example with activities represented by string keys, RawRepresentalbe enum keys or OptionSet.
public protocol ActivityControlling<Activity> where Activity: SetAlgebra {
    associatedtype Activity
    var activityChangePublisher: AnyPublisher<Activity, Never> { get }
    
    func isLoading() -> AnyPublisher<Bool, Never>
    func isLoading(anyOf activities: Activity) -> AnyPublisher<Bool, Never>
    func willStart(activity: Activity.Element)
    func didFinish(activity: Activity.Element)
}

/// Default implementation of theActivity controller interface ``ActivityControlling``.
///
/// Activity controller allows to manage the loading indicator and guarantee that it wont disappear until all observed activites are done.
/// Interested view may observe ``isLoading()`` publisher for any activity or decide for which activietes the loading indicator should be displayed by observing publisher created with ``isLoading(anyOf:)``.
/// On the other hand the same instance might be utilized by one or more workers which are reporting begining and the end of the activity to the controller with ``willStart(activity:)`` and ``didFinish(activity:)``
///
/// Observed `Activity` type is defined as any implementation of SetAlgebra. It might be regular Set for example with activities represented by string keys, RawRepresentalbe enum keys or OptionSet.
///
/// Example of option set used by the activity change publisher to notify what activities are currently being performed:
/// ```swift
/// struct ExampleActivity: OptionSet, Hashable {
///    let rawValue: Int
///    static let none: Self = []
///    static let data = Self(rawValue: 1 << 0)
///    static let image = Self(rawValue: 1 << 1)
///
///    /// Activities group containing all available activities.
///    static let all: Self = [.data, .image]
/// }
/// ```
final class ActivityController<Activity>: ActivityControlling where Activity: SetAlgebra {
    private var ongoingActivitiesSubject = CurrentValueSubject<Activity, Never>([])
    private var ongoingActivities: Activity {
        get { ongoingActivitiesSubject.value }
        set { ongoingActivitiesSubject.send(newValue) }
    }
    
    /// Publisher which might be utilized by the activity observer allowing to observe any change of activity set.
    ///
    /// This is a base for other two publishers. Might be used when more sophisticated logic is required.
    var activityChangePublisher: AnyPublisher<Activity, Never> {
        ongoingActivitiesSubject.removeDuplicates().eraseToAnyPublisher()
    }
    
    /// Publisher utilized by the activity observer allowing to observe if there is any activity being performed.
    func isLoading() -> AnyPublisher<Bool, Never> {
        activityChangePublisher
        // Check if the activity set contains any activity
            .map { !$0.isEmpty }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// Publisher utilized by the activity observer allowing to observe a subset of the supported activity set and reporting `true` if any of the activity form the subset is being performed.
    func isLoading(anyOf activities: Activity) -> AnyPublisher<Bool, Never> {
        activityChangePublisher
        // Check if the activity set contains any of the activities
            .map { $0.intersection(activities) != [] }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// Method utilized by the activity performing Worker to report that the activity is about to start.
    func willStart(activity: Activity.Element) {
        assert(Thread.isMainThread, "Method `\(#function)` should be performed on the main thread in order to avoid race conditions.")
        var value = ongoingActivities
        value.insert(activity)
        ongoingActivities = value
    }
    
    /// Method utilized by the activity performing Worker to report that the activity did end.
    func didFinish(activity: Activity.Element) {
        assert(Thread.isMainThread, "Method `\(#function)` should be performed on the main thread in order to avoid race conditions.")
        var value = ongoingActivities
        value.remove(activity)
        ongoingActivities = value
    }
}

// MARK: - OptionSet extension

extension OptionSet {
    var isEmpty: Bool { self == [] }
    
    /// Checks if the option set contains any of the options
    func includesAny(of options: Self) -> Bool {
        self.intersection(options) != []
    }
    
    /// Checks if the option set contains all of the options
    func includesAll(of options: Self.Element) -> Bool {
        self.contains(options)
    }
}
```