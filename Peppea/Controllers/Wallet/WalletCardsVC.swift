//
//  WalletCardsVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

@objc protocol AddCadsDelegate {
    func didAddCard(cards: Any)
}

protocol selectPaymentOptionDelegate {
    func selectPaymentOption(option: Any)
}

class WalletCardsVC: BaseViewController, UITableViewDataSource, UITableViewDelegate, AddCadsDelegate {
    
    

    
//    weak var delegateForTopUp: SelectCardDelegate!
//    weak var delegateForTransferToBank: SelectBankCardDelegate!
    
    var aryData = [[String:AnyObject]]()
    
    var delegate: selectPaymentOptionDelegate?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = ThemeColor
        
        return refreshControl
    }()
    
   
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func loadView() {
        super.loadView()
        
//        if SingletonClass.sharedInstance.isCardsVCFirstTimeLoad {
////            webserviceOFGetAllCards()
//
//            if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
//                aryData = SingletonClass.sharedInstance.CardsVCHaveAryData
//            }
//            else {
//
//                webserviceOFGetAllCards()
//
//            }
//        }
//        else {
//            if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
//                aryData = SingletonClass.sharedInstance.CardsVCHaveAryData
//            }
//            else {
//                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
//                next.delegateAddCard = self
//                self.navigationController?.pushViewController(next, animated: true)
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
         webserviceForCardList()
        self.setNavBarWithBack(Title: "Pesapal", IsNeedRightButton: true)
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    func setImageColorOfImage(name: String) -> UIImage {
        
        let imageView = UIImageView()
        let img = UIImage(named: name)
        imageView.image = img//?.maskWithColor(color: UIColor.white)
        return imageView.image!
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddCards: UIButton!
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return aryData.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCardsTableViewCell") as! WalletCardsTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddCard") as! WalletCardsTableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "m-pesa") as! WalletCardsTableViewCell
        
        cell.selectionStyle = .none
        cell2.selectionStyle = .none
        cell3.selectionStyle = .none
        
        if indexPath.section == 1 {
            
            let dictData = aryData[indexPath.row] as [String:AnyObject]
//["Expiry": 02/20,"CardNum2": xxxx xxxx xxxx 4242,"Id": 64,"Type": visa,"Alias":,"CardNum": 4242424242424242]
//            cell.lblCardType.text = "Credit Card"
            
//            let exp_date_month = dictData["exp_date_month"] as! String
            let month: String = dictData["exp_date_month"] as? String ?? ""
            let year: String = dictData["exp_date_year"] as? String ?? ""
            cell.lblMonthExpiry.text = "\(month)/\(year)" // String(describing: month!)
//            cell.lblYearExpiry.text = String(describing: year!)
            
            cell.viewCards.layoutIfNeeded()
//            cell.viewCards.dropShadowToCardView(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 5, scale: true)
            let colorTop = UIColor(hex: "FF954F").cgColor // UIColor(red: 78/255, green: 202/255, blue:237/255, alpha: 1.0).cgColor
            let colorMiddle = UIColor(hex: "FF3A86").cgColor // UIColor(red: 187/255, green: 241/255, blue: 239/255, alpha: 0.5).cgColor
            //            let colorBottom = UIColor(red: 64/255, green: 43/255, blue: 6/255, alpha: 0.8).cgColor
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorMiddle]
//            gradientLayer.locations = [ 0.0, 0.5]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = self.view.bounds
            cell.viewCards.layer.insertSublayer(gradientLayer, at: 0)
            cell.viewCards.layer.cornerRadius = 5
            cell.viewCards.layer.masksToBounds = true
            
            let type = dictData["card_type"] as! String
            cell.imgCardIcon.image = UIImage(named: setCreditCardImage(str: type))
            
            cell.imgCardIcon.layer.cornerRadius = cell.imgCardIcon.frame.height / 2
            cell.imgCardIcon.layer.masksToBounds = true

//                cell.viewCards.backgroundColor = UIColor.orange
//                cell.lblBankName.text = dictData["card_holder_name"] as? String
                cell.lblCardNumber.text = dictData["formated_card_no"] as? String
//                cell.imgCardIcon.image = UIImage(named: "MasterCard")

            return cell
        }
        else if indexPath.section == 0 {
//            let img = UIImage(named: "iconArrowGrey")
//            cell2.btnArrow.image = img?.maskWithColor(color: themeYellowColor)
            
            cell2.imgPlus.setImageColor(color: .white)
            return cell2
        } else if indexPath.section == 2 {
            return cell3
        }
        
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let selectedData = aryData[indexPath.row] as [String:AnyObject]
            
            print("selectedData : \(selectedData)")
            if delegate != nil {
                delegate?.selectPaymentOption(option: selectedData)
                self.navigationController?.popViewController(animated: true)
            }
            
            
            
