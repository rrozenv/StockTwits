
import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIDevice {
    
    static var keyboard: Observable<(height: CGFloat, curve: UIView.AnimationCurve)> {
        return Observable.of(
            UIDevice.keyboardWillShowHeight,
            UIDevice.keyboardWillHideHeight
            )
            .merge()
            .distinctUntilChanged({ lhs, rhs in
                return lhs.height == rhs.height
            })
    }
    
    static var keyboardWillShowHeight: Observable<(height: CGFloat, curve: UIView.AnimationCurve)> {
        return NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .map { info in
                let keyboard = Keyboard(info.userInfo!)
                return (keyboard.endFrame.height, keyboard.animationCurve)
        }
    }
    
    static var keyboardWillHideHeight: Observable<(height: CGFloat, curve: UIView.AnimationCurve)> {
        return NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .map { info in
                let keyboard = Keyboard(info.userInfo!)
                return (0.0, keyboard.animationCurve)
        }
    }
    
}

