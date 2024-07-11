//
//  ItemDetailInformationCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/8/24.
//

import UIKit
import Foundation

class ItemDetailInformationCell: UITableViewCell {
    
    static let identifier = "ItemDetailInformationCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Information"
        return label
    }()
    
    let type: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "종류"
        return label
    }()
    
    let volume: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "용량"
        return label
    }()
    
    let abv: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "도수"
        return label
    }()
    
    let country: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "국가"
        return label
    }()
    
    let packaging: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "케이스"
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "종류"
        return label
    }()
    
    let volumeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "용량"
        return label
    }()
    
    let abvLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "도수"
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "국가"
        return label
    }()
    
    let packagingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "케이스"
        return label
    }()
    
    private lazy var typeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [type, typeLabel])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var volumeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [volume, volumeLabel])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var abvStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [abv, abvLabel])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var countryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [country, countryLabel])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var packagingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [packaging, packagingLabel])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, typeStackView, volumeStackView, abvStackView, countryStackView, packagingStackView])
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
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
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // setup UI + Layout
    private func setupCell() {
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        type.snp.makeConstraints {
            $0.width.equalTo(64)
        }
        volume.snp.makeConstraints {
            $0.width.equalTo(type)
        }
        abv.snp.makeConstraints {
            $0.width.equalTo(type)
        }
        country.snp.makeConstraints {
            $0.width.equalTo(type)
        }
        packaging.snp.makeConstraints {
            $0.width.equalTo(type)
        }
        
    }
    
    func configure(_ inform: Information) {
        typeLabel.text = inform.type
        volumeLabel.text = "\(inform.volume)ml"
        abvLabel.text = "\(inform.alcoholByVolume)%"
        countryLabel.text = inform.countryOfOrigin
        packagingLabel.text = inform.packaging
    }
}
