# Xcode Preview of the View Controller
- **shortcut**: `usr_xcodePreviewVC`
- **language**: Swift
- **platform**: iphoneos

## Summary


## Code:
```swift
// MARK: - Xcode Preview
// Works from Xcode 11 and macOS 10.15
// swiftlint:disable type_name

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
struct <#Name#>ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = <#Name#>ViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
        // let bundle = Bundle(for: UIViewControllerType.self)
        // let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        // return storyboard.instantiateViewController(identifier: "<#Name#>ViewController")
        return UIViewControllerType(nibName: nil, bundle: nil)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

@available(iOS 13.0, tvOS 13.0, *)
struct UIKit<#Name#>ViewControllerProvider: PreviewProvider {
    static var previews: <#Name#>ViewControllerRepresentable { <#Name#>ViewControllerRepresentable() }
}

#endif
// swiftlint:enable type_name
```