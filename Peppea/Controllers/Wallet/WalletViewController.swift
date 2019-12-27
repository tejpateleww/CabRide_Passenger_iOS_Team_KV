//
//  WalletViewController.swift
//  Peppea
//
//  Created by EWW80 on 10/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class WalletViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var iconSelectedPaymentMethod: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblBankCardName: UILabel!
    var pickerView = UIPickerView()
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtSelectPaymentMethod: UITextField!
    @IBOutlet weak var viewCardPin: UIView!
    
    var aryCards = [CardsList]()
    
    var CardID = String()
    var paymentType = String()
    var cardDetailModel : AddCardModel = AddCardModel()
    var addMoneyReqModel : AddMoney = AddMoney()
    var LoginDetail : LoginModel = LoginModel()
    var strPaymentType = String()
    @IBOutlet var selectPaymentType: [UIImageView]!
    @IBOutlet weak var lblTotalWalletBalance: UILabel!
    
    
    var didSelectPaymentType: Bool = true
    {
        didSet
        {
            if(didSelectPaymentType)
            {
                strPaymentType = "wallet"
                selectPaymentType.first?.image = UIImage(named: "SelectedCircle")
                selectPaymentType.last?.image = UIImage(named: "UnSelectedCircle")
            }
            else
            {
                strPaymentType = "mpesa"
                selectPaymentType.last?.image = UIImage(named: "SelectedCircle")
                selectPaymentType.first?.image = UIImage(named: "UnSelectedCircle")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.object(forKey: "userProfile") == nil) {
            return
        }
        do {
            LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
            self.lblTotalWalletBalance.text = SingletonClass.sharedInstance.walletBalance//LoginDetail.loginData.walletBalance
            cardDetailModel = try UserDefaults.standard.get(objectType: AddCardModel.self, forKey: "cards")!
            self.aryCards = cardDetailModel.cards
        }
        catch {
            AlertMessage.showMessageForError("error")
            return
        }
        
        pickerView.delegate = self
        
        self.setNavBarWithBack(Title: "Wallet", IsNeedRightButton: true)
        
        self.lblBankCardName.text = "Select Payment Method"
        self.lblCardNumber.isHidden = true
        iconSelectedPaymentMethod.image = UIImage.init(named: "iconcard")
        
        txtAmount.delegate = self
        viewCardPin.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblTotalWalletBalance.text = SingletonClass.sharedInstance.walletBalance//LoginDetail.loginData.walletBalance
    }
    
    @IBAction func btnSendMoneyTapped(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyViewController") as! SendMoneyViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func btnReceiveMoney(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveMoneyViewController") as! ReceiveMoneyViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnTransferToBankTapped(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TransferToBankVC") as! TransferToBankVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnHistoryTapped(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryListViewController") as! HistoryListViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnTopUpTapped(_ sender: Any)
    {
        if txtAmount.text?.count == 0
        {
            AlertMessage.showMessageForError("Please enter amount.")
        }
        else if self.CardID == "" //|| self.CardID == nil
        {
            AlertMessage.showMessageForError("Please select Payment method.")
        }
        else
        {
            addMoneyReqModel.card_id = self.CardID
            addMoneyReqModel.amount = self.txtAmount.text ?? ""
            addMoneyReqModel.customer_id = LoginDetail.loginData.id
            UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
            UserWebserviceSubclass.AddMoneytoWallet(addMoneyModel: addMoneyReqModel) { (json, status) in
                UtilityClass.hideHUD()
                if status
                {
                    self.lblTotalWalletBalance.text = json["wallet_balance"].stringValue
                    SingletonClass.sharedInstance.walletBalance = json["wallet_balance"].stringValue
                    AlertMessage.showMessageForSuccess(json["message"].stringValue)
                    self.txtAmount.text = ""
                }
                else
                {
                    AlertMessage.showMessageForError("error")
                }
            }
        }
    }
    
    @IBAction func btnSelectPaymentOption(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        next.delegate = self
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    @IBAction func txtSelectPaymentMethod(_ sender: UITextField) {
        //        self.performSegue(withIdentifier: "", sender: <#T##Any?#>)
        //        txtSelectPaymentMethod.inputView = pickerView
    }
    
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
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aryCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let data = aryCards[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let centerOfmyView = myView.frame.size.height / 4
        
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:centerOfmyView, width:40, height:26))
        myImageView.contentMode = .scaleAspectFit
        
        var rowString = String()
        
        switch row {
            
        case 0:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 1:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 2:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 3:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 4:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 5:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 6:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 7:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 8:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 9:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 10:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
        //        myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
       
        return myView
    }
    
    var isAddCardSelected = Bool()
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if aryCards.count != 0 {
            let data = aryCards[row]
            
            iconSelectedPaymentMethod.image = UIImage(named: setCardIcon(str: data.cardType)) //UIImage(named: setCardIcon(str: data["Type"] as! String))
            
            self.lblBankCardName.text = data.cardHolderName
            self.lblCardNumber.isHidden = false
            self.lblCardNumber.text = data.formatedCardNo
            self.CardID = data.id
            
            paymentType = "card"
        }        
    }
    
    @IBAction func btnPaymentTypeClicked(_ sender: UIButton)
    {
        if(sender.tag == 1) // Male
        {
            strPaymentType = "card"
            didSelectPaymentType = true
        }
        else if (sender.tag == 2) // Female
        {
            strPaymentType = "mpesa"
            didSelectPaymentType = false
        }
    }
}

extension WalletViewController: didSelectPaymentDelegate {
    func didSelectPaymentType(PaymentType: String, PaymentTypeID: String, PaymentNumber: String, PaymentHolderName: String, dictData: [String : Any]?) {
        
    }
}

extension WalletViewController: selectPaymentOptionDelegate {
    
    func selectPaymentOption(option: Any) {
        
        if let currentData = option as? [String:AnyObject] {
            if let selectedType = currentData["card_type"] as? String {
                if selectedType == "MPesa" {
                    self.lblBankCardName.isHidden = false
                    self.lblCardNumber.isHidden = true
                    self.viewCardPin.isHidden = true
                    self.lblBankCardName.text = "M-Pesa"
                    self.iconSelectedPaymentMethod.image = UIImage(named: "iconMPesa")
                     self.iconSelectedPaymentMethod.layer.cornerRadius = 10
                } else {
                    self.lblBankCardName.isHidden = false
                    self.lblCardNumber.isHidden = false
                    self.viewCardPin.isHidden = false
                    
                    let type = currentData["card_type"] as! String
                    self.iconSelectedPaymentMethod.image = UIImage(named: setCreditCardImage(str: type))
                    iconSelectedPaymentMethod.layer.cornerRadius = 10
                    self.lblBankCardName.text = currentData["card_holder_name"] as? String
                    self.lblCardNumber.text = currentData["formated_card_no"] as? String
                }
            }
        }
    }
}
