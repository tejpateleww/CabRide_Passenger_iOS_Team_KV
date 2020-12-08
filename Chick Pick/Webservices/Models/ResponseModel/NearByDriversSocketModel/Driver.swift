//
//  Driver.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 8, 2020

import Foundation
import SwiftyJSON


class Driver : NSObject, NSCoding{

    var id : String!
    var busy : Int!
    var createdAt : String!
    var deviceToken : String!
    var driverId : Int!
    var location : [Float]!
    var start : Int!
    var status : Int!
    var updatedTime : Int!
    var vehicleTypeId : [String]!
    var walletBalance : Int!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        id = json["_id"].stringValue
        busy = json["busy"].intValue
        createdAt = json["created_at"].stringValue
        deviceToken = json["device_token"].stringValue
        driverId = json["driver_id"].intValue
        location = [Int]()
        let locationArray = json["location"].arrayValue
        for locationJson in locationArray{
            location.append(locationJson.floatValue)
        }
        start = json["start"].intValue
        status = json["status"].intValue
        updatedTime = json["updated_time"].intValue
        vehicleTypeId = [Int]()
        let vehicleTypeIdArray = json["vehicle_type_id"].arrayValue
        for vehicleTypeIdJson in vehicleTypeIdArray{
            vehicleTypeId.append(vehicleTypeIdJson.stringValue)
        }
        walletBalance = json["wallet_balance"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if id != nil{
        	dictionary["_id"] = id
        }
        if busy != nil{
        	dictionary["busy"] = busy
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if deviceToken != nil{
        	dictionary["device_token"] = deviceToken
        }
        if driverId != nil{
        	dictionary["driver_id"] = driverId
        }
        if location != nil{
        	dictionary["location"] = location
        }
        if start != nil{
        	dictionary["start"] = start
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if updatedTime != nil{
        	dictionary["updated_time"] = updatedTime
        }
        if vehicleTypeId != nil{
        	dictionary["vehicle_type_id"] = vehicleTypeId
        }
        if walletBalance != nil{
        	dictionary["wallet_balance"] = walletBalance
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		id = aDecoder.decodeObject(forKey: "_id") as? String
		busy = aDecoder.decodeObject(forKey: "busy") as? Int
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
		driverId = aDecoder.decodeObject(forKey: "driver_id") as? Int
		location = aDecoder.decodeObject(forKey: "location") as? [Float]
		start = aDecoder.decodeObject(forKey: "start") as? Int
		status = aDecoder.decodeObject(forKey: "status") as? Int
		updatedTime = aDecoder.decodeObject(forKey: "updated_time") as? Int
		vehicleTypeId = aDecoder.decodeObject(forKey: "vehicle_type_id") as? [String]
		walletBalance = aDecoder.decodeObject(forKey: "wallet_balance") as? Int
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if busy != nil{
			aCoder.encode(busy, forKey: "busy")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if deviceToken != nil{
			aCoder.encode(deviceToken, forKey: "device_token")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "driver_id")
		}
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if start != nil{
			aCoder.encode(start, forKey: "start")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if updatedTime != nil{
			aCoder.encode(updatedTime, forKey: "updated_time")
		}
		if vehicleTypeId != nil{
			aCoder.encode(vehicleTypeId, forKey: "vehicle_type_id")
		}
		if walletBalance != nil{
			aCoder.encode(walletBalance, forKey: "wallet_balance")
		}

	}

}
