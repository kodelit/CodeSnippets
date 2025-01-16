# Impl: RefreshableView
- **shortcut**: `impl_RefreshableView`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import Combine
import SwiftUICore
// Depends on: ActivityController

/// Refreshable view is a view which will display the placeholder instead of the content every time one of the observed activities is in progress.
///
/// It's similar to the ``AsyncContentView`` but it's state depends on the ``ActivityController``
/// therefore may depend on several activityes instead of the the ``AsyncContentDownloader`` value loading which is one activity.
struct RefreshableView<Activity, Content, Placeholder>: View where Activity: OptionSet, Content: View, Placeholder: View {
    @StateObject var viewModel: RefreshableViewModel<Activity>
    @ViewBuilder let content: () -> Content
    /// Placeholder view displayed every time the content the app is reloading the content.
    /// It might be ProgressView or any other view.
    @ViewBuilder let placeholder: () -> Placeholder
    
    /// - Parameters:
    ///   - observedActivities: option set value containing options which are causing the placeholder being displayed instead of the content.
    ///   - observedActivitiesController: dependency that publishes and updates the current set of activities being performed.
    ///   - content: content to display when none of the observed activities is in progress.
    ///   - placeholder: content to display when any of the observed activities is in progress
    init(
        observedActivities: Activity,
        of observedActivitiesController: any ActivityControlling<Activity>,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.content = content
        self.placeholder = placeholder
        self._viewModel = StateObject(
            wrappedValue: RefreshableViewModel(
                observedActivities: observedActivities,
                observedActivitiesController: observedActivitiesController
            )
        )
    }
    
    /// - Parameters:
    ///   - viewModel: view model telling when the relevant activities are in progress.
    ///   - content: content to display when none of the observed activities is in progress.
    ///   - placeholder: content to display when any of the observed activities is in progress
    init(
        viewModel: RefreshableViewModel<Activity>,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.content = content
        self.placeholder = placeholder
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        if viewModel.isLoading {
            placeholder()
        } else {
            content()
        }
    }
}

// MARK: - View Model

final class RefreshableViewModel<Activity>: ObservableObject where Activity: OptionSet {
    private let observedActivitiesController: any ActivityControlling<Activity>
    @Published var isLoading: Bool = false
    
    init(observedActivities: Activity, observedActivitiesController: any ActivityControlling<Activity> = ActivityController<Activity>()) {
        self.observedActivitiesController = observedActivitiesController
        observedActivitiesController
            .isLoading(anyOf: observedActivities)
            .receive(on: DispatchQueue.main)
            .map { isLoading in
                withAnimation { isLoading }
            }
            .assign(to: &$isLoading)
    }
}

// MARK: - View Modifier

private struct RefreshableViewModifier<Activity, Placeholder>: ViewModifier where Activity: OptionSet, Placeholder: View {
    @StateObject var viewModel: RefreshableViewModel<Activity>
    /// Placeholder view displayed every time the content the app is reloading the content.
    /// It might be ProgressView or any other view.
    @ViewBuilder let placeholder: () -> Placeholder
    
    /// - Parameters:
    ///   - observedActivities: option set value containing options which are causing the placeholder being displayed instead of the content.
    ///   - observedActivitiesController: dependency that publishes and updates the current set of activities being performed.
    ///   - placeholder: content to display when any of the observed activities is in progress
    init(
        observedActivities: Activity,
        of observedActivitiesController: any ActivityControlling<Activity>,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.placeholder = placeholder
        self._viewModel = StateObject(
            wrappedValue: RefreshableViewModel(
                observedActivities: observedActivities,
                observedActivitiesController: observedActivitiesController
            )
        )
    }
    
    /// - Parameters:
    ///   - viewModel: view model telling when the relevant activities are in progress.
    ///   - placeholder: content to display when any of the observed activities is in progress
    init(
        viewModel: RefreshableViewModel<Activity>,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.placeholder = placeholder
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    func body(content: Content) -> some View {
        if viewModel.isLoading {
            placeholder()
        } else {
            content
        }
    }
}

extension View {
    /// Wraps the view maiking it refreshable view which will display the placeholder instead of the content every time one of the observed activities is in progress.
    ///
    /// - warning: Use only if Refreshable View cannot be utilized directly. Using RefreshableView directly instead of the modifier might be more optimal , because the content view builder of the RefreshableView is called only when the content should be displayed. In case of modifier the content is created and then replaced with the placeholder.
    /// - Parameters:
    ///   - observedActivities: option set value containing options which are causing the placeholder being displayed instead of the view.
    ///   - observedActivitiesController: dependency that publishes and updates the current set of activities being performed.
    ///   - placeholder: content to display when any of the observed activities is in progress
    func refreshable<Activity, Placeholder>(
        observedActivities: Activity,
        of observedController: any ActivityControlling<Activity>,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) -> some View where Activity: OptionSet, Placeholder: View {
        ModifiedContent(
            content: self,
            modifier: RefreshableViewModifier(
                observedActivities: observedActivities,
                of: observedController,
                placeholder: placeholder
            )
        )
    }
    
    /// Wraps the view maiking it refreshable view which will display the placeholder instead of the content every time one of the observed activities is in progress.
    ///
    /// - warning: Use only if Refreshable View cannot be utilized directly. Using RefreshableView directly instead of the modifier might be more optimal , because the content view builder of the RefreshableView is called only when the content should be displayed. In case of modifier the content is created and then replaced with the placeholder.
    /// - Parameters:
    ///   - viewModel: view model telling when the relevant activities are in progress.
    ///   - placeholder: content to display when any of the observed activities is in progress
    func refreshable<Activity, Placeholder>(
        viewModel: RefreshableViewModel<Activity>,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) -> some View where Activity: OptionSet, Placeholder: View {
        ModifiedContent(
            content: self,
            modifier: RefreshableViewModifier(
                viewModel: viewModel,
                placeholder: placeholder
            )
        )
    }
}

```