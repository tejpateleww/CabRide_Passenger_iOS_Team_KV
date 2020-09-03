//
//  MyMiles.swift
//  Peppea
//
//  Created by Apple on 09/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation


enum MyMiles: String, CaseIterable{
    
    case myMile = "MY MILE"
    case corporateMile = "CORPORATE MILE"
    case transferMile = "TRANSFER MILE"
    
    
    func getDescription(myMilesHistory : BulkMileListDataModel) -> [(String, String)]{
        switch self {
        case .myMile:
            return setMyMilesDescription(myMilesHistory: myMilesHistory)
        case .corporateMile:
//            return setUpcomingDescription(pastBookingHistory: myMilesHistory)
            return setMyMilesDescription(myMilesHistory: myMilesHistory)
        case .transferMile:
//            return setUpcomingDescription(pastBookingHistory: myMilesHistory)
            return setMyMilesDescription(myMilesHistory: myMilesHistory)
            
        }
    }
    static var titles = MyMiles.allCases.map({$0.rawValue})
    
    fileprivate func setMyMilesDescription(myMilesHistory : BulkMileListDataModel) -> [(String, String)]{
        
        if myMilesHistory.status == "canceled" {
            let tempArray = [("Status" , myMilesHistory.status)]  as! [(String,String)]
            
            return tempArray
        } else {
            var tempArray = [
//                ("Pick Up Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: myMilesHistory.createdAt, dateFormat: "dd-MM-YYYY HH:mm:ss") ),
//                             ("Drop Off Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: myMilesHistory.dropoffTime, dateFormat: "dd-MM-YYYY HH:mm:ss")),
                             ("Miles" , myMilesHistory.miles),
                             ("estimatedPrice" , myMilesHistory.estimatedPrice),
                             ("actualPrice" , myMilesHistory.actualPrice),
                             //                ("Time Cost :" , pastBookingHistory.id),
                            ("message" , myMilesHistory.description),
                                ("validity" , myMilesHistory.validity),
                                ("validity_type" , myMilesHistory.validityType),
                //                ("Promocode" , pastBookingHistory.promocode),
//                ("Total Paid To Driver" , myMilesHistory.grandTotal)
                
                ] as! [(String,String)]

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
    
    
    fileprivate func setFutureDescription(section: Int){
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
        
        return [("Title" ,"Upcoming"),
                ("PickupLocation" , pastBookingHistory.pickupLocation),
                ("DropoffLocation" , pastBookingHistory.dropoffLocation),
                ("Date" , strDate),
                ("Payment Type" , pastBookingHistory.paymentType)]
    }
}
