# Ext: IdentifiableByTag
- **shortcut**: `ext_IdentifiableByTag`
- **language**: Swift
- **platform**: iphoneos


## Code:
```swift
//
//  IdentifiableByTag.swift
//  IdentifiableByTag
//
//  Created by Grzegorz Maciak on 27.05.2018.
//  Copyright (c) 2018 Grzegorz Maciak.
//  This code is distributed under the terms and conditions of the MIT license.
//  See: https://gist.github.com/kodelit/04b5ef889e23f63f3462c8595d0164d9#file-license-md

import UIKit

public struct IdentifyingTag: RawRepresentable, ExpressibleByIntegerLiteral, CustomStringConvertible {

    public var rawValue: Int = 0

    public init?(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(integerLiteral value: Int) {
        self.rawValue = value
    }

    public var description: String {
        return "\(self.rawValue)"
    }
}

public protocol IdentifiableByTag {
    var tag: Int { get set }
}

public extension IdentifiableByTag {
    var customTag:IdentifyingTag {
        get { return IdentifyingTag(rawValue: self.tag)! }
        set { self.tag = newValue.rawValue}
    }
}

extension UIView: IdentifiableByTag {
    public func viewWithTag(_ tag: IdentifyingTag) -> UIView? {
        return self.viewWithTag(tag.rawValue)
    }
}

```