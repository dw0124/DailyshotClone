//
//  CartViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/1/24.
//

import Foundation
import RxSwift
import RxRelay


class CartViewModel {
    
    var disposeBag = DisposeBag()
    
    var cartRelay = BehaviorRelay<[Cart]>(value: [])
    
    var displayedCartRelay = BehaviorRelay<[Cart]>(value: [])
    
    init() {
        CartManager.fetchCartList()
            .flatMap { carts -> Observable<[Cart]> in
                // 각 Cart에 대해 item을 fetch한 후 업데이트
                let updatedCarts = carts.map { cart in
                    WebService.fetchItemWithId(with: cart.itemId)
                        .map { item -> Cart in
                            var updatedCart = cart
                            updatedCart.item = item
                            updatedCart.store = Store.dumy()
                            return updatedCart
                        }
                }
                // 모든 업데이트된 카트들을 zip으로 묶어 배열로 반환
                return Observable.zip(updatedCarts)
            }
            .subscribe(onNext: { [weak self] updatedCarts in
                self?.cartRelay.accept(updatedCarts)
                self?.displayedCartRelay.accept(updatedCarts)
            }, onError: { error in
                print("Error updating cartRelay: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func selectCart(index: Int) -> Bool {
        var items = cartRelay.value
        items[index].isSelected.toggle()
        cartRelay.accept(items)
        
        let isSelected = items[index].isSelected
        
        return isSelected
    }
    
    func removeFromCart(index: Int) {
        var items = cartRelay.value
        let cartId = items[index].cartId
        items.remove(at: index)
        cartRelay.accept(items)
        
        var displayedItems = displayedCartRelay.value
        displayedItems.remove(at: index)
        displayedCartRelay.accept(items)
        
        CartManager.removeFromCart(with: cartId)
            .subscribe(onNext: { success in
                if success {
                    print("Item removed to cart successfully.")
                } else {
                    print("Failed to remove item to cart.")
                }
            }, onError: { error in
                // 에러 발생 시 화면에 Alert 표시
                print(error.localizedDescription)
            }, onDisposed: {
                print("dispose!!")
            })
            .disposed(by: disposeBag)
    }
    
    func changeCount(index: Int, count: Int) {
        var items = cartRelay.value
        let cartId = items[index].cartId
        items[index].count = count
        cartRelay.accept(items)
        
        CartManager.updateCartItemCount(cartId: cartId, count: count)
            .subscribe(onNext: { success in
                if success {
                    print("Item count update complete")
                } else {
                    print("Failed to update item Count")
                }
            }, onError: { error in
                print("Error removing item from cart: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    
    func selectAll(_ isSelected: Bool) {
        var value = cartRelay.value
        value = value.map {
            var item = $0
            item.isSelected = isSelected
            return item
        }
        cartRelay.accept(value)
    }
    
    func removeSelectedItems() {
        let selectedItems = cartRelay.value.filter { $0.isSelected }
        var remainingItems = cartRelay.value
        remainingItems.removeAll(where: { $0.isSelected })
        
        // cartRelay와 displayedCartRelay 동기화
        cartRelay.accept(remainingItems)
        displayedCartRelay.accept(remainingItems)
        
        // 선택된 아이템을 제거
        selectedItems.forEach { cart in
            CartManager.removeFromCart(with: cart.cartId)
                .subscribe(onNext: { success in
                    if success {
                        print("Item removed from cart successfully: \(cart.cartId)")
                    } else {
                        print("Failed to remove item from cart: \(cart.cartId)")
                    }
                }, onError: { error in
                    print("Error removing item from cart: \(error.localizedDescription)")
                }, onDisposed: {
                    print("Removal process disposed for cartId: \(cart.cartId)")
                })
                .disposed(by: disposeBag)
        }
    }
}
