
import RxSwift
import RxCocoa
import Domain

public class AppListViewModel {

    // MARK: - Inputs
    public typealias Inputs = (
        loadApps$: Observable<Void>,
        selectedIndexPath$: Observable<IndexPath>
    )

    // MARK: - Outputs
    public typealias Outputs = (
        apps$: Driver<[ApplicationViewModel]>,
        loading$: Driver<Bool>,
        error$: Driver<Error>
    )

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let apiService: ApplicationsUseCase

    // MARK: - Initalization
    public init(apiService: ApplicationsUseCase = App.apiService) {
        self.apiService = apiService
    }

    // MARK: - Coordinator Outputs
    public let selectedApp$ = PublishSubject<Application>()

}

// MARK: - Transformation
extension AppListViewModel {
    
    public func transform(inputs: Inputs) -> Outputs {
        
        /// Properties
        let apiService = self.apiService
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        let apps$ = BehaviorRelay<[ApplicationViewModel]>(value: [])
        
        /// Fetch apps and map to view models.
        inputs.loadApps$
            .flatMapLatest { _ in
                apiService.fetchApplications()
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
            }
            .map { $0.map(ApplicationViewModel.init) }
            .bind(to: apps$)
            .disposed(by: disposeBag)
        
        /// Pass selected app to coordinator.
        inputs.selectedIndexPath$
            .map { apps$.value[$0.row].rawModel }
            .bind(to: selectedApp$)
            .disposed(by: disposeBag)
        
        /// Return outputs.
        return (apps$: apps$.asDriver(),
                loading$: activityTracker.asDriver(),
                error$: errorTracker.asDriver())
    }

}

// MARK: - ApplicationViewModel
public struct ApplicationViewModel: Equatable {
    public let rawModel: Application
    public let nameText: String
    public let descriptionText: String
    public let actionText: String
    public let inAppPurchaseText: String?
    public let imageURL: URL?
    
    public init(_ app: Application) {
        self.rawModel = app
        self.nameText = app.name.capitalized
        self.descriptionText = app.description.capitalized
        self.imageURL = URL(string: app.imageURL)
        self.inAppPurchaseText = app.inAppPurchases ? Strings.in_app_purchases() : nil
        self.actionText = app.price != nil ? app.price! : Strings.get().uppercased()
    }
}



