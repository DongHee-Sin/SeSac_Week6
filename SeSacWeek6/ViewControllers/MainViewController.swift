//
//  MainViewController.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

import Kingfisher

/*
 
 awakeFromNib - Cell UI 초기화, 재사용 메커니즘에 의해 일정 횟수 이상 호출되지 않음
 cellForItemAt :
    - Cell이 재사용 될 때마다, 사용자에게 보일 때마다 항상 실행됨
    - 화면과 데이터는 별개, 모든 indexPath.item(row)에 대한 조건이 없다면 재사용 문제 발생 (기존의 데이터가 남아있음)
 prepareForReuse :
    - 셀이 재사용 될 때 초기화 하고자 하는 값을 넣으면 재사용 문제를 해결할 수 있음. 즉, cellForRowAt에서 모든 조건을 처리하지 않아도 재사용 문제를 해결 가능
 CollectionView in TableView :
    - 하나의 컬렉션뷰, 하나의 테이블뷰만 사용했다면 (단순한 구조라면) index가 꼬이는 문제가 발생하진 않음
    - 복합적인 구조라면, 테이블셀도 재사용 되어야 하고, 컬렉션셀도 재사용이 되어야 함
    - 각 Cell 내부의 CollectionView를 Cell이 재사용될 때마다 reload 시켜주면 Index 꼬이는 문제 해결
        (포함관계에 따라 뭘 reload시켜줄지는 달라질 수 있음 -> 지금은 TableViewCell 내부에 CollectionView가 있는 상황)
 
 */


class MainViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .lightGray, .yellow, .black, .blue]
    
//    let numberList: [[Int]] = [
//        [Int](100...110),
//        [Int](55...75),
//        [Int](1000...1010),
//        [Int](1...7),
//        [Int](77...80),
//        [Int](100...110),
//        [Int](55...75),
//        [Int](1000...1010),
//        [Int](1...7),
//        [Int](77...80)
//    ]
    
    var episodeList: [[String]] = []
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        bannerCollectionView.isPagingEnabled = true  // divice width 기준으로 페이징됨
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        TMDBAPIManager.shared.requestImage { value in
            dump(value)
            // 1. 네트워크 통신   2. 배열 생성   3. 배열에 결과값 담기   4. UI 업데이트
            self.episodeList = value
            
            // 5. reload
            self.mainTableView.reloadData()
        }
    }

}



// MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    // 매개변수로 들어오는 collectionView : 1. banner  2. CollectionView in TableView
    // 매개변수가 아닌 명확한 아웃렛을 사용하여 dequeue를 수행하면, 특정 collectionview의 셀을 재사용하게 됨
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //print("MainViewController", #function, indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        }else {
            cell.cardView.posterImageView.backgroundColor = .black
            
            let url = URL(string: TMDBAPIManager.shared.imageURL + episodeList[collectionView.tag][indexPath.item])
            cell.cardView.posterImageView.kf.setImage(with: url)
            
//            if indexPath.item < 2 {
//                cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
//            }else {
//                cell.cardView.contentLabel.text = "HAPPY"
//            }
        }
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}



// MARK: - Main TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    // 내부 매개변수 tableView를 통해 테이블뷰를 특정
    // 테이블뷰 객체가 하나일 경우에는 내부 매개변수를 활용하지 않아도 문제가 생기지 않는다. -> 어차피 테이블뷰가 하나니까 섞이지 않음
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("MainViewController", #function, indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .yellow
        cell.contentCollectionView.backgroundColor = .clear
        
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        cell.contentCollectionView.tag = indexPath.section
        
        cell.contentCollectionView.reloadData()   // Index가 꼬이는 문제 해결
        
        cell.titleLabel.text = TMDBAPIManager.shared.tvList[indexPath.section].0 + " 다시보기"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

