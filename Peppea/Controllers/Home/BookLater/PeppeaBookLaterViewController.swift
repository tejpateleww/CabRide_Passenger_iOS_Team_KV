//
//  PeppeaBookLaterViewController.swift
//  PepPea
//
//  Created by Mayur iMac on 08/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit


protocol didSelectDateDelegate {

    func didSelectDateAndTime(date: String, timeStemp: String)
}

class PeppeaBookLaterViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
   
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    var delegateOfSelectDateAndTime : didSelectDateDelegate!
    var selectedDateAndTime : String!
    var selectedTimeStemp = ""
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()


        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 30, to: Date())
        datePicker.minimumDate = date

        datePickerValueChanged(self.datePicker)
        // Do any additional setup after loading the view.
    }
    
    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {

        print("sender.date: \(datePicker.date)")
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd EEEE MMMM yyyy hh mm ss a"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        print("selectedDate: \(selectedDate)")

        dateFormatter.dateFormat = "hh:mm a"
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: -10, to: sender.date) as! Date
        print("date: \(date)")
        
        
//        yyyy-mm-dd hh:mm:ss
        
        let dateFormateForSendParam = DateFormatter()
        dateFormateForSendParam.dateFormat = "yyyy-MM-dd HH:mm:ss"
        selectedTimeStemp = dateFormateForSendParam.string(from: datePicker.date)
        
//        let myTimeInterval = TimeInterval(datePicker.date.timeIntervalSince1970)
        print("selectedTimeStemp: \(selectedTimeStemp)")
//        selectedTimeStemp = "\(Int(myTimeInterval))"
        
        let selectedTime1 = dateFormatter.string(from: date)
        let selectedTime2 = dateFormatter.string(from: datePicker.date)
        self.lblTime.text = "\(selectedTime1) - \(selectedTime2)"
        
//        UtilityClass

        dateFormatter.dateFormat = "EEEE,dd MMMM"
        let selectedDateAndDay = dateFormatter.string(from: date)

        let strDate = selectedDateAndDay

        self.lblDate.text = strDate

        selectedDateAndTime = "\(strDate) at \(selectedTime1)-\(selectedTime2)"
    }

    @IBAction func btnContinue(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        guard (delegateOfSelectDateAndTime != nil) else {
            return
        }
        delegateOfSelectDateAndTime?.didSelectDateAndTime(date: selectedDateAndTime, timeStemp: selectedTimeStemp)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
