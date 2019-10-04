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
