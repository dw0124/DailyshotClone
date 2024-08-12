//
//  ItemDetailViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/26/24.
//

import Foundation

import RxSwift
import RxCocoa

import FirebaseAuth
import FirebaseDatabase

class ItemDetailViewModel {
    
    var sectionModels = BehaviorRelay<[DetailSectionModel]>(value: [])
    var dailyshotItemRelay: BehaviorRelay<DailyshotItem>
    var storeRelay = BehaviorRelay(value: Store.dumy())
    
    var isWishList = BehaviorRelay<Bool>(value: false)
    
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
        
        dailyshotItemRelay = BehaviorRelay<DailyshotItem>(value: dailyshotItem)
        
        isContainWishList()
    }
    
    func addToWishList() -> Observable<Bool> {
        let itemId = self.dailyshotItemRelay.value.productId
        return UserManager.shared.wishList.addWishList(with: itemId)
    }
    
    func removeFromWishList() -> Observable<Bool> {
        let itemId = self.dailyshotItemRelay.value.productId
        return UserManager.shared.wishList.removeFromWishList(with: itemId)
    }
    
    private func isContainWishList() {
        let itemId = dailyshotItemRelay.value.productId
        let isContain = UserManager.shared.wishList.items.contains(itemId)
        print(isContain)
        isWishList.accept(isContain)
    }
}
