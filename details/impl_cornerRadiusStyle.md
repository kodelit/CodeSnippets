# Impl: CornerRadius style
- **shortcut**: `impl_cornerRadiusStyle`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import SwiftUI

/// Documentation: https://www.figma.com/design/bDlQbmunNLTW1JUCTgp3s1/Viva-UI-2.0?node-id=4953-32113&t=zTOplDUzLxv5WsDP-4
struct CornerRadius: RawRepresentable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {

    let rawValue: CGFloat
    init(rawValue: CGFloat) { self.rawValue = rawValue }
    init(floatLiteral value: FloatLiteralType) { self.rawValue = value }
    init(integerLiteral value: IntegerLiteralType) { self.init(rawValue: CGFloat(value)) }
}

struct BorderWidth: Hashable, RawRepresentable, Equatable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    static let zero: Self = 0
    static let `default`: Self = 1.5

    let rawValue: CGFloat
    init(rawValue: CGFloat) { self.rawValue = rawValue }
    init(floatLiteral value: FloatLiteralType) { self.init(rawValue: value) }
    init(integerLiteral value: IntegerLiteralType) { self.init(rawValue: CGFloat(value)) }
}

private struct CornerRadiusStyle: ViewModifier {
    var radius: CornerRadius
    var corners: UIRectCorner
    var borderWidth: BorderWidth = .zero
    var borderColor: Color?

    struct CornerRadiusShape: Shape {
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius.rawValue, corners: corners))
            .if(borderWidth != .zero) { view in
                if let borderColor {
                    view
                        .overlay(
                            CornerRadiusShape(radius: radius.rawValue, corners: corners)
                                .stroke(borderColor, lineWidth: borderWidth.rawValue)
                        )
                        // The following padding is to avoid the borders beeing clipped
                        // by the super view by drawing them whole inside
                        .padding(borderWidth.rawValue / 2)
                } else {
                    view
                }
            }
    }
}

extension View {
    func customCorners(_ corners: UIRectCorner, radius: CornerRadius = .default, borderWidth: BorderWidth = .zero, borderColor: Color? = nil) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners, borderWidth: borderWidth, borderColor: borderColor))
    }

    @ViewBuilder func customCornerRadius(_ radius: CornerRadius, borderWidth: BorderWidth = .zero, borderColor: Color = .clear) -> some View {
        // We are using cornerRadius instead of clipShape because we need the overlay below which needs to have the same (fixed) corner radius when the button is displayed with bigger font (accessibility)
        cornerRadius(radius.rawValue)
            .if(borderWidth != .zero) { view in
                view
                    .overlay(
                        RoundedRectangle(cornerRadius: radius.rawValue)
                            .stroke(borderColor, lineWidth: borderWidth.rawValue)
                    )
                    // The following padding is to avoid the borders beeing clipped
                    // by the super view by drawing them whole inside
                    .padding(borderWidth.rawValue / 2)
            }
    }
}
```