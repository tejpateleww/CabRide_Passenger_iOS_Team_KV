//
//  ForgotPasswordViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 03/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var lblForgetPW: UILabel!
    
    @IBOutlet weak var txtEmail: ThemeTextFieldLoginRegister!
    @IBOutlet weak var btnResetPw: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func uiSettings(){
        btnResetPw.backgroundColor = ThemeColor
        lblForgetPW.font = UIFont.semiBold(ofSize: 20)
       
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

   
}
