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
    var redirectToPaymentList : (() -> ())?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblOTP: UILabel!
    @IBOutlet var btnAction: UIButton!
    var shouldRedirect = Bool()
    // MARK: - Variables declaration
    var strMessage = String()
    var strTitle = String()
    var strOTP = String()
    var strBtnTitle = String()

    
    // MARK: - Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = strTitle
        lblMessage.text = strMessage
        lblOTP.text = strOTP
        btnAction.setTitle(strBtnTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        if(shouldRedirect)
        {
            redirectToPaymentList?()
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    

}
