//
//  NearByDriversModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 8, 2020

import Foundation
import SwiftyJSON


class NearByDriversModel : NSObject, NSCoding{

    var drivers : [Driver]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        drivers = [Driver]()
        let driversArray = json["drivers"].arrayValue
        for driversJson in driversArray{
            let value = Driver(fromJson: custArrayJson)
            custArray.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if drivers != nil{
        var dictionaryElements = [[String:Any]]()
        for driversElement in drivers {
        	dictionaryElements.append(driversElement.toDictionary())
        }
        dictionary["drivers"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		drivers = aDecoder.decodeObject(forKey: "drivers") as? [Driver]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if drivers != nil{
			aCoder.encode(drivers, forKey: "drivers")
		}

	}

}
