//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 29, 2019

import Foundation
import SwiftyJSON


class BulkMileListDataModel : NSObject, NSCoding{

    var actualPrice : String!
    var createdAt : String!
    var descriptionField : String!
    var estimatedPrice : String!
    var id : String!
    var miles : String!
    var perMileCharges : String!
    var status : String!
    var validity : String!
    var validityType : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        actualPrice = json["actual_price"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        estimatedPrice = json["estimated_price"].stringValue
        id = json["id"].stringValue
        miles = json["miles"].stringValue
        perMileCharges = json["per_mile_charges"].stringValue
        status = json["status"].stringValue
        validity = json["validity"].stringValue
        validityType = json["validity_type"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if actualPrice != nil{
        	dictionary["actual_price"] = actualPrice
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if estimatedPrice != nil{
        	dictionary["estimated_price"] = estimatedPrice
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if miles != nil{
        	dictionary["miles"] = miles
        }
        if perMileCharges != nil{
        	dictionary["per_mile_charges"] = perMileCharges
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if validity != nil{
        	dictionary["validity"] = validity
        }
        if validityType != nil{
        	dictionary["validity_type"] = validityType
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		actualPrice = aDecoder.decodeObject(forKey: "actual_price") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		estimatedPrice = aDecoder.decodeObject(forKey: "estimated_price") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		miles = aDecoder.decodeObject(forKey: "miles") as? String
		perMileCharges = aDecoder.decodeObject(forKey: "per_mile_charges") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		validity = aDecoder.decodeObject(forKey: "validity") as? String
		validityType = aDecoder.decodeObject(forKey: "validity_type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if actualPrice != nil{
			aCoder.encode(actualPrice, forKey: "actual_price")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if estimatedPrice != nil{
			aCoder.encode(estimatedPrice, forKey: "estimated_price")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if miles != nil{
			aCoder.encode(miles, forKey: "miles")
		}
		if perMileCharges != nil{
			aCoder.encode(perMileCharges, forKey: "per_mile_charges")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if validity != nil{
			aCoder.encode(validity, forKey: "validity")
		}
		if validityType != nil{
			aCoder.encode(validityType, forKey: "validity_type")
		}

	}

}
