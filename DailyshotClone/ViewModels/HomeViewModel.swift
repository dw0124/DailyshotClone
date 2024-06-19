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
    
    var bannerImages: [UIImage]
    var menuButtons: [MenuButtonItem]
    var sectionModels = BehaviorRelay<[SectionModel]>(value: [])
    
    init() {
        bannerImages = [UIImage(systemName: "circle.fill")!, UIImage(systemName: "circle.fill")!,UIImage(systemName: "circle.fill")!]
        menuButtons = [
            MenuButtonItem(name: "Home", buttonImage: UIImage(systemName: "house.fill")!),
            MenuButtonItem(name: "Search", buttonImage: UIImage(systemName: "magnifyingglass")!),
            MenuButtonItem(name: "Profile", buttonImage: UIImage(systemName: "person.fill")!),
            MenuButtonItem(name: "Settings", buttonImage: UIImage(systemName: "gear")!),
            MenuButtonItem(name: "Home", buttonImage: UIImage(systemName: "house.fill")!),
            MenuButtonItem(name: "Search", buttonImage: UIImage(systemName: "magnifyingglass")!),
            MenuButtonItem(name: "Profile", buttonImage: UIImage(systemName: "person.fill")!),
            MenuButtonItem(name: "Settings", buttonImage: UIImage(systemName: "gear")!),
            MenuButtonItem(name: "Home", buttonImage: UIImage(systemName: "house.fill")!),
            MenuButtonItem(name: "Search", buttonImage: UIImage(systemName: "magnifyingglass")!),
            MenuButtonItem(name: "Profile", buttonImage: UIImage(systemName: "person.fill")!),
            //MenuButtonItem(name: "Settings", buttonImage: UIImage(systemName: "gear")!)
        ]

        
        let items = WebService.load([DailyshotItem].self, from: "productData")!
        
        sectionModels.accept([
            SectionModel(items: [.banner(items: [BannerItem(images: bannerImages)])]),
            SectionModel(items: [.menu(items: menuButtons)]),
            SectionModel(header: Header(title: "초특가 창고 대방출", subTitle: "전국 마지막 수량"), items: [.smallItem(items: items)]),
            SectionModel(header: Header(title: "MD PICK", subTitle: "MD가 자신있게 추천합니다"), items: [.mediumItem(items: items)]),
            SectionModel(header: Header(title: "믿고 먹는 재입고 상품", subTitle: "실패하고 싶지 않다면"), items: [.largeItem(items: items)]),
        ])
    }
}
