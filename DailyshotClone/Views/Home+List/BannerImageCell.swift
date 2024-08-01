//
//  BannerImageCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/10/24.
//

import UIKit
import Foundation
import SnapKit

import RxSwift

class BannerImageCell: UICollectionViewCell {
    
    static let identifier = "BannerImageCell"
    
    var disposeBag = DisposeBag()
    
    // 이미지를 표시할 imageView
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        
        disposeBag = DisposeBag()
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
        
        let urlString = "gs://dailyshotclone.appspot.com/banners/banner1.jpg"
        
        ImageCacheManager.shared.loadImageFromStorage(storagePath: urlString)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
    
    func configure(with urlStr: String) {
        let urlString = "gs://dailyshotclone.appspot.com/banners/banner1.jpg"
        
        ImageCacheManager.shared.loadImageFromStorage(storagePath: urlString)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
