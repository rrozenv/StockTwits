
import UIKit

/**
Storyboard + Nib identifiers.
 */
extension UIViewController {
    public static var defaultNib: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
    
    public static var storyboardIdentifier: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}

/**
 Helper methods to add/remove child view controller.
 */
extension UIViewController {
    
    /// Adds child view controller to view.
    ///
    /// - Parameters:
    ///   - viewController: View controller to add.
    ///   - view: View to add to.
    ///   - frame: Optional frame for new view controller. If == nil, will fill the given views bouds.
    public func add(child viewController: UIViewController, to view: UIView, frame: CGRect? = nil) {
        addChild(viewController)
        viewController.view.frame = frame ?? view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    /// Removes child view controller from parent.
    ///
    /// - Parameter viewController: View controller to remove.
    public func remove(child viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

}

/**
Displays a UIAlertController for the given error.
 */
extension UIViewController {
    
    public func display(error: Error) {
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
       
        switch error {
        case let err as ErrorRepresentable:
            alertVc.title = err.title
            alertVc.message = err.body
            alertVc.addAction(UIAlertAction.init(title: err.actionTitle, style: .cancel))
        default:
            alertVc.title = "Error"
            alertVc.message = error.localizedDescription
            alertVc.addAction(UIAlertAction.init(title: "OK", style: .cancel))
        }
        
        DispatchQueue.main.async {
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
}

