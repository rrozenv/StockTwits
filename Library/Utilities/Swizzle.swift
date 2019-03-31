
import Foundation
import UIKit

private var hasSwizzled = false

/**
 Swizzles UIView `traitCollectionDidChange(_:)` method to inject 2 extra method calls:
 - bindViewModel()
 - bindStyles()
 */
private func swizzle(_ v: UIView.Type) {
    [
        (#selector(v.traitCollectionDidChange(_:)),
         #selector(v.swizzled_traitCollectionDidChange(_:)))
        ]
        .forEach { original, swizzled in
            
            let originalMethod = class_getInstanceMethod(v, original)
            let swizzledMethod = class_getInstanceMethod(v, swizzled)
            
            let didAddViewDidLoadMethod = class_addMethod(v,
                                                          original,
                                                          method_getImplementation(swizzledMethod!),
                                                          method_getTypeEncoding(swizzledMethod!))
            
            if didAddViewDidLoadMethod {
                class_replaceMethod(v,
                                    swizzled,
                                    method_getImplementation(originalMethod!),
                                    method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
    }
}

extension UIView {
    
    final public class func swizzleTraitCollectionDidChange() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        swizzle(self)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.bindViewModel()
    }
    
    @objc internal func swizzled_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection) {
        self.swizzled_traitCollectionDidChange(previousTraitCollection)
        self.bindViewModel()
        self.bindStyles()
    }
    
    /// Should override for style binding.
    @objc open func bindStyles() { }
    
    /// Should override for binding view model.
    @objc open func bindViewModel() { }
    
}
