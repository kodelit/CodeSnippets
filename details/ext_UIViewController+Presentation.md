# Ext: UIViewController+Presentation.swift
- **shortcut**: `ext_UIViewController+Presentation`
- **language**: Generic
- **platform**: 

## Summary
UIViewController enstension and protocol allowing convinient display of the modal view controller

## Code:
```generic
//
//  UIViewController+Presentation.swift
//
//
//  Created by Grzegorz Maciak on 10.05.2018.
//  Copyright (c) 2018 Grzegorz Maciak.
//  This code is distributed under the terms and conditions of the MIT license.
//  See: https://gist.github.com/kodelit/04b5ef889e23f63f3462c8595d0164d9#file-license-md
//

import UIKit

public protocol ViewControllerPresentation { }

extension ViewControllerPresentation {
    public static func presentViewController(_ controller:UIViewController, on presenter:UIViewController?, animated:Bool = true, didShowOn:((UIViewController) -> Void)? = nil) {
        var presenter = presenter ?? UIApplication.shared.keyWindow?.rootViewController
        while presenter?.presentedViewController != nil {
            presenter = presenter?.presentedViewController!
            if presenter === controller {
                presenter = nil
                break
            }
        }
        
        if let target = presenter {
            target.present(controller, animated: animated, completion: {
                didShowOn?(target)
            })
        }
    }
    
    public static func dissmisViewController(_ controller:UIViewController, animated:Bool = true, completed: (() -> Void)? = nil ) {
        guard animated else {
            controller.presentingViewController?.dismiss(animated: animated, completion: completed)
            return
        }
        
        var presented = controller
        while presented.presentedViewController != nil {
            presented = presented.presentedViewController!
        }
        
        if presented === controller {
            presented.presentingViewController?.dismiss(animated: animated, completion: completed)
        }else{
            presented.presentingViewController?.dismiss(animated: animated, completion: {
                Self.dissmisViewController(controller, animated: animated, completed: completed)
            })
        }
    }
}

extension UIViewController: ViewControllerPresentation {
    public func present(on presenter: UIViewController?, animated: Bool = true, didShowOn: ((UIViewController) -> Void)? = nil) {
        UIViewController.presentViewController(self, on: presenter, animated: animated, didShowOn: didShowOn)
    }
    
    public func dismiss(animated:Bool = true, completed: (() -> Void)? = nil) {
        UIViewController.dissmisViewController(self, animated: animated, completed: completed)
    }
}

```