//            if SingletonClass.sharedInstance.isFromTopUP {
//                delegateForTopUp.didSelectCard(dictData: selectedData)
//                SingletonClass.sharedInstance.isFromTopUP = false
//                self.navigationController?.popViewController(animated: true)
//            }
//            else if SingletonClass.sharedInstance.isFromTransferToBank {
//                delegateForTransferToBank.didSelectBankCard(dictData: selectedData)
//                SingletonClass.sharedInstance.isFromTransferToBank = false
//                self.navigationController?.popViewController(animated: true)
//            }
        }
        else if indexPath.section == 0 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
            next.delegateAddCard = self
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if indexPath.section == 2 {
            if delegate != nil {
                var mPesa = [String:AnyObject]()
                mPesa["card_type"] = "MPesa" as AnyObject
                delegate?.selectPaymentOption(option: mPesa)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return 80 // 164
        }
        else {
            return 60 // 75
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let selectedData = aryData[indexPath.row] as [String:AnyObject]
            if editingStyle == .delete {
                let selectedID = selectedData["Id"] as? String
                tableView.beginUpdates()
                aryData.remove(at: indexPath.row)
                webserviceForRemoveCardFromWallet(cardId : selectedID!)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnAddCards(_ sender: UIButton) {
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
//        next.delegateAddCard = self
//        self.navigationController?.pushViewController(next, animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        webserviceOFGetAllCards()
        tableView.reloadData()
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Add Cads Delegate Methods
    //-------------------------------------------------------------
  
    func didAddCard(cards: Any) {
        aryData = cards as! [[String:AnyObject]]
        tableView.reloadData()
    }
    
//    func giveGradientColor() {
//
//        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
//        let colorMiddle =  UIColor(red: 36/255, green: 24/255, blue: 3/255, alpha: 0.5).cgColor
//        let colorBottom = UIColor(red: 64/255, green: 43/255, blue: 6/255, alpha: 0.8).cgColor
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
//        gradientLayer.locations = [ 0.0, 0.5, 1.0]
//        gradientLayer.frame = self.view.bounds
//        self.view.layer.insertSublayer(gradientLayer, at: 0)
//
//    }
//
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For All Cards
    //-------------------------------------------------------------
    func webserviceForCardList()
    {
        self.aryData.removeAll()
        let cardList = CardList()
        cardList.customer_id = SingletonClass.sharedInstance.loginData.id
//        CardListReqModel.customer_id = LoginDetail.loginData.id
        //        UtilityClass.showHUD(with: self.view)
        UserWebserviceSubclass.CardInList(cardListModel: cardList) { (json, status) in
            //            UtilityClass.hideHUD()
            if status
            {
                //                UtilityClass.hideHUD()
                let CardListDetails = AddCardModel.init(fromJson: json)
                do {
                    self.aryData = CardListDetails.cards.map{$0.toDictionary() as [String:AnyObject]}
                    try UserDefaults.standard.set(object: CardListDetails, forKey: "cards")
                    self.tableView.reloadData()
                    self.updateViewConstraints()
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
    
    func webserviceOFGetAllCards() {
        /*
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
       
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = self.aryData
                
                SingletonClass.sharedInstance.isCardsVCFirstTimeLoad = false
                
                self.tableView.reloadData()
                
                if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                    next.delegateAddCard = self
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("CardListReload"), object: nil)
                self.refreshControl.endRefreshing()
            }
            else {
                
                print(result)
             
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
        */

    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Remove Cards
    //-------------------------------------------------------------
    
    func webserviceForRemoveCardFromWallet(cardId : String) {
      
        /*
        var params = String()
        params = "\(SingletonClass.sharedInstance.strPassengerID)/\(cardId)"

        webserviceForRemoveCard(params as AnyObject) { (result, status) in
        
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = self.aryData
                
                SingletonClass.sharedInstance.isCardsVCFirstTimeLoad = false
                
                
                // Post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardListReload"), object: nil)

                
                if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
             
                    self.navigationController?.popViewController(animated: true)
                }
                
                
                self.tableView.reloadData()
                
        
                UtilityClass.setCustomAlert(title: "Removed", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
            else {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
        */
    }
    
}

extension UIView {
    
    func dropShadowToCardView(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

func setCreditCardImage(str: String) -> String {
    
    //   visa , mastercard , amex , diners , discover , jcb , other
    
    var strType = String()
    if str == "visa" {
        strType = "iconVisaCard"
    }
    else if str == "mastercard" {
        strType = "iconMasterCard"
    }
    else if str == "amex" {
        strType = "Amex"
    }
    else if str == "diners" {
        strType = "icondDiners"
    }
    else if str == "discover" {
        strType = "iconDiscover"
    }
    else if str == "jcb" {
        strType = "JCB"
    }
    else {
        strType = "iconcard"
    }
    return strType
}

