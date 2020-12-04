//
//  FAQQuestionsViewController.swift
//  TEGO-Driver
//
//  Created by EWW074 on 30/10/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class FAQQuestionsViewController: BaseViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNodataFound: UILabel!
    @IBOutlet weak var imgNoDataFound: UIImageView!
    
    var aryFaqListData = [[String: Any]]()
    var name = String()
    var FAQId = String()
    var FAQSubTypesId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarWithBack(Title: name, IsNeedRightButton: false)
        tableView.tableFooterView = UIView()
//        tableView.separatorStyle = .none
        self.imgNoDataFound.isHidden = true
        webserviceOfFAQDetails(FAQTypeId: FAQId, FAQSubTypesId: FAQSubTypesId)
    }
    
    func webserviceOfFAQDetails(FAQTypeId: String, FAQSubTypesId: String) {
        
        let strURL = ApiKey.FAQ.rawValue + "\(FAQTypeId)/\(FAQSubTypesId)"
        
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


extension FAQQuestionsViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        cell.lblQuestions.text = currentData["question"] as? String
//        cell.lblAnswers.text = "\(indexPath.row + 1). \(currentData["Answers"] as? String ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentData = self.aryFaqListData[indexPath.row]
        let next = self.storyboard?.instantiateViewController(withIdentifier: "FAQDetailsViewController") as! FAQDetailsViewController
        next.dict = currentData
        self.navigationController?.pushViewController(next, animated: true)
    }
}


class FAQQuestionsTableViewCell: UITableViewCell {
    
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
