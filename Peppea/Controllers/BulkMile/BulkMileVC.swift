//
//  BulkMileVC.swift
//  Peppea
//
//  Created by EWW80 on 08/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit


class BulkMileVC: BaseViewController, didSelectPaymentDelegate{
    
    
    
    
    //MARK:- Variables
    var tripType = MyMiles.myMile
    var data = [(String, String)]()
    var arrBulkMileList = [BulkMileListDataModel]()
    var PurchaseMile : BulkMilesPurchase = BulkMilesPurchase()
    var isAlreadyPurchased : Bool = false
    var PurchasedMiles:String = ""
    
    private let refreshControl = UIRefreshControl()
    var isRefresh = Bool()
    var selectedCell : Int = -1
    var NeedToReload:Bool = false
    var PageLimit = 10
    var PageNumber = 1
    
    //MARK:- Outlets
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var collectionTableView: HeaderTableViewController!
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionTableView()
        webserviceCallForBulkMile(pageNo: 1)
        self.setNavBarWithBack(Title: "Bulk Mile", IsNeedRightButton: false)
        cardTableView.register(UINib(nibName: "BulkMileTableViewCell", bundle: nil), forCellReuseIdentifier: "BulkMileTableViewCell")
        cardTableView.register(UINib(nibName: "TransferMileTableViewCell", bundle: nil), forCellReuseIdentifier: "TransferMileTableViewCell")
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            collectionTableView.tableView.refreshControl = refreshControl
        } else {
            collectionTableView.tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = ThemeColor // UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let NavigationRightButton = UIBarButtonItem(image: UIImage(named: "iconMiles"), style: .plain, target: self, action: #selector(OpenBulkMileHistory))
        self.navigationItem.rightBarButtonItem = NavigationRightButton
    }
    
    private func setCollectionTableView(){
        collectionTableView.isSizeToFitCellNeeded = true
        collectionTableView.indicatorColor = .black
        collectionTableView.titles = MyMiles.titles
        collectionTableView.parentVC = self
        collectionTableView.indicatorColor = .black
        collectionTableView.textColor = .black
        collectionTableView.registerNibs = [BulkMileTableViewCell.identifier,
                                            BulkMileTableViewCell.identifier,
                                            TransferMileTableViewCell.identifier]
        collectionTableView.cellInset = UIEdgeInsets.zero
        collectionTableView.spacing = 0
        
        collectionTableView.didSelectItemAt = {
            indexpaths in
            if indexpaths.indexPath != indexpaths.previousIndexPath{
                self.tripType = MyMiles.allCases[indexpaths.indexPath.item]
                //                self.setData()
                self.selectedCell = -1
                
                if indexpaths.indexPath.item == 1 {
                    self.LoadNewData()
                    //                    self.webserviceForUpcommingBooking(pageNo: 1)
                } else {
                    self.LoadNewData()
                    //                    self.webserviceCallForGettingPastHistory(pageNo: 1)
                }
                self.collectionTableView.tableView.removeAllSubviews()
                self.collectionTableView.tableView.reloadData()
            }
        }
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        isRefresh = true
        self.LoadNewData()
    }
    
    func LoadNewData() {
        self.PageNumber = 1
        //        self.pastBookingHistoryModelDetails.removeAll()
        //        self.collectionTableView.tableView.reloadData()
        if self.tripType.rawValue.lowercased() == SingletonClass.sharedInstance.loginData.userType {
            self.webserviceCallForBulkMile(pageNo: self.PageNumber)
        } else if self.tripType.rawValue.lowercased() == SingletonClass.sharedInstance.loginData.userType {
            self.webserviceCallForBulkMile(pageNo: self.PageNumber)
        }else{
            self.webserviceCallForBulkMile(pageNo: self.PageNumber)
        }
        
        collectionTableView.tableView.refreshControl?.endRefreshing()
    }
    
    @objc func OpenBulkMileHistory() {
        let BulkMilesHistoryPage = self.storyboard?.instantiateViewController(withIdentifier: "BulkMilesHistory") as! BulkMilesHistory
        if self.isAlreadyPurchased == true {
            BulkMilesHistoryPage.PurchasePlan = self.PurchasedMiles
        }
        self.navigationController?.pushViewController(BulkMilesHistoryPage, animated: true)
    }

    //MARK:- Button Action Method
    
    @objc func connected(sender: UIButton){
        if self.isAlreadyPurchased {
            AlertMessage.showMessageForError("You have already purchase miles.")
            return
        }
        let buttonTag = sender.tag
        let CurrentBulkMile = self.arrBulkMileList[buttonTag]
        self.PurchaseMile.bulk_miles_id = CurrentBulkMile.id
        self.PurchaseMile.user_type = "customer"
        self.PurchaseMile.user_id = SingletonClass.sharedInstance.loginData.id
        let PaymentPage = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        PaymentPage.Delegate = self
        PaymentPage.isFlatRateSelected = false
        PaymentPage.OpenedForPayment = true
        PaymentPage.PagefromBulkMiles = true
        self.navigationController?.pushViewController(PaymentPage, animated: true)
//        let NavController = UINavigationController(rootViewController: PaymentPage)
        
    }

    @objc func btnSendMiles() {
        
    }
    
    //MARK:- Webservice Methods
    
    func webserviceCallForBulkMile(pageNo: Int)
    {
        
        guard let CustomerID = SingletonClass.sharedInstance.loginData.id else {
            return
        }
//        company OR individual OR under_company
        
        let userType = SingletonClass.sharedInstance.loginData.userType
        
        UserWebserviceSubclass.getBulkMile(strURL: "/\(CustomerID)/\(userType ?? "")") { (response, status) in
            if(status)
            {
                if let arrayResponse = response.dictionary?["data"]?.array {
                    self.arrBulkMileList = arrayResponse.map({ (item) -> BulkMileListDataModel in
                        return BulkMileListDataModel.init(fromJson: item)
                    })
                }
                self.cardTableView.reloadData()
//                self.refreshControl.endRefreshing()
            }
            else
            {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    
    func WebServiceCallForMilePurchase() {
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        UserWebserviceSubclass.PurchaseBulkMile(PurchaseRequest: self.PurchaseMile) { (response, status) in
        UtilityClass.hideHUD()
            if(status)
            {
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                self.webserviceCallForBulkMile(pageNo: 1)
            }
            else
            {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    func webserviceForTransferMiles(employee_id: String, miles: String) {
//        customer_id:5
//        employee_id:64
//        miles:10
        let employee_id = employee_id
        let miles = miles
        let param = SingletonClass.sharedInstance.loginData.id + "/" + employee_id + "/" + miles
        
        UserWebserviceSubclass.transferCorporateMiles(strURL: param) { (response, status) in
            print(response)
            if status {
                
            } else {
                
            }
        }
    }
    
    // MARK:- Payment Select Delegate Methods
       
    func didSelectPaymentType(PaymentTypeTitle: String, PaymentType: String, PaymentTypeID: String, PaymentNumber: String, PaymentHolderName: String, dictData: [String : Any]?) {
        self.PurchaseMile.payment_type = PaymentType
        if PaymentType == "card" {
            self.PurchaseMile.card_id = PaymentTypeID
        }
        self.WebServiceCallForMilePurchase()
    }
}

extension BulkMileVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tripType == .transferMile {
            return 1
        }
        return arrBulkMileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.tripType == .transferMile {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransferMileTableViewCell", for: indexPath) as? TransferMileTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
//            cell.btnSubmit.addTarget(self, action: #selector(self.btnSendMiles), for: .touchUpInside)
            
            cell.submitAction = { (employeeName, Miles) in
                print("\n Employee Name: \(employeeName)")
                print("\n Miles: \(Miles)")
                self.webserviceForTransferMiles(employee_id: employeeName, miles: Miles)
            }
                        
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BulkMileTableViewCell", for: indexPath) as? BulkMileTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let bulkMileData = arrBulkMileList[indexPath.row]
        cell.btnPurchase.tag = indexPath.row
        cell.btnPurchase.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.btnPurchase.isHidden = bulkMileData.isPurchased
        if bulkMileData.isPurchased == true {
            self.isAlreadyPurchased = true
            self.PurchasedMiles = bulkMileData.miles
        }
        
        let longString = "\(Currency) \(bulkMileData.estimatedPrice ?? "") - \(Currency) \(bulkMileData.actualPrice ?? "")"
        let longestWord = "\(Currency) \(bulkMileData.estimatedPrice ?? "")"
        
        let longestWordRange = (longString as NSString).range(of: longestWord)
        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        
//        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.red], range: longestWordRange)
        
        attributedString.setAttributes([NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)], range: longestWordRange)
        cell.lblPriceRange.attributedText = attributedString
        
        
        cell.lblDescription.text = bulkMileData.descriptionField
//        cell.lblPriceRange.attributedText = myAttrString
//        cell.lblPriceRange.text = "\(Currency) \(bulkMileData.actualPrice ?? "0.00")"
        
        
        cell.lblDistance.attributedText = NSAttributedString(string: "\(bulkMileData.miles ?? "0.00") \(MeasurementSign)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        
        var DoubleValidity = Double()
        if let validity = bulkMileData.validity, let doubleLat = Double(validity) {
            DoubleValidity = doubleLat
        }
        
        cell.lblValidity.text = "\(bulkMileData.validity ?? "0.00") \(bulkMileData.validityType ?? "") Valid"
        if(DoubleValidity > 1.0)
        {
            cell.lblValidity.text = "\(bulkMileData.validity ?? "0.00") \(bulkMileData.validityType ?? "")s Valid"
        }
       return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.tripType == .transferMile {
            let frm = collectionTableView.tableView.frame
            return frm.size.height
        }
        return 130
    }
}
