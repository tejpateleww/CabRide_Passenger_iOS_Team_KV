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
    
    var selectedPickUpDate: String = ""
    var selectedDropOffdate: String = ""
 
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
        
        
        self.setUpLabelData()
        
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
        
        
//        self.calendarView.scope = .week
//        self.CalendarHeight.constant = 100.0
//        self.calendarView.layoutIfNeeded()
//        self.view.layoutIfNeeded()
//        self.btnSmallCalendar.isSelected = true
        
        
        if let currentCalendar = currentCalendar {
            
            lblDate.text = self.dateFormatter.string(from: self.SelectDate)
            let DateComponents = currentCalendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
            lblTime.text = self.getTimeStringFromHours(Hours: Double(DateComponents.hour!))
            
            self.Ruler.measurement = NSMeasurement(
                doubleValue: Double(DateComponents.hour!),
                unit: UnitDuration.hours)
            let HourlyBase = "\(self.Ruler.measurement!.doubleValue)".components(separatedBy: ".")
            self.SelectedTimeHourFormat = "\((((HourlyBase[0] == "0") || (HourlyBase[0] == "24")) ? "0" : HourlyBase[0])):\(((HourlyBase[1] == "0") ? "00" : HourlyBase[1]))"
            
        }
        
    }
    
    func setNavigationBarDefault() {
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.view.backgroundColor = .white

    }
    
    
    func setUpLabelData() {
        
        ///1
        if isForPickUp {
            
            self.lblDateTitle.text = "PICKUP DATE"
            self.lblTimeTitle.text = "PICKUP TIME"
        }else{
            
            self.lblDateTitle.text = "DROP OFF DATE"
            self.lblTimeTitle.text = "DROP OFF TIME"
        }
        
        
        ///2
        if selectedPickUpDate != "" {

            self.pickUpDateLbl.text = self.selectedPickUpDate.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyDate)
            self.pickUpTimeLbl.text = self.selectedPickUpDate.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyTime)

        }else{
            self.pickUpDateLbl.text = "-"
            self.pickUpTimeLbl.text = ""
        }


        ///3
        if selectedDropOffdate != "" {
            
            self.dropOffDateLbl.text = self.selectedDropOffdate.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyDate)
            self.dropOffTimeLbl.text = self.selectedDropOffdate.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .onlyTime)

        }else{

            self.dropOffDateLbl.text = "-"
            self.dropOffTimeLbl.text = ""
        }
        
        
    }
    
    //MARK: Button Click
    @IBAction func btnSingleLineDate(_ sender: UIButton) {
        
        if sender.isSelected == false {
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
        sender.isSelected = !sender.isSelected
    }
    
   
    @IBAction func btnContinue(_ sender: Any) {
        self.dismiss(animated: true) {
            let DateformatterFinal = DateFormatter()
            DateformatterFinal.dateFormat = "yyyy-MM-dd"
            let dateTimes = (self.lblTime.text!).components(separatedBy: " ")
            if self.TypeofSelection == "PICKUP" {
                self.Delegate.DidSelectStartTripDate(SelectedDate: "\(DateformatterFinal.string(from: self.SelectDate)) \(dateTimes[0])", HoursFormat: "\(DateformatterFinal.string(from: self.SelectDate)) \(self.SelectedTimeHourFormat)", DisplayAmPmFormat: "\(DateformatterFinal.string(from: self.SelectDate)) \(self.lblTime.text!)")
            } else if self.TypeofSelection == "DROPOFF" {
                self.Delegate.DidSelectEndTripDate(SelectedDate: "\(DateformatterFinal.string(from: self.SelectDate)) \(dateTimes[0])", HoursFormat: "\(DateformatterFinal.string(from: self.SelectDate)) \(self.SelectedTimeHourFormat)", DisplayAmPmFormat: "\(DateformatterFinal.string(from: self.SelectDate)) \(self.lblTime.text!)")
            }
        }
    }
   
    
    
    
    
  
    
    
    
   
    
}
