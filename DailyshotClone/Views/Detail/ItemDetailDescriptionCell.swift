//
//  ItemDetailDescriptionCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/3/24.
//

import Foundation
import UIKit
import SnapKit

class ItemDetailDescriptionCell: UITableViewCell {

    static let identifier = "ItemDetailDescriptionCell"
    
    let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        return imageView
    }()
    
    let firstSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "소제목1"
        return label
    }()
    
    let firstDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "내용1"
        label.setLineSpacing(spacing: 8)
        return label
    }()    
    
    let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    let secondSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "소제목2"
        return label
    }()
    
    let secondDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "내용2"
        return label
    }()
    
    private lazy var firstLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstSubTitleLabel, firstDescriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstImageView, firstLabelStackView])
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
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
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // setup UI + Layout
    private func setupCell() {
        contentView.addSubview(stackView)
        
        firstLabelStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        firstLabelStackView.isLayoutMarginsRelativeArrangement = true
        
        firstImageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        secondImageView.snp.makeConstraints {
            $0.height.equalTo(250)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(_ item: DailyshotItem) {
        firstDescriptionLabel.text = item.productDescription
    }
}

