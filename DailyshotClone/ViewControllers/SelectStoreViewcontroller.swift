//
//  SelectStoreViewcontroller.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/10/24.
//

import UIKit
import Foundation
import SnapKit

import NMapsMap

import RxSwift

class SelectStoreViewcontroller: UIViewController, ViewModelBindableType {
    
    var viewModel: SelectStoreViewModel!
    
    var disposeBag = DisposeBag()
    
    let addressLabel = UILabel()
    let mapView = NMFMapView()
    let itemImageView = UIImageView()
    let itemLabel = UILabel()
    let storeButton = UIButton()
    let storeAddressLabel = UILabel()
    let pickupDay = UILabel()
    let priceLabel = UILabel()
    let stepper = CustomStepper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigation()
        setup()
        
        setupMarker()
    }
    
    func bindViewModel() {
        print(#function)
        viewModel.currentLocation
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.store
            .subscribe(onNext: { [weak self] store in
                self?.storeButton.setTitle(store.name, for: .normal)
                self?.storeAddressLabel.text = store.address
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: store.lat, lng: store.lng))
                self?.mapView.moveCamera(cameraUpdate)
            })
            .disposed(by: disposeBag)
        
        viewModel.dailyshotItem
            .subscribe(onNext: { [weak self] item in
                
                self?.itemLabel.text = item.name
            })
            .disposed(by: disposeBag)
        
        ImageCacheManager.shared.loadImageFromStorage(storagePath: viewModel.dailyshotItem.value.thumbnailImageURL)
            .subscribe(onNext: { [weak self] image in
                self?.itemImageView.image = image
            })
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .map { NumberFormatter.setDecimal($0) + "원" }
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        stepper.value
            .bind(to: viewModel.count)
            .disposed(by: disposeBag)
    }
    
    func setupNavigation() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "판매처 선택"
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func setup() {
        // 전체 스택뷰 생성
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(mainStackView)
        
        // 주소 라벨 초기화
        addressLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        addressLabel.numberOfLines = 1
        addressLabel.textAlignment = .left
        addressLabel.text = "서울특별시 강서구 ..."
        
        // 지도는 이미 초기화됨
        
        // 상품 이미지와 라벨 초기화
        itemImageView.backgroundColor = .systemGray
        
        itemLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        itemLabel.numberOfLines = 1
        itemLabel.textAlignment = .left
        itemLabel.text = "상품이름"
        
        let itemStackView = UIStackView(arrangedSubviews: [itemImageView, itemLabel])
        itemStackView.axis = .horizontal
        itemStackView.alignment = .top
        itemStackView.spacing = 8
        
        // 매장 버튼과 주소 라벨 초기화
        storeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        storeButton.titleLabel?.textAlignment = .left
        storeButton.setTitleColor(.black, for: .normal)
        storeButton.setTitle("매장 이름", for: .normal)
        storeButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        storeButton.semanticContentAttribute = .forceRightToLeft
        storeButton.tintColor = .black
        
        storeAddressLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        storeAddressLabel.numberOfLines = 1
        storeAddressLabel.textAlignment = .left
        storeAddressLabel.text = "매장 주소"
        storeAddressLabel.textColor = .systemGray
        
        let storeStackView = UIStackView(arrangedSubviews: [storeButton, storeAddressLabel])
        storeStackView.axis = .vertical
        storeStackView.alignment = .top
        storeStackView.spacing = 4
        
        // 픽업 요일과 가격 라벨 초기화
        pickupDay.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        pickupDay.numberOfLines = 1
        pickupDay.textAlignment = .left
        pickupDay.text = "?/?(요일) 준비완료 예정"
        
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .left
        priceLabel.text = "??,???원"
        
        let pickupStackView = UIStackView(arrangedSubviews: [pickupDay, UIView(), priceLabel])
        pickupStackView.axis = .horizontal
        pickupStackView.spacing = 8
        
        // 수량 라벨과 스텝퍼 초기화
        let count: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            label.numberOfLines = 1
            label.textAlignment = .left
            label.text = "수량"
            return label
        }()
        
        stepper.layer.cornerRadius = 10
        stepper.layer.borderWidth = 1
        stepper.layer.borderColor = UIColor.systemGray5.cgColor
        
        let countStackView = UIStackView(arrangedSubviews: [count, UIView(), stepper])
        countStackView.axis = .horizontal
        countStackView.spacing = 8
        
        // 장바구니와 구매 버튼 생성
        let cartButton: UIButton = {
            let button = UIButton()
            button.titleLabel?.textAlignment = .center
            button.setTitle("장바구니 담기", for: .normal)
            button.tintColor = .orange
            button.backgroundColor = #colorLiteral(red: 0.9920747876, green: 0.3846439123, blue: 0.003998160828, alpha: 0.1021833609)
            button.layer.cornerRadius = 10
            button.addPadding(top: 10, leading: 10, bottom: 10, trailing: 10)
            return button
        }()
        
        let purchaseButton: UIButton = {
            let button = UIButton()
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(.black, for: .normal)
            button.setTitle("바로 구매하기", for: .normal)
            button.backgroundColor = .orange
            button.setTitleColor(.white, for: .normal)
            button.tintColor = .white
            button.layer.cornerRadius = 10
            button.addPadding(top: 10, leading: 10, bottom: 10, trailing: 10)
            return button
        }()
        
        let buttonStackView = UIStackView(arrangedSubviews: [cartButton, purchaseButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .fillEqually
        
        // 스토어와 가격 정보 스택뷰 생성
        let storAndPriceStackView = UIStackView(arrangedSubviews: [storeStackView, UIView(), pickupStackView])
        storAndPriceStackView.axis = .vertical
        storAndPriceStackView.spacing = 8
        
        let itemStoreSeparatorLine = UIView()
        itemStoreSeparatorLine.backgroundColor = .lightGray
        
        let storeCountSeparatorLine = UIView()
        storeCountSeparatorLine.backgroundColor = .lightGray
        
        // 하단 스택뷰 생성
        let bottomStackView = UIStackView(arrangedSubviews: [itemStackView, itemStoreSeparatorLine, storAndPriceStackView, storeCountSeparatorLine, countStackView, buttonStackView])
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 15
        
        // 메인 스택뷰에 서브뷰 추가
        mainStackView.addArrangedSubview(addressLabel)
        mainStackView.addArrangedSubview(mapView)
        mainStackView.addArrangedSubview(bottomStackView)
        
        mainStackView.setCustomSpacing(10, after: addressLabel)
        
        // 스택뷰 제약조건 설정
        mainStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        itemStoreSeparatorLine.snp.makeConstraints {
            $0.height.equalTo(0.4)
        }
        
        storeCountSeparatorLine.snp.makeConstraints {
            $0.height.equalTo(0.4)
        }
        
        // 개별 뷰 제약조건 설정
        addressLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(mapView.snp.width).multipliedBy(0.8).priority(.low)
        }
        
        itemStackView.snp.makeConstraints {
            $0.height.equalTo(80).priority(.required)
        }
        
        itemImageView.snp.makeConstraints {
            $0.width.height.equalTo(80).priority(.required)
        }
        
        storAndPriceStackView.snp.makeConstraints {
            $0.height.equalTo(90).priority(.required)
        }
        
        stepper.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(44)
        }
    }
    
    func setupMarker() {
        let store = viewModel.store.value
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: store.lat, lng: store.lng)
        marker.mapView = mapView
    }
}
