
import Foundation
import RxSwift
import RxCocoa
import Domain

public struct APIService: ServiceType {

    // MARK: - Properties
    public let appId: String
    public let buildVersion: String
    public let baseApiUrl: URL
    public let oauthToken: String?
    public let language: String
    public let currency: String
    
    /// Called internally to notify listeners when an object is modifed, created, or deleted.
    /// Should not be subscribed to directly, check `ObjectNotificationProtocol` for helper methods.
    public let objectNotifier$ = PublishSubject<(object: Any, action: ObjectAction)>()
 
    // MARK: - Initalization
    public init(appId: String = Configuration.appName,
                buildVersion: String = Configuration.buildVersion,
                baseApiUrl: URL = Configuration.rootURL,
                oauthToken: String? = nil,
                language: String = Locale.current.languageCode ?? "en",
                currency: String = "USD") {
        self.buildVersion = buildVersion
        self.appId = appId
        self.baseApiUrl = baseApiUrl
        self.oauthToken = oauthToken
        self.language = language
        self.currency = currency
    }

}

// MARK: - ApplicationsUseCase
extension APIService {
    
    public func fetchApplications() -> Observable<[Application]>  {
        // Cached result if it exists.
        let cachedResult = App.current.storage
            .fetch(ApplicationEnvelope.self).asObservable()
            .catchErrorReturnEmpty()
        
        // New network result which overrwrites latest cache.
        let networkResult = Observable
            .just(try! JSONMapper.createArray(Application.self, from: JSONFile.getApplications.rawValue))
            .map(ApplicationEnvelope.init)
            .flatMap { result -> Observable<ApplicationEnvelope> in
                return App.current.storage.save(object: result)
                    .asObservable()
                    .map { _ in result }
                    .catchErrorJustReturn(result)
        }
        
        // Return cached result immediatly if exists. Then return network result.
        return cachedResult
            .concat(networkResult)
            .map { $0.apps }
    }
    
}

// MARK: - UsersUseCase
extension APIService {
    
    public func fetchCurrentUser() -> Observable<User> {
        // Cached result if it exists.
        let cachedResult = App.current.storage
            .fetch(User.self).asObservable()
            .catchErrorReturnEmpty()
        
        // New network result which overrwrites latest cache.
        let networkResult = Observable
            .just(User.template)
        
        return cachedResult.concat(networkResult)
    }
    
    public func fetchUsers() -> Observable<UserEnvelope> {
        // Cached result if it exists.
        let cachedResult = App.current.storage
            .fetch(UserEnvelope.self).asObservable()
            .catchErrorReturnEmpty()
        
        // New network result which overrwrites latest cache.
        let networkResult = Observable
            .just(UserEnvelope.template)

        return cachedResult.concat(networkResult)
    }
    
}



