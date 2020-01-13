//
//  PreviousDueViewController.swift
//  Peppea
//
//  Created by EWW074 on 03/01/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit
import SwiftyJSON

class PreviousDueViewController: BaseViewController {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var aryData = [PreviousDueModel]()
    let model = PreviousDuePayment()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarWithBack(Title: "Previous Due", IsNeedRightButton: true)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        webserviceForPreviousDue()
    }
    
    @objc func btnPayAction(sender: UIButton) {
        
        print("Pay Action")
        
        if let payment = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
            payment.Delegate = self
            payment.isFromSideMenu = true
            payment.OpenedForPayment = true
            self.present(payment, animated: true, completion: nil)
        }
    }

    func webserviceForPreviousDue() {
        
        UserWebserviceSubclass.pastDueHistoryList(strURL: SingletonClass.sharedInstance.loginData.id) { (response, status) in
            
            if status {
                let res = PreviousDueModelParent(fromJson: response)
                self.aryData = res.data
                self.tableView.reloadData()
            } else {
                UtilityClass.showDefaultAlertView(withTitle: "", message: response.dictionary?["message"]?.string ?? "", buttons: ["Ok"], completion: { (ind) in
                    
                })
            }
        }
    }
    
    func webserviceForPaymentPreviousDue() {
        
        UserWebserviceSubclass.PreviousDuePaymentData(SendChat: model) { (response, status) in
            
            if status {
                
                UtilityClass.showDefaultAlertView(withTitle: "", message: response.dictionary?["message"]?.string ?? "", buttons: ["Ok"], completion: { (ind) in
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                UtilityClass.showDefaultAlertView(withTitle: "", message: response.dictionary?["message"]?.string ?? "", buttons: ["Ok"], completion: { (ind) in
                    
                })
            }
        }
    }
}


extension PreviousDueViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousDueTableViewCell", for: indexPath) as! PreviousDueTableViewCell
        cell.selectionStyle = .none
        let currentItem = aryData[indexPath.row]
        cell.setupData(object: currentItem)
        model.booking_id = currentItem.bookingId
        model.customer_id = currentItem.customerId
        cell.btnPay.addTarget(self, action: #selector(self.btnPayAction(sender:)), for: .touchUpInside)
        return cell
    }
}

extension PreviousDueViewController: didSelectPaymentDelegate {
    func didSelectPaymentType(PaymentTypeTitle: String, PaymentType: String, PaymentTypeID: String, PaymentNumber: String, PaymentHolderName: String, dictData: [String : Any]?) {
        
        model.payment_type = PaymentType
        if PaymentType.lowercased() == "card" {
            model.card_id = PaymentTypeID
            if model.card_id == "" {
                UtilityClass.showAlert(title: "", message: "Please select card id", alertTheme: .error)
            }
        }
        
        
        if model.booking_id == "" {
            UtilityClass.showAlert(title: "", message: "Please select booking", alertTheme: .error)
        } else if model.customer_id == "" {
            UtilityClass.showAlert(title: "", message: "Please select customer", alertTheme: .error)
        }
        else if model.payment_type == "" {
            UtilityClass.showAlert(title: "", message: "Please select payment type", alertTheme: .error)
        } else {
            webserviceForPaymentPreviousDue()
        }
    }
    
}
