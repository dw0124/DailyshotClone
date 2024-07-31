//
//  FilterListViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/16/24.
//

import Foundation

import RxRelay
import RxDataSources

// 섹션 모델 정의
enum FilterListType: String {
    case service
    case category
    case packaging
    case coutnry
}

struct FilterListSectionModel {
    var type: FilterListType
    var header: String
    var items: [String]
}

extension FilterListSectionModel: SectionModelType {
    typealias Item = String

    init(original: FilterListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

class FilterListViewModel {
    
    var sectionModels = BehaviorRelay<[FilterListSectionModel]>(value: [])
    
    var selectedOptions = BehaviorRelay<[String:[String]]>(value: [:])
    
    // 한번 이상 필터를 적용했고 다시 화면이 불러졌을 때 IndexPath를 isSelected 상태로 만들기 위한 프로퍼티
    var preSelectedIndexPath = BehaviorRelay<[IndexPath]>(value: [])
    
    init() {
        let service = FilterListSectionModel(type: .service, header: "서비스", items: ["스토어", "파트너", "배송상품"])
        let category = FilterListSectionModel(type: .category, header: "카테고리", items: ["위스키", "와인", "리큐르", "맥주", "기타"])
        let packaging = FilterListSectionModel(type: .packaging, header: "케이스", items: ["있음", "없음"])
        let country = FilterListSectionModel(type: .coutnry, header: "국가", items: ["미국", "독일", "일본", "이탈리아", "스코틀랜드", "태국", "대만", "인도"])
        
        sectionModels.accept([service, category, packaging, country])
    }
    
    func selectOption(type: String, option: String) {
        var options = selectedOptions.value

        if var typeOptions = options[type] {
            if let index = typeOptions.firstIndex(of: option) {
                typeOptions.remove(at: index)
            } else {
                typeOptions.append(option)
            }
            options[type] = typeOptions
            
            if typeOptions.isEmpty {
                options.removeValue(forKey: type)
            }
        } else {
            options[type] = [option]
        }

        selectedOptions.accept(options)
    }


    func resetOption() {
        selectedOptions.accept([:])
    }
}
