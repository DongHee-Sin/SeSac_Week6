//
//  CardCollectionViewCell.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    // 변경되지 않는 UI
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //print("CardCollectionViewCell", #function)
        
        setupUI()
    }

    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 10
        cardView.likeButton.tintColor = .systemPink
    }
    
    
    // MARK: - 재사용되기 위해 준비하는 메서드 (reuse되기 전에 호출)
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
