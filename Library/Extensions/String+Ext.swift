
import Foundation

extension String {
    
    public var bool: Bool {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return false
        }
    }
    
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
