//
//  PaymentViewController.swift
//  Peppea
//
//  Created by eww090 on 12/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import FormTextField
import SwipeCellKit

protocol didSelectPaymentDelegate {
    
    func didSelectPaymentType(PaymentTypeTitle:String, PaymentType:String, PaymentTypeID:String, PaymentNumber: String, PaymentHolderName:String, dictData: [String:Any]?, isForPaymentDue: Bool?)
    
    func removeCard(PaymentTypeID: String)
}

class PaymentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, UITextFieldDelegate
{
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewPaymentPopup: UIView!
    @IBOutlet weak var constraintHeightOfTableView: NSLayoutConstraint! // 229
    
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
    var isFlatRateSelected:Bool = false
    var PagefromBulkMiles:Bool = false
    var OpenedForPayment:Bool = false
    var isForPaymentDue:Bool = false
    var Delegate:didSelectPaymentDelegate!
    
    @IBOutlet weak var btnAddCard: ThemeButton!
    var aryTempMonth = [String]()
    var aryTempYear = [String]()
    
    @IBOutlet weak var txtCardNumber: FormTextField!
    @IBOutlet weak var txtValidThrough: FormTextField!
    @IBOutlet weak var txtCVVNumber: FormTextField!
    @IBOutlet weak var txtCArdHolderName: FormTextField!
    
    var LoginDetail : LoginModel = LoginModel()
    var addCardReqModel : AddCard = AddCard()
    var CardListReqModel : CardList = CardList()
    var RemoveCardReqModel : RemoveCard = RemoveCard()
    
    
    var aryMonth = [String]()
    var aryYear = [String]()
    
    var aryCardData = [CardsList]()//[[String : AnyObject]]()
    var aryOtherPayment = [[String : AnyObject]]()
    
    var isComingFromPeppeaRental = false
    var isFromSideMenu = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtValidThrough.delegate = self

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
        
        if self.PagefromBulkMiles  == false {
            
            var dict5 = [String:AnyObject]()
            dict5["CardNum"] = "M-Pesa" as AnyObject
            dict5["CardNum2"] = "m_pesa" as AnyObject
            dict5["Type"] = "iconMPesa" as AnyObject
//            self.aryOtherPayment.append(dict5)
            
            var dict2 = [String:AnyObject]()
            dict2["CardNum"] = "Cash" as AnyObject
            dict2["CardNum2"] = "cash" as AnyObject
            dict2["Type"] = "iconCash" as AnyObject
//            self.aryOtherPayment.append(dict2)
            
            if SingletonClass.sharedInstance.loginData.userType == "under_company" {
                var dict4 = [String:AnyObject]()
                dict4["CardNum"] = "My Mile Balance" as AnyObject
                dict4["CardNum2"] = "bulk_miles" as AnyObject
                dict4["Type"] = "iconMilesText" as AnyObject
//                self.aryOtherPayment.append(dict4)
                
                var dict5 = [String:AnyObject]()
                dict5["CardNum"] = "Corporate Mile Balance(0.00)" as AnyObject
                dict5["CardNum2"] = "co_bulk_miles" as AnyObject
                dict5["Type"] = "iconMPesa" as AnyObject
//                self.aryOtherPayment.append(dict5)
            } else {
                var dict4 = [String:AnyObject]()
                dict4["CardNum"] = "My Mile Balance" as AnyObject
                dict4["CardNum2"] = "bulk_miles" as AnyObject
                dict4["Type"] = "iconMilesText" as AnyObject
//                self.aryOtherPayment.append(dict4)
            }
            
            var dict3 = [String:AnyObject]()
            dict3["CardNum"] = "Wallet" as AnyObject
            dict3["CardNum2"] = "wallet" as AnyObject
            dict3["Type"] = "iconWalletColor" as AnyObject
//            self.aryOtherPayment.append(dict3)
        }
        
        tblView.reloadData()
        tblView.layoutIfNeeded()
        self.constraintHeightOfTableView.constant = self.tblView.contentSize.height
        /*
         
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
        */
//        viewPaymentPopup.roundCorners([.topRight,.topLeft], radius: 12)
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        do {
            LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
      
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if isComingFromPeppeaRental {
            ///Peppea Rental flow
            
        }else{
//            if isFromSideMenu {
                ///Normal Peppea flow
                self.webserviceForCardList()
//            } else {
//                viewPaymentPopup.isHidden = true
//                constraintHeightOfTableView.constant = CGFloat(60 * aryOtherPayment.count)
//            }
        }
//        self.setNavBarWithBack(Title: "Payment", IsNeedRightButton: true)
        self.setNavBarWithBack(Title: "Payment", IsNeedRightButton: false)
//        cardNum()
        cardHolder()
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
//        let countdots = (textField.text?.components(separatedBy: ".").count)! - 1
//
//        if countdots > 0 && string == "."
//        {
//            return false
//        }
        
        if textField == txtValidThrough && string == "" {
            textField.text = txtValidThrough.formatter?.formatString(textField.text ?? string, reverse: true)
        }
        return true
    }
    
