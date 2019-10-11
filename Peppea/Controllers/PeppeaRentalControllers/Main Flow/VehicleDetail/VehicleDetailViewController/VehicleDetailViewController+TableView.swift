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
            
            customCell = cell
        }
        else if indexPath.section == 3
        {
            ///PAyment Breakdown cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehiclePaymentBreakdownCell") as! VehiclePaymentBreakdownCell
            
            cell.setUpUI()
            
            
            customCell = cell
        }
        else if indexPath.section == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailTotalAmountCell") as! VehicleDetailTotalAmountCell
            
            
            cell.setUpUI()
            
            
            customCell = cell
        }

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
