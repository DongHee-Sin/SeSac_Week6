//
//  URL+Extension.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/08.
//

import Foundation

extension URL {
    private static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
