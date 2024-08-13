//
//  WishListManager.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/13/24.
//

import Foundation

import RxSwift
import RxRelay

import FirebaseAuth
import FirebaseDatabase

class WishListManager {
    
    static let shared = WishListManager()
    
    var items: [String] = []
    var itemsRelay = BehaviorRelay<[String]>(value: [])
    
    private init() {
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
