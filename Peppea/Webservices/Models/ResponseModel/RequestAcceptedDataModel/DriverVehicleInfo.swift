//
//  DriverVehicleInfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 6, 2020

import Foundation
import SwiftyJSON


class DriverVehicleInfo : NSObject, NSCoding{

    var carBack : String!
    var carFront : String!
    var carLeft : String!
    var carRight : String!
    var companyId : Int!
    var driverId : Int!
    var id : Int!
    var noOfPassenger : Int!
    var plateNumber : String!
    var vehicleType : Int!
    var vehicleTypeManufacturerId : Int!
    var vehicleTypeManufacturerName : String!
    var vehicleTypeModelId : Int!
    var vehicleTypeModelName : String!
    var yearOfManufacture : Int!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        carBack = json["car_back"].stringValue
        carFront = json["car_front"].stringValue
        carLeft = json["car_left"].stringValue
        carRight = json["car_right"].stringValue
        companyId = json["company_id"].intValue
        driverId = json["driver_id"].intValue
        id = json["id"].intValue
        noOfPassenger = json["no_of_passenger"].intValue
        plateNumber = json["plate_number"].stringValue
        vehicleType = json["vehicle_type"].intValue
        vehicleTypeManufacturerId = json["vehicle_type_manufacturer_id"].intValue
        vehicleTypeManufacturerName = json["vehicle_type_manufacturer_name"].stringValue
        vehicleTypeModelId = json["vehicle_type_model_id"].intValue
        vehicleTypeModelName = json["vehicle_type_model_name"].stringValue
        yearOfManufacture = json["year_of_manufacture"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if carBack != nil{
        	dictionary["car_back"] = carBack
        }
        if carFront != nil{
        	dictionary["car_front"] = carFront
        }
        if carLeft != nil{
        	dictionary["car_left"] = carLeft
        }
        if carRight != nil{
        	dictionary["car_right"] = carRight
        }
        if companyId != nil{
        	dictionary["company_id"] = companyId
        }
        if driverId != nil{
        	dictionary["driver_id"] = driverId
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if noOfPassenger != nil{
        	dictionary["no_of_passenger"] = noOfPassenger
        }
        if plateNumber != nil{
        	dictionary["plate_number"] = plateNumber
        }
        if vehicleType != nil{
        	dictionary["vehicle_type"] = vehicleType
        }
        if vehicleTypeManufacturerId != nil{
        	dictionary["vehicle_type_manufacturer_id"] = vehicleTypeManufacturerId
        }
        if vehicleTypeManufacturerName != nil{
        	dictionary["vehicle_type_manufacturer_name"] = vehicleTypeManufacturerName
        }
        if vehicleTypeModelId != nil{
        	dictionary["vehicle_type_model_id"] = vehicleTypeModelId
        }
        if vehicleTypeModelName != nil{
        	dictionary["vehicle_type_model_name"] = vehicleTypeModelName
        }
        if yearOfManufacture != nil{
        	dictionary["year_of_manufacture"] = yearOfManufacture
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		carBack = aDecoder.decodeObject(forKey: "car_back") as? String
		carFront = aDecoder.decodeObject(forKey: "car_front") as? String
		carLeft = aDecoder.decodeObject(forKey: "car_left") as? String
		carRight = aDecoder.decodeObject(forKey: "car_right") as? String
		companyId = aDecoder.decodeObject(forKey: "company_id") as? Int
		driverId = aDecoder.decodeObject(forKey: "driver_id") as? Int
		id = aDecoder.decodeObject(forKey: "id") as? Int
		noOfPassenger = aDecoder.decodeObject(forKey: "no_of_passenger") as? Int
		plateNumber = aDecoder.decodeObject(forKey: "plate_number") as? String
		vehicleType = aDecoder.decodeObject(forKey: "vehicle_type") as? Int
		vehicleTypeManufacturerId = aDecoder.decodeObject(forKey: "vehicle_type_manufacturer_id") as? Int
		vehicleTypeManufacturerName = aDecoder.decodeObject(forKey: "vehicle_type_manufacturer_name") as? String
		vehicleTypeModelId = aDecoder.decodeObject(forKey: "vehicle_type_model_id") as? Int
		vehicleTypeModelName = aDecoder.decodeObject(forKey: "vehicle_type_model_name") as? String
		yearOfManufacture = aDecoder.decodeObject(forKey: "year_of_manufacture") as? Int
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if carBack != nil{
			aCoder.encode(carBack, forKey: "car_back")
		}
		if carFront != nil{
			aCoder.encode(carFront, forKey: "car_front")
		}
		if carLeft != nil{
			aCoder.encode(carLeft, forKey: "car_left")
		}
		if carRight != nil{
			aCoder.encode(carRight, forKey: "car_right")
		}
		if companyId != nil{
			aCoder.encode(companyId, forKey: "company_id")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "driver_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if noOfPassenger != nil{
			aCoder.encode(noOfPassenger, forKey: "no_of_passenger")
		}
		if plateNumber != nil{
			aCoder.encode(plateNumber, forKey: "plate_number")
		}
		if vehicleType != nil{
			aCoder.encode(vehicleType, forKey: "vehicle_type")
		}
		if vehicleTypeManufacturerId != nil{
			aCoder.encode(vehicleTypeManufacturerId, forKey: "vehicle_type_manufacturer_id")
		}
		if vehicleTypeManufacturerName != nil{
			aCoder.encode(vehicleTypeManufacturerName, forKey: "vehicle_type_manufacturer_name")
		}
		if vehicleTypeModelId != nil{
			aCoder.encode(vehicleTypeModelId, forKey: "vehicle_type_model_id")
		}
		if vehicleTypeModelName != nil{
			aCoder.encode(vehicleTypeModelName, forKey: "vehicle_type_model_name")
		}
		if yearOfManufacture != nil{
			aCoder.encode(yearOfManufacture, forKey: "year_of_manufacture")
		}

	}

}
