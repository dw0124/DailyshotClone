//
//  CartManager.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/13/24.
//

import Foundation

import RxSwift
import RxRelay

import FirebaseAuth
import FirebaseDatabase

class CartManager {
    
    static func fetchCartList() -> Observable<[Cart]> {
        
        guard let user = Auth.auth().currentUser else {
            return Observable.just([])
        }
        
        return Observable.create { observer in
            let databaseRef = Database.database().reference()
            let itemsRef = databaseRef.child("users/\(user.uid)/cart")
            
            itemsRef.getData { error, snapshot in
                if let error = error {
                    print("데이터 읽기 오류: \(error.localizedDescription)")
                    observer.onError(error)
                }
                
                guard let value = snapshot?.value as? [String: [String: Any]] else {
                    print("데이터 형식 오류")
                    return
                }
                
                var items: [Cart] = []
                for (_, itemData) in value {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: itemData, options: [])
                        let item = try JSONDecoder().decode(Cart.self, from: jsonData)
                        items.append(item)
                    } catch let error {
                        print("fetchCartList - 데이터 디코딩 오류: \(error.localizedDescription)")
                    }
                }
                
                observer.onNext(items)
                observer.onCompleted()
            }
            
            return Disposables.create {
                // 작업 취소
            }
        }
    }
    
    static func addToCart(itemId: String, storeId: String, count: Int) -> Observable<Bool> {
        // 로그인 확인
        guard let user = Auth.auth().currentUser else {
            return Observable.just(false)
        }
        
        return Observable.create { observer in
            
            let cartId = UUID().uuidString
            
            let data: [String: Any] = [
                "cartId": cartId,
                "itemId": itemId,
                "storeId": storeId,
                "count": count,
                "isSelected": true
            ]
            
            // Realtime Database 경로
            let userRef = Database.database().reference().child("users/\(user.uid)/cart")
            
            // 경로에 데이터 저장
            userRef.child(cartId).setValue(data) { (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    observer.onError(error)
                    
                } else {
                    print("Data saved successfully!")
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
        .retry(3)
    }
    
    static func removeFromCart(with cartId: String) -> Observable<Bool> {
        // 로그인 확인
        guard let user = Auth.auth().currentUser else {
            return Observable.just(false)
        }
        
        return Observable.create { observer in
            // Realtime Database 경로
            let userRef = Database.database().reference().child("users/\(user.uid)/cart")
            
            // 경로에서 데이터 삭제
            userRef.child(cartId).setValue(nil) { (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    observer.onError(error)
                    
                } else {
                    print("Data removed successfully!")
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }
    
    static func updateCartItemCount(cartId: String, count: Int) -> Observable<Bool> {
        // 로그인 확인
        guard let user = Auth.auth().currentUser else {
            return Observable.just(false)
        }
        
        return Observable.create { observer in
            // Realtime Database 경로
            let userRef = Database.database().reference().child("users/\(user.uid)/cart")
            
            // 경로에서 데이터 삭제
            userRef.child(cartId).child("count").setValue(count) { (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    observer.onError(error)
                    
                } else {
                    print("Data removed successfully!")
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }
}
