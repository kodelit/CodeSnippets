# Xcode Preview of the View
- **shortcut**: `usr_xcodePreviewV`
- **language**: Swift
- **platform**: iphoneos

## Summary


## Code:
```swift
// MARK: - Xcode Preview
// swiftlint:disable type_name

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct <#Name#>Representable: UIViewRepresentable {
    typealias View = <#Name#>

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        //container.backgroundColor = .black
        let view = View(frame: .zero)
        //view.frame = <#frame#>
        //view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //container.addSubview(view)

        // or

        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            view.leadingAnchor.constraint(greaterThanOrEqualTo: container.layoutMarginsGuide.leadingAnchor)
        ])
        // setup view here

        return container
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<<#Name#>Representable>) {}
}

struct UIKit<#Name#>Provider: PreviewProvider {
    static var previews: some View { <#Name#>Representable() }
}
#endif
// swiftlint:enable type_name
```