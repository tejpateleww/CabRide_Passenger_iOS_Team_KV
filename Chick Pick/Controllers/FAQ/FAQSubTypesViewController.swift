//
//  FAQSubTypesViewController.swift
//  TEGO-Driver
//
//  Created by EWW074 on 31/10/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class FAQSubTypesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNodataFound: UILabel!
    @IBOutlet weak var imgNoDataFound: UIImageView!
    
    var aryFaqListData = [[String: Any]]()
    var FAQId = String()
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarWithBack(Title: name, IsNeedRightButton: false)
        tableView.tableFooterView = UIView()
//        tableView.separatorStyle = .none
        self.imgNoDataFound.isHidden = true
        webserviceOfFAQDetails(FAQTypeId: FAQId)
    }
    
    func webserviceOfFAQDetails(FAQTypeId: String) {
        
        let strURL = ApiKey.FAQSubCategories.rawValue + FAQTypeId
        
        UserWebserviceSubclass.getAPIcall(strURL: strURL) { (response, status) in
            UtilityClass.hideHUD()
            
            if(status) {
                if let faqListData = response["data"].arrayObject as? [[String: Any]] {
                    self.aryFaqListData = faqListData
                    self.tableView.reloadData()
                    
                    if self.aryFaqListData.count != 0 {
                        self.lblNodataFound.isHidden = true
                        self.tableView.isHidden = false
                        self.imgNoDataFound.isHidden = true
                    } else {
                        self.lblNodataFound.text = "No data found"
                        self.lblNodataFound.isHidden = false
                        self.tableView.isHidden = true
                        self.imgNoDataFound.isHidden = false
                    }
                }
            }
            else {
                self.lblNodataFound.isHidden = false
                self.tableView.isHidden = true
                self.imgNoDataFound.isHidden = false
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}


extension FAQSubTypesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryFaqListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQQuestionsTableViewCell", for: indexPath) as! FAQQuestionsTableViewCell
        
        cell.selectionStyle = .none
        let currentData = self.aryFaqListData[indexPath.row]
        
        let imgView = UIImageView(image: UIImage(named: "iconArrowGray"))
        imgView.frame = CGRect(x: imgView.frame.origin.x, y: imgView.frame.origin.y, width: 20, height: 20)
        imgView.contentMode = .scaleAspectFit
        cell.accessoryView = imgView
        
        cell.lblQuestions.text = currentData["name"] as? String
        //        cell.lblAnswers.text = "\(indexPath.row + 1). \(currentData["Answers"] as? String ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentData = self.aryFaqListData[indexPath.row]
        let next = self.storyboard?.instantiateViewController(withIdentifier: "FAQQuestionsViewController") as! FAQQuestionsViewController
        next.FAQId = "\(currentData["category_id"]!)"
        next.FAQSubTypesId = "\(currentData["id"]!)"
        next.name = currentData["name"] as! String
        self.navigationController?.pushViewController(next, animated: true)
    }
}


class FAQSubTypesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var lblAnswers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
