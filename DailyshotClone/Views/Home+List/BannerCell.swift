//
//  BannerCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/7/24.
//

import Foundation
import UIKit
import SnapKit

class BannerCell: UITableViewCell {

    static let identifier = "BannerCell"
    
    var bannerImages: [UIImage]?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let itemWidth = UIScreen.main.bounds.width
        let itemHeight: CGFloat = itemWidth
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.backgroundView?.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true // 페이징 활성화
        collectionView.register(BannerImageCell.self, forCellWithReuseIdentifier: BannerImageCell.identifier)
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
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
//        collectionView.snp.makeConstraints {
//            $0.width.equalToSuperview().priority(.high)
//            $0.height.equalTo(collectionView.snp.width)
//            $0.centerX.equalToSuperview()
//        }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    // configure
    func configure(_ bannerImages: [UIImage]) {
        self.bannerImages = bannerImages
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension BannerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerImageCell.identifier, for: indexPath) as? BannerImageCell else { return UICollectionViewCell() }
        
        let image = bannerImages?[indexPath.item]
        
        cell.configure(with: image)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching
extension BannerCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //print(indexPaths)
    }
}

// MARK: - UICollectionViewDelegate
extension BannerCell: UICollectionViewDelegate {
    
}

//// MARK: - UIScrollViewDelegate / pageControl 관련
extension BannerCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            
            print(currentPage)
            //pageControl.currentPage = currentPage
        }
    }
    
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
