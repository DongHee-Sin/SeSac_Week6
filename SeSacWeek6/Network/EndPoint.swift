//
//  EndPoint.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/08.
//

import Foundation

enum EndPoint {
    case blog
    case cafe
    case naverCFR
    
    var requestURL: String {
        switch self {
        case .blog: return URL.makeEndPointString("blog?query=")
        case .cafe: return URL.makeEndPointString("cafe?query=")
        case .naverCFR: return "https://openapi.naver.com/v1/vision/celebrity"
        }
    }
}
