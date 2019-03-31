
import Domain
import Foundation

/**
Holds all of the apps global depenedencies.
 */
public struct Environment {
    
    // MARK: - Properties
    public let apiService: ServiceType
    public let storage: StorageType
    public let language: Language
    public let currentUser: User?
    
    // MARK: - Initialization
    public init(
        apiService: ServiceType = APIService(),
        storage: StorageType = FileSystemCache(),
        language: Language = Language(rawValue: Locale.current.languageCode ?? "en")!,
        currentUser: User? = nil
    ) {
        self.apiService = apiService
        self.storage = storage
        self.language = language
        self.currentUser = currentUser
    }
    
}
