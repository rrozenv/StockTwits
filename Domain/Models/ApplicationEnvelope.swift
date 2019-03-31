
import Foundation

public struct ApplicationEnvelope: Codable, Equatable {
    public let apps: [Application]
    
    public init(_ apps: [Application]) {
        self.apps = apps
    }
}

