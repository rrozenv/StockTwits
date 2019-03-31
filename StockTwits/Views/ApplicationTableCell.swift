
import Foundation
import UIKit
import Prelude

// MARK: - ApplicationTableCell
final class ApplicationTableCell: UITableViewCell {
    
    // MARK: - Properties
    let cellView = ApplicationTableCellView()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(cellView)
        cellView.fillSuperview()
    }
    
}
