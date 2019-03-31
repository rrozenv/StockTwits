
import UIKit
import Library
import RxSwift
import Domain

/**
 Manages the main dashboard navigation controller.
 */
internal final class DashboardCoordinator: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let navController = UINavigationController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Add nav as child.
        add(child: navController, to: view)
        
        // Navigate to root nav vc.
        navigateToAppList()
    }
    
}

// MARK: - Navigation
extension DashboardCoordinator {
    
    /// Navigates to root app list.
    private func navigateToAppList() {
        let vc = AppListViewController.instantiate()
        navController.show(vc, sender: self)
    }
    
}
