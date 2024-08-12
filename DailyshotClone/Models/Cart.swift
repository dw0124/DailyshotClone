//
//  Cart.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/12/24.
//

import Foundation

struct Cart: Codable {
    var cartId: String
    var itemId: String
    var storeId: String
    var count: Int
    
    var isSelected: Bool
    
    var store: Store?
    var item: DailyshotItem?
    
    mutating func isSelectedToggle() {
        isSelected.toggle()
    }
    
    mutating func updateItem(_ newItem: DailyshotItem) {
        item = newItem
    }
}

struct CartTest: Codable {
    var cartId: String
    var itemId: String
    var storeId: String
    var count: Int
}
