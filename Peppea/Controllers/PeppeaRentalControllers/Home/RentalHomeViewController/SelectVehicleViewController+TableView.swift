//
//  SelectVehicleViewController+TableView.swift
//  Peppea
//
//  Created by EWW078 on 28/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation


// MARK: - Table view data source

extension SelectVehicleViewController : UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrVehicles.count > 0 ? arrVehicles.count : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.arrVehicles.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectVehicleViewCell") as! SelectVehicleViewCell
            
            cell.selectionStyle = .none

            cell.uiSetup()
            
            cell.DelegateForVehicalBook = self

            
            let VehicleDict = self.arrVehicles[indexPath.row]
            


            
            cell.lblVehicleName.text = VehicleDict["vehiclemodel"] as? String ?? ""
            
            if let capacity = VehicleDict["number_of_people"] as? String {
                cell.lblSeater.text = "\(capacity) seater"
            }
            
            if let Distance = VehicleDict["distance"] as? String {
                cell.lblDistance.text = "Within \(String(format: "%.2f", Double(Distance)!)) km"
            }
            
            //        if let VehicleImageName = VehicleDict["image"] as? String {
            //            let VehicleURL = URL(string: "\(WebserviceURLs.kImageVehicleBaseURL)\(VehicleImageName)")
            //            cell.iconVehicle.sd_setShowActivityIndicatorView(true)
            //            cell.iconVehicle.sd_setIndicatorStyle(.gray)
            //            cell.iconVehicle.sd_setImage(with: VehicleURL, placeholderImage: UIImage(named: "imgYellowCar"))
            //        }
                cell.lblAddress.text = VehicleDict["address"] as? String ?? ""

            if self.NeedToReload == true && indexPath.row == self.arrVehicles.count - 1  {
                self.reloadMoreHistory()
            }
            
            return cell

        } else {

            let noDataCell = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! UITableViewCell

            return noDataCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tblView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath)
        self.didVehicleBook(CustomCell: cell!)
        
    }
    
    func didVehicleBook(CustomCell: UITableViewCell) {
        
        let customIndexPath = self.tblView.indexPath(for: CustomCell)!
        let vehicleDetail = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailViewController") as! VehicleDetailViewController
        vehicleDetail.VehicleDetail = self.arrVehicles[customIndexPath.row] as [String : AnyObject]
        vehicleDetail.vehicleFrom_To = (startDate,endDate)
        vehicleDetail.startDisplayDate = self.DisplayPickupDate
        vehicleDetail.endDisplayDate = self.DisplayDeliveryDate
        vehicleDetail.selectedAddress = self.selectedAddress
        vehicleDetail.selectedAddLat = self.selectedAddLat
        vehicleDetail.selectedAddLong = self.selectedAddLong
        vehicleDetail.selectedTripType = self.selectedTripType
        vehicleDetail.VehicalCat_IDName = self.VehicalCat_IDName
        self.navigationController?.pushViewController(vehicleDetail, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrVehicles.count > 0 {
            return 110
            //150
        } else {
            return 200
        }
    }
    
   
    
}

