# Impl: Default Close Button Modifier
- **shortcut**: `impl_DefaultCloseButtonModifier`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import SwiftUI

struct CloseButtonAddingModifier: ViewModifier {
    enum WrappingStack {
        case vstack, zstack
    }

    let wrappingStack: WrappingStack
    let action: () -> Void

    private var closeButton: some View {
        Button(action: action, label: {
            Image(.iconClose).accessibilityLabel(Text("Close button"))
        })
        .frame(width: 16, height: 16)
    }

    func body(content: Content) -> some View {
        switch wrappingStack {
        case .vstack:
            // total size is 56 (both width and height) - 16 padding, 24 icon size and 16 VStack spacing
            VStack(alignment: .trailing) {
                closeButton
                    .padding([.top, .trailing], 6)
                content
            }
        case .zstack:
            ZStack(alignment: .topTrailing) {
                content
                closeButton
                    .padding([.top, .trailing], 6)
            }
        }
    }
}

extension View {
    /// - warning: Using this method all modifiers after this method will modify the wrapping V/ZStack, not the view itself, so the order of the modifiers matters.
    func addCloseButton(
        using stack: CloseButtonAddingModifier.WrappingStack = .zstack,
        action: @escaping () -> Void
    ) -> some View {
        modifier(CloseButtonAddingModifier(wrappingStack: stack, action: action))
    }

    func wrapText(lineLimit number: Int? = nil) -> some View {
        lineLimit(number).fixedSize(horizontal: false, vertical: true)
    }
}

```