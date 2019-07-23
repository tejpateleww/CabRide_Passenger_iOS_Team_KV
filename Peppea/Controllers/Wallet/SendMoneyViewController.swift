//
//  SendMoneyViewController.swift
//  Peppea
//
//  Created by eww090 on 12/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation
import SkyFloatingLabelTextField


class SendMoneyViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource,QRCodeReaderViewControllerDelegate,UITextFieldDelegate
{

    
    lazy var reader: QRCodeReader = QRCodeReader()
    @IBOutlet var previewView: QRCodeReaderView!{
        didSet {
            previewView.setupComponents(with: QRCodeReaderViewControllerBuilder {
                $0.reader                 = reader
                $0.showTorchButton        = false
                $0.showSwitchCameraButton = false
                $0.showCancelButton       = false
                $0.showOverlayView        = true
                $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
            })
        }
    }
    
    
    @IBOutlet var btnQR: UIButton!
    @IBOutlet weak var txtmobileNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblReceiverName: UILabel!
    @IBOutlet weak var viewPlaceholderQR: UIView!
    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var iconQRCodePlaceholder: UIImageView!
    
    @IBOutlet weak var iconSelectedPaymentMethod: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblBankCardName: UILabel!
    var pickerView = UIPickerView()
    
    @IBOutlet weak var txtSelectPaymentMethod: UITextField!
    var QRCodeDetailsReqModel : QRCodeDetails = QRCodeDetails()
    var MobileNoDetailReqModel : MobileNoDetail = MobileNoDetail()
    var QRCodeDetailsResult : QRCodeScannedModel = QRCodeScannedModel()
    var aryCards = [CardsList]()
    
    var CardID = String()
    var SCnnedQRCode = String()
    var paymentType = String()
    
    var cardDetailModel : AddCardModel = AddCardModel()
    
    var transferMoneyReqModel : TransferMoneyModel = TransferMoneyModel()
    var LoginDetail : LoginModel = LoginModel()
    
    var strUserType = String()
    
