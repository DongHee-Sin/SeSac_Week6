//
//  SeSacButton.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

/*
 Swift Attribute (속성)
 @IBInspectable, @IBDesignable, @objc, @escaping, @vailable ...
 */


// 인터페이스 빌더 컴파일 시점 실시간으로 객체 속성을 확인 가능
@IBDesignable
class SeSacButton: UIButton {

    // 인터페이스 빌더의 인스펙터 영역에 보여줌
    @IBInspectable
    var conerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
}
