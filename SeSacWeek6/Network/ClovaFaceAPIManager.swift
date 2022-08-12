//
//  ClovaFaceAPIManager.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/12.
//

import UIKit

import Alamofire
import SwiftyJSON

class ClovaFaceAPIManager {
    
    static let shared = ClovaFaceAPIManager()
    private init() {}
    
    func requestCFR(image: UIImage) {
        let url = EndPoint.naverCFR.requestURL
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientID,
            "X-Naver-Client-Secret": APIKey.naverClientSecret,
            "Content-Type": "multipart/form-data"    // Content-Type은 기본값이 라이브러리에 내장되어 있음
        ]
        
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image")
        }, to: url, headers: header)
        .validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
