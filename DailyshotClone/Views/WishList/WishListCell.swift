//
//  WishListCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/6/24.
//

import UIKit
import Foundation
import SnapKit

import RxSwift
import RxRelay

class WishListCell: UITableViewCell {
    
    static let identifier = "WishListCell"
    
    var disposeBag = DisposeBag()
    
    var item: DailyshotItem?
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "상품이름"
        return label
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "0"
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = ""
        label.textColor = .darkGray
        return label
    }()
    
    let purchaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    let emptyView = UIView()

    lazy var itemStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemNameLabel, totalPriceLabel, ratingLabel, UIView(), purchaseButton])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var totalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemImageView, itemStackView, deleteButton])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 10
        stackView.backgroundColor = .white
        return stackView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .lightGray
        
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.image = nil
        
        disposeBag = DisposeBag()
    }
    
    // setup UI + Layout
    private func setupCell() {
        totalStackView.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        totalStackView.isLayoutMarginsRelativeArrangement = true
        
        totalStackView.setCustomSpacing(15, after: itemStackView)
        
        contentView.addSubview(totalStackView)
        
        totalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        itemImageView.snp.makeConstraints {
            $0.width.equalTo(120).priority(.required)
            $0.height.equalTo(140).priority(.required)
        }
        
        itemStackView.snp.makeConstraints {
            $0.height.equalTo(itemImageView.snp.height)
        }
        
        deleteButton.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    func configure(item: DailyshotItem) {
        
        itemNameLabel.text = item.name
        
        // 가격 표시
        if let discount = item.discountRate, discount > 0 {
            let discountText = "\(discount)% "
            totalPriceLabel.attributedText = NSMutableAttributedString()
                .coloredText(discountText, fontSize: 17, weight: .semibold, textColor: .orange)
                .priceText(NumberFormatter.setDecimal(item.finalPrice), fontSize: 17)
        } else {
            totalPriceLabel.text = NumberFormatter.setDecimal(item.finalPrice)
        }
        
        if let rating = item.rating, rating > 0 {
            ratingLabel.isHidden = false
            let attributedString = NSMutableAttributedString(string: "")
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow)
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            attributedString.append(NSAttributedString(string: "\(rating) (\(item.reviewCount ?? 0))"))
            ratingLabel.attributedText = attributedString
        } else {
            ratingLabel.isHidden = true
        }
        
        // 이미지
        let imageURLStr = item.thumbnailImageURL
        ImageCacheManager.shared.loadImageFromStorage(storagePath: imageURLStr)
            .asDriver(onErrorJustReturn: nil)
            .drive(itemImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
