//
//  CategoryItemListViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/15/24.
//

import Foundation
import RxRelay

class CategoryItemListViewModel {
    
    var sectionModels = BehaviorRelay<[ItemListSectionModel]>(value: [])
    
    init(urlStr: String) {
        // api 호출 예정
        let items = WebService.load([DailyshotItem].self, from: "productData")!
        
        sectionModels.accept([ItemListSectionModel(header: nil, items: items)])
    }
}
