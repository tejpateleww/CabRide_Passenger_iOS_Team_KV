//
//  SelectVehicleViewController+WebService.swift
//  Peppea
//
//  Created by EWW078 on 28/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation



// MARK:- Custom Methods

extension SelectVehicleViewController {
    
    
    
    func reloadMoreHistory() {
        self.PageNumber += 1
//        self.LoaderBackView.isHidden = false
        self.ActivityIndicator.startAnimating()
        //        self.webserviceFindVehicle()
    }
    
    //    func webserviceFindVehicle()
    //    {
    //        var dictParams = [String:Any]()
    //
    //        dictParams["pickup_location"] = self.selectedAddress
    //        dictParams["start_lat"] = self.selectedAddLat
    //        dictParams["start_lang"] = self.selectedAddLong
    //        dictParams["pickup_time"] = self.startDate
    //        //            self.selectedPickupTime
    //        dictParams["drop_time"] = self.endDate
    //        //                self.selectedDeliveryTime
    //        dictParams["category"] = self.VehicalCat_IDName.0
    //        dictParams["page"] = self.PageNumber
    //
    //        if FilterByType != "" {
    //            dictParams["type"] = self.FilterByType
    //        }
    //
    //        if FilterByModel != "" {
    //            dictParams["model"] = self.FilterByModel
    //        }
    //
    //        webserviceForFindVehicles(dictParams, showHUD: true) { (result, status) in
    //            if status
    //            {
    //                print(result)
    //                let arrVehicalList = result["data"] as! [[String : Any]]
    //
    //                if arrVehicalList.count == 10 {
    //                    self.NeedToReload = true
    //                } else {
    //                    self.NeedToReload = false
    //                }
    //
    //                if self.arrVehicles.count == 0 {
    //                    self.arrVehicles = arrVehicalList
    //                } else {
    //                    self.arrVehicles.append(contentsOf: arrVehicalList)
    //                }
    //
    //                if self.LoaderBackView.isHidden == false {
    //                    self.ActivityIndicator.stopAnimating()
    //                    self.LoaderBackView.isHidden = true
    //                }
    //
    //                self.tblView.reloadData()
    //
    //                //                    let SuccessAlert = UIAlertController(title: "Password Updated Successfully.", message: "", preferredStyle: .alert)
    //                //                    SuccessAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
    //                //                        self.navigationController?.popViewController(animated: true)
    //                //                    }))
    //                //                    self.present(SuccessAlert, animated: true, completion: nil)
    //
    //            }else {
    //                print(result)
    //                if let ErrorMessages = (result as! NSDictionary).object(forKey: "error") as? [String] {
    //                    let strMSG = ErrorMessages[0]
    //                    Utilities.showAlert(appName, message: strMSG, vc: self)
    //                } else if let ErrorMessage = (result as! NSDictionary).object(forKey: "error") as? String {
    //                    let strMSG = ErrorMessage
    //                    Utilities.showAlert(appName, message: strMSG, vc: self)
    //                }
    //            }
    //        }
    //
    //    }
    
    
    //    func getDummyVehicles() -> [[String: Any]] {
    //
    //        var arrayVehicles: [[String: Any]] = [
    //                                                [
    //                                                 "vehicleName" : "Ford Figo",
    //                                                 "noOfSeats" : "5 Seater",
    //                                                 "distance": "5.5 km",
    //                                                 "Address": "Linden Street, PO Box No 12345"],
    //                                                [
    //                                                    "vehicleName" : "Ford Figo",
    //                                                    "noOfSeats" : "5 Seater",
    //                                                    "distance": "5.5 km",
    //                                                    "Address": "Linden Street, PO Box No 12345"],
    //                                                [
    //                                                    "vehicleName" : "Ford Figo",
    //                                                    "noOfSeats" : "5 Seater",
    //                                                    "distance": "5.5 km",
    //                                                    "Address": "Linden Street, PO Box No 12345"],
    //                                                [
    //                                                    "vehicleName" : "Ford Figo",
    //                                                    "noOfSeats" : "5 Seater",
    //                                                    "distance": "5.5 km",
    //                                                    "Address": "Linden Street, PO Box No 12345"]
    //                                            ]
    //
    //        return arrayVehicles
    //    }
}
