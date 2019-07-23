//
//  FlatRateListModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 17, 2019

import Foundation
import SwiftyJSON


class FlatRateListModel : Codable
{

    var Ratedata : [FlatRateData]!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        Ratedata = [FlatRateData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = FlatRateData(fromJson: dataJson)
            Ratedata.append(value)
        }
        status = json["status"].boolValue
    }
    
    init()
    {
    }
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if Ratedata != nil{
        var dictionaryElements = [[String:Any]]()
        for dataElement in Ratedata {
        	dictionaryElements.append(dataElement.toDictionary())
        }
        dictionary["data"] = dictionaryElements
        }
        if status != nil{
        	dictionary["status"] = status
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		Ratedata = aDecoder.decodeObject(forKey: "data") as? [FlatRateData]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if Ratedata != nil{
			aCoder.encode(Ratedata, forKey: "data")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}

class FlatRateData : Codable
{
    
    var createdAt : String!
    var dropoffLat : String!
    var dropoffLng : String!
    var dropoffLocation : String!
    var id : String!
    var pickupLat : String!
    var pickupLng : String!
    var pickupLocation : String!
    var rate : String!
    var status : String!
    var updatedAt : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        dropoffLat = json["dropoff_lat"].stringValue
        dropoffLng = json["dropoff_lng"].stringValue
        dropoffLocation = json["dropoff_location"].stringValue
        id = json["id"].stringValue
        pickupLat = json["pickup_lat"].stringValue
        pickupLng = json["pickup_lng"].stringValue
        pickupLocation = json["pickup_location"].stringValue
        rate = json["rate"].stringValue
        status = json["status"].stringValue
        updatedAt = json["updated_at"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if dropoffLat != nil{
            dictionary["dropoff_lat"] = dropoffLat
        }
        if dropoffLng != nil{
            dictionary["dropoff_lng"] = dropoffLng
        }
        if dropoffLocation != nil{
            dictionary["dropoff_location"] = dropoffLocation
        }
        if id != nil{
            dictionary["id"] = id
        }
        if pickupLat != nil{
            dictionary["pickup_lat"] = pickupLat
        }
        if pickupLng != nil{
            dictionary["pickup_lng"] = pickupLng
        }
        if pickupLocation != nil{
            dictionary["pickup_location"] = pickupLocation
        }
        if rate != nil{
            dictionary["rate"] = rate
        }
        if status != nil{
            dictionary["status"] = status
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        dropoffLat = aDecoder.decodeObject(forKey: "dropoff_lat") as? String
        dropoffLng = aDecoder.decodeObject(forKey: "dropoff_lng") as? String
        dropoffLocation = aDecoder.decodeObject(forKey: "dropoff_location") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        pickupLat = aDecoder.decodeObject(forKey: "pickup_lat") as? String
        pickupLng = aDecoder.decodeObject(forKey: "pickup_lng") as? String
        pickupLocation = aDecoder.decodeObject(forKey: "pickup_location") as? String
        rate = aDecoder.decodeObject(forKey: "rate") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if dropoffLat != nil{
            aCoder.encode(dropoffLat, forKey: "dropoff_lat")
        }
        if dropoffLng != nil{
            aCoder.encode(dropoffLng, forKey: "dropoff_lng")
        }
        if dropoffLocation != nil{
            aCoder.encode(dropoffLocation, forKey: "dropoff_location")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if pickupLat != nil{
            aCoder.encode(pickupLat, forKey: "pickup_lat")
        }
        if pickupLng != nil{
            aCoder.encode(pickupLng, forKey: "pickup_lng")
        }
        if pickupLocation != nil{
            aCoder.encode(pickupLocation, forKey: "pickup_location")
        }
        if rate != nil{
            aCoder.encode(rate, forKey: "rate")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        
    }
    
}

