# Rx: ViewController: ReactiveView
- **shortcut**: `rx_ViewController`
- **language**: Swift
- **platform**: 

## Summary
ViewController declaration conforming ReactiveView protocol

## Code:
```swift
public class <#ViewControllerClassName#>: UIViewController, ReactiveView {
    lazy var viewModel = <#ViewModelClassName#>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupReactiveX()
    }
    
    func setupReactiveX() {
        #if !TARGET_INTERFACE_BUILDER
        
        // reactive code
        
        #endif
    }
}
```