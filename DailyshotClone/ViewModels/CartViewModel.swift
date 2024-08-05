//
//  CartViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/1/24.
//

import Foundation
import RxSwift
import RxRelay

struct CartModel {
    var isSelected: Bool
    let store: Store
    let item: DailyshotItem
    var count: Int
    
    mutating func isSelectedToggle() {
        isSelected.toggle()
    }
}

class CartViewModel {
    
    var disposeBag = DisposeBag()
    
    var cartModel = BehaviorRelay<[CartModel]>(value: [])
    
    init() {
        // DB에서 user/cart에 있는 목록 불러오기
        // 데이터는 스토어 + 아이템 정보 + 수량으로 구성
        let store = Store.dumy()
        let item = DailyshotItem(productId: "001", itemCategory: .whisky, name: "오드 괴즈 분", price: 39000, discountRate: 30, rating: 0, reviewCount: 0, specialOffer: true, recommended: true, thumbnailImageURL: "gs://dailyshotclone.appspot.com/items/ddbKingSue.png", productImageURL: "", detailImageURL: "", tastingNotes: nil, information: nil, productDescription: "")
        
        
        let store2 = Store.dumy()
        let item2 = DailyshotItem(productId: "002", itemCategory: .whisky, name: "기네스", price: 39000, discountRate: 0, rating: 0, reviewCount: 0, specialOffer: true, recommended: true, thumbnailImageURL: "gs://dailyshotclone.appspot.com/items/ddbKingSue.png", productImageURL: "", detailImageURL: "", tastingNotes: nil, information: nil, productDescription: "")
        
        let store3 = Store.dumy()
        let item3 = DailyshotItem(productId: "002", itemCategory: .whisky, name: "하이네켄", price: 39000, discountRate: 0, rating: 0, reviewCount: 0, specialOffer: true, recommended: true, thumbnailImageURL: "gs://dailyshotclone.appspot.com/items/ddbKingSue.png", productImageURL: "", detailImageURL: "", tastingNotes: nil, information: nil, productDescription: "")
        
        let store4 = Store.dumy()
        let item4 = DailyshotItem(productId: "002", itemCategory: .whisky, name: "테스트", price: 39000, discountRate: 0, rating: 0, reviewCount: 0, specialOffer: true, recommended: true, thumbnailImageURL: "gs://dailyshotclone.appspot.com/items/ddbKingSue.png", productImageURL: "", detailImageURL: "", tastingNotes: nil, information: nil, productDescription: "")
        
        let dumy = CartModel(isSelected: true, store: store, item: item, count: 1)
        let dumy2 = CartModel(isSelected: true, store: store2, item: item2, count: 1)
        let dumy3 = CartModel(isSelected: true, store: store3, item: item3, count: 1)
        let dumy4 = CartModel(isSelected: true, store: store4, item: item4, count: 1)
        
        cartModel.accept([dumy, dumy2, dumy3, dumy4, dumy4, dumy4, dumy4, dumy4])
    }
    
    func selectCart(index: Int) -> Bool {
        var items = cartModel.value
        items[index].isSelected.toggle()
        cartModel.accept(items)
        
        let isSelected = items[index].isSelected
        
        return isSelected
    }
    
    func removeFromCart(index: Int) {
        var items = cartModel.value
        items.remove(at: index)
        cartModel.accept(items)
    }
    
    func changeCount(index: Int, count: Int) {
        var items = cartModel.value
        items[index].count = count
        cartModel.accept(items)
    }
    
    func selectAll(_ isSelected: Bool) {
        var value = cartModel.value
        value = value.map {
            var item = $0
            item.isSelected = isSelected
            return item
        }
        cartModel.accept(value)
    }
    
    func removeSelectedItems() {
        var items = cartModel.value
        items.removeAll(where: { $0.isSelected })
        cartModel.accept(items)
    }
}
