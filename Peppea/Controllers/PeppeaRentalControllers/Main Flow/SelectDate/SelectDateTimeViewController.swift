//
//  SelectDateTimeViewController.swift
//  RentInFlash-Customer
//
//  Created by EWW-iMac Old on 18/12/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit
import RKMultiUnitRuler
import FSCalendar

protocol SelectDateDelegate {
    func DidSelectStartTripDate(SelectedDate:String, HoursFormat:String, DisplayAmPmFormat:String)
    func DidSelectEndTripDate(SelectedDate:String, HoursFormat:String, DisplayAmPmFormat:String)
}

class SelectDateTimeViewController: BaseViewController, RKMultiUnitRulerDataSource, RKMultiUnitRulerDelegate, FSCalendarDataSource, FSCalendarDelegate{
    
    var isForPickUp: Bool = true
    
    var selectedPickUpDateString: String = ""
    var selectedDropOffdateString: String = ""
 
    @IBOutlet weak var pickUpDateLbl: UILabel!
    @IBOutlet weak var pickUpTimeLbl: UILabel!


    @IBOutlet weak var dropOffDateLbl: UILabel!
    @IBOutlet weak var dropOffTimeLbl: UILabel!

    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var Ruler: RKMultiUnitRuler!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblTimeTitle: UILabel!
    @IBOutlet weak var CalendarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnSmallCalendar: UIButton!
    
    @IBOutlet weak var lblTime: UILabel!
    var currentCalendar: Calendar?
    var rangeStart = Measurement(value: 00.00, unit: UnitDuration.hours)
    var rangeLength = Measurement(value: Double(24.01), unit: UnitDuration.hours)
    var colorOverridesEnabled = false
    var segments = Array<RKSegmentUnit>()
    var TypeofSelection:String = ""
    var SelectDate = Date()
    var Delegate:SelectDateDelegate!
    
    var SelectedTimeHourFormat:String = ""
    var SelectedTimeHourWithAmPm:String = ""
    
    @IBOutlet weak var btnContinue: UIButton!
    override func loadView() {
        super.loadView()
        
        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale.current
        currentCalendar?.timeZone = NSTimeZone.system
        
    }
    
   lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    
    
    
    //MARK: View ControllerLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ///TODO:
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviLightBlueColor, naviTitle: "", leftImage: kClose_Icon, rightImage: "", isTranslucent: false)
        

//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = .white
        setNavBarWithBack(Title: "Date & Time", IsNeedRightButton: false)
            //, barColor: .white,titleFontColor: .black,backBarButtonColor: .black)
        setNavigationBarDefault()
        
        
        
        self.btnContinue.layer.cornerRadius = self.btnContinue.frame.height / 2.0
        self.btnContinue.layer.masksToBounds = true
        
        
        self.Ruler.direction = .horizontal
//        self.Ruler.tintColor = UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 38.0/255.0, alpha: 1.0)
//        self.Ruler.backgroundColor = UIColor.green
        segments = self.createSegments()
        self.Ruler?.delegate = self
        self.Ruler?.dataSource = self
        for subview  in self.Ruler.subviews {
            if let subSegment = subview as? UISegmentedControl {
                subSegment.backgroundColor = UIColor.white
                    //UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 38.0/255.0, alpha: 1.0)
                subSegment.isHidden = true
            } else if let sub = subview as? UIView {
                sub.backgroundColor = UIColor.white
                    //UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 38.0/255.0, alpha: 1.0)
                
            }
        }
        
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.calendarView.select(self.SelectDate)
        
        self.loadLabelDataFirstTime()

        
