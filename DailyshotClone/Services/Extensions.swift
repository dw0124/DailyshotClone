//
//  extensions.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/26/24.
//

import Foundation
import UIKit


func calculateDiscountedPrice(price: Double, discountRate: Double) -> Int {
    let discountFactor = 1 - (discountRate / 100)
    let discountedPrice = price * discountFactor
    return Int(discountedPrice)
}

// MARK: - NumberFormatter
extension NumberFormatter {
    static func setDecimal(_ num: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let price = num
        let result = numberFormatter.string(for: price)!
        
        return result
    }
}

// MARK: - UIButton
extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
    
    func centerVertically(padding: CGFloat = 4.0) {
        var config = self.configuration ?? UIButton.Configuration.plain()
        
        config.imagePadding = padding
        config.titlePadding = padding
        config.imagePlacement = .top
        
        self.configuration = config
    }
    
    func addPadding(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        var config = self.configuration ?? UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        self.configuration = config
    }
    
    func setTitleSize(title: String, size: CGFloat, weight: UIFont.Weight = .regular) {
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: weight)]
        let attributedTitle = NSAttributedString(string: title, attributes: attribute)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        setBackgroundImage(backgroundImage, for: state)
    }
}

// MARK: - NSMutableAttributedString
extension NSMutableAttributedString {
    func coloredText(_ value:String, fontSize: CGFloat, weight: UIFont.Weight, textColor: UIColor) -> NSMutableAttributedString {
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: textColor
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func priceText(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: UIColor.black,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func discountText(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: UIColor.systemGray,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func beforeDiscountText(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: .light)
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: UIColor.systemGray,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

// MARK: - UINavigationController
extension UINavigationController: UIGestureRecognizerDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

// MARK: - CALayer
extension CALayer {
    func addBorder(_ edges: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: width)
            case .bottom:
                border.frame = CGRect(x: 0, y: frame.height - width, width: frame.width, height: width)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            case .right:
                border.frame = CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
            default:
                continue
            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}

// MARK: - UILabel + Padding
class PaddingLabel: UILabel {

    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat

    required init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}

extension UILabel {
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}

// MARK: - UIView
extension UIView {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
       let mask = CAShapeLayer()
       mask.path = path.cgPath
       layer.mask = mask
   }
}

// MARK: - CollectionView + LeftAlignedCollectionViewFlowLayout(셀 왼쪽 정렬)
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
