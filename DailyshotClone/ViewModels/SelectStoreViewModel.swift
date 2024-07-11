//
//  SelectStoreViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/10/24.
//

import Foundation
import RxRelay

class SelectStoreViewModel {
    
    var currentLocation = PublishRelay<String>()
    var dailyshotItem = PublishRelay<DailyshotItem>()
    var store = PublishRelay<Store>()
    var count = BehaviorRelay<Int>(value: 1)
    
}
