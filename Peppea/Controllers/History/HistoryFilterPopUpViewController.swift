//
//  HistoryFilterPopUpViewController.swift
//  Peppea
//
//  Created by eww090 on 12/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class HistoryFilterPopUpViewController: BaseViewController
{

    
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var txtFromDate: ThemeTextFieldLoginRegister!
     @IBOutlet weak var txtToDate: ThemeTextFieldLoginRegister!
    
    var strSelectedFromDate = String()
    var strSelectedTODate = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        viewPopup.roundCorners([.topRight , .topLeft], radius: 10)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func txtDateFrom(_ sender: SkyFloatingLabelTextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.maximumDate = Date()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethodFromDate(_:)), for: UIControl.Event.valueChanged)
    }
    
    @IBAction func txtDateTO(_ sender: SkyFloatingLabelTextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.maximumDate = Date()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethodTodate(_:)), for: UIControl.Event.valueChanged)
    }
    
    
    @objc func pickupdateMethodFromDate(_ sender: UIDatePicker)
    {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        txtFromDate.text = dateFormaterView.string(from: sender.date)
        strSelectedFromDate = txtFromDate.text!
    }
    
    @objc func pickupdateMethodTodate(_ sender: UIDatePicker)
    {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        txtToDate.text = dateFormaterView.string(from: sender.date)
        strSelectedTODate = txtToDate.text!
    }
    
    
    @IBAction func bnOKClikced(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
