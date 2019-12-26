//
//  TransferToBankVC.swift
//  Peppea
//
//  Created by EWW80 on 11/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class TransferToBankVC: BaseViewController, UITextFieldDelegate
{

    
    @IBOutlet weak var lblWalletAmount: UILabel!
    
    @IBOutlet weak var btnTransferToBank: UIButton!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtAccountHolderName: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtBankName: ThemeTextFieldLoginRegister!
    
    @IBOutlet weak var txtBankAccountNo: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtBankCode: ThemeTextFieldLoginRegister!
    
    var transferToBankReqModel : transferMoneyToBank = transferMoneyToBank()
    var LoginDetails : LoginModel = LoginModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setNavBarWithBack(Title: "Transfer To Bank", IsNeedRightButton: true)
        self.lblWalletAmount.text = SingletonClass.sharedInstance.walletBalance
        
        txtPrice.delegate = self
        
        do {
            LoginDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.lblWalletAmount.text = SingletonClass.sharedInstance.walletBalance//LoginDetail.loginData.walletBalance
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPrice {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                return true
            case ".":
                let array = Array(textField.text ?? "")
                var decimalCount = 0
                for character in array {
                    if character == "." {
                        decimalCount += 1
                    }
                }
                
                if decimalCount == 1 {
                    return false
                } else {
                    return true
                }
            default:
                let array = Array(string)
                if array.count == 0 {
                    return true
                }
                return false
            }
        }
        
        return true
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
        /*
         "customer_id:1
         amount:10
         account_holder_name:mayur
         bank_name:patel
         bank_branch:SBI
         account_number:986532124578"
         */
        
        
        let profile = LoginDetails.loginData
        transferToBankReqModel.customer_id = profile!.id
        transferToBankReqModel.amount = txtPrice.text ?? ""
        transferToBankReqModel.account_holder_name = txtAccountHolderName.text ?? ""
        transferToBankReqModel.bank_name = txtBankName.text ?? ""
        transferToBankReqModel.bank_branch = txtBankCode.text ?? ""
        transferToBankReqModel.account_number = txtBankAccountNo.text ?? ""
        
        if(self.validations().0 == false)
        {
            AlertMessage.showMessageForError(self.validations().1)
        }
        else
        {
            self.webserviceForTransferToBank(transferToBankReqModel: transferToBankReqModel)
        }
    }
    func webserviceForTransferToBank(transferToBankReqModel : transferMoneyToBank)
    {
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        
        UserWebserviceSubclass.transferMoneyToBank(transferMoneyToBankModel: transferToBankReqModel) { (json, status) in
            UtilityClass.hideHUD()
            if status
            {
                UtilityClass.hideHUD()
                SingletonClass.sharedInstance.walletBalance = json["wallet_balance"].stringValue
                self.lblWalletAmount.text = SingletonClass.sharedInstance.walletBalance
                self.navigationController?.popViewController(animated: true)
                 AlertMessage.showMessageForSuccess(json["message"].stringValue)
            }
            else
            {
                UtilityClass.hideHUD()
                 AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
    func validations() -> (Bool,String)
    {
        if(transferToBankReqModel.amount.isBlank)
        {
            return (false,"Please enter Amount")
        }
        else if(transferToBankReqModel.account_holder_name.isBlank)
        {
            return (false,"Please enter account holder name")
        }
        else if(transferToBankReqModel.bank_name.isBlank)
        {
            return (false,"Please enter bank name")
        }
        else if(transferToBankReqModel.bank_branch.isBlank)
        {
            return (false,"Please enter bank branch")
        }
        else if(transferToBankReqModel.account_number.isBlank)
        {
            return (false,"Please enter account number")
        }
        return (true,"")
    }
    
}
