
import UIKit

extension UIView {
    
    @discardableResult
    public func bounce() -> Self {
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.4),
                       initialSpringVelocity: CGFloat(1.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
        }, completion: nil)
        
        return self
    }
    
    @discardableResult
    public func generateFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> Self {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
        return self
    }
    
    public func dropShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 6.0
    }
    
}

extension UIView {
    
    @discardableResult
    public func xibSetup<T: UIView>() -> T? {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        guard let contentView = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? T else {
            fatalError("Could not load nib of type: \(T.self)")
        }
        addSubview(contentView)
        contentView.fillSuperview()
        return contentView
    }
    
}

extension UIView {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    /// Adds a shadow with given corner radius and background color to a view.
    /// Should be called from inside `layoutSubviews()`
    @discardableResult
    public func setShadow(cornerRadius: CGFloat = 10.0,
                          backgroundColor: UIColor = .white) -> UIView {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = backgroundColor.cgColor
        shadowLayer.shadowColor = UIColor.lightGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        layer.insertSublayer(shadowLayer, at: 0)
        return self
    }
    
}
