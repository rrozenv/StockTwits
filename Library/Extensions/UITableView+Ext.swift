
import Foundation

/**
 Wrappers around common table view methods.
 */
extension UITableView {
    
    public func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass.self, forCellReuseIdentifier: String(describing: cellClass.self))
    }
    
    public func dequeueReusableCell<CellClass: UITableViewCell>(of class: CellClass.Type, for indexPath: IndexPath, configure: ((CellClass) -> Void) = { _ in }) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: CellClass.identifier, for: indexPath)
        if let typedCell = cell as? CellClass {
            configure(typedCell)
        }
        return cell
    }
    
}

/**
 Cells gain identifier that equals class name.
 */
extension UITableViewCell {
    public static var identifier: String { return String(describing: self) }
}
