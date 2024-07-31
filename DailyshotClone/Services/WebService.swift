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
    
    static func loadData<T: Codable>(urlStr: String, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: urlStr) else { fatalError("Invalid URL") }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(result)
                } catch {
                    print("Failed to decode JSON data: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    static func load<T: Codable>(_ type: [T].Type, from resourceName: String) -> [T]? {
        // type : 디코딩 할 때 사용되는 모델의 타입
        // resourceName : json 파일의 이름
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "json") else {
            return nil
        }
        // 확장자가 json인 파일의 경로를 가져오는 부분
        guard let jsonString = try? String(contentsOfFile: path) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        
        guard let data = data else { return nil }
        
        var items: [T]? = nil
        do {
            items = try decoder.decode(type, from: data)
        } catch {
            print(error)
        }
        
        return items == nil ? nil : items
    }
    
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
                        print("데이터 디코딩 오류: \(error.localizedDescription)")
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
}


class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    /// firebase storage에서 이미지 데이터 불러오는 메소드
    func loadImageFromStorage(storagePath: String) -> Observable<UIImage?> {
        Observable.create { observer in
            // Firebase Storage에 저장된 이미지를 저장하지 않았을때
            if storagePath == "" {
                observer.onNext(nil)
                observer.onCompleted()
            }
            
            let cacheKey = NSString(string: storagePath)
            
            // 캐시에 저장된 이미지가 있을때
            if let cachedImage = ImageCacheManager.shared.cache.object(forKey: cacheKey) {
                observer.onNext(cachedImage)
                observer.onCompleted()
            } else { // 캐시에 저장된 이미지가 없을때 Firebase Storage에서 이미지를 불러오고 캐시로 저장
                let storage = Storage.storage()
                let storageRef = storage.reference(forURL: storagePath)
                storageRef.getData(maxSize: Int64(100 * 1024 * 1024)){ (data, error) in
                    if let error = error {
                        observer.onError(error)
                    }
                    if let data = data, let image = UIImage(data: data) {
                        // 이미지를 캐시로 저장
                        ImageCacheManager.shared.cache.setObject(image, forKey: cacheKey)
                        observer.onNext(image)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
}
