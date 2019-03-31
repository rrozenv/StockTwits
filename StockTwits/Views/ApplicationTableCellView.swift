
import UIKit
import Prelude
import Library

final class ApplicationTableCellView: UIView {
    
    // MARK: - Properties
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let actionButton = UIButton()
    let appPurchaseLabel = UILabel()
    let topRightSV = UIStackView()
    let bottomRightSV = UIStackView()
    
    // MARK: - Styles
    override func bindStyles() {
        super.bindStyles()
        _ = logoImageView |> roundedStyle()
        _ = titleLabel |> baseTitleThreeLabelStyle
        _ = descriptionLabel |> baseBodyLabelStyle
        _ = actionButton |> baseTextButtonStyle
        _ = appPurchaseLabel |> baseCaptionOneStyle
    }
    
    // MARK: - Initalization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupViewHeirarchy()
        setupLogoImageView()
        setupTopRightSV()
        setupBottomRightSV()
    }
    
}

// MARK: - View Setup
extension ApplicationTableCellView {
    
    private func setupViewHeirarchy() {
        addSubview(logoImageView)
        addSubview(topRightSV)
        addSubview(bottomRightSV)
    }
    
    private func setupLogoImageView() {
        logoImageView.anchorCenterYToSuperview()
        logoImageView.anchor(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            topConstant: 20,
            leftConstant: 20,
            bottomConstant: 20,
            widthConstant: 110,
            heightConstant: 110
        )
    }
    
    private func setupTopRightSV() {
        descriptionLabel.lineBreakMode = .byTruncatingTail
        topRightSV.distribution = .fillProportionally
        topRightSV.axis = .vertical
        topRightSV.spacing = 3
        topRightSV.addArrangedSubview(titleLabel)
        topRightSV.addArrangedSubview(descriptionLabel)
        
        topRightSV.anchor(
            logoImageView.topAnchor,
            left: logoImageView.rightAnchor,
            right: rightAnchor,
            leftConstant: 15,
            rightConstant: 20
        )
    }
    
    private func setupBottomRightSV() {
        actionButton.anchor(widthConstant: 70, heightConstant: 40)
        bottomRightSV.distribution = .fillProportionally
        bottomRightSV.axis = .horizontal
        bottomRightSV.spacing = 10
        bottomRightSV.addArrangedSubview(actionButton)
        bottomRightSV.addArrangedSubview(appPurchaseLabel)
        
        bottomRightSV.anchor(
            left: logoImageView.rightAnchor,
            bottom: logoImageView.bottomAnchor,
            right: rightAnchor,
            leftConstant: 15,
            rightConstant: 20
        )
    }
    
}

