//
//  EstimateFare.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on November 6, 2020

import Foundation
import SwiftyJSON


class EstimateFare : NSObject, NSCoding{

    var capacity : String!
    var distance : String!
    var driverReachInMinute : String!
    var durationInMinute : String!
    var durationInSecond : String!
    var estimateTripFare : String!
    var fareId : Int!
    var image : String!
    var increasePercent : Int!
    var increasePrice : Int!
    var promocodeTripFare : String!
    var vehicleTypeId : String!
    var vehicleTypeName : String!
    var isPromoCodeApplied : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        capacity = json["capacity"].stringValue
        distance = json["distance"].stringValue
        driverReachInMinute = json["driver_reach_in_minute"].stringValue
        durationInMinute = json["duration_in_minute"].stringValue
        durationInSecond = json["duration_in_second"].stringValue
        estimateTripFare = json["estimate_trip_fare"].stringValue
        fareId = json["fare_id"].intValue
        image = json["image"].stringValue
        increasePercent = json["increase_percent"].intValue
        increasePrice = json["increase_price"].intValue
        promocodeTripFare = json["promocode_trip_fare"].stringValue
        vehicleTypeId = json["vehicle_type_id"].stringValue
        vehicleTypeName = json["vehicle_type_name"].stringValue
        isPromoCodeApplied = json["is_promo_code_applied"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if capacity != nil{
            dictionary["capacity"] = capacity
        }
        if distance != nil{
            dictionary["distance"] = distance
        }
        if driverReachInMinute != nil{
            dictionary["driver_reach_in_minute"] = driverReachInMinute
        }
        if durationInMinute != nil{
            dictionary["duration_in_minute"] = durationInMinute
        }
        if durationInSecond != nil{
            dictionary["duration_in_second"] = durationInSecond
        }
        if estimateTripFare != nil{
            dictionary["estimate_trip_fare"] = estimateTripFare
        }
        if fareId != nil{
            dictionary["fare_id"] = fareId
        }
        if image != nil{
            dictionary["image"] = image
        }
        if increasePercent != nil{
            dictionary["increase_percent"] = increasePercent
        }
        if increasePrice != nil{
            dictionary["increase_price"] = increasePrice
        }
        if promocodeTripFare != nil{
            dictionary["promocode_trip_fare"] = promocodeTripFare
        }
        if vehicleTypeId != nil{
            dictionary["vehicle_type_id"] = vehicleTypeId
        }
        if vehicleTypeName != nil{
            dictionary["vehicle_type_name"] = vehicleTypeName
        }
        if vehicleTypeName != nil{
            dictionary["vehicle_type_name"] = vehicleTypeName
        }
        if isPromoCodeApplied != nil{
            dictionary["is_promo_code_applied"] = isPromoCodeApplied
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        capacity = aDecoder.decodeObject(forKey: "capacity") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String
        driverReachInMinute = aDecoder.decodeObject(forKey: "driver_reach_in_minute") as? String
        durationInMinute = aDecoder.decodeObject(forKey: "duration_in_minute") as? String
        durationInSecond = aDecoder.decodeObject(forKey: "duration_in_second") as? String
        estimateTripFare = aDecoder.decodeObject(forKey: "estimate_trip_fare") as? String
        fareId = aDecoder.decodeObject(forKey: "fare_id") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? String
        increasePercent = aDecoder.decodeObject(forKey: "increase_percent") as? Int
        increasePrice = aDecoder.decodeObject(forKey: "increase_price") as? Int
        promocodeTripFare = aDecoder.decodeObject(forKey: "promocode_trip_fare") as? String
        vehicleTypeId = aDecoder.decodeObject(forKey: "vehicle_type_id") as? String
        vehicleTypeName = aDecoder.decodeObject(forKey: "vehicle_type_name") as? String
        isPromoCodeApplied = aDecoder.decodeObject(forKey: "is_promo_code_applied") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if capacity != nil{
            aCoder.encode(capacity, forKey: "capacity")
        }
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if driverReachInMinute != nil{
            aCoder.encode(driverReachInMinute, forKey: "driver_reach_in_minute")
        }
        if durationInMinute != nil{
            aCoder.encode(durationInMinute, forKey: "duration_in_minute")
        }
        if durationInSecond != nil{
            aCoder.encode(durationInSecond, forKey: "duration_in_second")
        }
        if estimateTripFare != nil{
            aCoder.encode(estimateTripFare, forKey: "estimate_trip_fare")
        }
        if fareId != nil{
            aCoder.encode(fareId, forKey: "fare_id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if increasePercent != nil{
            aCoder.encode(increasePercent, forKey: "increase_percent")
        }
        if increasePrice != nil{
            aCoder.encode(increasePrice, forKey: "increase_price")
        }
        if promocodeTripFare != nil{
            aCoder.encode(promocodeTripFare, forKey: "promocode_trip_fare")
        }
        if vehicleTypeId != nil{
            aCoder.encode(vehicleTypeId, forKey: "vehicle_type_id")
        }
        if vehicleTypeName != nil{
            aCoder.encode(vehicleTypeName, forKey: "vehicle_type_name")
        }
        if isPromoCodeApplied != nil{
            aCoder.encode(isPromoCodeApplied, forKey: "is_promo_code_applied")
        }
    }
}
