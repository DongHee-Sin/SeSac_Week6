//
//  ViewController.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/08.
//

import UIKit

//import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    // MARK: - Propertys
    var blogList: [String] = []
    var cafeList: [String] = []
    
    var isExpanded = false
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.rowHeight = UITableView.automaticDimension // 모든 섹션의 셀에 대해서 유동적!
        
        searchBlog()
    }
    
    

    // MARK: - Method
    func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { [unowned self] json in
            print(json)
            
            json["documents"].arrayValue.forEach { item in
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                blogList.append(value)
            }
            
            searchCafe()
        }
    }
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { [unowned self] json in
            print(json)
            
            json["documents"].arrayValue.forEach { item in
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                cafeList.append(value)
            }
            
            tableView.reloadData()
        }
    }
    
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        isExpanded.toggle()
        tableView.reloadData()
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoCell", for: indexPath) as? KakaoCell else {
            return UITableViewCell()
        }
        
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        cell.testLabel.numberOfLines = isExpanded ? 0 : 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색 결과" : "카페 검색 결과"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}






// MARK: - Cell
class KakaoCell: UITableViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
}
