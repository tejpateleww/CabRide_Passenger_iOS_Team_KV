//
//  VehicleDetailViewController+TableView.swift
//  Peppea
//
//  Created by EWW078 on 28/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation



extension VehicleDetailViewController : UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var customCell = UITableViewCell()

        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailHeaderCell") as! VehicleDetailHeaderCell
            
            
            //            cell.viewCell.backgroundColor = UIColor.white
//            cell.viewCell.layer.shadowColor = UIColor.darkGray.cgColor
//            cell.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//            cell.viewCell.layer.shadowOpacity = 0.4
//            cell.viewCell.layer.shadowRadius = 1
//
//            cell.viewCell.layer.cornerRadius = cell.viewCell.frame.height / 2
//
//            cell.lblPickupTime.text = self.startDisplayDate
//            cell.lblDropoffTime.text = self.endDisplayDate
//
//            cell.layer.zPosition = (indexPath.row == 0) ? 1 : 0
            cell.selectionStyle = .none
            
            customCell = cell
        }

        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleFirstTimeDurationCell") as! VehicleFirstTimeDurationCell
            
            
            //            cell.viewCell.backgroundColor = UIColor.white
            cell.viewCell.layer.shadowColor = UIColor.darkGray.cgColor
            cell.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cell.viewCell.layer.shadowOpacity = 0.4
            cell.viewCell.layer.shadowRadius = 1
            
            cell.viewCell.layer.cornerRadius = cell.viewCell.frame.height / 2
            
            cell.lblPickupTime.text = self.startDisplayDate
            cell.lblDropoffTime.text = self.endDisplayDate
            
            cell.layer.zPosition = (indexPath.row == 0) ? 1 : 0
            cell.selectionStyle = .none
            
            customCell = cell
        }
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailMapViewCell") as! VehicleDetailMapViewCell
            //        cell.viewCell.layer.cornerRadius = 10
            //        cell.viewCell.layer.borderWidth = 1
            //        cell.viewCell.layer.borderColor = UIColor.lightGray.cgColor
            
            
           
            cell.setUiSetUp()
            
            cell.MapViewLatitude = 23.0
            //self.selectedAddLat
            cell.MapViewlongitude = 73.0
            //self.selectedAddLong
            cell.MapViewAddress = "30525 Linden Street PO Box 283 Lindstrom, MN 55045"
            //self.selectedAddress
            
            cell.setPinonMap()
            
            
            //        cell.viewCell.layer.masksToBounds = true
            //        cellMenu.imgDetail?.image = UIImage.init(named:  "\(arrMenuIcons[indexPath.row])")
            //        cellMenu.selectionStyle = .none
            //
            //        cellMenu.lblTitle.text = arrMenuTitle[indexPath.row]
            
            customCell = cell
        }
        else if indexPath.section == 3
        {
            ///PAyment Breakdown cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehiclePaymentBreakdownCell") as! VehiclePaymentBreakdownCell
            //            cell.Delegate = self
            //            cell.lblFarePriceKM.text = "\(currency) \( (self.Fare != "") ? String(format: "%.2f", (self.Fare as NSString).doubleValue) : "")"
            //            cell.lblRefundableDeposit.text = "\(currency) \( (self.Fare != "") ? String(format: "%.2f", (self.Fare as NSString).doubleValue) : "")"
            //            cell.lblSpecialFare.text = "\(currency) \( (self.SpecialFare != "") ? String(format: "%.2f", (self.SpecialFare as NSString).doubleValue) : "")"
            //            cell.lblDeliveryFare.text = "\(currency) \( (self.DeliveryFare != "") ? String(format: "%.2f", (self.DeliveryFare as NSString).doubleValue) : "")"
            //            cell.lblTaxAmount.text = "\(currency) \( (self.Tax != "") ? String(format: "%.2f", (self.Tax as NSString).doubleValue) : "")"
//            cell.PromoView.layer.shadowColor = UIColor.darkGray.cgColor
//            cell.PromoView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//            cell.PromoView.layer.shadowOpacity = 0.4
//            cell.PromoView.layer.shadowRadius = 1
//            cell.PromoView.layer.cornerRadius = 10
//
//            cell.btnApply.layer.cornerRadius = 5.0
//            cell.btnApply.layer.masksToBounds = true
//
//            cell.btnViewOffers.layer.cornerRadius = cell.btnViewOffers.frame.height/2.0
//            cell.btnViewOffers.layer.masksToBounds = true
            
//
//            if self.selectedTripType == "delivery" {
//                cell.ViewDeliveryFare.isHidden = false
//            } else {
//                cell.ViewDeliveryFare.isHidden = true
//            }
//
//            if self.AppliedPromocode  != "" {
//                cell.txtHavePromoCode.isEnabled = false
//                cell.btnRemovePromocode.isHidden = false
//                cell.imgVerified.isHidden = false
//            } else {
//                cell.txtHavePromoCode.isEnabled = true
//                cell.btnRemovePromocode.isHidden = true
//                cell.imgVerified.isHidden = true
//            }
            
            customCell = cell
        }
        else if indexPath.section == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailTotalAmountCell") as! VehicleDetailTotalAmountCell
            
            
            cell.setUpUI()
            
//            if self.Discount != "" {
//                //                cell.lblDiscountAmount.text = "\(currency) \( (self.Discount != "") ? String(format: "%.2f", (self.Discount as NSString).doubleValue) : "")"
//                cell.promocodeView.isHidden = false
//
//                let FinalAmount = Double(Double(self.Total)! - Double(self.Discount)!)
//                //                cell.lblTotalAmount.text = "\(currency)\(String(format: "%.2f", FinalAmount))"
//                //                if self.Total != "" {
//                //
//                //                    cell.lblTotalAmount.text = "\(currency)\((self.Total.contains(".") ? self.Total : (String(format: "%.2f",Double(self.Total)!))))"
//                //                }
//            } else {
//                cell.lblDiscountAmount.text = ""
//                cell.promocodeView.isHidden = true
//                if self.Total != "" {
//                    //                    cell.lblTotalAmount.text = "\(currency)\((self.Total.contains(".") ? self.Total : (String(format: "%.2f",Double(self.Total)!))))"
//                }
//            }
            
            customCell = cell
        }
//        else if indexPath.section == 4
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailExtraChargesCell") as! VehicleDetailExtraChargesCell
//            cell.viewNotes.layer.cornerRadius = 10
//            cell.viewNotes.layer.borderColor = UIColor.lightGray.cgColor
//            cell.viewNotes.layer.borderWidth = 1
//            customCell = cell
//        }
        customCell.selectionStyle = .none
        return customCell
        
    }
    
}


extension VehicleDetailViewController : UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        tblView.deselectRow(at: indexPath, animated: true)
        //        let  viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchForVehicleViewController") as! SearchForVehicleViewController
        //        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if indexPath.section == 0 {

            ///HEader cEll
            return 285 + topBarHeight
        }
        else if indexPath.section == 1 {

            return 0.0
        }
        else if indexPath.section == 2
        {
            ///Map cell
            return 202
        }
        else if indexPath.section == 3
        {
            //Payment Breakdown cell
            return 284.0
                //UITableView.automaticDimension
        }
        else if indexPath.section == 4
        {
            ///Total Amount
            return 220
            
        }
//        else if indexPath.section == 4
//        {
//            return 120
//        }
        else
        {
            return 60
        }
    }
    
}
