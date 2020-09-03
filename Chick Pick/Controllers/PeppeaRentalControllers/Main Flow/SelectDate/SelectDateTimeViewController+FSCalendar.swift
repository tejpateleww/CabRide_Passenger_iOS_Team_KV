//
//  SelectDateTimeViewController+FSCalendar.swift
//  Peppea
//
//  Created by EWW078 on 03/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import FSCalendar
import UIKit



extension SelectDateTimeViewController {
    
    // MARK:- FSCalendarDataSource &  FSCalendarDelegate Methods
    /*
        Changing the date by calendar view
        - Select Date is updating, so below part is updating
        1. PickUp and Drop Off date,
           //1.1 related labels in Top View
        2. Date Label near to Ruler View
     
     //Note: Ruler is only responsible to update time part
     */

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        print("did select date \(self.dateFormatter.string(from: date))")
        self.lblDate.text = self.dateFormatter.string(from: date)
        self.SelectDate = date
        
        //        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        //        print("selected dates is \(selectedDates)")
        
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        //Updating date related labels
        self.updatePickUpDropOffDateLabels()
        
    }

    /* Updating Labels
         1. Select Date is updated in this method earlier
         2. Update selectedPickUpDateString
         3. Top View Labels pick up and drop off
     */

    func updatePickUpDropOffDateLabels() {
        
        if isForPickUp {
            //When u are on Pickup date page
            
            ///1.
            let DateformatterFinal = DateFormatter()
            DateformatterFinal.dateFormat = "yyyy-MM-dd"
            self.selectedPickUpDateString = "\(DateformatterFinal.string(from: self.SelectDate)) \(self.SelectedTimeHourFormat)"
            
            ///2.
            self.pickUpDateLbl.text = self.selectedPickUpDateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyDate)
            self.pickUpTimeLbl.text = self.selectedPickUpDateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyTime)

            
        }else{
            
            ///1. Basic date to update
            let DateformatterFinal = DateFormatter()
            DateformatterFinal.dateFormat = "yyyy-MM-dd"
            self.selectedDropOffdateString = "\(DateformatterFinal.string(from: self.SelectDate)) \(self.SelectedTimeHourFormat)"
            
            ///2. Top View Labels to be updated
            self.dropOffDateLbl.text = self.selectedDropOffdateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyDate)
            self.dropOffTimeLbl.text = self.selectedDropOffdateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyTime)

        }
        
    }
    
}
