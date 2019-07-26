//
//  MyTrips.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 05/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

enum MyTrips: String, CaseIterable{
    
    case past = "Past"
    case upcoming = "Upcoming"
    
  
    func getDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
        switch self {
        case .past:
            return setPastDescription(pastBookingHistory: pastBookingHistory)
        case .upcoming:
            return setUpcomingDescription(pastBookingHistory: pastBookingHistory)
        }
    }
    static var titles = MyTrips.allCases.map({$0.rawValue})
    
    fileprivate func setPastDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{

        var tempArray = [("Pick Up Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: pastBookingHistory.pickupTime, dateFormat: "dd-MM-YYYY HH:mm:ss") ),
                         ("Drop Off Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: pastBookingHistory.dropoffTime, dateFormat: "dd-MM-YYYY HH:mm:ss")),
                         ("Booking Fee" , pastBookingHistory.bookingFee),
                         ("Base Fare" , pastBookingHistory.baseFare),
                         //                ("Time Cost :" , pastBookingHistory.id),
            ("Subtotal" , pastBookingHistory.subTotal),
            //                ("Other Charges" , pastBookingHistory.subTotal),
            //                ("Cancellation Charges" , pastBookingHistory.cancellationCharge),
            //                ("Promocode" , pastBookingHistory.promocode),
            ("Total Paid To Driver" , pastBookingHistory.grandTotal)

        ] as! [(String,String)]


        if(pastBookingHistory.promocode.count != 0)
        {
            tempArray.insert( ("Promocode" , pastBookingHistory.promocode), at: tempArray.count-1)
        }

        return tempArray
    }


//    fileprivate func setPastDescriptionIfCancelled(pastBookingHistory : PastBookingHistoryResponse?) -> [(title : String, description : Any)]{
//        guard obj != nil else { return []}
//        return [("Vehicle Type" , obj?["Model"] ?? ""),
//                ("Waiting Time" , obj?["WaitingTime"] ?? ""),
//                ("Payment Type" , obj?["PaymentType"] ?? ""),
//                ("Trip Status" , obj?["Status"] ?? "")]
//
//    }


    fileprivate func setFutureDescription(section: Int){
    }
    
    fileprivate func setUpcomingDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
        return [("Title" ,"Upcoming"),
                ("PickupLocation" , pastBookingHistory.pickupLocation),
                ("DropoffLocation" , pastBookingHistory.dropoffLocation),
                ("Date" , pastBookingHistory.pickupDateTime),
                ("BookingId" , pastBookingHistory.id)]
    }
}