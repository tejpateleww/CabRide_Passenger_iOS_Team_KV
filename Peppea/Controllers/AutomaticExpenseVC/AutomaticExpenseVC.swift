//
//  AutomaticExpenseVC.swift
//  Peppea
//
//  Created by EWW80 on 08/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class AutomaticExpenseVC: BaseViewController
{

    @IBOutlet weak var lblAllset: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblVarifyEmail: UILabel!
    @IBOutlet weak var txtRideRec: UITextField!
    @IBOutlet weak var txtRidePayment: UITextField!
    @IBOutlet weak var txtTravelReports: UITextField!
    @IBOutlet weak var txtExpenseProvide: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarWithBack(Title: "", IsNeedRightButton: false)
        uiSettings()
        
    }
    
    func uiSettings(){
        btnDone.backgroundColor = ThemeColor
        lblAllset.font = UIFont.semiBold(ofSize: 32)
        lblInfo.font = UIFont.regular(ofSize: 15)
        lblVarifyEmail.font = UIFont.regular(ofSize: 13)
    }
    
    
    
}
