//
//  CollectionViewSeparatorFooterView.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/17/24.
//

import Foundation
import UIKit

import SnapKit

class C_SeparatorFooterView: UICollectionReusableView {
    static let identifier = "C_SeparatorFooterView"
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
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
        addSubview(separatorLineView)
        
        separatorLineView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setLineColor(color: UIColor) {
        separatorLineView.backgroundColor = color
    }
}
