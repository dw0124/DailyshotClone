//
//  CartHeaderView.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/5/24.
//

import UIKit
import Foundation

import SnapKit

import RxSwift

class CartHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "CartHeaderView"
    
    var disposeBag = DisposeBag()
    
    let selectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkmark.circle"), for: .normal)
        button.setImage(UIImage(named: "checkmark.circle.fill"), for: .selected)
        button.setTitleSize(title: "전체 선택", size: 16, weight: .regular)
        button.tintColor = .black
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 8
        let bottomContentInset = configuration.contentInsets.bottom
        let topContentInset = configuration.contentInsets.top
        configuration.contentInsets = NSDirectionalEdgeInsets(top: topContentInset, leading: .zero, bottom: bottomContentInset, trailing: .zero)
        
        configuration.background.backgroundColor = .clear
        
        button.configuration = configuration
        
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleSize(title: "선택삭제", size: 16, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectButton, UIView(), deleteButton])
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
}
