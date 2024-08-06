//
//  WishListViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/6/24.
//

import Foundation
import RxRelay

class WishListViewModel {
    
    var itemsRelay = BehaviorRelay<[DailyshotItem]>(value: [])
    
    init() {
        let item = DailyshotItem(productId: "001", itemCategory: .whisky, name: "오드 괴즈 분", price: 39000, discountRate: 30, rating: 4.0, reviewCount: 12, specialOffer: true, recommended: true, thumbnailImageURL: "gs://dailyshotclone.appspot.com/items/ddbKingSue.png", productImageURL: "gs://dailyshotclone.appspot.com/items/ddbKingSue.png", detailImageURL: "gs://dailyshotclone.appspot.com/items/ddbKingSue.png", tastingNotes: nil, information: nil, productDescription: "")
        
        let item2 = DailyshotItem(productId: "002", itemCategory: .whisky, name: "기네스", price: 4500, discountRate: 0, rating: 0, reviewCount: 0, specialOffer: true, recommended: true, thumbnailImageURL: "gs://dailyshotclone.appspot.com/items/ddbKingSue.png", productImageURL: "", detailImageURL: "", tastingNotes: nil, information: nil, productDescription: "")
        
        let item3 = DailyshotItem(productId: "002", itemCategory: .whisky, name: "하이네켄", price: 3000, discountRate: 0, rating: 0, reviewCount: 0, specialOffer: true, recommended: true, thumbnailImageURL: "gs://dailyshotclone.appspot.com/items/ddbKingSue.png", productImageURL: "", detailImageURL: "", tastingNotes: nil, information: nil, productDescription: "")
        
        itemsRelay.accept([item, item2, item3])
    }
    
    
}
