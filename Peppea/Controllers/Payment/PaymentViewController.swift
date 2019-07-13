//
//  PaymentViewController.swift
//  Peppea
//
//  Created by eww090 on 12/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import FormTextField


class PaymentViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource
{

    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewPaymentPopup: UIView!
    
    var pickerViewExpiry = UIPickerView()
    var strSelectMonth = String()
    var strSelectYear = String()
    
    var validation = Validation()
    var inputValidator = InputValidator()
    var creditCardValidator: CreditCardValidator!
    var isCreditCardValid = Bool()
    var cardTypeLabel = String()
    var CardNumber = String()
    var strMonth = String()
    var strYear = String()
    var strCVV = String()
    
    var aryTempMonth = [String]()
    var aryTempYear = [String]()
    
    
    @IBOutlet weak var txtCardNumber: FormTextField!
    @IBOutlet weak var txtValidThrough: FormTextField!
    @IBOutlet weak var txtCVVNumber: FormTextField!
    @IBOutlet weak var txtCArdHolderName: UITextField!
    
    var aryMonth = [String]()
    var aryYear = [String]()
    
    var aryCardData = [[String : AnyObject]]()
    var aryOtherPayment = [[String : AnyObject]]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        creditCardValidator = CreditCardValidator()
        
        aryMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        
        aryTempMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        
       
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        
        for i in (year..<(year + 50)).reversed()
        {
            aryTempYear.append("\(i)")
        }
        
        aryYear = aryTempYear
        
        
        var dict2 = [String:AnyObject]()
        dict2["CardNum"] = "cash" as AnyObject
        dict2["CardNum2"] = "cash" as AnyObject
        dict2["Type"] = "iconCash" as AnyObject
        self.aryOtherPayment.append(dict2)
        
        
        var dict3 = [String:AnyObject]()
        dict3["CardNum"] = "M-Pesa" as AnyObject
        dict3["CardNum2"] = "M-Pesa" as AnyObject
        dict3["Type"] = "iconMPesa" as AnyObject
        self.aryOtherPayment.append(dict3)
        
        var dict = [String:AnyObject]()
        dict["CardNum"] = "HDFC BANK" as AnyObject
        dict["CardNum2"] = "XXXX XXXX XXXX 8967" as AnyObject
        dict["Type"] = "iconVisaCard" as AnyObject
        self.aryCardData.append(dict)
        
        dict = [String:AnyObject]()
        dict["CardNum"] = "AXIS BANK" as AnyObject
        dict["CardNum2"] = "XXXX XXXX XXXX 5534" as AnyObject
        dict["Type"] = "iconMasterCard" as AnyObject
        self.aryCardData.append(dict)
        
