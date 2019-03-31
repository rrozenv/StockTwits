
import UIKit
import RxSwift
import RxCocoa
import Library
import Prelude
import Domain

internal final class AppListViewController: RxViewController, BindableType {
    
    // MARK: - View Model
    internal var viewModel: AppListViewModel?
    
    // MARK: - Properties
    internal let tableView = UITableView()
    internal let errorLabel = UILabel()
    internal let refreshControl = UIRefreshControl()
    
    // MARK: - Initalization
    static func instantiate() -> AppListViewController {
        let vc = AppListViewController()
        let vm = AppListViewModel()
        vc.setViewModelBinding(model: vm)
        return vc
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Style Binding
    override func bindStyles() {
        super.bindStyles()
        _ = self |> baseControllerStyle
        setupNavigationBar()
    }
    
    // MARK: - View Model binding
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel else {
            assertionFailure("\(String(describing: self)) view model not set.")
            return
        }
        
        /** MARK: - Inputs **/
        
        /// Triggers on pull to refresh.
        let didPullRefresh$ = refreshControl.rx.controlEvent(.valueChanged).mapToVoid()
        
        /// Combined inputs.
        let inputs = AppListViewModel.Inputs(
            loadApps$: Observable.merge(initalLoad$, didPullRefresh$),
            selectedIndexPath$: tableView.rx.itemSelected.asObservable()
        )
        
        /** MARK: - Outputs **/
        let outputs = viewModel.transform(inputs: inputs)
        
        /// Displays settings in table view.
        outputs.apps$
            .drive(tableView.rx.items(cellIdentifier: String(describing: ApplicationTableCell.self), cellType: ApplicationTableCell.self)) { row, app, cell in
                print(row)
                cell.cellView.titleLabel.text = app.nameText
                cell.cellView.descriptionLabel.text = app.descriptionText
                cell.cellView.actionButton.setTitle(app.actionText, for: .normal)
                cell.cellView.appPurchaseLabel.text = app.inAppPurchaseText
                cell.cellView.logoImageView.backgroundColor = .orange
            }
            .disposed(by: disposeBag)
        
        /// Animates refresh control.
        outputs.loading$
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        /// Displays error message.
        outputs.error$
            .drive(rx.displayError)
            .disposed(by: disposeBag)
        
        /// Hides error label when loading.
        outputs.loading$
            .filter { $0 }
            .drive(errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    // MARK: - View Setup
    private func setupNavigationBar() {
        navigationItem.title = Strings.applications()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

// MARK: - View Setup
extension AppListViewController {
    
    private func setupUI() {
        setupViewHeirarchy()
        setupTableView()
        setupErrorLabel()
    }
    
    private func setupViewHeirarchy() {
        view.addSubview(tableView)
        view.addSubview(errorLabel)
        tableView.addSubview(refreshControl)
    }
    
    private func setupTableView() {
        tableView.register(ApplicationTableCell.self)
        tableView.tableFooterView = UIView()
        tableView.fillSuperview()
    }
    
    private func setupErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.textAlignment = .center
        errorLabel.anchorCenterSuperview()
        errorLabel.anchor(widthConstant: view.frame.width * 0.7)
    }
    
}

// MARK: - Error
fileprivate extension Reactive where Base: AppListViewController {
    
    fileprivate var displayError: Binder<Error> {
        return Binder(base) { vc, error in
            vc.errorLabel.isHidden = false
            switch error {
            case let err as ErrorRepresentable:
                vc.errorLabel.text = err.title
            default:
                vc.errorLabel.text = error.localizedDescription
            }
        }
    }
    
}
