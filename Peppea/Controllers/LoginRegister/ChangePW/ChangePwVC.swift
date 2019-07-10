//
//  ChangePwVC.swift
//  Peppea
//
//  Created by EWW80 on 08/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class ChangePwVC: BaseViewController
{

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtConfirmPw: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtNewPw: ThemeTextFieldLoginRegister!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.backgroundColor = ThemeColor
        
        self.setNavBarWithBack(Title: "Change Password", IsNeedRightButton: false)
        
    }
    

   

}
