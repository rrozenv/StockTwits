
import Foundation

public protocol ServiceType:
                    UsersUseCase,
                    ApplicationsUseCase {
    
    var appId: String { get }
    var buildVersion: String { get }
    var language: String { get }

    init(appId: String,
         buildVersion: String,
         baseApiUrl: URL,
         language: String)

}

