//
//  CancelReason.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 6, 2020

import Foundation
import SwiftyJSON


class CancelReason : NSObject, NSCoding{

    var id : String!
    var reason : String!

    override init() {
        
    }
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        id = json["id"].stringValue
        reason = json["reason"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if id != nil{
        	dictionary["id"] = id
        }
        if reason != nil{
        	dictionary["reason"] = reason
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		id = aDecoder.decodeObject(forKey: "id") as? String
		reason = aDecoder.decodeObject(forKey: "reason") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if reason != nil{
			aCoder.encode(reason, forKey: "reason")
		}

	}

}
