//
//  ItemListViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/19/24.
//

import Foundation

import RxSwift
import RxRelay
import RxDataSources

struct ItemListSectionModel {
    var header: Header?
    var items: [DailyshotItem]
}

extension ItemListSectionModel: SectionModelType {
    typealias Item = DailyshotItem

    init(original: ItemListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

class ItemListViewModel {
    
    var sectionModels = BehaviorRelay<[ItemListSectionModel]>(value: [])
    
    var sectionModel = PublishRelay<SectionModel>()
    
    var header: Header?
    
    init(_ sectionModel: SectionModel) {
        header = (sectionModel.header ?? nil)
        
        var dailyshotItems = [DailyshotItem]()
        
        for sectionItem in sectionModel.items {
            switch sectionItem {
            case .smallItem(let items):
                for item in items {
                    dailyshotItems.append(item)
                }
            case .mediumItem(let items):
                for item in items {
                    dailyshotItems.append(item)
                }
            case .largeItem(let items):
                for item in items {
                    dailyshotItems.append(item)
                }
            default:
                break
            }
        }
        
        sectionModels.accept([ItemListSectionModel(header: header, items: dailyshotItems)])
    }
}
