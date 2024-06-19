//
//  MenuCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/12/24.
//

import Foundation
import UIKit
import SnapKit

class MenuCell: UITableViewCell {

    static let identifier = "MenuCell"
    
    var menuImages: [UIImage]?
    
    var menuItems: [MenuButtonItem]?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let itemWidth = 60
        let itemHeight = 80
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.backgroundView?.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MenuButtonCell.self, forCellWithReuseIdentifier: MenuButtonCell.identifier)
        return collectionView
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
        
        imageView?.backgroundColor = .systemGray3
    }
    
    // setup UI + Layout
    private func setupCell() {
        
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        //collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    
    // configure
    func configure(_ menuImages: [UIImage]) {
        self.menuImages = menuImages
        
        collectionView.reloadData()
    }
    
    func configure(_ menuItems: [MenuButtonItem]) {
        self.menuItems = menuItems
        collectionView.reloadData()
    }

    
}

// MARK: - UICollectionViewDataSource
extension MenuCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuButtonCell.identifier, for: indexPath) as? MenuButtonCell else { return UICollectionViewCell() }
        
        if let item = menuItems?[indexPath.item] {   
            cell.configure(with: item)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching
extension MenuCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //print(indexPaths)
    }
}

extension MenuCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64.0, height: 80)
    }
}

//// MARK: - UICollectionViewDelegate
//extension MenuCell: UICollectionViewDelegate {
//    
//}
////
//////// MARK: - UIScrollViewDelegate / pageControl 관련
////extension MenuCell: UIScrollViewDelegate {
////    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        if scrollView == collectionView {
////            let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
////            
////            print(currentPage)
////            //pageControl.currentPage = currentPage
////        }
////    }
////    
////    @objc func pageControlValueChanged(_ sender: UIPageControl) {
////        let indexPath = IndexPath(item: sender.currentPage, section: 0)
////        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
////    }
////}
