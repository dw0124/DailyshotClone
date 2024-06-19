//
//  Item.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/10/24.
//

import UIKit
import Foundation

enum ItemCategory: String, Codable {
    case whisky
    case beer
    case wine
    case liqueur
    case brandy
    case rum
    case vodka
}

struct DailyshotItem: Codable {
    let itemCategory: ItemCategory  // 상품 카테고리
    let name: String        // 상품명
    let price: Int       // 가격
    let discountRate: Int?  // 할인률
    let rating: Double?     // 평점
    
    let specialOffer: Bool  // 특가 표시
    let recommended: Bool   // 추천 표시
    
    let thumnailImageURL: String    // 섬네일 이미지
    let productImageURL: String     // 상품 이미지
    let detailImageURL: String      // 상품 상세 이미지
    
    let productDescription: String
}