        dict = [String:AnyObject]()
        dict["CardNum"] = "BOB BANK" as AnyObject
        dict["CardNum2"] = "XXXX XXXX XXXX 2211" as AnyObject
        dict["Type"] = "iconDiscover" as AnyObject
        self.aryCardData.append(dict)
        
//        viewPaymentPopup.roundCorners([.topRight,.topLeft], radius: 12)
      
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setNavBarWithBack(Title: "Payment", IsNeedRightButton: false)
        cardNum()
        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - PicketView Methods
    //-------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return aryMonth.count
        }
        else {
            return aryYear.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return aryMonth[row]
        }
        else {
            return aryYear[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 1 {
            if currentYear == aryYear[row] {
                
                aryYear.removeFirst(row)
                for i in 0..<aryMonth.count {
                    if currentMonth == aryMonth[i] {
                        aryMonth.removeFirst(i - 1)
                    }
                }
                pickerViewExpiry.reloadComponent(0)
            }
            else {
                aryMonth = aryTempMonth
                aryYear = aryTempYear
                
                pickerViewExpiry.reloadComponent(0)
            }
        }
        
        if component == 0 {
            strSelectMonth = aryMonth[row]
        }
        else {
            strSelectYear = aryYear[row]
            strSelectYear.removeFirst(2)
        }
        
        txtValidThrough.text = "\(strSelectMonth)/\(strSelectYear)"
    }
    
    var currentMonth = String()
    var currentYear = String()
    
    func findCurrentMonthAndYear() {
        
        let now = NSDate()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let curMonth = monthFormatter.string(from: now as Date)
        print("currentMonth : \(curMonth)")
        currentMonth = curMonth
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let curYear = yearFormatter.string(from: now as Date)
        print("currentYear : \(curYear)")
        currentYear = curYear
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let countdots = (textField.text?.components(separatedBy: ".").count)! - 1
        
        if countdots > 0 && string == "."
        {
            return false
        }
        return true
    }
    func cardNum()
    {
//        txtCardNumber.inputType = .integer
        txtCardNumber.formatter = CardNumberFormatter()
        txtCardNumber.placeholder = "Card Number"
        
        
        validation.maximumLength = 19
        validation.minimumLength = 14
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        inputValidator = InputValidator(validation: validation)
        
        txtCardNumber.inputValidator = inputValidator
        
        cardExpiry()
    }
    
    func cardExpiry()
    {
        txtValidThrough.inputType = .integer
        txtValidThrough.formatter = CardExpirationDateFormatter()
        txtValidThrough.placeholder = "Exp. Date (MM/YY)"
        
        //        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        txtValidThrough.inputValidator = inputValidator
        
        cardCVV()
        print("")
        
    }
    
    func cardCVV() {
        
        txtCVVNumber.inputType = .integer
        txtCVVNumber.placeholder = "CVV"
        
        //        var validation = Validation()
        
        if self.cardTypeLabel == "Amex" {
            self.validation.maximumLength = 4
            self.validation.minimumLength = 3
        }
        else {
            self.validation.maximumLength = 3
            self.validation.minimumLength = 3
        }
        
        
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        txtCVVNumber.inputValidator = inputValidator
        
        //        print("txtCVV.text : \(txtCVV.text)")
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        //        resultLabel.text = "user canceled"
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            _ = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            //            resultLabel.text = str as String
            txtCardNumber.text = info.redactedCardNumber
            txtValidThrough.text = "\(info.expiryMonth)/\(info.expiryYear)"
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func txtValidThrough(_ sender: UITextField) {
        
        txtValidThrough.inputView = pickerViewExpiry
        
    }
    
    @IBAction func txtCardNumber(_ sender: UITextField) {
        
        if let number = sender.text {
            if number.isEmpty {
                isCreditCardValid = false
                
                //                imgCard.image = UIImage(named: "iconDummyCard")
                //                self.cardValidationLabel.text = "Enter card number"
                //                self.cardValidationLabel.textColor = UIColor.black
                //
                //                self.cardTypeLabel.text = "Enter card number"
                //                self.cardTypeLabel.textColor = UIColor.black
            } else
            {
                validateCardNumber(number: number)
                detectCardNumberType(number: number)
            }
        }
    }
    
    func validateCardNumber(number: String) {
        if creditCardValidator.validate(string: number) {
            
            isCreditCardValid = true
            
            //            self.cardValidationLabel.text = "Card number is valid"
            //            self.cardValidationLabel.textColor = UIColor.green
        } else {
            
            isCreditCardValid = false
            
            //            imgCard.image = UIImage(named: "iconDummyCard")
            //            self.cardValidationLabel.text = "Card number is invalid"
            //            self.cardValidationLabel.textColor = UIColor.red
        }
    }
    
    func detectCardNumberType(number: String)
    {
        if let type = creditCardValidator.type(from: number) {
            
            isCreditCardValid = true
            
            self.cardTypeLabel = type.name
            
            print(type.name)
            
            //            imgCard.image = UIImage(named: type.name)
            
            self.cardCVV()
            
            
            //            self.cardTypeLabel.textColor = UIColor.green
        }
        else
        {
            
            //            imgCard.image = UIImage(named: "iconDummyCard")
            
            isCreditCardValid = false
            
            self.cardTypeLabel = "Undefined"
            //            self.cardTypeLabel.textColor = UIColor.red
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if section == 0
        {
            return aryOtherPayment.count
        }
        else
        {
            return aryCardData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentWalletTypeListCell") as! PaymentWalletTypeListCell
            
            cell.selectionStyle = .none
            
            //        cell.viewAddress.layer.cornerRadius = 10
            //        cell.viewAddress.clipsToBounds = true
            //        cell.viewPrice.layer.cornerRadius = 5
            //        cell.viewPrice.clipsToBounds = true
            //        if btnCityDestination.isSelected
            //        {
            //            let dictTemp = arrFlatRateListCityDEstination[indexPath.row]
            //
            //            cell.lblPickupLocation.text = dictTemp["PickupLocation"] as! String
            //            cell.lblDropOffLocation.text = dictTemp["DropoffLocation"] as! String
            //
            //            var flatRatePrice = String()
            //
            //            if let price = dictTemp["Price"] as? Int
            //            {
            //                flatRatePrice = "$ \(String(price))"
            //            }
            //            else if let tripprice = dictTemp["Price"] as? String
            //            {
            //                flatRatePrice = "$ \(tripprice)"
            //            }
            //            cell.btnPrice.setTitle(flatRatePrice, for: .normal)
            //        }
            //        else
            //        {
            //             let dictTemp = arrFlatRateListCityDEstination[indexPath.row]
            //            cell.lblPickupLocation.text = dictTemp["PickupLocation"] as! String
            //            cell.lblDropOffLocation.text = dictTemp["DropoffLocation"] as! String
            //        }
            let data = aryOtherPayment[indexPath.row]
            cell.iconWallet.image = UIImage.init(named: data["Type"] as! String)
            cell.lblTitle.text = data["CardNum"] as! String
        
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCardTypeListCell") as! PaymentCardTypeListCell
            let data = aryCardData[indexPath.row]
            cell.selectionStyle = .none
            cell.iconCard.image = UIImage.init(named: data["Type"] as! String)
            cell.lblTitle.text = data["CardNum"] as! String
        
            cell.lblCardNumber.text = data["CardNum2"] as! String
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tblView.deselectRow(at: indexPath, animated: true)
    }
    
   

}
