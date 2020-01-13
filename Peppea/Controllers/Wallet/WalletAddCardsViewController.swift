//
//  WalletAddCardsViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 28/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import FormTextField

class WalletAddCardsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CardIOPaymentViewControllerDelegate {
    
    
    @IBOutlet var viewOuters: [UIView]!
    
    var aryMonth = [String]()
    var aryYear = [String]()
    var filterMonth = [String]()
    
    var strSelectMonth = String()
    var strSelectYear = String()
    
    var pickerView = UIPickerView()
    var pickerOfCountory = UIPickerView()
    
    weak var delegateAddCard: AddCadsDelegate!
    
    //    var delegateAddCardFromHomeVC: addCardFromHomeVCDelegate!
    //    var delegateAddCardFromBookLater: isHaveCardFromBookLaterDelegate!
    
    var creditCardValidator: CreditCardValidator!
    var isCreditCardValid = Bool()
    
    var cardTypeLabel = String()
    var aryData = [[String:AnyObject]]()
    
    var CardNumber = String()
    var strMonth = String()
    var strYear = String()
    var strCVV = String()
    
    var aryTempMonth = [String]()
    var aryTempYear = [String]()
    
    var validation = Validation()
    var inputValidator = InputValidator()
    var isCameforTips:Bool = false // this is to check page open from BookingViewcontroller to Give Tips After Booking
    
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignView()
        
        // Initialise Credit Card Validator
        creditCardValidator = CreditCardValidator()
        
        pickerView.delegate = self
        
        ////        aryMonths = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        ////        aryMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        //        aryMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        //        aryYear = ["2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040"]
        //
        //        aryTempMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        //        aryTempYear = ["2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040"]
        
        
        // For current year to 20 years array
        
        for i in 0...19
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            
            let formatterMonth = DateFormatter()
            formatterMonth.dateFormat = "MM"
            
