//
//  CardView.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

/*
 Xml Interface Builder
 1. UIView Custom Class
 2. File's owner => 확장성(?), 활용도가 높음 > 한 파일에서 여러 View를 사용할 때 제약..?
 */


/*
 View:
 - 인터페이스 빌더 UI 초기화 구문 : required init?
    - 프로토콜 초기화 구문 : required > 초기화 구문이 프로토콜로 명세되어 있음
 - 코드 UI 초기화 구문         : override init
 */

class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    // 초기화
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.backgroundColor = .lightGray
        self.addSubview(view)
    }
    
}
