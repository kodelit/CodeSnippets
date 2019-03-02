# Protocol Impl: ManualTransitionManagerTarget
- **shortcut**: `prot_impl_ManualTransitionManagerTarget`
- **language**: Swift
- **platform**: 


## Code:
```swift
public private(set) lazy var transitionManager:ManualTransitionManager = self.createTransitionManager()
    
    public func willUpdateUIWithProgress(_ progress:Double, animated:Bool) {
        // setup constraints here
    }
    
    public func updateUIWithProgress(_ progress:Double, animated:Bool) {
        // Here define params to animate
        
        // Uncomment following line to animate updated constraints
        // self.view.layoutIfNeeded()
    }
```