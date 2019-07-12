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



class SendMoneyViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource,QRCodeReaderViewControllerDelegate
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
    @IBOutlet weak var txtmobileNumber: UITextField!
    
    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var iconQRCodePlaceholder: UIImageView!
    
    @IBOutlet weak var iconSelectedPaymentMethod: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblBankCardName: UILabel!
    var pickerView = UIPickerView()
    
    @IBOutlet weak var txtSelectPaymentMethod: UITextField!
    
    var aryCards = [[String : AnyObject]]()
    
    var CardID = String()
    var paymentType = String()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        pickerView.delegate = self
        self.setNavBarWithBack(Title: "Send Money", IsNeedRightButton: false)
        self.lblBankCardName.text = "Select Payment Method"
        self.lblCardNumber.isHidden = true
        iconSelectedPaymentMethod.image = UIImage.init(named: "")
        
        var dict = [String:AnyObject]()
        dict["CardNum"] = "HDFC BANK" as AnyObject
        dict["CardNum2"] = "XXXX XXXX XXXX 8967" as AnyObject
        dict["Type"] = "iconVisaCard" as AnyObject
        self.aryCards.append(dict)
        
        dict = [String:AnyObject]()
        dict["CardNum"] = "AXIS BANK" as AnyObject
        dict["CardNum2"] = "XXXX XXXX XXXX 5534" as AnyObject
        dict["Type"] = "iconMasterCard" as AnyObject
        self.aryCards.append(dict)
        
        dict = [String:AnyObject]()
        dict["CardNum"] = "BOB BANK" as AnyObject
        dict["CardNum2"] = "XXXX XXXX XXXX 2211" as AnyObject
        dict["Type"] = "iconDiscover" as AnyObject
        self.aryCards.append(dict)
        
        dict = [String:AnyObject]()
        dict["CardNum"] = "cash" as AnyObject
        dict["CardNum2"] = "cash" as AnyObject
        dict["Type"] = "iconCash" as AnyObject
        self.aryCards.append(dict)
        
        var dict2 = [String:AnyObject]()
        dict2["CardNum"] = "wallet" as AnyObject
        dict2["CardNum2"] = "wallet" as AnyObject
        dict2["Type"] = "iconWallet" as AnyObject
        
        var dict3 = [String:AnyObject]()
        dict3["CardNum"] = "pesapal" as AnyObject
        dict3["CardNum2"] = "pesapal" as AnyObject
        dict3["Type"] = "iconMPesa" as AnyObject
        
//        self.aryCards.append(dict)
        self.aryCards.append(dict2)
        self.aryCards.append(dict3)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        previewView.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: true, reader: reader)
        previewView.isHidden = true
        btnQR.isHidden = false
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
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 1:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 2:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 3:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 4:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 5:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 6:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 7:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 8:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 9:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 10:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let data = aryCards[row]
        
        iconSelectedPaymentMethod.image = UIImage.init(named: data["Type"] as! String) //UIImage(named: setCardIcon(str: data["Type"] as! String))
//        txtSelectPaymentMethod.text = data["CardNum2"] as? String
        
        //        if data["CardNum"] as! String == "Add a Card" {
        //
        //            isAddCardSelected = true
        ////            self.addNewCard()
        //        }
        //
        
//        dict["CardNum"] = "HDFC BANK" as AnyObject
//        dict["CardNum2"] = "XXXX XXXX XXXX 8967" as AnyObject
//        dict["Type"] = "iconVisaCard" as AnyObject
        self.lblBankCardName.text = data["CardNum"] as! String
        self.lblCardNumber.isHidden = false
        self.lblCardNumber.text = data["CardNum2"] as! String
        
        
        let type = data["CardNum"] as! String
        
        if type  == "wallet"
        {
            paymentType = "wallet"
            self.lblBankCardName.text = data["CardNum"] as! String
            self.lblCardNumber.isHidden = true
        }
        else if type == "cash"
        {
            paymentType = "cash"
            self.lblBankCardName.text = data["CardNum"] as! String
            self.lblCardNumber.isHidden = true
        }
        else if type == "card"
        {
            paymentType = "card"
        }
        else {
//            paymentType = "pesapal"
        }
        
        
        //        if paymentType == "card" {
        //
        //            if data["Id"] as? String != "" {
        //                CardID = data["Id"] as! String
        //            }
        //        }
        
        // do something with selected row
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
        btnQR.isHidden = true
        reader.didFindCode = { result in
            print("Completion with result: \(result.value)")      
            
        }
        
        reader.startScanning()
    }
}
