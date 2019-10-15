//
//  SelectDateTimeViewController+Conversions.swift
//  Peppea
//
//  Created by EWW078 on 03/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation



extension SelectDateTimeViewController {
    
    
    func getTimeStringFromHours(Hours:Double) -> String {
        print(" \(Hours)")
        var timeString:String = "";
        //        int hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
        if (Hours == 0.0) || (Hours == 24.0) {
            timeString =  "12:00 AM";
        } else if (Hours < 12.0) {
            let strHours = "\(Hours)".components(separatedBy: ".")
            if strHours[1] != "0" {
                timeString =  "\(strHours[0]):30 AM"
            } else {
                timeString = "\(strHours[0]):00 AM"
            }
        } else if (Hours == 12.0) {
            timeString = "12:00 PM";
        } else if (Hours == 12.5) {
            timeString = "12:30 PM";
        } else if (Hours > 12.0) {
            let strHours = "\(Hours - 12.0)".components(separatedBy: ".")
            if strHours[1] != "0" {
                timeString =  "\(strHours[0]):30 PM"
            } else {
                timeString = "\(strHours[0]):00 PM"
            }
            //            timeString = hour-12 +"PM";
        }
        return timeString
    }
    
    func getMonthName(MonthNumber:Int) -> String {
        
        var MonthName:String = ""
        switch MonthNumber {
        case 1:
            MonthName = "Jan"
        case 2:
            MonthName = "Feb"
        case 3:
            MonthName = "Mar"
        case 4:
            MonthName = "Apr"
        case 5:
            MonthName = "May"
        case 6:
            MonthName = "Jun"
        case 7:
            MonthName = "Jul"
        case 8:
            MonthName = "Aug"
        case 9:
            MonthName = "Sep"
        case 10:
            MonthName = "Oct"
        case 11:
            MonthName = "Nov"
        case 12:
            MonthName = "Dec"
        default:
            break
        }
        return MonthName
    }
    

}


extension SelectDateTimeViewController {
    
    /*
     
     At this time we need to cehk all these things
         1. First time coming to this vc
         2. Canging the date in calendar view
         3. Changing the Time by ruler view
     
     In this method
        * Check List
         - Pick Up Date/ Drop Off Date from previous vc
         - "SelectDate" will be come from one of the above two dates
         - Update Top View Labels Pick Up date / Drop OFf date Labels
         - Calendar date to select
         - Ruler and Time Labels
      */
    
    func loadLabelDataFirstTime() {
        
        ///1
        if isForPickUp {
            
            self.lblDateTitle.text = "PICKUP DATE"
            self.lblTimeTitle.text = "PICKUP TIME"
            
            ///1. Calendar date to select
            let pickUpDatetoShowInCalendar = self.selectedPickUpDateString.getDate(inputFormat: .dateWithOutSeconds)
            self.calendarView.select(pickUpDatetoShowInCalendar)
            
            //2. If nil then assigning current date
            self.SelectDate = pickUpDatetoShowInCalendar ?? Date()
           
            
        }else{
            
            self.lblDateTitle.text = "DROP OFF DATE"
            self.lblTimeTitle.text = "DROP OFF TIME"
            
            ///1. Calendar date to select
            let dropOffDatetoShowInCalendar = self.selectedDropOffdateString.getDate(inputFormat: .dateWithOutSeconds)
            self.calendarView.select(dropOffDatetoShowInCalendar, scrollToDate: true)
            
            ///2. Select Date
            ///If nil then assigning current date
            self.SelectDate = dropOffDatetoShowInCalendar ?? Date()
           
        }
        
        ///2. Ruler Time
        self.updateTimeLabelAndRuler(from: self.SelectDate)
        
        ///3.  -------- Top View Date Labels to show ------------
        
        if selectedPickUpDateString != "" {
            
            self.pickUpDateLbl.text = self.selectedPickUpDateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyDate)
            self.pickUpTimeLbl.text = self.selectedPickUpDateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyTime)
            
        }else{
            
            self.pickUpDateLbl.text = "-"
            self.pickUpTimeLbl.text = ""
            
        }
        
        
        if selectedDropOffdateString != "" {
            
            self.dropOffDateLbl.text = self.selectedDropOffdateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyDate)
            self.dropOffTimeLbl.text = self.selectedDropOffdateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyTime)
            
            
        }else{
            
            self.dropOffDateLbl.text = "-"
            self.dropOffTimeLbl.text = ""
        }
        
        
    }
    
    // Updating Ruler and Time Label based on date procided
    // Mosty used when page loads
    func updateTimeLabelAndRuler(from date1: Date) {
        
        if let currentCalendar = currentCalendar {
            
            lblDate.text = self.dateFormatter.string(from: date1).uppercased()
            let DateComponents = currentCalendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date1)
            
            ///Note: For 4.30 -- this format we need to device minutes by 100
            lblTime.text = self.getTimeStringFromHours(Hours: Double(DateComponents.hour!) + (Double(DateComponents.minute!))/100)
            
            
            self.Ruler.measurement = NSMeasurement(
                doubleValue: Double(DateComponents.hour!),
                unit: UnitDuration.hours)
            let HourlyBase = "\(self.Ruler.measurement!.doubleValue)".components(separatedBy: ".")
            self.SelectedTimeHourFormat = "\((((HourlyBase[0] == "0") || (HourlyBase[0] == "24")) ? "0" : HourlyBase[0])):\(((HourlyBase[1] == "0") ? "00" : HourlyBase[1]))"
            
        }
        
    }
    
}