    @IBOutlet var selectGender: [UIImageView]!
    @IBOutlet weak var btnDriver: UIButton!
    @IBOutlet weak var btnCustomer: UIButton!
    var didSelectDriverCustomer: Bool = true
    {
        didSet
        {
            if(didSelectDriverCustomer)
            {
                strUserType = "driver"
                selectGender.first?.image = UIImage(named: "SelectedCircle")
                selectGender.last?.image = UIImage(named: "UnSelectedCircle")
                
                
            }
            else
            {
                strUserType = "customer"
                selectGender.last?.image = UIImage(named: "SelectedCircle")
                selectGender.first?.image = UIImage(named: "UnSelectedCircle")
                
            }
        }
    }
    var didMaxMobileNumberLimit: Bool = false
    {
        didSet
        {
            if(didMaxMobileNumberLimit)
            {
                self.webserviceMobileNoDetails()
            }
            else
            {
        
            }
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        strUserType = "driver"
        txtmobileNumber.delegate = self
        txtmobileNumber.textAlignment = .center
        txtmobileNumber.titleLabel.textAlignment = .center
        self.lblReceiverName.text = ""
        txtmobileNumber.titleFormatter = { $0 }
        
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        do
        {
            LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
            cardDetailModel = try UserDefaults.standard.get(objectType: AddCardModel.self, forKey: "cards")!
            self.aryCards = cardDetailModel.cards
        }
        catch
        {
            AlertMessage.showMessageForError("error")
            return
        }
        pickerView.delegate = self
        previewView.isHidden = true
        viewPlaceholderQR.isHidden = false
        btnQR.isHidden = false
        self.setNavBarWithBack(Title: "Send Money", IsNeedRightButton: false)
        self.lblBankCardName.text = "Select Payment Method"
        self.lblCardNumber.isHidden = true
        iconSelectedPaymentMethod.image = UIImage.init(named: "")
       
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        previewView.isHidden = true
        viewPlaceholderQR.isHidden = false
        btnQR.isHidden = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtmobileNumber
        {
            let resultText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            if textField == txtmobileNumber && range.location == 0 {

                if string == "0" {
                    return false
                }

            }
            if resultText!.count >= 11
            {
//                print("False:-- \(resultText!.count) && \(txtmobileNumber.text)")
//                self.didMaxMobileNumberLimit = true
                return false
            }
            else
            {
//                print("true:-- \(resultText!.count) && \(txtmobileNumber.text)")
//                self.didMaxMobileNumberLimit = false
                return true
            }
        }

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
    
        if textField == txtmobileNumber
        {
            let resultText: String? = (textField.text as String?)//?.replacingCharacters(in: range, with: string)
            
            if resultText!.count == 10
            {
                print("False:-- \(resultText!.count) && \(txtmobileNumber.text)")
                self.didMaxMobileNumberLimit = true
            }
            else
            {
                print("true:-- \(resultText!.count) && \(txtmobileNumber.text)")
                self.didMaxMobileNumberLimit = false
            }
        }
        
        
    }
  
    @IBAction func btnDriverCustomerClicked(_ sender: UIButton)
    {
        
        if(sender.tag == 1) // Male
        {
            strUserType = "driver"
            didSelectDriverCustomer = true
        }
        else if (sender.tag == 2) // Female
        {
            strUserType = "customer"
            didSelectDriverCustomer = false
        }
        
        if txtmobileNumber.text?.count == 10
        {
            self.didMaxMobileNumberLimit = true
        }
        else
        {
           self.didMaxMobileNumberLimit = false
        }
    }
    @IBAction func btnSelectPaymentMethod(_ sender: Any)
    {
//        txtSelectPaymentMethod.inputView = pickerView
    }
    
    @IBAction func txtSelectPaymentMethod(_ sender: UITextField) {
        
        txtSelectPaymentMethod.inputView = pickerView
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
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
        
        let data = aryCards[row]
        
        iconSelectedPaymentMethod.image = UIImage(named: setCardIcon(str: data.cardType)) //UIImage(named: setCardIcon(str: data["Type"] as! String))
        
        self.lblBankCardName.text = data.cardHolderName
        self.lblCardNumber.isHidden = false
        self.lblCardNumber.text = data.formatedCardNo
        self.CardID = data.id
        
        paymentType = "card"
    }
    
    func addNewCard() {
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
//        next.delegateAddCardFromBookLater = self
//        self.isAddCardSelected = false
//        self.navigationController?.present(next, animated: true, completion: nil)
    }
    
    @IBAction func btnScanCodeClicked(_ sender: Any)
    {
        previewView.isHidden = false
        
        viewPlaceholderQR.isHidden = true
        btnQR.isHidden = true
        reader.didFindCode = { result in
            print("Completion with result: \(result.value)")
            
            self.pickerView.isHidden = false
            self.viewPlaceholderQR.isHidden = true
            self.btnQR.isHidden = true
            self.SCnnedQRCode = result.value
            self.webserviceScanQRCode()
            
        }
        
        reader.startScanning()
    }
    func webserviceScanQRCode()
    {
        UtilityClass.showHUD(with: self.view)
        
        
        QRCodeDetailsReqModel.qr_code = self.SCnnedQRCode
        
        UserWebserviceSubclass.scanCodeDetail(QRCodeDetailsModel: QRCodeDetailsReqModel) { (json, status) in
            UtilityClass.hideHUD()
            
            if status
            {
                self.QRCodeDetailsResult = QRCodeScannedModel.init(fromJson: json)
                self.lblReceiverName.text = self.QRCodeDetailsResult.data.firstName + " " + self.QRCodeDetailsResult.data.lastName
                self.txtmobileNumber.text = self.QRCodeDetailsResult.data.mobileNo
            }
            else{
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    
    }
    
    func webserviceMobileNoDetails()
    {
//        UtilityClass.showHUD(with: self.view)
        
        
        MobileNoDetailReqModel.mobile_no = txtmobileNumber.text ?? ""
        MobileNoDetailReqModel.user_type = self.strUserType
        
        UserWebserviceSubclass.MobileNoDetailDetail(MobileNoDetailModel: MobileNoDetailReqModel) { (json, status) in
//            UtilityClass.hideHUD()
            
            if status
            {
                let MobileData = MobileNoResultModel.init(fromJson: json)
                self.lblReceiverName.text = MobileData.data.firstName + " " + MobileData.data.lastName
//                self.txtmobileNumber.text = self.QRCodeDetailsResult.data.mobileNo
            }
            else{
//                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
       
    }
    @IBAction func btnSendMoneyClicked(_ sender: Any)
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
           self.webserciveForTransferMoney()
        }
    }
    
    
    func webserciveForTransferMoney()
    {
        transferMoneyReqModel.qr_code = self.SCnnedQRCode
        transferMoneyReqModel.amount = self.txtAmount.text ?? ""
        transferMoneyReqModel.sender_id = LoginDetail.loginData.id
        UtilityClass.showHUD(with: self.view)
        UserWebserviceSubclass.transferMoney(transferMoneyModel: transferMoneyReqModel) { (json, status) in
            UtilityClass.hideHUD()
            
            if status
            {
                SingletonClass.sharedInstance.walletBalance = json["wallet_balance"].stringValue
                self.navigationController?.popViewController(animated: true)
                AlertMessage.showMessageForSuccess(json["message"].stringValue)
//                self.lblReceiverName.text = json["first_name"].stringValue + " " + json["last_name"].stringValue
//                self.txtmobileNumber.text = json["mobile_no"].stringValue
            }
            else{
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
      
        
    }
}