    func cardHolder()
    {
        txtCArdHolderName.inputType = .name
        txtCArdHolderName.placeholder = "Card Holder"
        
        let characterSet = NSMutableCharacterSet.letter()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        inputValidator = InputValidator(validation: validation)
        
        txtCArdHolderName.inputValidator = inputValidator
        
        cardNum()
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
            let data = aryOtherPayment[indexPath.row]
            cell.iconWallet.image = UIImage.init(named: data["Type"] as! String)
            cell.iconWallet.tintColor = .white
//            cell.iconWallet.setImageColor(color: .white)
            cell.lblTitle.text = data["CardNum"] as? String
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCardTypeListCell") as! PaymentCardTypeListCell
            let data = aryCardData[indexPath.row]
            cell.selectionStyle = .none
            cell.delegate = self

            cell.iconCard.image = UIImage(named: setCardIcon(str: data.cardType.lowercased()))//UIImage.init(named: data["Type"] as! String)
            cell.lblTitle.text = data.cardHolderName
            cell.iconCard.tintColor = .white
            cell.lblCardNumber.text = data.formatedCardNo
            return cell
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        var strCardID = String()
        
        if indexPath.section != 0
        {
            let data = aryCardData[indexPath.row]
            strCardID = data.id
        }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            UtilityClass.showDefaultAlertView(withTitle: AppName.kAPPName, message: "Are you sure you want to delete card?", buttons: ["Delete","Cancel"], completion: { (index) in
                if(index == 0)
                {
                    self.webserviceForDeleteCardFromList(strCardID)
                }
            })
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.OpenedForPayment {
            if indexPath.section == 0
            {
                let PaymentObject = self.aryOtherPayment[indexPath.row]
                if (self.isFlatRateSelected == true) && ((PaymentObject["CardNum2"] as! String) != "bulk_miles") {
                    self.dismiss(animated: true) {
                        self.Delegate.didSelectPaymentType(PaymentTypeTitle: PaymentObject["CardNum"] as! String, PaymentType:  PaymentObject["CardNum2"] as! String, PaymentTypeID: "", PaymentNumber: "", PaymentHolderName: "", dictData: PaymentObject, isForPaymentDue: false)
                    }
                } else if self.isFlatRateSelected == false {
                    if self.PagefromBulkMiles == true {
                        self.Delegate.didSelectPaymentType(PaymentTypeTitle: PaymentObject["CardNum"] as! String, PaymentType:  PaymentObject["CardNum2"] as! String, PaymentTypeID: "", PaymentNumber: "", PaymentHolderName: "", dictData: PaymentObject, isForPaymentDue: false)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true) {
                            self.Delegate.didSelectPaymentType(PaymentTypeTitle: PaymentObject["CardNum"] as! String, PaymentType:  PaymentObject["CardNum2"] as! String, PaymentTypeID: "", PaymentNumber: "", PaymentHolderName: "", dictData: PaymentObject, isForPaymentDue: false)
                        }
                    }
                }
            }
            else
            {
                if self.PagefromBulkMiles == true {
                    let card = self.aryCardData[indexPath.row]
                    
                    self.Delegate.didSelectPaymentType(PaymentTypeTitle: card.cardHolderName, PaymentType: "card" , PaymentTypeID: card.id, PaymentNumber: card.formatedCardNo, PaymentHolderName: card.cardHolderName, dictData: card.toDictionary(), isForPaymentDue: false)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true) {
                        let card = self.aryCardData[indexPath.row]
                        self.Delegate.didSelectPaymentType(PaymentTypeTitle: card.cardHolderName, PaymentType: "card" , PaymentTypeID: card.id, PaymentNumber: card.formatedCardNo, PaymentHolderName: card.cardHolderName, dictData: card.toDictionary(), isForPaymentDue: self.isForPaymentDue)
                    }
                }
            }
        }
//        self.tblView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func btnAddCardClicked(_ sender: Any)
    {
        
        if isComingFromPeppeaRental {
            print("Not processing if coming from Peppea Rental")
            return
        }
        self.webserviceforAddnewCard()
    }
    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//        self.constraintHeightOfTableView.constant = self.tblView.contentSize.height
