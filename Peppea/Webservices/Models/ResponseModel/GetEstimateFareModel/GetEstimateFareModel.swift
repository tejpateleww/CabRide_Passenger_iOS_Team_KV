//
//  GetEstimateFareModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 24, 2019

import Foundation
import SwiftyJSON


class GetEstimateFareModel : NSObject, NSCoding {

    var estimateFare : [EstimateFare]!
    var status : Bool!

    override init() {
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        estimateFare = [EstimateFare]()
        let estimateFareArray = json["estimate_fare"].arrayValue
        for estimateFareJson in estimateFareArray{
            let value = EstimateFare(fromJson: estimateFareJson)
            estimateFare.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if estimateFare != nil{
        var dictionaryElements = [[String:Any]]()
        for estimateFareElement in estimateFare {
        	dictionaryElements.append(estimateFareElement.toDictionary())
        }
        dictionary["estimateFare"] = dictionaryElements
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
		estimateFare = aDecoder.decodeObject(forKey: "estimate_fare") as? [EstimateFare]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if estimateFare != nil{
			aCoder.encode(estimateFare, forKey: "estimate_fare")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
