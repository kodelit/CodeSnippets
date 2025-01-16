# Impl: Struct Reducer
- **shortcut**: `impl_tca_ReducerStruct`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import ComposableArchitecture
import Foundation

@Reducer
struct <#Name#>Feature {
    @ObservableState
    struct State: Equatable {

    }
    enum Action {
        case onViewFistAppear
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewFistAppear:
                return .none
            }
        }
    }
}
```