//    }
    
    func webserviceForDeleteCardFromList(_ strCardId : String)
    {
        RemoveCardReqModel.card_id = strCardId
        RemoveCardReqModel.customer_id = LoginDetail.loginData.id
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        
        UserWebserviceSubclass.RemoveCardFromList(removeCardModel: RemoveCardReqModel) { (json, status) in
            UtilityClass.hideHUD()
            if status {
                if (self.navigationController?.children.first as? PaymentViewController) != nil {
                     self.Delegate.removeCard(PaymentTypeID: strCardId)
                }
                self.webserviceForCardList()
            }
            else {
                AlertMessage.showMessageForError("error")
            }
        }
    }
    
    func webserviceForCardList()
    {
        self.aryCardData.removeAll()
        CardListReqModel.customer_id = LoginDetail.loginData.id
//        UtilityClass.showHUD(with: self.view)
        UserWebserviceSubclass.CardInList(cardListModel: CardListReqModel) { (json, status) in
//            UtilityClass.hideHUD()
            if status
            {
//                UtilityClass.hideHUD()
                let CardListDetails = AddCardModel.init(fromJson: json)
                do {
                    self.aryCardData = CardListDetails.cards
                    try UserDefaults.standard.set(object: CardListDetails, forKey: "cards")
                    self.constraintHeightOfTableView.constant = self.tblView.contentSize.height
                    self.tblView.reloadData()
                    
                    self.constraintHeightOfTableView.constant = CGFloat(60 * (self.aryOtherPayment.count + self.aryCardData.count)) //self.tblView.contentSize.height
//                    self.updateViewConstraints()
                }
                catch
                {
                    UtilityClass.hideHUD()
                    AlertMessage.showMessageForError("error")
                }
            }
            else
            {
                AlertMessage.showMessageForError("error")
            }
        }
    }
    
    func webserviceforAddnewCard()
    {
        /*
         customer_id:2
         card_no:4242424242424242
         card_holder_name:mayurH
         exp_date_month:02
         exp_date_year:20
         cvv:123
         */
       
        addCardReqModel.customer_id = LoginDetail.loginData.id
        addCardReqModel.card_no = txtCardNumber.text ?? ""
        addCardReqModel.card_holder_name = txtCArdHolderName.text ?? ""
        addCardReqModel.exp_date_month = (txtValidThrough.text?.components(separatedBy: "/"))?.first ?? ""
        addCardReqModel.exp_date_year = (txtValidThrough.text?.components(separatedBy: "/"))?.last ?? ""
        addCardReqModel.cvv = txtCVVNumber.text ?? ""
        
        if(self.validations().0 == false)
        {
            AlertMessage.showMessageForError(self.validations().1)
        }
        else
        {
            UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
            
            UserWebserviceSubclass.addCardInList(addCardModel: addCardReqModel) { (json, status) in
                UtilityClass.hideHUD()
                if status
                {
                    self.txtCardNumber.text = ""
                    self.txtCArdHolderName.text = ""
                    self.txtValidThrough.text = ""
                    self.txtCVVNumber.text = ""
                    self.webserviceForCardList()
                }
                else
                {
                    UtilityClass.hideHUD()
                    if json["message"].stringValue.count != 0 {
                        AlertMessage.showMessageForError(json["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func validations() -> (Bool,String)
    {
        
        if(addCardReqModel.card_holder_name.isBlank)
        {
            return (false,"Please enter card holder name")
        }
        else if(addCardReqModel.card_no.isBlank)
        {
            return (false,"Please enter card number")
        }
        else if(addCardReqModel.exp_date_year.isBlank)
        {
            return (false,"Please enter expiry date")
        }
        else if(addCardReqModel.cvv.isBlank)
        {
            return (false,"Please enter your CVV")
        }
        else if !expDateValidation(dateStr: txtValidThrough.text ?? "")
        {
            return (false,"Please enter valid expiry date")
        }
        
        return (true,"")
    }
    
    func expDateValidation(dateStr:String) -> Bool {

        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)

        let enterdYr = Int(dateStr.suffix(2)) ?? 0   // get last two digit from entered string as year
        let enterdMonth = Int(dateStr.prefix(2)) ?? 0  // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user

        if enterdYr > currentYear{
            if (1 ... 12).contains(enterdMonth){
                return true
            } else{
                return false
            }
        } else  if currentYear == enterdYr {
            if enterdMonth >= currentMonth{
                if (1 ... 12).contains(enterdMonth) {
                    return true
                } else{
                    return false
                }
            } else {
                return false
            }
        } else if enterdYr < currentYear {
            return false
        } else {
            return true
        }
    }
}
