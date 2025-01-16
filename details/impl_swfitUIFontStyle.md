# Impl: SwftUI+FontStyle
- **shortcut**: `impl_swfitUIFontStyle`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import SwiftUI
// Doc: https://www.figma.com/design/bDlQbmunNLTW1JUCTgp3s1/Viva-UI-2.0?node-id=29960-211395

extension Font.Weight {
    static let viva400Regular: Font.Weight = .regular
    /// - warning: Font with weight 500 is defined in the documentation but is not provided. Even in the doc it seams to be same as regular (it's named 500 but the weight is 400).
    /// Making it real `Font.Weight.medium` will cause that the font will be acually semibold.
    static let viva500Medium: Font.Weight = .regular
    static let viva600Semibold: Font.Weight = .semibold
    static let viva700Bold: Font.Weight = .bold
}

/// - note: In order to make font bolder just set the apropiriate `weight`
struct FontStyle {
    /// iOS: caption, VIVA Typography: Miniscule, font size 12.
    static let viva12Miniscule: Self = .init(
        uiFont: UIFont(name: "AvertaPE-Regular", size: 12)!,
        relativeTo: .caption,
        lineHeight: 17
    )
    /// iOS: footnote, VIVA Typography: Small, font size 14.
    static let viva14Small: Self = .init(
        uiFont: UIFont(name: "AvertaPE-Regular", size: 14)!,
        relativeTo: .footnote,
        lineHeight: 20
    )
    /// iOS: body, VIVA Typography: Base / H6, font size 16.
    static let viva16Base: Self = .init(
        uiFont: UIFont(name: "AvertaPE-Regular", size: 16)!,
        relativeTo: .body,
        lineHeight: 22
    )
    /// iOS: subheadline, VIVA Typography: Large / H5, font size 18.
    static let viva18Large: Self = .init(
        uiFont: UIFont(name: "AvertaPE-Regular", size: 18)!,
        relativeTo: .subheadline,
        lineHeight: 24
    )
    /// iOS: headline, VIVA Typography: Extra large / H4, font size 20.
    static let viva20ExtraLarge: Self = .init(
        uiFont: UIFont(name: "AvertaPE-Regular", size: 20)!,
        relativeTo: .headline,
        lineHeight: 28
    )
    /// iOS: title3, VIVA Typography: H4, font size 24.
    @available(iOS 14.0, *)
    static let viva24Header4: Self = .init(
        uiFont: UIFont(name: "AvertaPE-Regular", size: 24)!,
        relativeTo: .title3,
        lineHeight: 32
    )
    /// iOS: title2, VIVA Typography: H3, font size 30.
    @available(iOS 14.0, *)
    static let viva30Header3: Self = .init(
        uiFont: UIFont(name: "AvertaPE-Regular", size: 30)!,
        relativeTo: .title2,
        lineHeight: 36
    )
    /// iOS: title, VIVA Typography: H2, font size 36.
    static let viva36Header2: Self = .init(
        uiFont: UIFont(name: "AvertaPE-Regular", size: 36)!,
        relativeTo: .title,
        lineHeight: 42
    )
    
    let uiFont: UIFont
    let relativeTo: Font.TextStyle
    let lineHeight: CGFloat
    var weight: Font.Weight?
    var isItalic = false
    var hasUnderline = false
    var isStrikedThrough = false
    
    var font: Font {
        .custom(uiFont.fontName, size: uiFont.pointSize, relativeTo: relativeTo)
    }
    
    func bold(_ weight: Font.Weight = .viva700Bold) -> Self {
        self.weight(weight)
    }
    
    func weight(_ weight: Font.Weight) -> Self {
        var newValue = self
        newValue.weight = weight
        return newValue
    }
    
    func italic() -> Self {
        var newValue = self
        newValue.isItalic = true
        return newValue
    }
    
    @available(iOS 16.0, *)
    func underline() -> Self {
        var newValue = self
        newValue.hasUnderline = true
        return newValue
    }
    
    @available(iOS 16.0, *)
    func strikethrough() -> Self {
        var newValue = self
        newValue.isStrikedThrough = true
        return newValue
    }
}

extension View {
    func font(style: FontStyle) -> some View {
        let uiFontLineHeight = style.uiFont.lineHeight
        let heightDifference = style.lineHeight - uiFontLineHeight
        var value = style.font
        if let weight = style.weight {
            value = value.weight(weight)
        }
        if style.isItalic {
            value = value.italic()
        }
        return font(value)
            .if(style.hasUnderline) {
                $0.underlineIfPossible()
            }
            .if(style.isStrikedThrough) { $0.strikethroughIfPossible() }
            .lineSpacing(heightDifference)
            .padding(.vertical, (heightDifference) / 2)
    }
}

// MARK: - Text styling

extension View {
    /// - warning: It's not working on Button type. Use Text as button label and use the modifier on Text instead, eg.:
    /// ```
    /// Button(action: {}) {
    ///     Text("Title")
    ///         .underlineIfPossible()
    /// }
    /// ```
    func underlineIfPossible() -> some View {
        modify { view in
            if #available(iOS 16.0, *) {
                view.underline()
            }
        }
    }

    func strikethroughIfPossible() -> some View {
        modify { view in
            if #available(iOS 16.0, *) {
                view.strikethrough()
            }
        }
    }
}

```