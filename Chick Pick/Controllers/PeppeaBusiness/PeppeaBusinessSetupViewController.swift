//
//  PeppeaBusinessSetupViewController.swift
//  Peppea
//
//  Created by eww090 on 13/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class PeppeaBusinessSetupViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource
{

    
    @IBOutlet weak var tblView: UITableView!
    
    var aryCardData = [[String : AnyObject]]()
    var aryOtherPayment = [[String : AnyObject]]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        
        
        self.setNavBarWithBack(Title: "", IsNeedRightButton: false)
        //        viewPaymentPopup.roundCorners([.topRight,.topLeft], radius: 12)
        
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
            cell.lblTitle.text = data["CardNum"] as? String
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCardTypeListCell") as! PaymentCardTypeListCell
            let data = aryCardData[indexPath.row]
            cell.selectionStyle = .none
            cell.iconCard.image = UIImage.init(named: data["Type"] as! String)
            cell.lblTitle.text = data["CardNum"] as? String
            
            cell.lblCardNumber.text = data["CardNum2"] as? String
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tblView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func btnAddPaymentClicked(_ sender: Any)
    {
        
    }
    
    @IBAction func btnNextClicked(_ sender: Any)
    {
//        AutomaticExpenseVC
        
        let storyboradMain = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboradMain.instantiateViewController(withIdentifier: "AutomaticExpenseVC") as! AutomaticExpenseVC
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
