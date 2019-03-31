
import RxSwift
import RxCocoa
import UIKit

/**
 Tracks how long an observable takes to emit the following `next` event.
 Useful for tracking the loading of a network request.
 */
extension Reactive where Base: UIViewController {
    public var displayError: Binder<Error> {
        return Binder(base) { vc, error in
            guard vc.presentedViewController == nil else { return }
            vc.display(error: error)
        }
    }
}

extension Reactive where Base: UIViewController {
    public var dismiss: Binder<Void> {
        return Binder(base) { vc, _ in
            vc.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: Reactive Extension
extension Reactive where Base: UIPageViewController {
    public var displayNext: Binder<UIViewController> {
        return Binder(base) { pageVc, vc in
            pageVc.setViewControllers(
                [vc],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
    }
}

public extension UIViewController {
    
    public enum ControllerLifecycleState {
        case unknown, didAppear, didDisappear, willAppear, willDisappear
    }
}

/**
 Tracks how long an observable takes to emit the following `next` event.
 Useful for tracking the loading of a network request.
 */
public extension Reactive where Base: UIViewController {
    
    private typealias _StateSelector = (Selector, UIViewController.ControllerLifecycleState)
    private typealias _State = UIViewController.ControllerLifecycleState
    
    private func observableAppearance(_ selector: Selector, state: _State) -> Observable<UIViewController.ControllerLifecycleState> {
        return (base as UIViewController).rx
            .methodInvoked(selector)
            .map { _ in state }
    }
    
    public func controllerLifecycleState() -> Driver<UIViewController.ControllerLifecycleState> {
        let statesAndSelectors: [_StateSelector] = [
            (#selector(UIViewController.viewDidAppear(_:)), .didAppear),
            (#selector(UIViewController.viewDidDisappear(_:)), .didDisappear),
            (#selector(UIViewController.viewWillAppear(_:)), .willAppear),
            (#selector(UIViewController.viewWillDisappear(_:)), .willDisappear)
        ]
        let observables = statesAndSelectors
            .map({ observableAppearance($0.0, state: $0.1) })
        return Observable
            .from(observables)
            .merge()
            .asDriver(onErrorJustReturn: UIViewController.ControllerLifecycleState.unknown)
            .startWith(UIViewController.ControllerLifecycleState.unknown)
            .distinctUntilChanged()
    }
    
}




