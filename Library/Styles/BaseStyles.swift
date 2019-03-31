
import Foundation
import Prelude

// MARK: - ** Labels **/
public let baseTitleOneLabelStyle =
    UILabel.lens.textColor .~ Theme.current.primaryTextColor
        <> UILabel.lens.font .~ .title1()
        <> UILabel.lens.numberOfLines .~ 0

public let baseTitleTwoLabelStyle =
    UILabel.lens.textColor .~ Theme.current.primaryTextColor
        <> UILabel.lens.font .~ .title2()
        <> UILabel.lens.numberOfLines .~ 0

public let baseTitleThreeLabelStyle =
    UILabel.lens.textColor .~ Theme.current.primaryTextColor
        <> UILabel.lens.font .~ .title3()
        <> UILabel.lens.numberOfLines .~ 0

public let baseBodyLabelStyle =
    UILabel.lens.textColor .~ Theme.current.secondaryTextColor
        <> UILabel.lens.font .~ .body()
        <> UILabel.lens.numberOfLines .~ 1

public let baseCaptionOneStyle =
    UILabel.lens.textColor .~ Theme.current.secondaryTextColor
        <> UILabel.lens.font .~ .caption1()
        <> UILabel.lens.numberOfLines .~ 0


// MARK: - ** Buttons **/
public let baseTextButtonStyle =
    roundedStyle(cornerRadius: 5)
        <> UIButton.lens.titleLabel.font .~ UIFont.callout()
        <> UIButton.lens.adjustsImageWhenHighlighted .~ false
        <> UIButton.lens.titleColor(for: .normal) .~ .blue
        <> UIButton.lens.backgroundImage(for: .normal) .~ Theme.current.dividerColor.image()
        <> roundedStyle()


// MARK: - ** Controllers **/
public let baseControllerStyle = UIViewController.lens.view.backgroundColor .~ .white
 <> (UIViewController.lens.navigationController..navBarLens) %~ { $0.map(baseNavigationBarStyle) }

private let baseNavigationBarStyle =
    UINavigationBar.lens.titleTextAttributes .~ [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont.title2()
        ]
        <> UINavigationBar.lens.largeTitleTextAttributes .~ [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.headline()
        ]
        <> UINavigationBar.lens.isTranslucent .~ false
        <> UINavigationBar.lens.barTintColor .~ .white
        <> UINavigationBar.lens.backgroundImage(for: .default) .~ UIImage()
        <> UINavigationBar.lens.shadowImage .~ UIImage()

private let navBarLens: Lens<UINavigationController?, UINavigationBar?> = Lens(
    view: { $0?.navigationBar },
    set: { _, whole in whole }
)


// MARK: - ** Tab bar items **/
public let baseTabBarItemStyle = UITabBarItem.lens.title .~ nil
    <> UITabBarItem.lens.titlePositionAdjustment .~ UIOffset(horizontal: 0, vertical: 9_999_999)
    <> UITabBarItem.lens.imageInsets %~ { _ -> UIEdgeInsets in
        UIScreen.main.traitCollection.isRegularRegular ?
            UIEdgeInsets(top: 0.0, left: -8, bottom: 0.0, right: 8) :
            UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
    }

public let tabBarItemOneStyle = baseTabBarItemStyle
    <> UITabBarItem.lens.image .~ UIImage()
    <> UITabBarItem.lens.selectedImage .~ UIImage()

public let baseTabBarStyle = UITabBar.lens.tintColor .~ .black


// MARK: - ** Generic **/
public func roundedStyle <V: UIViewProtocol> (cornerRadius r: CGFloat = 10.0) -> ((V) -> V) {
    return V.lens.clipsToBounds .~ true
        <> V.lens.layer.masksToBounds .~ true
        <> V.lens.layer.cornerRadius .~ r
}

public func dropShadowStyle <V: UIViewProtocol>(radius: CGFloat = 10.0,
                                                offset: CGSize = .init(width: 0, height: 0)) -> ((V) -> V) {
    return
        V.lens.layer.shadowColor .~ UIColor.lightGray.cgColor
            <> V.lens.layer.shadowOpacity .~ 0.2
            <> V.lens.layer.shadowRadius .~ radius
            <> V.lens.layer.masksToBounds .~ false
            // <> V.lens.layer.shouldRasterize .~ true // Affects labels if added as subviews
            <> V.lens.layer.shadowOffset .~ offset
}
