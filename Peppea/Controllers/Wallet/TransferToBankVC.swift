//
//  TransferToBankVC.swift
//  Peppea
//
//  Created by EWW80 on 11/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

enum PhoneType : String {
    case My = "my"
    case Other = "other"
}

import UIKit

class TransferToBankVC: BaseViewController
{

    //MARK:- IBOutlets
    
    @IBOutlet weak var lblWalletAmount: UILabel!
    
    @IBOutlet weak var btnTransferToBank: UIButton!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtAccountHolderName: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtBankName: ThemeTextFieldLoginRegister!
    
    @IBOutlet weak var txtBankAccountNo: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtBankCode: ThemeTextFieldLoginRegister!
    
    
    @IBOutlet weak var VwAmount: UIView!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnMyOption: UIButton!
    @IBOutlet weak var btnOtherOption: UIButton!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    
    
    
    //MARK:- Variables
    
    
    var transferToBankReqModel : transferMoneyToBank = transferMoneyToBank()
    var LoginDetails : LoginModel = LoginModel()
    
    var PhoneNumberType:PhoneType = .My {
        didSet {
            self.btnMyOption.isSelected = false
            self.btnOtherOption.isSelected = false
            switch self.PhoneNumberType {
            case .My:
                self.btnMyOption.isSelected = true
                self.txtPhoneNumber.text = LoginDetails.loginData.mobileNo
                self.viewPassword.isHidden = true
            case .Other:
                self.btnOtherOption.isSelected = true
                self.txtPhoneNumber.text = ""
                self.viewPassword.isHidden = false
            }
        }
    }
    
    
    var PhoneTypes:Int = 0 {
        didSet {
            switch self.PhoneTypes {
            case 0:
                self.PhoneNumberType = .My
            case 1:
                self.PhoneNumberType = .Other
            default:
                break
            }
        }
    }
    
    //MARK:- View Life Cycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setNavBarWithBack(Title: "Wallet To Mpesa", IsNeedRightButton: true)
        self.lblWalletAmount.text = Currency + " " + SingletonClass.sharedInstance.walletBalance
        
        txtAmount.delegate = self
        self.txtAmount.setCurrencyLeftView()
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
        self.lblWalletAmount.text = Currency + " " + SingletonClass.sharedInstance.walletBalance//LoginDetail.loginData.walletBalance
        self.PhoneNumberType = .My
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- IBAction Methods
    
    @IBAction func btnSelectPhoneType(_ sender: UIButton) {
        self.PhoneTypes = sender.tag
    }
    
    
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
        /*
        let profile = LoginDetails.loginData
        transferToBankReqModel.customer_id = profile!.id
        transferToBankReqModel.amount = txtPrice.text ?? ""
        transferToBankReqModel.account_holder_name = txtAccountHolderName.text ?? ""
        transferToBankReqModel.bank_name = txtBankName.text ?? ""
        transferToBankReqModel.bank_branch = txtBankCode.text ?? ""
        transferToBankReqModel.account_number = txtBankAccountNo.text ?? ""
        */
        
       
        
        if(self.validations().0 == false)
        {
            AlertMessage.showMessageForError(self.validations().1)
        }
        else
        {
            let MpesaReqModel = transferMoneyToMpesa()
            MpesaReqModel.customer_id = LoginDetails.loginData.id
            MpesaReqModel.amount = self.txtAmount.text!
            MpesaReqModel.mobile_no = self.txtPhoneNumber.text!
            MpesaReqModel.type = self.PhoneNumberType.rawValue
            self.webServiceForWalletToMpesa(transferToMpesaReqModel: MpesaReqModel)
//            self.webserviceForTransferToBank(transferToBankReqModel: transferToBankReqModel)
        }
    }

    
}


    //MARK:- Textfield Delegate Methods

extension TransferToBankVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtAmount {
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
    
}


//MARK:- Webservice & Custom Methods

extension TransferToBankVC {
    
    func webserviceForTransferToBank(transferToBankReqModel : transferMoneyToBank)
    {
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        
        UserWebserviceSubclass.transferMoneyToBank(transferMoneyToBankModel: transferToBankReqModel) { (json, status) in
            UtilityClass.hideHUD()
            if status
            {
                UtilityClass.hideHUD()
                SingletonClass.sharedInstance.walletBalance = json["wallet_balance"].stringValue
                self.lblWalletAmount.text = Currency + " " + SingletonClass.sharedInstance.walletBalance
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
    
    func webServiceForWalletToMpesa(transferToMpesaReqModel : transferMoneyToMpesa) {
        
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        UserWebserviceSubclass.transferMoneyToMPesa(transferMoneyToMpesaModel: transferToMpesaReqModel) { (json, status) in
        
            UtilityClass.hideHUD()
            if status
            {
                UtilityClass.hideHUD()
                SingletonClass.sharedInstance.walletBalance = json["wallet_balance"].stringValue
                self.lblWalletAmount.text = Currency + " " + SingletonClass.sharedInstance.walletBalance
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
    
    
    func validations() -> (Bool,String) {
        
        if self.txtAmount.text!.isBlank {
            return (false,"Please enter Amount")
        }
        else if self.txtPhoneNumber.text!.isBlank {
            return (false,"Please enter phone number")
        }
        else if self.txtPhoneNumber.text!.count < 10 {
            return (false,"Please enter valid phone number")
        }
        
        return (true,"")
    }
    
    /*
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
     */
    
}
