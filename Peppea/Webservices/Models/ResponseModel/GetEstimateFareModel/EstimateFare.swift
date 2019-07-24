//
//  EstimateFare.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 24, 2019

import Foundation
import SwiftyJSON


class EstimateFare : Codable {

    var distance : String!
    var driverReachInMinute : String!
    var durationInMinute : String!
    var durationInSecond : String!
    var estimateTripFare : String!
    var vehicleTypeId : String!
    var vehicleTypeName : String!

    init() {
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        distance = json["distance"].stringValue
        driverReachInMinute = json["driver_reach_in_minute"].stringValue
        durationInMinute = json["duration_in_minute"].stringValue
        durationInSecond = json["duration_in_second"].stringValue
        estimateTripFare = json["estimate_trip_fare"].stringValue
        vehicleTypeId = json["vehicle_type_id"].stringValue
        vehicleTypeName = json["vehicle_type_name"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
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
        if vehicleTypeId != nil{
        	dictionary["vehicle_type_id"] = vehicleTypeId
        }
        if vehicleTypeName != nil{
        	dictionary["vehicle_type_name"] = vehicleTypeName
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		distance = aDecoder.decodeObject(forKey: "distance") as? String
		driverReachInMinute = aDecoder.decodeObject(forKey: "driver_reach_in_minute") as? String
		durationInMinute = aDecoder.decodeObject(forKey: "duration_in_minute") as? String
		durationInSecond = aDecoder.decodeObject(forKey: "duration_in_second") as? String
		estimateTripFare = aDecoder.decodeObject(forKey: "estimate_trip_fare") as? String
		vehicleTypeId = aDecoder.decodeObject(forKey: "vehicle_type_id") as? String
		vehicleTypeName = aDecoder.decodeObject(forKey: "vehicle_type_name") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
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
		if vehicleTypeId != nil{
			aCoder.encode(vehicleTypeId, forKey: "vehicle_type_id")
		}
		if vehicleTypeName != nil{
			aCoder.encode(vehicleTypeName, forKey: "vehicle_type_name")
		}

	}

}
