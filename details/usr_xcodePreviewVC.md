# Xcode Preview of the View Controller
- **shortcut**: `usr_xcodePreviewVC`
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
struct <#Name#>ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias ViewController = <#Name#>ViewController

    func makeUIViewController(context: Context) -> ViewController {
        // let bundle = Bundle(for: StartViewController.self)
        // let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        // return storyboard.instantiateViewController(identifier: "<#Name#>ViewController")
        return ViewController(nibName: nil, bundle: nil)
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

@available(iOS 13.0, tvOS 13.0, *)
struct UIKit<#Name#>ViewControllerProvider: PreviewProvider {
    static var previews: <#Name#>ViewControllerRepresentable { <#Name#>ViewControllerRepresentable() }
}

#endif

```