//
//  HomeItemHeaderCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/19/24.
//

import Foundation
import UIKit
import SnapKit

import RxSwift

class HomeItemHeaderCell: UITableViewHeaderFooterView {
    static let identifier = "HomeItemHeaderCell"
    
    var disposeBag = DisposeBag()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "타이틀 타이틀"
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "서브 타이틀"
        return label
    }()
    
    let headerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.systemGray, for: .normal)
        button.setTitle("더보기", for: .normal)
        return button
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let emptyView = UIView()
        
        let stackView = UIStackView(arrangedSubviews: [titleStackView, emptyView, headerButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .top
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func setupViews() {
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with header: Header) {
        titleLabel.text = header.title
        subTitleLabel.text = header.subTitle
    }
}
