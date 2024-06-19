//
//  SmallItemCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/13/24.
//

import UIKit
import Foundation
import SnapKit

import RxSwift
import RxRelay

class SmallItemCell: UITableViewCell {
    
    static let identifier = "SmallItemCell"
    
    var disposeBag = DisposeBag()
    
    var items: PublishRelay<[DailyshotItem]> = PublishRelay<[DailyshotItem]>()
    
    var bannerImages: [UIImage]?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let itemW = UIScreen.main.bounds.width / 2.5 - (10 * 2)
        let itemH = itemW * 2.2
        layout.itemSize = CGSize(width: itemW, height: itemH)
        
//        let itemWidth: CGFloat = 140
//        let itemHeight: CGFloat = 300
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.backgroundView?.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SmallItemImageCell.self, forCellWithReuseIdentifier: SmallItemImageCell.identifier)
        return collectionView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionView])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
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
    }
    
    // setup UI + Layout
    private func setupCell() {
        
        selectionStyle = .none
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
//        contentView.addSubview(collectionView)
//        
//        collectionView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(16)
//        }
    }
    
    
    // configure
    func configure(_ bannerImages: [UIImage]) {
        self.bannerImages = bannerImages
        
        collectionView.reloadData()
    }
    
    func configure(_ items: [DailyshotItem]) {
        print(#function, items.count)
        self.items.accept(items)
    }
    
    func binding() {
        items
            .bind(to: collectionView.rx.items(cellIdentifier: SmallItemImageCell.identifier, cellType: SmallItemImageCell.self)) { (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
}
