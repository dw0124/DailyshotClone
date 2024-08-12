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
    
    func saveToCart() {
        let itemId = dailyshotItem.value.productId
        let storeId = store.value.storeId
        let count = count.value
        
        CartManager.addToCart(itemId: itemId, storeId: storeId, count: count)        
            .subscribe(onNext: { success in
            if success {
                print("Item added to cart successfully.")
            } else {
                print("Failed to add item to cart.")
            }
        }, onError: { error in
            // 에러 발생 시 화면에 Alert 표시
            print(error.localizedDescription)
        }, onDisposed: {
            print("dispose!")
        })
        .disposed(by: disposeBag)
    }
}
