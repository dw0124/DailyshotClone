//
//  ItemDetailViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/26/24.
//

import Foundation

import RxSwift
import RxCocoa

class ItemDetailViewModel {
    
    var sectionModels = BehaviorRelay<[DetailSectionModel]>(value: [])
    
    init(dailyshotItem: DailyshotItem) {
        let item = DetailSectionModel(type: .item, items: [.itemCell(dailyshotItem)])
        let store = DetailSectionModel(type: .store, items: [.storeCell])
        let description = DetailSectionModel(type: .store, items: [.description(dailyshotItem)])
        
        var tasting = DetailSectionModel(type: .tastingNotes, items: [])
        if let tastingNotes = dailyshotItem.tastingNotes {
            tasting = DetailSectionModel(type: .tastingNotes, items: [.tastingNotes(tastingNotes)])
        }
        
        var inform = DetailSectionModel(type: .information, items: [])
        if let information = dailyshotItem.information {
            inform = DetailSectionModel(type: .information, items: [.information(information)])
        }
        
        sectionModels.accept([item, store, tasting, inform, description])
    }
    
}
