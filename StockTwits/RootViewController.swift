
import UIKit
import RxSwift
import Library
import Domain
import RxCocoa

/**
Manages the root view controller in window.
 */
internal class RootViewController: RxViewController, BindableType {
    
    internal var viewModel: RootViewModel?
    
    /// Root view controller singleton.
    internal static let shared = RootViewController.instantiate()
    
    /// Root view controller of window.
    internal var current: UIViewController = UIViewController() {
        didSet {
            remove(child: oldValue)
            add(child: current, to: view)
        }
    }
    
    /// Activity indicator view.
    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .gray)
        activity.hidesWhenStopped = true
        return activity
    }()
    
    // MARK: - Initalization
    private static func instantiate() -> RootViewController {
        let vc = RootViewController()
        let vm = RootViewModel()
        vc.setViewModelBinding(model: vm)
        return vc
    }
    
    internal init() {
        Theme.current.apply()
        super.init(nibName:  nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        current = createSplashViewController()
    }
    
    // MARK: - View Model Binding
    override func bindViewModel() {
        guard let viewModel = viewModel else {
            assertionFailure("\(String(describing: self)) view model not set.")
            return
        }
        
        /** MARK: - Outputs */
        let outputs = viewModel.transform(initalLoad$: initalLoad$)
        
        /// Shared current user observable.
        let currentUser$ = outputs.currentUser$.share()
        
        /// Update current user in enviorment.
        currentUser$
            .subscribe(onNext: App.updateCurrentUser)
            .disposed(by: disposeBag)
        
        /// Display loading.
        outputs.loading$
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        /// Display errror.
        outputs.error$
            .drive(rx.displayError)
            .disposed(by: disposeBag)
        
        /// Sets root coordinator.
        currentUser$
            .subscribe(onNext: { [unowned self] _ in
                self.current = DashboardCoordinator()
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Private Methods
extension RootViewController {
    
    private func createSplashViewController() -> UIViewController {
        let splashVc = UIViewController()
        splashVc.view.addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
        return splashVc
    }
    
}
