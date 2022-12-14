//
//  MainTableViewCell.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //print("MainTableViewCell", #function)
        
        setupUI()
    }


    func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "넷플릭스 인기 컨텐츠"
        titleLabel.backgroundColor = .clear
        
        contentCollectionView.backgroundColor = .clear
        contentCollectionView.collectionViewLayout = collectionViewLayout()
    }
}



extension MainTableViewCell {
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 110)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return layout
    }
    
}
