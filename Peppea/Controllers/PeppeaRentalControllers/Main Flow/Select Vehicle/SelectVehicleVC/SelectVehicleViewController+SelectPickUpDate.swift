//
//  SelectVehicleViewController+SelectPickUpDate.swift
//  Peppea
//
//  Created by EWW078 on 10/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation



extension SelectVehicleViewController: SelectDateDelegate {
   
    
    
    
    @IBAction func selectPickUpDateButtonClicked(_ sender: Any) {
    
        let selectDateTime = self.storyboard?.instantiateViewController(withIdentifier: "SelectDateTimeViewController") as! SelectDateTimeViewController
        selectDateTime.Delegate = self
        selectDateTime.TypeofSelection = "PICKUP"
        selectDateTime.isForPickUp = true
        
        
        //Data to Pass
        selectDateTime.selectedPickUpDate = self.selectedPickUpDate
        selectDateTime.selectedDropOffdate = self.selectedDropOffDate
        
        let NavSelect = UINavigationController(rootViewController: selectDateTime)
        self.present(NavSelect, animated: true, completion: nil)
    
    }
    
    @IBAction func selectDropOffDateButtonClicked(_ sender: Any) {
    
        let selectDateTime = self.storyboard?.instantiateViewController(withIdentifier: "SelectDateTimeViewController") as! SelectDateTimeViewController
        selectDateTime.Delegate = self
        selectDateTime.TypeofSelection = "DROPOFF"
        selectDateTime.isForPickUp = false
        
        
        //Data to Pass
        selectDateTime.selectedPickUpDate = self.selectedPickUpDate
        selectDateTime.selectedDropOffdate = self.selectedDropOffDate
        
        let NavSelect = UINavigationController(rootViewController: selectDateTime)
        self.present(NavSelect, animated: true, completion: nil)
    
    
    }
    
    
    //MARK: Select Date delegate
    /*
     - Selecteddate: "2019-10-14 5:30"
     - HoursFormat: "2019-10-14 17:30"
     - DisplayAmPmFormat : "2019-10-14 5:30 PM"
     */
    func DidSelectStartTripDate(SelectedDate: String, HoursFormat: String, DisplayAmPmFormat: String) {
        
        //        self.pickTimeToDisplay = DisplayAmPmFormat
        self.selectedPickUpDate = HoursFormat
        ///yyyy-MM-dd HH:mm
        ///24 hours format
        
        //To Display in cell
        self.lblPickUpDate.text = "\(HoursFormat)".convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .fullDate)

    }
    
    /*
     - Selecteddate: "2019-10-14 5:30"
     - HoursFormat: "2019-10-14 17:30"
     - DisplayAmPmFormat : "2019-10-14 5:30 PM"
     */
    func DidSelectEndTripDate(SelectedDate: String, HoursFormat: String, DisplayAmPmFormat: String) {
        
        //        self.dropOffTimeToDisplay = DisplayAmPmFormat
        self.selectedDropOffDate = HoursFormat
        ///yyyy-MM-dd HH:mm
        ///24 hours format
        
        //To Display in cell
        self.lblDropOffDate.text = "\(HoursFormat)".convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .fullDate)
        
        
    }
    
}

