//
//  CategoryCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/12/24.
//

import Foundation
import SnapKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"

    let label: UILabel = {
        let label = UILabel()
        label.text = "없음"
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .lightGray
        return label
    }()
    
    // 초기화 및 레이아웃 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with text: String?) {
        label.text = text
    }
    
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = CategoryCell()
        cell.configure(with: name)

        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        let width = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required).width
        return .init(width: width, height: availableHeight)
    }
}
