//
//  ItemDetailImageCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/26/24.
//
import Foundation
import UIKit
import SnapKit
import Cosmos

import RxSwift

class ItemDetailImageCell: UITableViewCell {

    static let identifier = "ItemDetailImageCell"
    
    var disposeBag = DisposeBag()
    
    var menuImages: UIImage?
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.text = "상품이름"
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "0"
        return label
    }()
    
    let ratingStarView: CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.fillMode = .half
        cosmosView.settings.filledColor = UIColor.systemYellow
        cosmosView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return cosmosView
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = ""
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()    
    
    let separatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "/"
        return label
    }()
    
    let reviewCountButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.titleLabel?.textAlignment = .left
//        button.setTitleColor(.black, for: .normal)
//        button.setTitle("0개의 리뷰", for: .normal)
//        button.setUnderline()
        return button
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingStarView, ratingLabel, separatorLabel, reviewCountButton, UIView()])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel, ratingStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemImageView, labelStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.backgroundColor = .systemGray3
        
        disposeBag = DisposeBag()
    }
    
    // setup UI + Layout
    private func setupCell() {
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero)
        )
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        labelStackView.isLayoutMarginsRelativeArrangement = true
        
        itemImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(250).priority(.required)
        }
        
    }
    
    
    // configure
    func configure(_ item: DailyshotItem) {
        nameLabel.text = item.name
        
        if let rating = item.rating {
            ratingStarView.rating = rating
            ratingLabel.text = "\(rating)"
        } else {
            ratingStackView.isHidden = true
        }
        
        if let reviewCount = item.reviewCount {
            let title = "\(reviewCount)개의 리뷰"
            reviewCountButton.setTitle(title, for: .normal)
            reviewCountButton.setUnderline()
        } else {
            separatorLabel.isHidden = true
            reviewCountButton.isHidden = true
        }
        
        if let discountRate = item.discountRate {
            priceLabel.attributedText = NSMutableAttributedString()
                .priceText(NumberFormatter.setDecimal(item.finalPrice) + "원", fontSize: 20)
                .discountText("  \(discountRate)%  ", fontSize: 16)
                .beforeDiscountText("\(NumberFormatter.setDecimal(item.price))", fontSize: 16)
        } else {
            priceLabel.text = NumberFormatter.setDecimal(item.finalPrice) + "원"
        }
        
        let imageURLStr = item.productImageURL
        ImageCacheManager.shared.loadImageFromStorage(storagePath: imageURLStr)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.itemImageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
