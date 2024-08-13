//
//  WishListViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/6/24.
//

import Foundation
import RxSwift
import RxRelay

class WishListViewModel {
    
    var disposeBag = DisposeBag()
    
    var itemsRelay = BehaviorRelay<[DailyshotItem]>(value: [])
    
    init() {
        
    }
    
    func updateWishList() {
        let wishListItems = WishListManager.shared.items
        
        let observables = wishListItems.map { itemId in
            WebService.fetchItemWithId(with: itemId)
        }
        
        if !observables.isEmpty {
            Observable.zip(observables)
                .subscribe(onNext: { [weak self] items in
                    let nonNilItems = items.compactMap { $0 }
                    self?.itemsRelay.accept(nonNilItems)
                })
                .disposed(by: disposeBag)
        }
    }
}
