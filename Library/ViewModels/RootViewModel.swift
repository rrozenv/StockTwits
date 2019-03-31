
import RxSwift
import RxCocoa
import Domain

public class RootViewModel {
    
    // MARK: - Outputs
    public typealias Outputs = (
        currentUser$: Observable<User>,
        loading$: Driver<Bool>,
        error$: Driver<Error>
    )
    
    // MARK: - Initalization
    private let disposeBag = DisposeBag()
    private let apiService: UsersUseCase
    
    public init(apiService: UsersUseCase = App.apiService) {
        self.apiService = apiService
    }

}

// MARK: - Transformation (Inputs -> Outputs)
extension RootViewModel {
    
    public func transform(initalLoad$: Observable<Void>) -> Outputs {
        /// Properties.
        let apiService = self.apiService
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        
        /// Fetch current user.
        let currentUser$ = initalLoad$.flatMap {
            apiService.fetchCurrentUser()
                .trackError(errorTracker)
                .trackActivity(activityTracker)
        }
        
        /// Return outputs.
        return (
            currentUser$: currentUser$,
            loading$: activityTracker.asDriver(),
            error$: errorTracker.asDriver()
        )
    }
    
}


