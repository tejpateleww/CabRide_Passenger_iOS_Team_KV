//
//  CancelTripViewController.swift
//  Peppea
//
//  Created by EWW074 on 09/01/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit
import DropDown

protocol delegateForCancelTripReason {
    func didCancelTripFromRider(obj: Any)
}

class CancelTripViewController: UIViewController,UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnSelectReason: UIButton!
    @IBOutlet weak var txtOtherReason: UITextField!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet var viewDropDown: UIView!
    @IBOutlet var btnOk: UIButton!

    var isDropDownHidden = false

    var strBtnOkText = String()
    var strTextPlaceHolder = String()
    // MARK: - Variables declaration
    var strMessage = String()
    var strDescription = String()
    var delegate: delegateForCancelTripReason?
    var reason: CancelReason?
    
    
    // MARK: - Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOtherReason.isHidden = true

        if(strBtnOkText.count != 0)
        {
            txtOtherReason.isHidden = false
            txtOtherReason.keyboardType = .numberPad
            txtOtherReason.isSecureTextEntry = true
            btnOk.setTitle(strBtnOkText, for: .normal)
        }
        if(strTextPlaceHolder.count != 0)
        {
            txtOtherReason.placeholder = strTextPlaceHolder
        }

        lblMessage.text = strDescription
        viewDropDown.isHidden = isDropDownHidden
        txtOtherReason.delegate = self
    }
    

    // MARK: - Actions
    @IBAction func btnSelectReasonAction(_ sender: UIButton) {
        
        var reasons = SingletonClass.sharedInstance.cancelReason.map{$0.reason}
        reasons.insert("Select Reason", at: 0)
        reasons.append("Other")
        
        let dropDown = DropDown()
        dropDown.anchorView = btnSelectReason
        dropDown.dataSource = reasons as! [String]// ?? [""]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.strMessage = item
            self.reason = nil
            self.btnSelectReason.setTitle(item, for: .normal)
            
            if item != "Select Reason" && item != "Other" {
                self.reason = SingletonClass.sharedInstance.cancelReason.filter{$0.reason == item}.first
            }
            self.txtOtherReason.isHidden = true
            if item == "Other" {
                self.txtOtherReason.text = ""
                self.txtOtherReason.isHidden = false
            }
            dropDown.hide()
        }
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .any
        dropDown.show()
    }
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        
        if delegate != nil {
            if self.reason != nil {
                delegate?.didCancelTripFromRider(obj: reason!)
                self.dismiss(animated: true, completion: nil)
            }
            else if txtOtherReason.isHidden == false {
                if txtOtherReason.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 {
                    delegate?.didCancelTripFromRider(obj: txtOtherReason.text ?? "")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    txtOtherReason.text = txtOtherReason.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                     if(isDropDownHidden)
                    {
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                        let image = UIImage(named: "iconAlert")
                        imageView.image = image
                        txtOtherReason.rightView = imageView
                        txtOtherReason.rightViewMode = .unlessEditing

                    }
                    else
                     {
                        UtilityClass.showAlert(title: "", message: "Please enter reason for cencel trip", alertTheme: .error)

                    }
                }
            }
            else if self.strMessage == "Select Reason" {
                
                UtilityClass.showAlert(title: "", message: "Please select reason for cencel trip", alertTheme: .error)
            }
        }
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 6
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtOtherReason.rightViewMode = .never

    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.didCancelTripFromRider(obj: "")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Custom Methods
   

   
    

}
