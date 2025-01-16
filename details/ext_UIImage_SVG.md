# Ext: UIImage+SVG
- **shortcut**: `ext_UIImage_SVG`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import UIKit

extension UIImage {
    static func with(svg data: Data?) -> UIImage? {
        guard let data,
              let svg = SVG(data) else {
            return nil
        }
        let render = UIGraphicsImageRenderer(size: svg.size)
        let uiImage = render.image { context in
            svg.draw(in: context.cgContext)
        }
        return uiImage
    }
}

// MARK: - Private CoreSVG Framework

/// Full credit for the `CoreSVG` private framework code  goes to Oliver Atkinson, for creating this [SVG.swift](https://gist.github.com/ollieatkinson/eb87a82fcb5500d5561fed8b0900a9f7) gist.
@objc
final fileprivate class CGSVGDocument: NSObject {}

// private var CGSVGDocumentRetain: (@convention(c) (CGSVGDocument?) -> Unmanaged<CGSVGDocument>?) = load("CGSVGDocumentRetain")
private var CGSVGDocumentRetain: (@convention(c) (CGSVGDocument?) -> Unmanaged<CGSVGDocument>?) = load("==gbpFGdlJFduVWb1N2bEdkVTd0Q".deobfuscated)

// private var CGSVGDocumentRelease: (@convention(c) (CGSVGDocument?) -> Void) = load("CGSVGDocumentRelease")
private var CGSVGDocumentRelease: (@convention(c) (CGSVGDocument?) -> Void) = load("=U2chVGblJFduVWb1N2bEdkVTd0Q".deobfuscated)

// private var CGSVGDocumentCreateFromData: (@convention(c) (CFData?, CFDictionary?) -> Unmanaged<CGSVGDocument>?) = load("CGSVGDocumentCreateFromData")
private var CGSVGDocumentCreateFromData: (@convention(c) (CFData?, CFDictionary?) -> Unmanaged<CGSVGDocument>?) = load("hRXYE12byZUZ0FWZyNEduVWb1N2bEdkVTd0Q".deobfuscated)

// private var CGSVGDocumentWriteToData: (@convention(c) (CGSVGDocument?, CFData?, CFDictionary?) -> Void) = load("CGSVGDocumentWriteToData")
private var CGSVGDocumentWriteToData: (@convention(c) (CGSVGDocument?, CFData?, CFDictionary?) -> Void) = load("hRXYE9GVlRXaydFduVWb1N2bEdkVTd0Q".deobfuscated)

// private var CGContextDrawSVGDocument: (@convention(c) (CGContext?, CGSVGDocument?) -> Void) = load("CGContextDrawSVGDocument")
private var CGContextDrawSVGDocument: (@convention(c) (CGContext?, CGSVGDocument?) -> Void) = load("05WZtV3YvR0RWN1dhJHR0hXZ052bDd0Q".deobfuscated)

// private var CGSVGDocumentGetCanvasSize: (@convention(c) (CGSVGDocument?) -> CGSize) = load("CGSVGDocumentGetCanvasSize")
private var CGSVGDocumentGetCanvasSize: (@convention(c) (CGSVGDocument?) -> CGSize) = load("=UmepN1chZnbhNEdldEduVWb1N2bEdkVTd0Q".deobfuscated)

#if canImport(UIKit)
// private typealias ImageWithCGSVGDocument = @convention(c) (AnyObject, Selector, CGSVGDocument) -> UIImage
private typealias ImageWithCGSVGDocument = @convention(c) (AnyObject, Selector, CGSVGDocument) -> UIImage
#endif

// private var ImageWithCGSVGDocumentSEL: Selector = NSSelectorFromString("_imageWithCGSVGDocument:")
private var ImageWithCGSVGDocumentSEL: Selector = NSSelectorFromString("6Qnbl1Wdj9GRHZ1UHNEa0l2VldWYtl2X".deobfuscated)

// private let CoreSVG = dlopen("/System/Library/PrivateFrameworks/CoreSVG.framework/CoreSVG", RTLD_NOW)
private let CoreSVG = dlopen("=ckVTVmcvN0LrJ3b3VWbhJnZuckVTVmcvN0LztmcvdXZtFmcGVGdhZXayB1L5JXYyJWaM9SblR3c5N1L".deobfuscated, RTLD_NOW)

extension String {
    fileprivate var deobfuscated: String { Data(base64Encoded: String(reversed()))!.string }
}

extension Data {
    fileprivate var string: String { String(decoding: self, as: UTF8.self) }
}


fileprivate func load<T>(_ name: String) -> T {
    unsafeBitCast(dlsym(CoreSVG, name), to: T.self)
}

final fileprivate class SVG {
    deinit { CGSVGDocumentRelease(document) }

    let document: CGSVGDocument

    convenience init?(_ value: String) {
        guard let data = value.data(using: .utf8) else { return nil }
        self.init(data)
    }

    init?(_ data: Data) {
        guard let document = CGSVGDocumentCreateFromData(data as CFData, nil)?.takeUnretainedValue() else { return nil }
        guard CGSVGDocumentGetCanvasSize(document) != .zero else { return nil }
        self.document = document
    }

    var size: CGSize {
        CGSVGDocumentGetCanvasSize(document)
    }

    func image() -> UIImage? {
        let ImageWithCGSVGDocument = unsafeBitCast(UIImage.method(for: ImageWithCGSVGDocumentSEL), to: ImageWithCGSVGDocument.self)
        let image = ImageWithCGSVGDocument(UIImage.self, ImageWithCGSVGDocumentSEL, document)
        return image
    }

    func draw(in context: CGContext) {
        draw(in: context, size: size)
    }

    func draw(in context: CGContext, size target: CGSize) {
        var target = target

        let ratio = (
            x: target.width / size.width,
            y: target.height / size.height
        )

        let rect = (
            document: CGRect(origin: .zero, size: size), ()
        )

        let scale: (x: CGFloat, y: CGFloat)

        if target.width <= 0 {
            scale = (ratio.y, ratio.y)
            target.width = size.width * scale.x
        } else if target.height <= 0 {
            scale = (ratio.x, ratio.x)
            target.width = size.width * scale.y
        } else {
            let min = min(ratio.x, ratio.y)
            scale = (min, min)
            target.width = size.width * scale.x
            target.height = size.height * scale.y
        }

        let transform = (
            scale: CGAffineTransform(scaleX: scale.x, y: scale.y),
            aspect: CGAffineTransform(translationX: (target.width / scale.x - rect.document.width) / 2, y: (target.height / scale.y - rect.document.height) / 2)
        )

        context.translateBy(x: 0, y: target.height)
        context.scaleBy(x: 1, y: -1)
        context.concatenate(transform.scale)
        context.concatenate(transform.aspect)

        CGContextDrawSVGDocument(context, document)
    }
}
```