//        self.calendarView.scope = .week
//        self.CalendarHeight.constant = 100.0
//        self.calendarView.layoutIfNeeded()
//        self.view.layoutIfNeeded()
//        self.btnSmallCalendar.isSelected = true
        
        
        
        
    }
    
    func setNavigationBarDefault() {
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.view.backgroundColor = .white

    }
    
    
   

   
    
    
   
    
    //MARK: Button Click
    @IBAction func btnSingleLineDate(_ sender: UIButton) {
        
        if self.CalendarHeight.constant == 250.0 {
            //sender.isSelected == false {
            UIView.animate(withDuration: 0.5) {
                self.calendarView.scope = .week
                self.CalendarHeight.constant = 100.0
                self.calendarView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.calendarView.scope = .month
                self.CalendarHeight.constant = 250.0
                self.calendarView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
            
        }
        ///Note: Not using is selected property here, as we used tint color for button image,
        //selected state affects button image color so (nt using sleected state)
        //        sender.isSelected = !sender.isSelected
    }
    
   
    @IBAction func btnContinue(_ sender: Any) {
        
        let (isValid, message) = isValidate()
        
        if isValid {

            self.dismiss(animated: true) {
                let DateformatterFinal = DateFormatter()
                DateformatterFinal.dateFormat = "yyyy-MM-dd"
                let dateTimes = (self.lblTime.text!).components(separatedBy: " ")
                if self.TypeofSelection == "PICKUP" {
                    self.Delegate.DidSelectStartTripDate(SelectedDate: "\(DateformatterFinal.string(from: self.SelectDate)) \(dateTimes[0])", HoursFormat: "\(DateformatterFinal.string(from: self.SelectDate)) \(self.SelectedTimeHourFormat)", DisplayAmPmFormat: "\(DateformatterFinal.string(from: self.SelectDate)) \(self.lblTime.text!)")
                } else if self.TypeofSelection == "DROPOFF" {
                    self.Delegate.DidSelectEndTripDate(SelectedDate: "\(DateformatterFinal.string(from: self.SelectDate)) \(dateTimes[0])", HoursFormat: "\(DateformatterFinal.string(from: self.SelectDate)) \(self.SelectedTimeHourFormat)", DisplayAmPmFormat: "\(DateformatterFinal.string(from: self.SelectDate)) \(self.lblTime.text!)")
                }
                
            }//Dismiss ends here

        }else{
            
            AlertMessage.showMessageForError(message)
            
        } //Is validate ends here
    } //Button continue ends here
   
    
    func isValidate() -> (Bool,String) {
        
        var isValid:Bool = true
        var ValidatorMessage:String = ""
        
        ///Nil check
      
        let pickUpDate = self.selectedPickUpDateString.getDate(inputFormat: .dateWithOutSeconds)
        let dropOffDate = self.selectedDropOffdateString.getDate(inputFormat: .dateWithOutSeconds)


        if isForPickUp {
            //Checkng pick up date
            //1. Pickup date should be less than drop of date
           
            if pickUpDate == nil {
                
                ValidatorMessage = "Please select Pick Up Date"
                isValid = false
                
            }
            else {

                //Drop off date should be there for comparison
                if dropOffDate != nil {
                    
                    
                    let timeInterval = pickUpDate!.timeIntervalSince(dropOffDate!)
                    
                    if timeInterval > 0.0 {
                        
                        ValidatorMessage = "Pick up date must be less than drop off date"
                        isValid = false
                    }
                    
                }
                
            }
            
            
        }else{
            //Checking Drop off date
            if dropOffDate == nil {
                
                ValidatorMessage = "Please select Drop Off Date"
                isValid = false
                
            }
            else {
                
                //Pick Up date should be there for comparison
                if pickUpDate != nil {
                    
                    //Drop Off date should not be less than pick up date
                    //If the receiver is earlier than `anotherDate`, the return value is negative.
                    let timeInterval = dropOffDate!.timeIntervalSince(pickUpDate!)
                    
                    if timeInterval < 0.0 {
                        
                        ValidatorMessage = "Drop off date must be greater than pick up date"
                        isValid = false
                    }
                    
                }
                
            }
            
        }
        
        
    
        
        return (isValid,ValidatorMessage)
    }
    
  
    
    
    
   
    
}
