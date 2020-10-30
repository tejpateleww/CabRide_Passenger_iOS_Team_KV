//
//  MyTrips.swift
//  Chick Pick
//
//  Created by EWW-iMac Old on 05/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

enum MyTrips: String, CaseIterable{
    
    case past = "Past"
    //    case current = "Current"
    case upcoming = "Upcoming"
    
    
    func getDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
        switch self {
        case .past:
            return setPastDescription(pastBookingHistory: pastBookingHistory)
        case .upcoming:
            return setUpcomingDescription(pastBookingHistory: pastBookingHistory)
            //        case .current:
            //            return setUpcomingDescription(pastBookingHistory: pastBookingHistory)
            
        }
    }
    
    static var titles = MyTrips.allCases.map({$0.rawValue})
    
    fileprivate func setPastDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
        
        if pastBookingHistory.status == "canceled" {
            
            if pastBookingHistory.cancelBy != "driver" {
                let tempArray = [("Status" , "Cancelled"), ("Cancellation Charges" , "\(Currency) \(pastBookingHistory.cancellationCharge ?? "")"), ("Total Paid To Driver" , "\(Currency) \(pastBookingHistory.grandTotal ?? "")")]
                
                return tempArray
            } else {
                let tempArray = [("Status" , "Cancelled")]
                
                return tempArray
            }
            
            
        } else {
            var tempArray = [("Pick Up Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: pastBookingHistory.pickupTime, dateFormat: "dd-MM-YYYY HH:mm:ss") ),
                             ("Drop Off Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: pastBookingHistory.dropoffTime, dateFormat: "dd-MM-YYYY HH:mm:ss")),
                             ("Subtotal" , "\(Currency) \(pastBookingHistory.subTotal ?? "")"),
                             //                             ("Booking Fee" , pastBookingHistory.bookingFee),
                //                             ("Base Fare" , pastBookingHistory.baseFare),
                //                ("Time Cost :" , pastBookingHistory.id),
                ("Other Charges" , ""),
                ("Discount" , "\(Currency) \(pastBookingHistory.discount ?? "")"),
                
                //                ("Other Charges" , pastBookingHistory.subTotal),
                //                ("Cancellation Charges" , pastBookingHistory.cancellationCharge),
                //                ("Promocode" , pastBookingHistory.promocode),
                ("Total Paid To Driver" ,"\(Currency) \(pastBookingHistory.grandTotal ?? "")")
                
            ]
            
            
            if(pastBookingHistory.promocode.count != 0)
            {
                tempArray.insert( ("Promocode" , pastBookingHistory.promocode), at: tempArray.count-1)
            }
            return tempArray
        }
    }
    
    //    fileprivate func setPastDescriptionIfCancelled(pastBookingHistory : PastBookingHistoryResponse?) -> [(title : String, description : Any)]{
    //        guard obj != nil else { return []}
    //        return [("Vehicle Type" , obj?["Model"] ?? ""),
    //                ("Waiting Time" , obj?["WaitingTime"] ?? ""),
    //                ("Payment Type" , obj?["PaymentType"] ?? ""),
    //                ("Trip Status" , obj?["Status"] ?? "")]
    //
    //    }
    
    fileprivate func setFutureDescription(section: Int) { enum MyTrips: String, CaseIterable {
        
        case past = "Past"
        //        case current = "Current"
        case upcoming = "Upcoming"
        
        func getDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
            switch self {
            case .past:
                return setPastDescription(pastBookingHistory: pastBookingHistory)
            case .upcoming:
                return setUpcomingDescription(pastBookingHistory: pastBookingHistory)
                //            case .current:
                //                return setUpcomingDescription(pastBookingHistory: pastBookingHistory)
                
            }
        }
        static var titles = MyTrips.allCases.map({$0.rawValue})
        
        fileprivate func setPastDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
            
            if pastBookingHistory.status == "canceled" {
                let tempArray = [("Status" , "Cancelled")]
                return tempArray
                
            } else {
                var tempArray = [("Pick Up Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: pastBookingHistory.pickupTime, dateFormat: "dd-MM-YYYY HH:mm:ss") ),
                                 ("Drop Off Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: pastBookingHistory.dropoffTime, dateFormat: "dd-MM-YYYY HH:mm:ss")),
                                 ("Booking Fee" ,"\(Currency) \(pastBookingHistory.bookingFee ?? "")"),
                                 ("Base Fare" , "\(Currency) \(pastBookingHistory.baseFare ?? "")"),
                                 //                ("Time Cost :" , pastBookingHistory.id),
                    ("Subtotal" , "\(Currency) \(pastBookingHistory.subTotal ?? "")"),
                    //                ("Other Charges" , pastBookingHistory.subTotal),
                    //                ("Cancellation Charges" , pastBookingHistory.cancellationCharge),
                    //                ("Promocode" , pastBookingHistory.promocode),
                    ("Total Paid To Driver" , "\(Currency) \(pastBookingHistory.grandTotal ?? "")")
                ]
                
                if(pastBookingHistory.promocode.count != 0)
                {
                    tempArray.insert( ("Promocode" , pastBookingHistory.promocode), at: tempArray.count-1)
                }
                return tempArray
            }
        }
        
        fileprivate func setFutureDescription(section: Int){
        }
        
        fileprivate func setUpcomingDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)] {
            
            let inter = TimeInterval("\(pastBookingHistory.pickupDateTime!)") ?? 0
            let date = Date(timeIntervalSince1970: inter)
            let dateFormatter = DateFormatter()
            //        dateFormatter.locale = Locale.currentf
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss" //Specify your format that you want
            var strDate = dateFormatter.string(from: date)
            
            if pastBookingHistory.pickupDateTime == "" {
                strDate = "N/A"
            }
            
            return [("Date" , strDate),
                    ("Vehicle Model" , pastBookingHistory.vehicleName)]
        }
        }
    }
    
    fileprivate func setUpcomingDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
        
        let inter = TimeInterval("\(pastBookingHistory.pickupDateTime!)") ?? 0
        let date = Date(timeIntervalSince1970: inter)
        let dateFormatter = DateFormatter()
        //        dateFormatter.locale = Locale.currentf
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss" //Specify your format that you want
        var strDate = dateFormatter.string(from: date)
        
        if pastBookingHistory.pickupDateTime == "" {
            strDate = "N/A"
        }
        
        return [("Date" , strDate),
                ("Vehicle Model" , pastBookingHistory.vehicleName)]
    }
}
