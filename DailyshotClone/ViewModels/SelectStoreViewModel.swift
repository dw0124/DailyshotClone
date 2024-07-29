//
//  SelectStoreViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/10/24.
//

import Foundation
import RxRelay
import RxSwift

class SelectStoreViewModel {
    
    var disposeBag = DisposeBag()
    
    var currentLocation = PublishRelay<String>()
    var dailyshotItem: BehaviorRelay<DailyshotItem>
    var store: BehaviorRelay<Store>
    var count = BehaviorRelay<Int>(value: 1)
    
    var totalPrice: BehaviorRelay<Int>
    
    init(store: Store, dailyshotItem: DailyshotItem) {
        
        
        self.dailyshotItem = BehaviorRelay<DailyshotItem>(value: dailyshotItem)
        self.store = BehaviorRelay<Store>(value: store)
        
        self.totalPrice = BehaviorRelay<Int>(value: dailyshotItem.finalPrice)
        
        self.count
            .subscribe(onNext: { count in
                self.totalPrice.accept(count * dailyshotItem.finalPrice) 
            })
            .disposed(by: disposeBag)
    }
    
}
