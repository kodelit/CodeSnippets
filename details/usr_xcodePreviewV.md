# Xcode Preview of the View
- **shortcut**: `usr_xcodePreviewV`
- **language**: Swift
- **platform**: iphoneos

## Summary


## Code:
```swift
// MARK: - Xcode Preview
// Works from Xcode 11 and macOS 10.15

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
struct <#Name#>ViewRepresentable: UIViewRepresentable {
    typealias View = <#Name#>

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        //container.backgroundColor = .black
        let view = <#Name#>(frame: .zero)
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

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<<#Name#>ViewRepresentable>) {}
}

@available(iOS 13.0, tvOS 13.0, *)
struct UIKit<#Name#>ViewProvider: PreviewProvider {
    static var previews: <#Name#>ViewRepresentable { <#Name#>ViewRepresentable() }
}
#endif
```