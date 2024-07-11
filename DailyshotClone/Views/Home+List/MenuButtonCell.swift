//
//  MenuButtonCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/12/24.
//

import UIKit
import Foundation
import SnapKit

class MenuButtonCell: UICollectionViewCell {
    
    static let identifier = "MenuButtonCell"
 
    // 이미지를 표시할 imageView
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel])
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
    
    private func setupImageView() {
        
          contentView.addSubview(stackView)
          
          stackView.snp.makeConstraints {
              $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
          }
          
          imageView.snp.makeConstraints {
              $0.width.equalTo(imageView.snp.height)
          }
    }
    
    
    func configure(with item: MenuButtonItem) {
        imageView.image = item.buttonImage
        nameLabel.text = item.name
    }
}
