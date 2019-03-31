
import Foundation
import RxSwift
import RxCocoa
import UIKit

/**
Provides base functionality for a view controller in a reactive code base.
 */
open class RxViewController: UIViewController {
    
    // MARK: - Properties
    public let disposeBag = DisposeBag()
    
    /// Called first time viewWillAppear(_:) is invoked.
    public lazy var initalLoad$ = rx.controllerLifecycleState()
        .filter { $0 == .willAppear }
        .asObservable()
        .take(1)
        .mapToVoid()
        .share()
  
    override open func viewDidLoad() {
        super.viewDidLoad()
        initalLoad$
            .subscribe(onNext: { [weak self] in
                self?.bindStyles()
            })
            .disposed(by: disposeBag)
    }
    
    deinit { Log.i("\(type(of: self)) deinit") }
    
    // MARK: View Model Binding
    /// Should override
    open func bindViewModel() { }
    
    // MARK: Styles Binding
    /// Should override
    open func bindStyles() { }

}

extension RxViewController {
    
    /// Pops view controller if embedded in navigation stack and calls provided completion.
    public func popOnLeftBarButtonTap(completion: @escaping @autoclosure () -> Void = { }()) {
        navigationItem.leftBarButtonItem?.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                completion()
            })
            .disposed(by: disposeBag)
    }
    
    /// All constraints provided will move up/down with keyboard
    public func keyboardAvoidable(constraints: [NSLayoutConstraint]) {
        UIDevice.keyboard
            .subscribe(onNext: { keyboard in
                for constraint in constraints {
                    UIView.animateKeyframes(withDuration: 1.0,
                                            delay: 0.0,
                                            options: UIView.KeyframeAnimationOptions(rawValue: UInt(keyboard.curve.rawValue)), animations: {
                                                constraint.constant = keyboard.height + 10
                    },completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
}

