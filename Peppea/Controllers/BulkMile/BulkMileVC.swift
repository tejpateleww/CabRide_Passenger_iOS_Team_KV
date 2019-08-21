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
    var arrBulkMileList = [BulkMileListDataModel]()
    var PurchaseMile : BulkMilesPurchase = BulkMilesPurchase()
    var isAlreadyPurchased : Bool = false
    var PurchasedMiles:String = ""
    //MARK:- Outlets
    @IBOutlet weak var cardTableView: UITableView!

    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webserviceCallForBulkMile()
        self.setNavBarWithBack(Title: "Bulk Mile", IsNeedRightButton: false)
        cardTableView.register(UINib(nibName: "BulkMileTableViewCell", bundle: nil), forCellReuseIdentifier: "BulkMileTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let NavigationRightButton = UIBarButtonItem(image: UIImage(named: "iconMiles"), style: .plain, target: self, action: #selector(OpenBulkMileHistory))
        self.navigationItem.rightBarButtonItem = NavigationRightButton
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

    
    //MARK:- Webservice Methods
    
    func webserviceCallForBulkMile()
    {
        
        guard let CustomerID = SingletonClass.sharedInstance.loginData.id as? String else {
            return
        }
        UserWebserviceSubclass.getBulkMile(strURL: "/\(CustomerID)") { (response, status) in
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
                self.webserviceCallForBulkMile()
            }
            else
            {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
            
        }
        
    }
    
    
    // MARK:- Payment Select Delegate Methods
    
    func didSelectPaymentType(PaymentType: String, PaymentTypeID: String, PaymentNumber: String, PaymentHolderName: String) {
        self.PurchaseMile.payment_type = PaymentType
        if PaymentType == "card" {
            self.PurchaseMile.card_id = PaymentTypeID
        }
        self.WebServiceCallForMilePurchase()
    }
}

extension BulkMileVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBulkMileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BulkMileTableViewCell", for: indexPath) as! BulkMileTableViewCell
        
        let bulkMileData = arrBulkMileList[indexPath.row]
        cell.btnPurchase.tag = indexPath.row
        cell.btnPurchase.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.btnPurchase.isHidden = bulkMileData.isPurchased
        if bulkMileData.isPurchased == true {
            self.isAlreadyPurchased = true
            self.PurchasedMiles = bulkMileData.miles
        }
        cell.lblDescription.text = bulkMileData.descriptionField
        cell.lblPriceRange.text = "\(Currency) \(bulkMileData.actualPrice ?? "0.00")"
        cell.lblDistance.text = "\(bulkMileData.miles ?? "0.00") \(MeasurementSign)"
        
        var DoubleValidity = Double()
        if let validity = bulkMileData.validity, let doubleLat = Double(validity) {
            DoubleValidity = doubleLat
        }
        
        cell.lblValidity.text = "\(bulkMileData.validity ?? "0.00") \(bulkMileData.validityType ?? "")"
        if(DoubleValidity > 1.0)
        {
            cell.lblValidity.text = "\(bulkMileData.validity ?? "0.00") \(bulkMileData.validityType ?? "")s"
        }
       return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
