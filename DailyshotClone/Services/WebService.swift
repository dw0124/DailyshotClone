//
//  APIManager.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/12/24.
//

import Foundation

import RxSwift

import FirebaseDatabase
import FirebaseStorage

class WebService {
    
    static func fetchItems() -> Observable<[DailyshotItem]> {
        return Observable.create { observer in
            
            let databaseRef = Database.database().reference()
            let itemsRef = databaseRef.child("items")
            
            itemsRef.getData { error, snapshot in
                if let error = error {
                    print("데이터 읽기 오류: \(error.localizedDescription)")
                    observer.onError(error)
                }
                
                guard let value = snapshot?.value as? [String: [String: Any]] else {
                    print("데이터 형식 오류")
                    return
                }
                
                var items: [DailyshotItem] = []
                for (_, itemData) in value {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: itemData, options: [])
                        let item = try JSONDecoder().decode(DailyshotItem.self, from: jsonData)
                        items.append(item)
                    } catch let error {
                        print("fetchItems - 데이터 디코딩 오류: \(error.localizedDescription)")
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
    
    static func fetchItemWithId(with id: String) -> Observable<DailyshotItem?> {
        return Observable.create { observer in
            
            let databaseRef = Database.database().reference()
            let itemRef = databaseRef.child("items").child(id)
            
            itemRef.getData { error, snapshot in
                if let error = error {
                    print("데이터 읽기 오류: \(error.localizedDescription)")
                    observer.onError(error)
                    return
                }
                
                guard let itemData = snapshot?.value as? [String: Any] else {
                    print("데이터 형식 오류")
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: itemData, options: [])
                    let item = try JSONDecoder().decode(DailyshotItem.self, from: jsonData)
                    observer.onNext(item)
                } catch let error {
                    print("fetchItemWithId - 데이터 디코딩 오류: \(error.localizedDescription)")
                    observer.onError(error)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }

}
