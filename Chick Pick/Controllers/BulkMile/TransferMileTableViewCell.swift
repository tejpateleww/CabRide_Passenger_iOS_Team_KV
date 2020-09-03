//
//  TransferMileTableViewCell.swift
//  Peppea
//
//  Created by Apple on 09/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class TransferMileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblMiles.layer.borderWidth = 2
        lblMiles.layer.borderColor = UIColor.init(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0).cgColor
        lblMiles.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var submitAction: ((String,String) -> Void)?
    
//    var submitAction(configurationHandler: ((UITextField) -> Void)? = nil)
    
    
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var txtEnterMiles: UITextField!
    @IBOutlet weak var txtEmployeeName: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBAction func btnAction(_ sender: UIButton) {
        
        if (txtEmployeeName.text?.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespaces).isEmpty)! {
            UtilityClass.showAlert(title: AppName.kAPPName, message: "Please enter employee name", alertTheme: .warning)
        } else if (txtEnterMiles.text?.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespaces).isEmpty)! {
            UtilityClass.showAlert(title: AppName.kAPPName, message: "Please enter miles", alertTheme: .warning)
        } else {
            if submitAction != nil {
                submitAction?(txtEmployeeName.text ?? "",txtEnterMiles.text ?? "")
            }
        }
    }
    
}
