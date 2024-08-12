//
//  UserManager.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/8/24.
//

import Foundation

import FirebaseAuth
import FirebaseDatabase

import RxSwift
import RxRelay

class UserManager {
    
    static let shared = UserManager()
    
    var currentUser: User?
    var wishList = WishList()
    
    private init() {
        setUser()
    }
    
    private func setUser() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let email = user.email ?? ""
            let name = user.displayName ?? ""
            let phoneNumber = user.phoneNumber ?? ""
            
            let userManagerUser = User(userId: userId, email: email, name: name, phoneNumber: phoneNumber, wishList: [])
            
            self.currentUser = userManagerUser
        }
    }
}

class WishList {
    
    var items: [String] = []
    var itemsRelay = BehaviorRelay<[String]>(value: [])
    
    init() {
        observingWishList()
    }
    
    // DB에 있는 위시리스트가 변경될때마다 self.wishList에 저장
    private func observingWishList() {
        if let user = Auth.auth().currentUser {
            let userRef = Database.database().reference().child("users/\(user.uid)/wishList")
            
            
            userRef.observe(DataEventType.value, with: { [weak self] snapshot in
                
                var updatedWishList: [String] = []
                
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot, let key = snapshot.key as String? {
                        updatedWishList.append(key)
                    }
                }
                self?.items = updatedWishList
                self?.itemsRelay.accept(updatedWishList)
            })
        }
    }
    
    func addWishList(with itemID: String) -> Observable<Bool> {
        // 로그인 확인
        guard let user = Auth.auth().currentUser else {
            return Observable.just(false)
        }
        
        return Observable.create { observer in
            // Realtime Database 경로
            let userRef = Database.database().reference().child("users/\(user.uid)/wishList")
            
            // 경로에 데이터 저장
            userRef.child(itemID).setValue(true) { (error:Error?, ref:DatabaseReference) in
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
    }
    
    func removeFromWishList(with itemID: String) -> Observable<Bool> {
        // 로그인 확인
        guard let user = Auth.auth().currentUser else {
            return Observable.just(false)
        }
        
        return Observable.create { observer in
            // Realtime Database 경로
            let userRef = Database.database().reference().child("users/\(user.uid)/wishList")
            
            // 경로에서 데이터 삭제
            userRef.child(itemID).setValue(nil) { (error:Error?, ref:DatabaseReference) in
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
