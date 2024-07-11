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

extension NumberFormatter {
    static func setDecimal(_ num: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let price = num
        let result = numberFormatter.string(for: price)!
        
        return result
    }
}

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
    
    func setTitleSize(title: String, size: CGFloat) {
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)]
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

extension NSMutableAttributedString {
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

extension UINavigationController: UIGestureRecognizerDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension CALayer {
    func addBorder(_ arrEdge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arrEdge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
