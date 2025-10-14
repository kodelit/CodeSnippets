# SwiftUI: Custom View
- **shortcut**: `impl_customView_swiftui`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import SwiftUI

struct <#ViewName#>: View {
    @ObservedObject var viewModel: <#ViewModelName#>

    var body: some View {
        // let _ = Self._printChanges()
        VStack {
            content()
        }
        .background(Color(.blueShade0), ignoresSafeAreaEdges: .all)
    }

    @ViewBuilder func content() -> some View {
        VStack(alignment: .center, spacing: 8) {

        }
    }
}

#Preview {
    <#ViewName#>()
}
```