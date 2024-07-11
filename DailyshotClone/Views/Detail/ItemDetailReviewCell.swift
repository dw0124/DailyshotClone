//
//  ItemDetailTitleCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/26/24.
//

import Foundation
import UIKit
import SnapKit

class ItemDetailReviewCell: UITableViewCell {

    static let identifier = "ItemDetailReviewCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.text = "리뷰"
        return label
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
        
        backgroundColor = #colorLiteral(red: 0.9239165187, green: 0.9213962555, blue: 0.9468390346, alpha: 1)
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // setup UI + Layout
    private func setupCell() {
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
