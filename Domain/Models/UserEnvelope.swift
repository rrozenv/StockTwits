
import Foundation

public struct UserEnvelope: Codable, Equatable {
    public let users: [User]
    
    public init(_ users: [User]) {
        self.users = users
    }
}
