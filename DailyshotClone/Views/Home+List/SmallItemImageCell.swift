//
//  SmallItemImageCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/13/24.
//

import UIKit
import Foundation
import SnapKit

import RxSwift

class SmallItemImageCell: UICollectionViewCell {
    
    static let identifier = "SmallItemImageCell"
    
    var disposeBag = DisposeBag()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.text = "상품이름"
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "0"
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = ""
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    let emptyView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, priceLabel, ratingLabel, emptyView])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        
        disposeBag = DisposeBag()
    }
    
    private func setupImageView() {
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.2).priority(.required)
        }
    }
    
    
    func configure(with item: DailyshotItem) {
        self.nameLabel.text = item.name
        
        if let discount = item.discountRate {
            if discount > 0 {
                let discountText = "\(discount)% "
                
                priceLabel.attributedText = NSMutableAttributedString()
                    .coloredText(discountText, fontSize: 17, weight: .semibold, textColor: .orange)
                    .priceText(NumberFormatter.setDecimal(item.finalPrice), fontSize: 17)
            }
        } else {
            self.priceLabel.text = NumberFormatter.setDecimal(item.price)
        }
        
        if let rating = item.rating, rating > 0 {
            self.ratingLabel.text = "\(rating)"
            self.ratingLabel.isHidden = false
        } else {
            self.ratingLabel.isHidden = true
        }
        
        let imageURLStr = item.thumbnailImageURL
        ImageCacheManager.shared.loadImageFromStorage(storagePath: imageURLStr)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
