
import Foundation
import UIKit

struct Keyboard {
    var beginFrame: CGRect
    let endFrame: CGRect
    let animationCurve: UIView.AnimationCurve
    let animationDuration: TimeInterval
    let isLocal: Bool
    
    init(_ userInfo: [AnyHashable: Any]) {
        self.beginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        self.endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let animationCurveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UIView.AnimationCurve.RawValue
        self.animationCurve = UIView.AnimationCurve(rawValue: animationCurveRaw)!
        self.animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        self.isLocal = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as! Bool
    }
}
