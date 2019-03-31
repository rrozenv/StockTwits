
import Domain
import RxSwift

/**
Manages the environment the app is currently running in.
 */
public struct App {
    // MARK: - Static Properties
    /// Enviroment container initalized with default environment.
    private static var stack: [Environment] = [Environment()]
    
    /// Returns the current enviroment.
    public static var current: Environment! { return stack.last }
    
    /// Convenience property to get the current api service.
    public static var apiService: ServiceType { return App.current.apiService }
}

// MARK: - Enviroment Static Methods
extension App {
    
    /// Push a new environment onto the stack.
    public static func pushEnvironment(_ env: Environment) {
        stack.append(env)
    }
    
    /// Pop an environment off the stack.
    @discardableResult
    public static func popEnvironment() -> Environment? {
        return stack.popLast()
    }
    
    /// Replace the current environment with a new environment.
    public static func switchCurrentEnvironment(to env: Environment) {
        stack.removeLast()
        pushEnvironment(env)
    }
    
    /// Replaces the current environment onto the stack with an environment that changes a subset of the global dependencies.
    public static func replaceCurrentEnvironment(
        apiService: ServiceType = current.apiService,
        storage: StorageType = current.storage,
        currentUser: User? = current.currentUser
    ) {
        switchCurrentEnvironment(to:
            Environment(
                apiService: apiService,
                storage: storage,
                currentUser: currentUser
            )
        )
    }
    
    public static func setMockEnvironment(
        apiErrors: [Error] = [],
        responseDelay: RxTimeInterval = 0
    ) {
        let mockService = MockAPIService()
        mockService.delay$.accept(responseDelay)
        mockService.errors$.accept(apiErrors)
        App.replaceCurrentEnvironment(
            apiService: mockService
        )
    }
    
    /// Updates current user in environment.
    public static func updateCurrentUser(_ user: User) {
        replaceCurrentEnvironment(
            currentUser: user
        )
    }
    
}


