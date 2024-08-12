//
//  Store.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/1/24.
//

import Foundation

struct Store: Codable {
    var storeId: String
    
    var name: String
    var storeDescription: String
    var address: String
    var storeNumber: String
    var openTime: String
    
    var lat: Double
    var lng: Double
    
    
    static func dumy() -> Store {
        return Store(storeId: "STORE1", name: "위스키파크", storeDescription: "다양한 주류를 만날수 있는 위스키파크입니다.", address: "서울 양천구 목동로25길 23 1", storeNumber: "010-5796-2607", openTime: "월 - 토 오후 12:00 - 오후 9:00 \n일 오후 4:00 - 오후 9:00", lat: 37.5279428, lng: 126.8614762)
    }
}
