
import Foundation

public enum AppListError {
    case fetchAppsFailed
}

extension AppListError: ErrorRepresentable {
    public var title: String {
        return Strings.Errors.generic_error_title()
    }
    
    public var body: String {
        return Strings.Errors.generic_error_message()
    }
    
    public var actionTitle: String {
        return Strings.Errors.generic_error_action_title()
    }
}
