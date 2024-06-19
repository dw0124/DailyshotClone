//
//  BannerImageCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/10/24.
//

import UIKit
import Foundation
import SnapKit

class BannerImageCell: UICollectionViewCell {
    
    static let identifier = "BannerImageCell"
    
    // 이미지를 표시할 imageView
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        // imageView를 contentView에 추가하고 제약 조건 설정
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
