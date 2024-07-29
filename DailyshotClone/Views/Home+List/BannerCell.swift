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
    
    
    lazy var bannerIndexButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.layer.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
        button.tintColor = .white
        button.addPadding(top: 4, leading: 6, bottom: 4, trailing: 6)
        return button
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
        
        
        collectionView.setContentOffset(
            .init(x: UIScreen.main.bounds.width, y: collectionView.contentOffset.y), animated: false)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.backgroundColor = .systemGray3
    }
    
    // setup UI + Layout
    private func setupCell() {
        
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        contentView.addSubview(bannerIndexButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bannerIndexButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(collectionView).inset(10)
        }
    }
    
    
    // configure
    func configure(_ bannerImages: [UIImage]) {
        var images: [UIImage] = []
        images = bannerImages
        
        images.insert(images[images.count - 1], at: 0)
        images.append(images[1])
        
        self.bannerImages = images
            
        bannerIndexButton.setTitle("1 / \(images.count - 2) | 전체보기", for: .normal)
        
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

// MARK: - UIScrollViewDelegate / pageControl 관련
extension BannerCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let count = bannerImages!.count
        
        if scrollView.contentOffset.x == 0 {
            scrollView.setContentOffset(.init(x: UIScreen.main.bounds.width * Double(count-2), y: scrollView.contentOffset.y), animated: false)
        }
        if scrollView.contentOffset.x == Double(count-1) * UIScreen.main.bounds.width {
            scrollView.setContentOffset(.init(x: UIScreen.main.bounds.width, y: scrollView.contentOffset.y), animated: false)
        }
        
        let index = scrollView.contentOffset.x / UIScreen.main.bounds.width
        print(index)
        
        
        self.bannerIndexButton.setTitle("\(Int(index)) / \(self.bannerImages!.count - 2) | 전체보기", for: .normal)
    
    }
}
