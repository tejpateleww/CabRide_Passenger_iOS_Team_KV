//
//  FAQDetailsViewController.swift
//  TEGO-Driver
//
//  Created by EWW074 on 30/10/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class FAQDetailsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNodataFound: UILabel!
    @IBOutlet weak var imgNoDataFound: UIImageView!
    
    var aryFaqListData = [[String: Any]]()
    var dict = [String:Any]()
    var FAQId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarWithBack(Title: "FAQ Detail", IsNeedRightButton: false)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.imgNoDataFound.isHidden = true
        
        aryFaqListData.append(dict)
        
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
        
//        webserviceOfFAQDetails(FAQTypeId: FAQId)
    }
}


extension FAQDetailsViewController: UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryFaqListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQDetailsListingTableViewCell", for: indexPath) as! FAQDetailsListingTableViewCell
        cell.selectionStyle = .none
        let currentData = self.aryFaqListData[indexPath.row]
        cell.lblQuestions.text = currentData["question"] as? String
        let ans = "\(currentData["answer"] as? String ?? "")"
        cell.lblAnswers.isHidden = true
//        cell.lblAnswers.attributedText = ans.htmlToAttributedString
        cell.txtView.attributedText = ans.htmlToAttributedString
        
        cell.txtView.isUserInteractionEnabled = true
        cell.txtView.isEditable = false
        cell.txtView.dataDetectorTypes = UIDataDetectorTypes.link
        cell.txtView.delegate = self
        cell.txtView.textColor = UIColor.black
        cell.txtView.font = cell.lblAnswers.font
        //Set how links should appear: blue and underlined
        cell.txtView.linkTextAttributes = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        //        lblTermsAndConditions.isHidden = true
        
        cell.txtView.translatesAutoresizingMaskIntoConstraints = true
        cell.txtView.sizeToFit()
        cell.txtView.isScrollEnabled = false
        return cell
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // Open links with a SFSafariViewController instance and return false to prevent the system to open Safari app
        
        print("\n \(URL) \n")
        
        //        if URL.absoluteString.contains("www.apple.com") || URL.absoluteString.contains("itunes.apple.com")  || URL.absoluteString.contains("play.google.com") {
        
        let url = URL
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
     
        return false
    }
}


class FAQDetailsListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var lblAnswers: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}



extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
