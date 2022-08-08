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
    
    var requestURL: String {
        switch self {
        case .blog: return URL.makeEndPointString("blog?query=")
        case .cafe: return URL.makeEndPointString("cafe?query=")
        }
    }
}
