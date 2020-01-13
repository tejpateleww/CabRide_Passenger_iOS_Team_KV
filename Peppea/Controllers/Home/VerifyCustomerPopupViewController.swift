//
//  VerifyCustomerPopupViewController.swift
//  Peppea
//
//  Created by EWW074 on 09/01/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit

class VerifyCustomerPopupViewController: UIViewController {

   
    // MARK: - Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblOTP: UILabel!
    
    // MARK: - Variables declaration
    var strMessage = String()
    var strTitle = String()
    var strOTP = String()
    
    
    // MARK: - Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = strTitle
        lblMessage.text = strMessage
        lblOTP.text = strOTP
    }
    
    // MARK: - Actions
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
