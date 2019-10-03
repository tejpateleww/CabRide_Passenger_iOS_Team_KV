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
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ///TODO:
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviLightBlueColor, naviTitle: "", leftImage: kClose_Icon, rightImage: "", isTranslucent: false)
        

        self.navigationController?.navigationBar.barTintColor = .white
        setNavBarWithBack(Title: "Date & Time", IsNeedRightButton: false, barColor: .white,titleFontColor: .black,backBarButtonColor: .black)
        
        
        if isForPickUp {
            
            self.lblDateTitle.text = "PICKUP DATE"
            self.lblTimeTitle.text = "PICKUP TIME"
        }else{
            
            self.lblDateTitle.text = "DROP OFF DATE"
            self.lblTimeTitle.text = "DROP OFF TIME"
        }
       
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
    
    //    if sender.isSelected == false {
    //
    //    self.CalendarHeight.constant = 250.0
    //    UIView.animate(withDuration: 0.5, animations: {
    //    self.view.layoutIfNeeded()
    //    self.calendarView.layoutIfNeeded()
    //    }) { (status) in
    //    self.calendarView.scope = .month
    //    }
    //
    //    } else {
    //    self.CalendarHeight.constant = 100.0
    //    UIView.animate(withDuration: 0.5, animations: {
    //    self.view.layoutIfNeeded()
    //    self.calendarView.layoutIfNeeded()
    //    }) { (status) in
    //    self.calendarView.scope = .week
    //    }
    //    }
    
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
    
    
    
    
    //MARK:- RKMultiUnitRulerDataSource & RKMultiUnitRulerDelegate Methods
    
    func valueChanged(measurement: NSMeasurement) {
        self.lblTime.text = self.getTimeStringFromHours(Hours: measurement.doubleValue)
        let HourlyBase = "\(measurement.doubleValue)".components(separatedBy: ".")
        
        self.SelectedTimeHourFormat = "\((((HourlyBase[0] == "0") || (HourlyBase[0] == "24")) ? "0" : HourlyBase[0])):\(((HourlyBase[1] != "0") ? "30" : "00"))"
    }
    
    private func createSegments() -> Array<RKSegmentUnit> {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        
        formatter.unitOptions = .providedUnit
        let kgSegment = RKSegmentUnit(name: "", unit: UnitDuration.hours, formatter: formatter)
        kgSegment.name = ""
        kgSegment.unit = UnitDuration.hours
        let kgMarkerTypeMax = RKRangeMarkerType(color: UIColor.gray, size: CGSize(width: 1.0, height: 50.0), scale: 5.0)
        kgMarkerTypeMax.labelVisible = true
        
        kgSegment.markerTypes = [
            RKRangeMarkerType(color: UIColor.gray, size: CGSize(width: 1.0, height: 35.0), scale: 0.5),
            RKRangeMarkerType(color: UIColor.gray, size: CGSize(width: 1.0, height: 50.0), scale: 1.0)]
        kgSegment.markerTypes.last?.labelVisible = true
        return [kgSegment]
    }
    
    func unitForSegmentAtIndex(index: Int) -> RKSegmentUnit {
        return segments[index]
    }
    var numberOfSegments: Int {
        get {
            return segments.count
        }
        set {
        }
    }
    
    func rangeForUnit(_ unit: Dimension) -> RKRange<Float> {
        let locationConverted = rangeStart.converted(to: unit as! UnitDuration)
        let lengthConverted = rangeLength.converted(to: unit as! UnitDuration)
        return RKRange<Float>(location: ceilf(Float(locationConverted.value)),
                              length: ceilf(Float(lengthConverted.value)))
    }
    
    func styleForUnit(_ unit: Dimension) -> RKSegmentUnitControlStyle {
        let style: RKSegmentUnitControlStyle = RKSegmentUnitControlStyle()
        style.scrollViewBackgroundColor = UIColor.white
            //UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 38.0/255.0, alpha: 1.0)
//            UIColor(red: 0.22, green: 0.74, blue: 0.86, alpha: 1.0)
        let range = self.rangeForUnit(unit)
        if unit == UnitMass.pounds {
            
            style.textFieldBackgroundColor = UIColor.clear
            // color override location:location+40% red , location+60%:location.100% green
        } else {
            style.textFieldBackgroundColor = UIColor.red
        }
        style.colorOverrides = [
            RKRange<Float>(location: range.location, length: 0.1 * (range.length)): UIColor.gray,
            RKRange<Float>(location: range.location + 0.4 * (range.length), length: 0.2 * (range.length)): UIColor.gray]
        style.textFieldBackgroundColor = UIColor.clear
        style.textFieldTextColor = UIColor.white
    
        return style
    }
    
    
    func colorSwitchValueChanged(sender: UISwitch) {
        colorOverridesEnabled = sender.isOn
        self.Ruler?.refresh()
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
