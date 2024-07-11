//
//  ItemListHeaderCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/24/24.
//

import Foundation
import UIKit

class ItemListHeaderCell: UICollectionReusableView {
    static let identifier = "ItemListHeaderCell"
    
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
        label.tintColor = .red
        label.text = "서브 타이틀"
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupViews() {
        self.addSubview(titleStackView)
        
        titleStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.top.equalToSuperview().inset(4)
            $0.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }
    
    func configure(with header: Header) {
        titleLabel.text = header.title
        subTitleLabel.text = header.subTitle
    }
}
