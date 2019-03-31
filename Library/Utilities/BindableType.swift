
import UIKit

/**
Used by view controllers to ensure the view is loaded before binding view model with UI.
 */
public protocol BindableType: class {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    
    /// Sets and binds view model for respective view controller.
    ///
    /// - Parameter model: View model to bind with.
    public func setViewModelBinding(model: Self.ViewModel) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
    
}
