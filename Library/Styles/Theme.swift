
import Foundation
import UIKit

public enum Theme: Int {
    case theme1
    
    // MARK: - Keys
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    /// Returns current theme.
    public static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .theme1
    }
    
    /// Saves them to defaults.
    public func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
    }
    
}

// MARK: - Background Colors
extension Theme {

    public var primaryColor: UIColor {
        switch self {
        case .theme1: return .white
        }
    }
    
    public var secondaryColor: UIColor {
        switch self {
        case .theme1: return Palette.aqua.color
        }
    }
    
    public var tertiaryColor: UIColor {
        switch self {
        case .theme1: return Palette.purple.color
        }
    }
    
    public var quaternaryColor: UIColor {
        switch self {
        case .theme1: return Palette.red.color
        }
    }
    
    public var inactiveColor: UIColor {
        switch self {
        case .theme1: return Palette.mediumGray.color
        }
    }
    
    public var dividerColor: UIColor {
        switch self {
        case .theme1: return Palette.lightGray.color
        }
    }
    
}

// MARK: - Text Colors
extension Theme {

    public var primaryTextColor: UIColor {
        switch self {
        case .theme1: return .black
        }
    }
    
    public var secondaryTextColor: UIColor {
        switch self {
        case .theme1: return Palette.darkGray.color
        }
    }
    
}

// MARK: - Palette
public enum Palette {
    case aqua, purple, red, darkGray, mediumGray, lightGray
    
    public var color: UIColor {
        switch self {
        case .aqua: return UIColor(hex: 0x14D2B8)
        case .purple: return UIColor(hex: 0x5856D6)
        case .red: return UIColor(hex: 0xEF6A68)
        case .darkGray: return UIColor(hex: 0x939393)
        case .mediumGray: return UIColor(hex: 0x838383)
        case .lightGray: return UIColor(hex: 0xF4F4F4)
        }
    }
}

extension UIColor {
    
    public convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    public class func forGradient(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
}
