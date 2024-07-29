//
//  FilterListView.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/17/24.
//

import Foundation
import UIKit

import SnapKit

import RxSwift

class FilterListCell: UICollectionViewCell {
    
    static let identifier = "FilterListCell"
    
    var type: FilterListType?
    
    override var isSelected: Bool {
       didSet{
           if self.isSelected {
               titleLabel.layer.borderColor = UIColor.orange.cgColor
               titleLabel.textColor = .orange
           }
           else {
               titleLabel.layer.borderColor = UIColor.systemGray5.cgColor
               titleLabel.textColor = .black
           }
       }
   }
    
    private let titleLabel: PaddingLabel = {
        let label = PaddingLabel(top: 4, bottom: 4, left: 8, right: 8)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray5.cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(type: FilterListType, with filterOption: String) {
        self.type = type
        titleLabel.text = filterOption
    }
}
