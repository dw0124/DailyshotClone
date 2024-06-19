//
//  APIManager.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/12/24.
//

import Foundation

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
}
