//
//  MenuCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/12/24.
//

import Foundation
import UIKit
import SnapKit

import RxSwift
import RxRelay

class MenuCell: UITableViewCell {

    static let identifier = "MenuCell"
    
    var disposeBag = DisposeBag()
    
    var menuImages: [UIImage]?
    
    //var menuItems: [MenuButtonItem]?
    
    var menuItems: BehaviorRelay<[MenuButtonItem]> = BehaviorRelay<[MenuButtonItem]>(value: [])
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        let itemWidth = 60
        let itemHeight = 80
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.backgroundView?.backgroundColor = .white
        //collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MenuButtonCell.self, forCellWithReuseIdentifier: MenuButtonCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        binding()
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
        
        imageView?.backgroundColor = .systemGray3
        
        disposeBag = DisposeBag()
        
        binding()
    }
    
    // setup UI + Layout
    private func setupCell() {
        
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    func binding() {
        menuItems
            .bind(to: collectionView.rx.items(cellIdentifier: MenuButtonCell.identifier, cellType: MenuButtonCell.self)) { (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
    
    // configure
    func configure(_ menuImages: [UIImage]) {
        self.menuImages = menuImages
        
        collectionView.reloadData()
    }
    
    func configure(_ menuItems: [MenuButtonItem]) {
        self.menuItems.accept(menuItems)
        collectionView.reloadData()
    }
}

extension MenuCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64.0, height: 80)
    }
}
