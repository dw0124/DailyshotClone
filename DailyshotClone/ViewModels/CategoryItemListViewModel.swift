//
//  CategoryItemListViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/15/24.
//

import Foundation
import RxRelay
import RxSwift

class CategoryItemListViewModel {
    
    var disposeBag = DisposeBag()
    
    var originalItems = BehaviorRelay<[DailyshotItem]>(value: [])
    var filteredItems = BehaviorRelay<[DailyshotItem]>(value: [])
    var sectionModels = BehaviorRelay<[ItemListSectionModel]>(value: [])
    
    var filterList = BehaviorSubject<[String: [String]]>(value: [:])
    var filterListIndexPath: [IndexPath] = [] // 선택했던 필터 목록의 IndexPath 정보
    
    init(urlStr: String) {
        binding()
        loadData(from: urlStr)
    }
    
    private func loadData(from urlStr: String) {
        // API 호출 구현 예정
        let items = WebService.load([DailyshotItem].self, from: "productData")!
        self.originalItems.accept(items)
        self.filteredItems.accept(items)
    }
    
    private func binding() {
        // 필터링된 아이템 변경 시 sectionModels 업데이트
        filteredItems
            .subscribe(onNext: { [weak self] items in
                self?.sectionModels.accept([ItemListSectionModel(header: nil, items: items)])
            })
            .disposed(by: disposeBag)
        
        // 필터 리스트 변경 시 아이템 필터링
        filterList
            .subscribe(onNext: { [weak self] filterList in
                self?.itemFilter(filterList)
            })
            .disposed(by: disposeBag)
    }
    
    private func itemFilter(_ filterList: [String: [String]]) {
        var filteredItems = originalItems.value
        
        // 필터 타입에 따라 필터링 적용
        for (key, values) in filterList {
            guard let filterType = FilterListType(rawValue: key) else { continue }
            
            switch filterType {
            case .service:
                print("#1 service", values)
            case .category:
                print("#1 category", values)
                filteredItems = filteredItems.filter {
                    values.contains($0.itemCategory.displayName)
                }
            case .packaging:
                print("#1 packaging", values)
            case .coutnry:
                print("#1 country", values)
                filteredItems = filteredItems.filter {
                    if let country = $0.information?.countryOfOrigin {
                        return values.contains(country)
                    } else {
                        return false
                    }
                }
            }
        }
        
        // 필터링된 결과로 업데이트
        self.filteredItems.accept(filteredItems)
    }
}
