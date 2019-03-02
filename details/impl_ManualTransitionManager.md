# Impl: Manual Transition Manager
- **shortcut**: `impl_ManualTransitionManager`
- **language**: Swift
- **platform**: 

## Summary
Requires: RxSwift

## Code:
```swift
//
//  TransitionManager.swift
//  ApplicationCoreKit
//
//  Created by Grzegorz Maciak on 25.09.2018.
//  Copyright © 2018 Grzegorz Maciak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ManualTransitionManager {
    private lazy var _lock = NSRecursiveLock()
    private lazy var _transitionId:Int = Int.random
    private lazy var _disposeBag = DisposeBag()
    private lazy var _progressSource = BehaviorSubject<Observable<Double>>(value: Observable.just(0.0))
    fileprivate lazy var _transitionProgress:BehaviorSubject<Double> = {
        let source = _progressSource.switchLatest()
        let subject = BehaviorSubject<Double>(value:0.0)
        source.bind(to: subject).disposed(by: self._disposeBag)
        return subject
    }()
    
    /**
     Progress of the transition from `currentStyle` to `targetStyle`.
     
     The value is (should be) between 0.0 and 1.0.
     */
    public var transitionProgress: Double {
        get { return (try? _transitionProgress.value()) ?? 0.0 }
        set { _transitionProgress.onNext(newValue) }
    }
    
    public var debugLabel:String? = nil
    
    public typealias ProgressInfoBeforeUpdate = (progress:Double, willAnimate:Bool)
    public typealias ProgressInfoOnUpdate = (progress:Double, isInAnimationBlock:Bool)
    
    fileprivate var _willUpdate:PublishSubject<ProgressInfoBeforeUpdate>?
    fileprivate var _update:PublishSubject<ProgressInfoOnUpdate>?
    fileprivate var _didFinish:PublishSubject<Void>?
    fileprivate var _didCancel:PublishSubject<Void>?
    
    public weak var delegate:ManualTransitionManagerDelegate? = nil
    public weak var target:ManualTransitionManagerTarget? = nil
    
    /**
     Block invoked before UIView animation,
     if changes are going to be animated second param value will be set to `true`,
     use it to perform preanimation setup of UI
     
     Block takes two params:
     
     - progress: value form 0.0 to 1.0
     - willAnimate: tells does the update will be animated
     */
    public var willUpdateUIWithProgress:((Double,Bool) -> Void)? = nil
    /**
     Block might be invoked in UIView animation block,
     if that so second param value will be set to `true`,
     use it to perform animatable changes in UI
     
     Block takes two params:
     
     - progress: value form 0.0 to 1.0
     - isInAnimationBlock: tells does the update will be animated
     */
    public var updateUIWithProgress:((Double,Bool) -> Void)? = nil
    
    init(childManagers:[ManualTransitionManager] = [], toUseAsChild:Bool = false) {
        for sub in childManagers {
            self.addChildManager(sub)
        }
        if !toUseAsChild {
            self.bind()
        }
    }

    /**
     Starts animated transition if `animated` is `true` or skips to final visual state instantly.
     
     Prevous transition if where defined will be break
     */
    public func beginTransition(animated:Bool) {
        _lock.lock(); defer { _lock.unlock() }
        self._transitionId = Int.random
        self._progressSource.onNext(Observable.empty())
        self.finishTransition(animated: animated)
    }
    
    /**
     Sets transition at its begining state, ready to update according to value of `progress` source
     
     Transitions can be:
     - controled "manualy" through the `progress` observable
     - can be canceled using `cancelTransition(animated:)`
     - can be finished using `finishTransition(animated:)`
     */
    public func beginManualTransition(progress:Observable<Double>?) {
        _lock.lock(); defer { _lock.unlock() }
        self._transitionId = Int.random
        self._progressSource.onNext(( progress ?? Observable.empty() ).filter{ $0 >= 0 })
    }
    
    public func finishTransition(animated:Bool = false) {
        let progress = 1.0
        if animated {
            _lock.lock()
            let _transitionId = self._transitionId
            _lock.unlock()
            
            self.willUpdate(progress: progress, willAnimate: true)
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
                self.update(progress:progress, isInAnimationBlock:true)
            }) { [weak self] (finished) in
                // skip if target was changed during animation
                if let target = self {
                    target._lock.lock()
                    let currentTransitionId = target._transitionId
                    target._lock.unlock()
                    
                    if _transitionId == currentTransitionId {
                        target.didFinishTransition()
                    }
                }
            }
        }else{
            self.willUpdate(progress: progress, willAnimate: false)
            self.update(progress:progress, isInAnimationBlock:false)
            self.didFinishTransition()
        }
    }
    
    public func cancelTransition(animated:Bool = false) {
        let progress = 0.0
        if animated {
            _lock.lock()
            let _transitionId = self._transitionId
            _lock.unlock()
            
            self.willCancelTransition(animated: true)
            self.willUpdate(progress: progress, willAnimate: true)
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
                self.update(progress:progress, isInAnimationBlock:true)
            }) { [weak self] (finished) in
                // skip if target was changed during animation
                if let target = self {
                    target._lock.lock()
                    let currentTransitionId = target._transitionId
                    target._lock.unlock()
                    
                    if _transitionId == currentTransitionId {
                        target.didCancelTransition()
                    }
                }
            }
        }else{
            self.willCancelTransition(animated: false)
            self.willUpdate(progress: progress, willAnimate: false)
            self.update(progress:progress, isInAnimationBlock:false)
            self.didCancelTransition()
        }
    }
    
    public func resetTransition(animated:Bool = false) {
        self.cancelTransition(animated: animated)
    }
    
    public func reset() {
        let submanagers = self._children
        for sub in submanagers {
            sub.reset()
        }
        self._progressSource.onNext(Observable.just(0.0))
    }
    
    // MARK: Private methods
    
    private func bind() {
        self._transitionProgress
            .catchErrorJustReturn(0.0)
            .observeOn(MainScheduler.instance)
            .bind(to: Binder<Double>(self, binding: { target, value in
                target.willUpdate(progress: value, willAnimate: false)
                target.update(progress: value, isInAnimationBlock: false)
            })).disposed(by: self._disposeBag)
    }
    
    private func unbind() {
        self._disposeBag = DisposeBag()
    }
    
    private func willUpdate(progress:Double, willAnimate animated:Bool) {
        self.willUpdateUIWithProgress?(progress, animated)
        self.target?.willUpdateUIWithProgress(progress, willAnimate: animated)
        self._willUpdate?.onNext((progress:progress, willAnimate: animated))
        let submanagers = self._children
        for sub in submanagers {
            sub.willUpdate(progress:progress, willAnimate:animated)
        }
    }
    
    private func update(progress:Double, isInAnimationBlock animated:Bool) {
        self.updateUIWithProgress?(progress, animated)
        self.target?.updateUIWithProgress(progress, isInAnimationBlock: animated)
        self._update?.onNext((progress: progress, isInAnimationBlock: animated))
        let submanagers = self._children
        for sub in submanagers {
            sub.update(progress: progress, isInAnimationBlock: animated)
        }
    }
    
    private func didFinishTransition() {
        print("\(#function): \(String(describing: self.debugLabel))")
        self.delegate?.transitionManagerDidFinish(self)
        self._didFinish?.onNext(())
        let submanagers = self._children
        for sub in submanagers {
            sub.didFinishTransition()
        }
    }
    
    private func willCancelTransition(animated:Bool) {
        self.delegate?.transitionManagerWillCancel(self, animated:animated)

        let submanagers = self._children
        for sub in submanagers {
            sub.willCancelTransition(animated:animated)
        }
    }
    
    private func didCancelTransition() {
        self.delegate?.transitionManagerDidCancel(self)
        self._didCancel?.onNext(())
        let submanagers = self._children
        for sub in submanagers {
            sub.didCancelTransition()
        }
    }
    
    // MARK: Child manager
    
    public private(set) weak var parent:ManualTransitionManager? = nil
    private var _submanagers:[ManualTransitionManager] = []
    private var _children:[ManualTransitionManager] {
        get {
            _lock.lock(); defer { _lock.unlock() }
            return _submanagers
        }
        set {
            _lock.lock(); defer { _lock.unlock() }
            _submanagers = newValue
        }
    }
    
    /**
     Adds child manager which progress will be synchronized with the parent.
     */
    public func addChildManager(_ manager:ManualTransitionManager) {
        _lock.lock(); defer { _lock.unlock() }
        manager.parent = self
        self._children.append(manager)
        manager._progressSource.onNext(self._transitionProgress)
    }
    
    public func removeChildManager(_ manager:ManualTransitionManager) {
        _lock.lock(); defer { _lock.unlock() }
        manager._progressSource.onNext(Observable.empty())
        if let index = self._children.index(where: { $0 === manager }) {
            self._children.remove(at: index)
        }
        manager.parent = nil
    }
    
    public func removeFromParent() {
        self.parent?.removeChildManager(self)
    }
}

// MARK: - TransitionManager+Rx
extension ManualTransitionManager: ReactiveCompatible {}

extension Reactive where Base:ManualTransitionManager {
    
    public func finishTransition(animated:Bool) -> Binder<Void> {
        return Binder<Void>(base, binding: { target, _ in
            target.finishTransition(animated: animated)
        })
    }
    
    public func cancelTransition(animated:Bool) -> Binder<Void> {
        return Binder<Void>(base, binding: { target, _ in
            target.cancelTransition(animated: animated)
        })
    }
    
    public func resetTransition(animated:Bool = false) -> Binder<Void> {
        return Binder<Void>(base, binding: { target, _ in
            target.resetTransition(animated: animated)
        })
    }
    
    public func resetTransitionManager() -> Binder<Void> {
        return Binder<Void>(base, binding: { target, _ in
            target.reset()
        })
    }
    
    public var willUpdate:Observable<Base.ProgressInfoBeforeUpdate> {
        if let source = self.base._willUpdate {
            return source
        }
        self.base._willUpdate = PublishSubject<Base.ProgressInfoBeforeUpdate>()
        return self.base._willUpdate!
    }
    
    public var update:Observable<Base.ProgressInfoOnUpdate> {
        if let source = self.base._update {
            return source
        }
        self.base._update = PublishSubject<Base.ProgressInfoOnUpdate>()
        return self.base._update!
    }
    
    public var didFinishTransition:Observable<Void> {
        if let source = self.base._didFinish {
            return source
        }
        self.base._didFinish = PublishSubject<Void>()
        return self.base._didFinish!
    }
    
    public var didCancelTransition:Observable<Void> {
        if let source = self.base._didCancel {
            return source
        }
        self.base._didCancel = PublishSubject<Void>()
        return self.base._didCancel!
    }
}

// MARK: - ManualTransitionManagerDelegate

public protocol ManualTransitionManagerDelegate:AnyObject {
    func transitionManagerDidFinish(_ manager:ManualTransitionManager)
    func transitionManagerWillCancel(_ manager:ManualTransitionManager, animated:Bool)
    func transitionManagerDidCancel(_ manager:ManualTransitionManager)
}

// MARK: - ManualTransitionManagerTarget

public protocol ManualTransitionManagerTarget:AnyObject {
    // required
    var transitionManager:ManualTransitionManager { get }
    
    // optional
    func beginTransition(animated:Bool)
    func beginManualTransition(progress:Observable<Double>)
    func finishTransition(animated:Bool)
    func cancelTransition(animated:Bool)
    func resetTransition(animated:Bool)
    func resetTransitionManager()
    
    func willUpdateUIWithProgress(_ progress:Double, willAnimate:Bool)
    func updateUIWithProgress(_ progress:Double, isInAnimationBlock:Bool)
    
    func createTransitionManager(id:String?, delegate:ManualTransitionManagerDelegate?, toUseAsChild:Bool) -> ManualTransitionManager
}

extension ManualTransitionManagerTarget where Self:AnyObject {
    
    // control
    
    public func beginTransition(animated:Bool = false) {
        self.transitionManager.beginTransition(animated: animated)
    }
    
    public func beginManualTransition(progress:Observable<Double>) {
        self.transitionManager.beginManualTransition(progress: progress)
    }
    
    public func finishTransition(animated:Bool = false) {
        self.transitionManager.finishTransition(animated: animated)
    }
    
    public func cancelTransition(animated:Bool = false) {
        self.transitionManager.cancelTransition(animated: animated)
    }
    
    public func resetTransition(animated:Bool = false) {
        self.transitionManager.resetTransition(animated: animated)
    }
    
    public func resetTransitionManager() {
        self.transitionManager.reset()
    }
    
    // update
    public func willUpdateUIWithProgress(_ progress:Double, willAnimate:Bool) {
        // setup constraints here
    }
    
    public func updateUIWithProgress(_ progress:Double, isInAnimationBlock:Bool) {
        // Here define params to animate
        
        // Uncomment following line to animate updated constraints
        // self.view.layoutIfNeeded()
    }
    
    // factory
    
    /**
     Creates instance of the manager with or without delegate
     
     Tt also pins callbacks to methods of `ManualTransitionManagerTarget` protocol:
     `willUpdateUIWithProgress(_:willAnimate:)`
     `updateUIWithProgress(_:isInAnimationBlock:)`
     
     Usage example:
     
         `public private(set) lazy var transitionManager:ManualTransitionManager = self.createTransitionManager(delegate:self)`
     or
     
         `public private(set) lazy var transitionManager:ManualTransitionManager = self.createTransitionManager()`
     */
    public func createTransitionManager(id:String? = nil, delegate:ManualTransitionManagerDelegate? = nil, toUseAsChild:Bool = false) -> ManualTransitionManager {
        let manager = ManualTransitionManager()
        manager.delegate = delegate
        manager.target = self
        manager.debugLabel = id
//        // prepere for animation
//        manager.willUpdateUIWithProgress = { [weak self] progress, animated in
//            self?.willUpdateUIWithProgress(progress, willAnimate:animated)
//        }
//        // animate
//        manager.updateUIWithProgress = { [weak self] progress, animated in
//            self?.updateUIWithProgress(progress, isInAnimationBlock:animated)
//        }
        return manager
    }
}

extension ManualTransitionManagerTarget where Self:ManualTransitionManagerDelegate {
    public func transitionManagerDidFinish(_ manager: ManualTransitionManager) { }
    public func transitionManagerWillCancel(_ manager:ManualTransitionManager, animated:Bool) { }
    public func transitionManagerDidCancel(_ manager: ManualTransitionManager) { }
}

extension Reactive where Base:ManualTransitionManagerTarget {
    public func finishTransition(animated:Bool) -> Binder<Void> {
        return Binder<Void>(base, binding: { target, _ in
            target.finishTransition(animated: animated)
        })
    }
    
    public func cancelTransition(animated:Bool) -> Binder<Void> {
        return Binder<Void>(base, binding: { target, _ in
            target.cancelTransition(animated: animated)
        })
    }
    
    public func resetTransition(animated:Bool = false) -> Binder<Void> {
        return Binder<Void>(base, binding: { target, _ in
            target.resetTransition(animated: animated)
        })
    }
    
    public var willUpdate:Observable<ManualTransitionManager.ProgressInfoBeforeUpdate> {
        return self.base.transitionManager.rx.willUpdate
    }
    
    public var update:Observable<ManualTransitionManager.ProgressInfoOnUpdate> {
        return self.base.transitionManager.rx.update
    }
    
    public var didFinishTransition:Observable<Void> {
        return self.base.transitionManager.rx.didFinishTransition
    }
    
    public var didCancelTransition:Observable<Void> {
        return self.base.transitionManager.rx.didCancelTransition
    }
}

```