            if let futureDate = Calendar.current.date(byAdding: .year, value: i, to: Date(), wrappingComponents: false) {
                print(futureDate)
                aryYear.append(formatter.string(from: futureDate))
            }
//            if let futureMonth = Calendar.current.date(byAdding: .month, value: i, to: Date(), wrappingComponents: false) {
//                print(futureMonth)
//                aryMonth.append(formatterMonth.string(from: futureMonth))
//            }
        }
        aryMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        aryTempMonth = aryMonth
        aryTempYear = aryYear
        
        
        self.title = "Add Card"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardNum()
        cardExpiry()
        cardCVV()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for item in viewOuters {
            item.layer.cornerRadius = 8
            item.layer.borderWidth = 1
            item.layer.borderColor = ThemeColor.cgColor
            item.layer.masksToBounds = true
        }
    }
    
    func setDesignView() {
        //        self.lblCardDetail.text = "Credit card details are processed via eway. our third party secure payment gateway provider, certified tier-one PCI DSS complaint.\nThere is a $0.10 fee when you register your card. This will be refunded within 7 working days."
        //        btnAddPaymentMethods.layer.cornerRadius = 5
        //        btnAddPaymentMethods.layer.masksToBounds = true
        
        
        //        viewScanCard.layer.cornerRadius = 5
        //        viewScanCard.layer.borderColor = UIColor.darkGray.cgColor
        //        viewScanCard.layer.borderWidth = 1.0
        //        viewScanCard.layer.shadowColor = UIColor.darkGray.cgColor
        
        //        viewScanCard.layer.shadowOpacity = 0.5
        //        viewScanCard.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        //        viewScanCard.layer.shadowRadius = 5
        
        //        viewScanCard.layer.shadowPath = UIBezierPath(rect: viewScanCard.bounds).cgPath
        //        viewScanCard.layer.shouldRasterize = true
        //        viewScanCard.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        //        viewScanCard.layer.masksToBounds = false
        
        txtCardNumber.leftMargin = 0
        txtCVVNumber.leftMargin = 0
//        txtValidThrough.leftMargin = 0
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var btnAddPaymentMethods: UIButton!
    @IBOutlet weak var txtCardNumber: FormTextField!
    @IBOutlet weak var txtValidThrough: UITextField!
    @IBOutlet weak var txtCVVNumber: FormTextField!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var txtAlies: UITextField!
    @IBOutlet var txtCardHolderName: FormTextField!
    
    
    //    @IBOutlet weak var lblCardDetail: UILabel!
    //    @IBOutlet weak var viewScanCard: UIView!
    
    
    //-------------------------------------------------------------
    // MARK: - PicketView Methods
    //-------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return filterMonth.count // aryMonth.count
        }
        else {
            return aryYear.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return filterMonth[row] // aryMonth[row]
        }
        else {
            return aryYear[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 1 {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: Date())
            let month = calendar.component(.month, from: Date())
            
            if year == Int(aryYear[row]) {
                
//                aryYear.removeFirst(row)
//                for i in 0..<aryMonth.count {
//                    if currentMonth == filterMonth[i] { // aryMonth[i] {
//                        filterMonth.removeFirst(i - 1) // aryMonth.removeFirst(i - 1)
//                    }
//                }
                
                
                if year == Int(aryYear[row]) {
                    filterMonth = aryMonth.filter{(Int($0) ?? 0) >= month}
                } else {
                    filterMonth = aryMonth
                }
                pickerView.reloadComponent(0)
            }
            else {
                aryMonth = aryTempMonth
                aryYear = aryTempYear
                filterMonth = aryMonth
                pickerView.reloadComponent(0)
            }
        }
        
        
        if component == 0 {
            strSelectMonth = filterMonth[row]
            if strSelectYear == "" {
                strSelectYear = aryYear[0]
                strSelectYear.removeFirst(2)
            }
        }
        else {
            if strSelectMonth == "" {
                strSelectMonth = filterMonth[0]
            }
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
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    func cardNum() {
        txtCardNumber.inputType = .integer
        txtCardNumber.formatter = CardNumberFormatter()
        txtCardNumber.placeholder = "Card Number"
        txtCardNumber.leftMargin = 0
        txtCardNumber.layer.cornerRadius = 5
        //        txtCardNumber.backgroundColor = UIColor.white
        //        txtCardNumber.activeBackgroundColor = UIColor.white
        //        txtCardNumber.enabledBackgroundColor = UIColor.white
        //        txtCardNumber.invalidBackgroundColor = UIColor.white
        //        txtCardNumber.disabledBackgroundColor = UIColor.white
        //        txtCardNumber.inactiveBackgroundColor = UIColor.white
        
        validation.maximumLength = 19
        validation.minimumLength = 14
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        inputValidator = InputValidator(validation: validation)
        txtCardNumber.inputValidator = inputValidator
    }
    
    func cardExpiry() {
        
//        txtValidThrough.inputType = .integer
//        txtValidThrough.formatter = CardExpirationDateFormatter()
//        txtValidThrough.placeholder = "Expiration Date (MM/YY)"
//
//        //        var validation = Validation()
//        validation.minimumLength = 1
//        let inputValidator = CardExpirationDateInputValidator(validation: validation)
//        txtValidThrough.inputValidator = inputValidator
        
        
        let expiryDatePicker = MonthYearPickerView()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
        }
    }
    
    func cardCVV() {
        
        txtCVVNumber.inputType = .integer
        txtCVVNumber.placeholder = "CVV"
        
        //        var validation = Validation()
        
        if self.cardTypeLabel == "Amex" {
            self.validation.maximumLength = 4
            self.validation.minimumLength = 4
        }
        else {
            self.validation.maximumLength = 3
            self.validation.minimumLength = 3
        }
        
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        txtCVVNumber.inputValidator = inputValidator
        
        print("txtCVV.text : \(txtCVVNumber.text!)")
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnAddPaymentMethods(_ sender: UIButton) {
        
        if (ValidationForAddPaymentMethod()) {
            webserviceforAddnewCard()
        }
    }
    
    @IBAction func txtValidThrough(_ sender: UITextField) {
        
//        let datePicker = UIDatePicker()
//        datePicker.date = Date()
//        datePicker.datePickerMode = .date
//        datePicker.maximumDate = Date()
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "MMM yyyy"
       
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        filterMonth = aryMonth.filter{(Int($0) ?? 0) >= month}
        
        
        
        txtValidThrough.inputView = pickerView
        
        
//        let expiryDatePicker = MonthYearPickerView()
//        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
//            let string = String(format: "%02d/%d", month, year)
//            NSLog(string) // should show something like 05/2015
//        }
//
//        txtValidThrough.inputView = expiryDatePicker
    }
    
    @IBAction func txtCardNumber(_ sender: UITextField) {
        
        if let number = sender.text {
            if number.isEmpty {
                isCreditCardValid = false
                self.txtCardNumber.textColor = ThemeColor
                //                imgCard.image = UIImage(named: "iconDummyCard")
                
                //                self.cardValidationLabel.text = "Enter card number"
                //                self.cardValidationLabel.textColor = UIColor.black
                //
                //                self.cardTypeLabel.text = "Enter card number"
                //                self.cardTypeLabel.textColor = UIColor.black
            } else {
                validateCardNumber(number: number)
                detectCardNumberType(number: number)
            }
        }
    }
    
    @IBAction func btnScanCard(_ sender: UIButton) {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
        
        
        //        UtilityClass.showAlert("", message: "This Feature will be soon.", vc: self)
    }
    
    
    func validateCardNumber(number: String) {
        if creditCardValidator.validate(string: number) {
            
            isCreditCardValid = true
            //            self.cardValidationLabel.text = "Card number is valid"
            //            self.cardValidationLabel.textColor = UIColor.green
        } else {
            
            isCreditCardValid = false
            self.txtCardNumber.textColor = ThemeColor
            //            imgCard.image = UIImage(named: "iconDummyCard")
            //            self.cardValidationLabel.text = "Card number is invalid"
            //            self.cardValidationLabel.textColor = UIColor.red
        }
    }
    
    func detectCardNumberType(number: String) {
        if let type = creditCardValidator.type(from: number) {
            
            isCreditCardValid = true
            self.cardTypeLabel = type.name
            print(type.name)
            self.txtCardNumber.textColor = UIColor.green
            //            imgCard.image = UIImage(named: type.name)
            
            self.cardCVV()
            
            
            //            self.cardTypeLabel.textColor = UIColor.green
        } else {
            
            //            imgCard.image = UIImage(named: "iconDummyCard")
            self.txtCardNumber.textColor = ThemeColor
            
            isCreditCardValid = false
            
            self.cardTypeLabel = "Undefined"
            //            self.cardTypeLabel.textColor = UIColor.red
        }
    }
    
    func ValidationForAddPaymentMethod() -> Bool {
        
        let cd = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let currentMM = dateFormatter.string(from: cd)
        dateFormatter.dateFormat = "YY"
        let currentYY = dateFormatter.string(from: cd)
        
        let selectedMM = txtValidThrough.text?.components(separatedBy: "/").first
        let selectedYY = txtValidThrough.text?.components(separatedBy: "/").last
        
        if (txtCardHolderName.text!.count == 0) {
            UtilityClass.showAlert(title: "", message: "Please enter holder name", alertTheme: .warning)
            //            UtilityClass.setCustomAlert(title: "Missing", message: "Enter CVV Number") { (index, title) in
            //            }
            return false
        }
        else if (txtCardNumber.text!.count == 0) {
            UtilityClass.showAlert(title: "", message: "Please enter card number", alertTheme: .warning)
            //            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Card Number") { (index, title) in
            //            }
            return false
        }
        else if (txtValidThrough.text!.count == 0) {
            UtilityClass.showAlert(title: "", message: "Please enter expiry date", alertTheme: .warning)
            //            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Expiry Date") { (index, title) in
            //            }
            return false
        }
//        else if (Int(selectedYY ?? "0") ?? 0) < (Int(currentYY) ?? 0) {
//            UtilityClass.showAlert(title: "", message: "Selected dete is already expired", alertTheme: .warning)
//            return false
//        }
//        else if (Int(selectedMM ?? "0") ?? 0) < (Int(currentMM) ?? 0) {
//            UtilityClass.showAlert(title: "", message: "Selected dete is already expired", alertTheme: .warning)
//            return false
//        }
        else if (txtCVVNumber.text!.count == 0) {
            UtilityClass.showAlert(title: "", message: "Please enter cvv number", alertTheme: .warning)
            
            //            UtilityClass.setCustomAlert(title: "Missing", message: "Enter CVV Number") { (index, title) in
            //            }
            return false
        }
        //        else if (txtAlies.text!.count == 0) {
        //
        //            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Bank Name") { (index, title) in
        //            }
        //            return false
        //        }
        return true
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    
    func webserviceOfAddCard() {
        // PassengerId,CardNo,Cvv,Expiry,Alias (CarNo : 4444555511115555,Expiry:09/20)
        
        //        if Connectivity.isConnectedToInternet() == false {
        //            UtilityClass.showAlert(title: "Connection Error", message: "Internet connection not available", alertTheme: .warning)
        //            return
        //        }
        
        //      CardNumber = txtCardNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var dictData = [String:AnyObject]()
        
        dictData["DriverId"] = SingletonClass.sharedInstance.loginData.id as AnyObject
        
        if CardNumber != "" {
            dictData["CardNo"] = CardNumber as AnyObject
        }
        else {
            dictData["CardNo"] = txtCardNumber.text!.replacingOccurrences(of: " ", with: "") as AnyObject
        }
        
        dictData["Cvv"] = txtCVVNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        dictData["Expiry"] = txtValidThrough.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        dictData["NameOnCard"] = txtCardHolderName.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        
        
        //        dictData["Alias"] = txtAlies.text as AnyObject
        
        //        webserviceForAddNewCardInWallet(dictData as AnyObject) { (result, status) in
        //
        //            if (status) {
        //                print(result)
        //
        //                if self.delegateAddCard != nil {
        //                    self.delegateAddCard.didAddCard(cards: (result as! NSDictionary).object(forKey: "cards") as! NSArray)
        //                }
        //
        //                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
        //
        //                Singletons.sharedInstance.CardsVCHaveAryData = self.aryData
        //
        //                // Post notification
        //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardListReload"), object: nil)
        //
        //                let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
        //                let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
        //
        ////                    if self.checkPresentation() {
        //
        //                        self.delegateAddCardFromHomeVC?.didAddCardFromHomeVC()
        //
        ////                        self.delegateAddCardFromBookLater?.didHaveCards()
        //
        ////                        self.dismiss(animated: true, completion: nil)
        ////                    }
        ////                    else {
        //                        self.navigationController?.popViewController(animated: true)
        //
        ////                    }
        //                })
        //
        //                alert.addAction(OK)
        //                self.present(alert, animated: true, completion: nil)
        //
        //            }
        //            else {
        //                print(result)
        //                if let res = result as? String {
        //                    UtilityClass.showAlert(AppNAME, message: res, vc: self)
        //                }
        //                else if let resDict = result as? NSDictionary {
        //                    UtilityClass.showAlert(AppNAME, message:  resDict.object(forKey: "message") as! String, vc: self)
        //                }
        //                else if let resAry = result as? NSArray {
        //                    UtilityClass.showAlert(AppNAME, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
        //                }
        //            }
        //        }
        
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
        
        let addCardReqModel = AddCard()
        
        addCardReqModel.customer_id = SingletonClass.sharedInstance.loginData.id
        addCardReqModel.card_no = txtCardNumber.text ?? ""
        addCardReqModel.card_holder_name = txtCardHolderName.text ?? ""
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
                    self.txtCardHolderName.text = ""
                    self.txtValidThrough.text = ""
                    self.txtCVVNumber.text = ""
                    
                    UtilityClass.showDefaultAlertView(withTitle: "", message: json.dictionary?["message"]?.string ?? "", buttons: ["Ok"], completion: { (ind) in
                        
                        if self.delegateAddCard != nil {
                            if json.dictionary?["cards"]?.arrayObject?.count != 0 {
                                self.delegateAddCard?.didAddCard(cards: json.dictionary?["cards"]?.arrayObject ?? [])
                            }
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                    
                }
                else
                {
                    AlertMessage.showMessageForError(json.dictionary?["message"]?.string ?? "")
                }
            }
        }
    }
    
    func validations() -> (Bool,String)
    {
        
        if(txtCardHolderName.text?.isBlank ?? true)
        {
            return (false,"Please enter card holder name")
        }
        else if(txtCardNumber.text?.isBlank ?? true)
        {
            return (false,"Please enter card number")
        }
        else if(txtValidThrough.text?.isBlank ?? true)
        {
            return (false,"Please enter ex. date")
        }
        else if(txtCVVNumber.text?.isBlank ?? true)
        {
            return (false,"Please enter your CVV")
        }
        
        
        return (true,"")
    }
    
    func checkPresentation() -> Bool {
        if (presentingViewController != nil) {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }
    
    //-------------------------------------------------------------
    // MARK: - Scan Card Methods
    //-------------------------------------------------------------
    
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        
//        print("CardInfo : \(cardInfo)")
        
        if let info = cardInfo {
            _ = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            //            resultLabel.text = str as String
            print("Card Number : \(info.cardNumber ?? "")")
            print("Redacted Card Number : \(customStringFormatting(of: info.redactedCardNumber))")
            print("Month : \(info.expiryMonth)")
            print("Year : \(info.expiryYear)")
            print("CVV : \(info.cvv ?? "")")
            
            var years = String(info.expiryYear)
            years.removeFirst(2)
            //            customStringFormatting(of: info.redactedCardNumber)
            
            print("Removed Year : \(years)")
            
            
            txtCardNumber.text = customStringFormatting(of: info.redactedCardNumber)
            //            txtCardNumber.text = info.cardNumber
            txtValidThrough.text = "\(info.expiryMonth)/\(years)"
            txtCVVNumber.text = info.cvv
            
            
            CardNumber = String(info.cardNumber)
            strMonth = String(info.expiryMonth)
            strYear = String(years)
            strCVV = String(info.cvv)
            
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
        
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
    
    
    func customStringFormatting(of str: String) -> String {
        return str.chunk(n: 4)
            .map{ String($0) }.joined(separator: " ")
        
    }
    
}

extension Collection {
    public func chunk(n: IndexDistance) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

extension String {
    var pairs: [String] {
        var result: [String] = []
        let characters = Array(self)
        stride(from: 0, to: characters.count, by: 2).forEach {
            result.append(String(characters[$0..<min($0+2, characters.count)]))
        }
        return result
    }
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: characters.count, by: n).forEach {
            result += String(characters[$0..<min($0+n, characters.count)])
            if $0+n < characters.count {
                result += separator
            }
        }
        return result
    }
}

/*
// SuccessFully
{
    cards =     (
        {
            Alias = Kotak;
            CardNum = 4242424242424242;
            CardNum2 = "xxxx xxxx xxxx 4242";
            Id = 3;
            Type = visa;
        }
    );
    message = "Card saved successfully";
    status = 1;
}
// Failed
{
    message = "Parameter missing";
    status = 0;
}
*/
