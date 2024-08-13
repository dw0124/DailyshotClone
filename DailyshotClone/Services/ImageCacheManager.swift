//
//  ImageCacheManager.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/13/24.
//

import Foundation
import UIKit

import RxSwift

import FirebaseStorage

class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    var cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    /// firebase storage에서 이미지 데이터 불러오는 메소드.
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
