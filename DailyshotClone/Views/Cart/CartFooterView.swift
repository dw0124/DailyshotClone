//
//  CartFooterView.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/5/24.
//

import UIKit

import RxSwift

class CartFooterView: UITableViewHeaderFooterView {

    static let identifier = "CartFooterView"
    
    var disposeBag = DisposeBag()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "총 결제 금액"
        return label
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "??,???원"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, UIView(), totalPriceLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        //stackView.spacing = 10
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func setup() {
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(price: Int) {
        totalPriceLabel.text = "\(NumberFormatter.setDecimal(price))원"
    }
}
