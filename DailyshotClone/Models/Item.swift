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
    
    var displayName: String {
        switch self {
        case .whisky: return "위스키"
        case .beer: return "맥주"
        case .wine: return "와인"
        case .liqueur: return "리큐르"
        case .brandy: return "브랜디"
        case .rum: return "럼"
        case .vodka: return "보드카"
        }
    }
}

struct DailyshotItem: Codable {
    let productId: String
    let itemCategory: ItemCategory  // 상품 카테고리
    let name: String        // 상품명
    let price: Int          // 원래 가격
    let discountRate: Int?  // 할인률
    let rating: Double?     // 평점
    let reviewCount: Int?   // 리뷰 수
    
    var finalPrice: Int {   // 할인률이 적용된 최종 가격
        if let discountRate = discountRate, discountRate > 0 {
            return Int(Double(price) * ((100.0 - Double(discountRate)) / 100.0))
        } else {
            return price
        }
    }
    
    let specialOffer: Bool  // 특가 표시
    let recommended: Bool   // 추천 표시
    
    let thumbnailImageURL: String    // 섬네일 이미지
    let productImageURL: String     // 상품 이미지
    let detailImageURL: String      // 상품 상세 이미지
    
    let tastingNotes: TastingNotes?
    let information: Information?
    
    let productDescription: String  // 상품 설명
}

struct TastingNotes: Codable {
    let aroma: String
    let taste: String
    let finish: String
}

struct Information: Codable {
    var type: String            // 종류
    var volume: Int          // 용량 (ml)
    var alcoholByVolume: Double // 도수 (%)
    var countryOfOrigin: String // 국가
    var packaging: String       // 케이스
}
