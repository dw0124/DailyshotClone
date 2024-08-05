//
//  CartCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/1/24.
//

import UIKit
import Foundation
import SnapKit

import RxSwift
import RxRelay

class CartCell: UITableViewCell {
    
    static let identifier = "CartCell"
    
    var disposeBag = DisposeBag()
    
    var store: Store?
    var item: DailyshotItem?
    var itemCount = PublishRelay<Int>()
    
    let selectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkmark.circle"), for: .normal)
        button.setImage(UIImage(named: "checkmark.circle.fill"), for: .selected)
        button.tintColor = .orange
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "스토어"
        return label
    }()
    
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "상품이름"
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .thin)
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
    
    
    let stepper: CustomStepper = {
        let stepper = CustomStepper()
        stepper.layer.cornerRadius = 10
        stepper.layer.borderWidth = 1
        stepper.layer.borderColor = UIColor.systemGray5.cgColor
        return stepper
    }()

    lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, totalPriceLabel, UIView(), stepper])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var imagePriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemImageView, priceStackView, UIView()])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var itemStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storeNameLabel, itemNameLabel, imagePriceStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var totalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectButton, itemStackView, UIView(), deleteButton])
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
        totalStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        totalStackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(totalStackView)
        
        totalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        }
        
        itemImageView.snp.makeConstraints {
            $0.width.height.equalTo(90).priority(.required)
        }
        
        priceStackView.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        stepper.snp.makeConstraints {
            $0.width.equalTo(130).priority(.required)
            $0.height.equalTo(44).priority(.required)
        }
    }
    
    func configure(isSelected: Bool, store: Store, item: DailyshotItem, itemCount: Int) {
        self.store = store
        self.item = item
        self.itemCount.accept(itemCount)
        
        self.storeNameLabel.text = store.name
        self.itemNameLabel.text = item.name
        
        selectButton.isSelected = isSelected
        
        // 이미지
        let imageURLStr = item.thumbnailImageURL
        ImageCacheManager.shared.loadImageFromStorage(storagePath: imageURLStr)
            .asDriver(onErrorJustReturn: nil)
            .drive(itemImageView.rx.image)
            .disposed(by: disposeBag)
        
        
        // 스텝퍼 값 변경 시 수량과 총 금액 업데이트
        stepper.value.accept(itemCount)

        stepper.value
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] newValue in
                
                let newCount = Int(newValue)
                self?.itemCount.accept(newCount)
                self?.setPriceLabels(for: item, itemCount: newCount)
            })
            .disposed(by: disposeBag)
    }
    
    // itemCount에 따라서 총 금액 계산해서 label에 입력
    private func setPriceLabels(for item: DailyshotItem, itemCount: Int) {
        let totalPrice = item.finalPrice * itemCount
        if let discount = item.discountRate, discount > 0 {
            priceLabel.isHidden = false
            let discountText = "\(discount)% "
            priceLabel.attributedText = NSMutableAttributedString()
                .beforeDiscountText("\(NumberFormatter.setDecimal(item.price))", fontSize: 14)
            totalPriceLabel.attributedText = NSMutableAttributedString()
                .coloredText(discountText, fontSize: 17, weight: .semibold, textColor: .orange)
                .priceText(NumberFormatter.setDecimal(totalPrice), fontSize: 17)
        } else {
            priceLabel.isHidden = true
            totalPriceLabel.text = NumberFormatter.setDecimal(totalPrice)
        }
    }
}
