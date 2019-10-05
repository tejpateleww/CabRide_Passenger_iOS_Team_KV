//
//  SelectDateTimeViewController+RKMultiUnitSegment.swift
//  Peppea
//
//  Created by EWW078 on 03/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import RKMultiUnitRuler

extension SelectDateTimeViewController {
    
    //MARK:- RKMultiUnitRulerDataSource & RKMultiUnitRulerDelegate Methods
    
    func valueChanged(measurement: NSMeasurement) {
        self.lblTime.text = self.getTimeStringFromHours(Hours: measurement.doubleValue)
        let HourlyBase = "\(measurement.doubleValue)".components(separatedBy: ".")
        
        self.SelectedTimeHourFormat = "\((((HourlyBase[0] == "0") || (HourlyBase[0] == "24")) ? "0" : HourlyBase[0])):\(((HourlyBase[1] != "0") ? "30" : "00"))"
    }
    
    func createSegments() -> Array<RKSegmentUnit> {
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
    
    
}
