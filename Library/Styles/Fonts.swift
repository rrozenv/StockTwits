
import Foundation
import UIKit

extension UIFont {
    
    /// 34pt font
    public static func headline(size: CGFloat? = 34) -> UIFont {
        return .preferredFont(style: .headline, size: size)
    }
    
    /// 20pt font
    public static func subhead(size: CGFloat? = 20) -> UIFont {
        return .preferredFont(style: .subheadline, size: size)
    }
    
    /// 28pt regular
    public static func title1(size: CGFloat? = 28) -> UIFont {
        return .preferredFont(style: .title1, size: size)
    }
    
    /// 24pt font
    public static func title2(size: CGFloat? = 24) -> UIFont {
        return .preferredFont(style: .title2, size: size)
    }
    
    /// 20pt font
    public static func title3(size: CGFloat? = 20) -> UIFont {
        return .preferredFont(style: .title3, size: size)
    }
    
    /// 14pt regular
    public static func body(size: CGFloat? = 14) -> UIFont {
        return .preferredFont(style: .body, size: size)
    }
    
    /// 12pt regular
    public static func caption1(size: CGFloat? = 12) -> UIFont {
        return .preferredFont(style: .caption1, size: size)
    }
    
    /// 16pt regular
    public static func callout(size: CGFloat? = 16) -> UIFont {
        return .preferredFont(style: .callout, size: size)
    }
    
    /// 13pt font
    public static func caption2(size: CGFloat? = nil) -> UIFont {
        return .preferredFont(style: .caption2, size: size)
    }
    
    /// 12pt font
    public static func footnote(size: CGFloat? = nil) -> UIFont {
        return .preferredFont(style: .footnote, size: size)
    }
    
    /// Returns a bolded version of `self`.
    public var bolded: UIFont {
        return self.fontDescriptor.withSymbolicTraits(.traitBold)
            .map { UIFont(descriptor: $0, size: 0.0) } ?? self
    }
    
    /// Returns a italicized version of `self`.
    public var italicized: UIFont {
        return self.fontDescriptor.withSymbolicTraits(.traitItalic)
            .map { UIFont(descriptor: $0, size: 0.0) } ?? self
    }
    
    private static func preferredFont(style: UIFont.TextStyle, size: CGFloat? = nil) -> UIFont {
        
        let defaultSize: CGFloat
        let fontType: FontType
        
        switch style {
        case UIFont.TextStyle.body:
            defaultSize = 14
            fontType = .avenir_medium
        case UIFont.TextStyle.title1:
            defaultSize = 28
            fontType = .avenir_medium
        case UIFont.TextStyle.title2:
            defaultSize = 24
            fontType = .avenir_medium
        case UIFont.TextStyle.headline:
            defaultSize = 34
            fontType = .avenir_medium
        case UIFont.TextStyle.subheadline:
            defaultSize = 20
            fontType = .avenir_medium
        case UIFont.TextStyle.caption1:
            defaultSize = 12
            fontType = .avenir_medium
        case UIFont.TextStyle.caption2:
            defaultSize = 13
            fontType = .avenir_medium
        case UIFont.TextStyle.callout:
            defaultSize = 16
            fontType = .avenir_medium
        case UIFont.TextStyle.title3:
            defaultSize = 20
            fontType = .avenir_medium
        case UIFont.TextStyle.footnote:
            defaultSize = 13
            fontType = .avenir_medium
        default:
            defaultSize = 17
            fontType = .avenir_medium
        }
        
        return UIFontMetrics.default
            .scaledFont(for: UIFont(name: fontType.rawValue, size: size ?? defaultSize)!)
    }
    
    public enum FontType: String {
        case avenir_medium = "Avenir-Medium"
        case avenir_heavy = "Avenir-Heavy"
        case avenir_black = "Avenir-Black"
    }

}

