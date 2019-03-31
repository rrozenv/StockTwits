
import RxSwift
import Domain
import Prelude
import RxCocoa

public enum ObjectAction {
    case created
    case modified
    case deleted
}

public struct MockAPIService: ServiceType {

    // MARK: - Properties
    public let appId: String
    public let buildVersion: String
    public let baseApiUrl: URL
    public let language: String
    
    /// Called internally to notify listeners when an object is modifed, created, or deleted.
    /// Should not be subscribed to directly, check `ObjectNotificationProtocol` for helper methods.
    public let objectNotifier$ = PublishSubject<(object: Any, action: ObjectAction)>()
    
    /// Sets mock errors.
    public let errors$ = BehaviorRelay<[Error]>(value: [])
    
    /// Set mocked response delay.
    public let delay$ = BehaviorRelay<RxTimeInterval?>(value: nil)
    
    // MARK: - Initalization
    public init(appId: String = Configuration.appName,
                buildVersion: String = Configuration.buildVersion,
                baseApiUrl: URL = Configuration.rootURL,
                language: String = Locale.current.languageCode ?? "en") {
        self.buildVersion = buildVersion
        self.appId = appId
        self.baseApiUrl = baseApiUrl
        self.language = language
    }
    
}

// MARK: - ApplicationsUseCase
extension MockAPIService {
    
    public func fetchApplications() -> Observable<[Application]> {
        let response = try! JSONMapper.createArray(Application.self, from: JSONFile.getApplications.rawValue)
        return observable(of: response, error: AppListError.fetchAppsFailed)
    }
    
}


// MARK: - UsersUseCase
extension MockAPIService {
    
    public func fetchCurrentUser() -> Observable<User> {
        return observable(of: User.template, error: UserError.fetchCurrentUserFailed)
    }
    
    public func fetchUsers() -> Observable<UserEnvelope> {
        return observable(of: UserEnvelope.template, error: UserError.fetchUsersFailed)
    }

}

// MARK: - Private Methods
extension MockAPIService {
    
    /// Checks if an `error$` or `delay$` is set on the mock service and returns the given object accordingly.
    private func observable<T, E: Error>(of object: T, error: E, completion: ((T) -> Void)? = nil) -> Observable<T> {
        guard let delay = delay$.value, delay > 0 else {
            guard let error = errorExists(for: error) else {
                return Observable.of(object)
                    .do(onNext: completion)
            }
            return .error(error)
        }
        
        guard let error = errorExists(for: error) else {
            return Observable<Int>.interval(delay, scheduler: MainScheduler.instance)
                .take(1)
                .mapToVoid()
                .map { object }
                .do(onNext: completion)
        }
        
        return Observable<Int>.interval(delay, scheduler: MainScheduler.instance)
            .take(1)
            .mapToVoid()
            .flatMap { Observable.error(error) }
    }
    
    /// Checks if the given error exists in the `errors$` array.
    private func errorExists<E: Error>(for error: E) -> Error? {
        return errors$.value.first { $0 is E }
    }
    
}
