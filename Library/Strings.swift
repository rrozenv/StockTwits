
import Foundation

/**
All strings requiring localization should be referenced here.
 */
public enum Strings {
    
    /**
     "Applications"
     */
    public static func applications() -> String {
        return localizedString(
            key: "applications",
            defaultValue: "Applications",
            count: nil,
            substitutions: [:]
        )
    }
    
    /**
     "In-App Purchases"
     */
    public static func in_app_purchases() -> String {
        return localizedString(
            key: "in_app_purchases",
            defaultValue:"In-App Purchases",
            count: nil,
            substitutions: [:]
        )
    }
    
    /**
     "In-App Purchases"
     */
    public static func get() -> String {
        return localizedString(
            key: "get",
            defaultValue:"get",
            count: nil,
            substitutions: [:]
        )
    }

}

// MARK: - Errors
extension Strings {
    
    enum Errors {
        /**
         "Error"
         */
        public static func generic_error_title() -> String {
            return localizedString(
                key: "generic_error_title",
                defaultValue: "Error",
                count: nil,
                substitutions: [:]
            )
        }
        
        /**
         "Something failed."
         */
        public static func generic_error_message() -> String {
            return localizedString(
                key: "generic_error_message",
                defaultValue: "Something failed.",
                count: nil,
                substitutions: [:]
            )
        }
        
        /**
         "Something failed."
         */
        public static func generic_error_action_title() -> String {
            return localizedString(
                key: "generic_error_action_title",
                defaultValue: "OK",
                count: nil,
                substitutions: [:]
            )
        }
    }
    
}
