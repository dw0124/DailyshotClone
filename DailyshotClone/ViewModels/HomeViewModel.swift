//
//  HomeViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/7/24.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources

class HomeViewModel {
    
    var disposeBag = DisposeBag()
    
    var dailyshotItems: Observable<[DailyshotItem]>
    
    var bannerImages: [UIImage]
    var menuButtons: [MenuButtonItem]
    var sectionModels = BehaviorRelay<[SectionModel]>(value: [])
    
    init() {
        dailyshotItems = WebService.fetchItems()
        
        bannerImages = [UIImage(systemName: "circle.fill")!, UIImage(systemName: "house.fill")!,UIImage(systemName: "person.fill")!]
        
        menuButtons = [
            MenuButtonItem(name: "픽업가이드", buttonImage: UIImage(named: "guideline-icon")!, viewControllerType: .itemList),
            MenuButtonItem(name: "베스트", buttonImage: UIImage(named: "thumbup-icon")!, viewControllerType: .itemList),
            MenuButtonItem(name: "공동구매", buttonImage: UIImage(named: "people-icon")!, viewControllerType: .itemList),
            MenuButtonItem(name: "MD픽", buttonImage: UIImage(named: "pick-icon")!, viewControllerType: .itemList),
            MenuButtonItem(name: "카테고리", buttonImage: UIImage(named: "categories-icon")!, viewControllerType: .category),
            MenuButtonItem(name: "신상품", buttonImage: UIImage(named: "new-icon")!, viewControllerType: .itemList),
            MenuButtonItem(name: "집앞배송", buttonImage: UIImage(named: "truck-icon")!, viewControllerType: .itemList),
        ]
        
        dailyshotItems
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                
                self.sectionModels.accept([
                    SectionModel(items: [.banner(items: [BannerItem(images: self.bannerImages)])]),
                    SectionModel(items: [.menu(items: self.menuButtons)]),
                    SectionModel(header: Header(title: "초특가 창고 대방출", subTitle: "전국 마지막 수량"), items: [.largeItem(items: items)]),
                    SectionModel(header: Header(title: "MD PICK", subTitle: "MD가 자신있게 추천합니다"), items: [.mediumItem(items: items)]),
                    SectionModel(header: Header(title: "믿고 먹는 재입고 상품", subTitle: "실패하고 싶지 않다면"), items: [.smallItem(items: items)])
                ])
            })
            .disposed(by: disposeBag)
    }
}
