//
//  FilterListHeaderCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/17/24.
//

import Foundation
import UIKit

import SnapKit

class FilterListHeaderCell: UICollectionReusableView {
    static let identifier = "FilterListHeaderCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.text = ""
        return label
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
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
