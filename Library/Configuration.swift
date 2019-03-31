
import Foundation

public struct Configuration {
    
    // MARK: - Static Properties
    /// Reference to main info plist.
    private static let infoDictionary: [String: Any] = Bundle.main.infoDictionary!
    
    /// App name.
    public static let appName: String = infoDictionary[Keys.Plist.appName] as! String
    
    /// Root api url.
    public static let rootURL: URL = {
        let rootURLstring = infoDictionary[Keys.Plist.rootURL] as! String
        return URL(string: rootURLstring)!
    }()
    
    /// Build version.
    public static let buildVersion: String = {
        return infoDictionary[Keys.Plist.buildVersion] as! String
    }()
    
    /// Logging enabled flag.
    public static let isLoggingEnabled: Bool = {
        return (infoDictionary[Keys.Plist.logging] as! String).bool
    }()
    
}

// MARK: - Keys
extension Configuration {
    
    private enum Keys {
        enum Plist {
            static let rootURL = "ROOT_URL"
            static let iexURL = "IEX_URL"
            static let appName = "CFBundleName"
            static let buildVersion = "CFBundleVersion"
            static let logging = "LOGGING"
        }
    }
    
}
