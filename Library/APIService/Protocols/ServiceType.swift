
import Foundation

public protocol ServiceType:
                    UsersUseCase,
                    ApplicationsUseCase {
    
    var appId: String { get }
    var buildVersion: String { get }
    var oauthToken: String? { get }
    var language: String { get }
    var currency: String { get }

    init(appId: String,
         buildVersion: String,
         baseApiUrl: URL,
         oauthToken: String?,
         language: String,
         currency: String)

}

