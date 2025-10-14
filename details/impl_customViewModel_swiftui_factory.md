# SwiftUI: ViewModel + Factory
- **shortcut**: `impl_customViewModel_swiftui_factory`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import Factory

@MainActor
final class <#ViewModelName#>: ObservableObject {
    @LazyInjected(\.networkReachability) private var networkReachability: NetworkReachability
    @Published var isLoading: Bool = false
    /// Tells if the view can proceed with the main flow/happy path.
    ///
    /// If false it may mean that for example:
    /// - there is no internet connection
    /// - other conditions are not fulfilled
    @Published var isEnabled: Bool = false

    /// Start point of the screen
    func onFirstAppear() {
        bind()
        Task {
            // Do all async work reqired on start here.
        }
    }
}

private extension <#ViewModelName#> {
    func bind() {
        networkReachability.isReachablePublisher
            .assign(to: &$isFunctionalityEnabled)
    }
}
```