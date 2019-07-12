//
//  TransferToBankVC.swift
//  Peppea
//
//  Created by EWW80 on 11/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class TransferToBankVC: BaseViewController
{

    
    @IBOutlet weak var lblWalletAmount: UILabel!
    
    @IBOutlet weak var btnTransferToBank: UIButton!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtAccountHolderName: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtBankName: ThemeTextFieldLoginRegister!
    
    @IBOutlet weak var txtBankAccountNo: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtBankCode: ThemeTextFieldLoginRegister!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.setNavBarWithBack(Title: "Transfer To Bank", IsNeedRightButton: false)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func btnTransferToBankClicked(_ sender: Any)
    {
        
    }
    
}
