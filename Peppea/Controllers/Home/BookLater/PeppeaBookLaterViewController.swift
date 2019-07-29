//
//  PeppeaBookLaterViewController.swift
//  PepPea
//
//  Created by Mayur iMac on 08/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit


protocol didSelectDateDelegate {

    func didSelectDateAndTime(date: String)
}

class PeppeaBookLaterViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    var delegateOfSelectDateAndTime : didSelectDateDelegate!
    var selectedDateAndTime : String!

    override func viewDidLoad() {
        super.viewDidLoad()


        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 30, to: Date())
        datePicker.minimumDate = date

        datePickerValueChanged(self.datePicker)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {

        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd EEEE MMMM yyyy hh mm ss a"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        print(selectedDate)

        dateFormatter.dateFormat = "hh:mm a"
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: -10, to: sender.date) as! Date
        let selectedTime1 = dateFormatter.string(from: date)
        let selectedTime2 = dateFormatter.string(from: datePicker.date)
        self.lblTime.text = "\(selectedTime1) - \(selectedTime2)"

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
        delegateOfSelectDateAndTime?.didSelectDateAndTime(date: selectedDateAndTime)
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
