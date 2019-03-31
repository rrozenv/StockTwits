
import Foundation

public protocol ErrorRepresentable: LocalizedError {
    var title: String { get }
    var body: String { get }
    var actionTitle: String { get }
}

    
