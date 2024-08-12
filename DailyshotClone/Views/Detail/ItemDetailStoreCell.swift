//
//  ItemDetailStoreCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/26/24.
//

import Foundation
import UIKit
import SnapKit

import RxSwift

import NMapsMap

class ItemDetailStoreCell: UITableViewCell {

    static let identifier = "ItemDetailStoreCell"
    
    var disposeBag = DisposeBag()
    
    var store: Store = Store.dumy()
    
    var isOpen: Bool = false
    
    let storeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.text = "판매처"
        return label
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.text = "목동 종합운동장"
        return label
    }()
    
    let storeAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .darkGray
        label.text = "서울 양천구 안양천로 939"
        return label
    }()
    
    let storeNumberButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setTitle("010-1234-1234", for: .normal)
        button.setUnderline()
        return button
    }()
    
    let storeTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.text = "월 - 토 오후 12:00 - 오후 9:00 \n일 오후 4:00 - 오후 9:00"
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.setImage(UIImage(systemName: "chevron.up"), for: .selected)
        return button
    }()
    
    let mapView: NMFMapView = {
        let mapView = NMFMapView()
        return mapView
    }()
    
    let moreStoreButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitle("판매처 상품 더보기 ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storeNameLabel, storeAddressLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.setCustomSpacing(8, after: storeAddressLabel)
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storeLabel, labelStackView, button])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var moreStoreButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [moreStoreButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var bigStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        disposeBag = DisposeBag()
    }
    
    // setup UI + Layout
    private func setupCell() {
        //mapContainerView.addSubview(mapView)
        
        contentView.addSubview(bigStackView)
        
        bigStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().priority(.required)
            $0.top.bottom.equalToSuperview().priority(.low)
        }
        
        bigStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        bigStackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        moreStoreButtonStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        moreStoreButtonStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func configure(store: Store) {
        self.store = store
        
        storeNameLabel.text = store.name
        storeTimeLabel.text = store.openTime
        storeAddressLabel.text = store.address
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: store.lat, lng: store.lng))
        mapView.moveCamera(cameraUpdate)
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: store.lat, lng: store.lng)
        marker.mapView = mapView
        
        storeNumberButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if let storeNumber = self?.store.storeNumber {
                    self?.callPhoneNumber(storeNumber)
                }
            })
            .disposed(by: disposeBag)
        
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.isOpen == false ? self.openCell() : self.closeCell()
                self.isOpen.toggle()
                self.button.isSelected.toggle()
            })
            .disposed(by: disposeBag)
    }
    
    func openCell() {
        labelStackView.addArrangedSubview(storeNumberButton)
        labelStackView.addArrangedSubview(storeTimeLabel)
        
        bigStackView.addArrangedSubview(mapView)
        bigStackView.addArrangedSubview(moreStoreButtonStackView)
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(250).priority(.required)
        }
        
        moreStoreButtonStackView.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        
        moreStoreButton.snp.makeConstraints {
            $0.height.equalTo(44).priority(.required)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func closeCell() {
        labelStackView.removeArrangedSubview(storeNumberButton)
        labelStackView.removeArrangedSubview(storeTimeLabel)
        bigStackView.removeArrangedSubview(mapView)
        bigStackView.removeArrangedSubview(moreStoreButtonStackView)
        
        storeNumberButton.removeFromSuperview()
        storeTimeLabel.removeFromSuperview()
        mapView.removeFromSuperview()
        moreStoreButtonStackView.removeFromSuperview()
        
        setNeedsLayout()
        layoutIfNeeded()
    }

    private func callPhoneNumber(_ phoneNumber: String) {
        if let url = NSURL(string: "tel://0" + "\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
