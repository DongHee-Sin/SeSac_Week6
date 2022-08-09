//
//  APIManager.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() {}
    
    // header 내용은 변하지 않아서 명시적으로 빼서 사용해도 괜찮음
    private let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: EndPoint, query: String, completionHandler: @escaping (JSON) -> ()) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
        
        AF.request(url, method: .get, headers: header).validate().responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
