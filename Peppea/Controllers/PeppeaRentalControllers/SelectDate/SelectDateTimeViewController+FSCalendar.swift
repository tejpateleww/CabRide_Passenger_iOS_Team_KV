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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        print("did select date \(self.dateFormatter.string(from: date))")
        self.lblDate.text = self.dateFormatter.string(from: date)
        self.SelectDate = date
        //        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        //        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
}
