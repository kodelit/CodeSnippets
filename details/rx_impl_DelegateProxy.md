# Rx Impl: Delegate Proxy Implementation
- **shortcut**: `rx_impl_DelegateProxy`
- **language**: Swift
- **platform**: 


## Code:
```swift
extension <#ClassName#>: HasDelegate {
    public typealias Delegate = <#ClassName#>Delegate
}

/// Delegate proxy of <#ClassName#>
public class Rx<#ClassName#>DelegateProxy : DelegateProxy<<#ClassName#>, <#ClassName#>Delegate> , DelegateProxyType , <#ClassName#>Delegate {
    
    public init(_ parent: <#ClassName#>) {
        super.init(parentObject: parent, delegateProxy: Rx<#ClassName#>DelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { Rx<#ClassName#>DelegateProxy($0) }
    }
    
    // MARK: Example state forwarding
//
//    enum State {
//        case `default`, some
//    }
//
//    internal lazy var didChangeState = PublishSubject<State>()
//
//    public func parrentObjectDidEnterSomeMode(_ parrentObject: CustomNavigationBar) {
//        _forwardToDelegate?.customNavigationBarDidEnterSearchMode(parrentObject)
//        didChangeState.onNext(.some)
//    }
//
//    public func parrentObjectDidExitSomeMode(_ parrentObject: CustomNavigationBar) {
//        _forwardToDelegate?.customNavigationBarDidExitSearchMode(parrentObject)
//        didChangeState.onNext(.default)
//    }
//
//    deinit {
//        self.didChangeState.on(.completed)
//    }
}
```