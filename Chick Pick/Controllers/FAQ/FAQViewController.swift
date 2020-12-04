//
//  FAQViewController.swift
//  TEGO-Driver
//
//  Created by Apple on 08/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class FAQViewController: BaseViewController {
    
    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var tableView: UITableView!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    var aryFaqListData = [[String: Any]]()

    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarWithBack(Title: "FAQ", IsNeedRightButton: false)
//        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        webserviceOfFAQTypes()
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
   
    func webserviceOfFAQTypes() {
        
        let strURL = ApiKey.FAQList.rawValue
        
        UserWebserviceSubclass.getAPIcall(strURL: strURL) { (response, status) in
            UtilityClass.hideHUD()
            
            if(status) {
                if let faqListData = response["data"].arrayObject as? [[String: Any]] {
                    self.aryFaqListData = faqListData
                    self.tableView.reloadData()
                }
            }
            else {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}


extension FAQViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.aryFaqListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQListingTableViewCell", for: indexPath) as! FAQListingTableViewCell // UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.tintColor = UIColor.black
//        iconArrowGray
        let imgView = UIImageView(image: UIImage(named: "iconArrowGray"))
        imgView.frame = CGRect(x: imgView.frame.origin.x, y: imgView.frame.origin.y, width: 20, height: 20)
        imgView.contentMode = .scaleAspectFit
        cell.accessoryView = imgView
        
//        cell.accessoryType = .disclosureIndicator
        
        let currentData = self.aryFaqListData[indexPath.row]
        cell.lblTitle.text = currentData["name"] as? String
//            cell.detailTextLabel?.text = currentData["Answers"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let currentData = self.aryFaqListData[indexPath.row]
        let next = self.storyboard?.instantiateViewController(withIdentifier: "FAQSubTypesViewController") as! FAQSubTypesViewController
        next.FAQId = "\(currentData["id"]!)"
        next.name = currentData["name"] as! String
        self.navigationController?.pushViewController(next, animated: true)
    }
}


class FAQListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
        // Configure the view for the selected state
    }
    
}
