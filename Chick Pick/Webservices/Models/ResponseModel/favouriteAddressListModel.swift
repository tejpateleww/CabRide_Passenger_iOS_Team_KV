//
//  favouriteAddressListModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 5, 2019

import Foundation
import SwiftyJSON


class favouriteAddressListModel : NSObject, NSCoding{

    var customerId : String!
    var dropoffLat : String!
    var dropoffLng : String!
    var dropoffLocation : String!
    var favouriteType : String!
    var id : String!
    var pickupLat : String!
    var pickupLng : String!
    var pickupLocation : String!
    
    override init() {
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        customerId = json["customer_id"].stringValue
        dropoffLat = json["dropoff_lat"].stringValue
        dropoffLng = json["dropoff_lng"].stringValue
        dropoffLocation = json["dropoff_location"].stringValue
        favouriteType = json["favourite_type"].stringValue
        id = json["id"].stringValue
        pickupLat = json["pickup_lat"].stringValue
        pickupLng = json["pickup_lng"].stringValue
        pickupLocation = json["pickup_location"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if customerId != nil{
            dictionary["customer_id"] = customerId
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
        if favouriteType != nil{
            dictionary["favourite_type"] = favouriteType
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
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        customerId = aDecoder.decodeObject(forKey: "customer_id") as? String
        dropoffLat = aDecoder.decodeObject(forKey: "dropoff_lat") as? String
        dropoffLng = aDecoder.decodeObject(forKey: "dropoff_lng") as? String
        dropoffLocation = aDecoder.decodeObject(forKey: "dropoff_location") as? String
        favouriteType = aDecoder.decodeObject(forKey: "favourite_type") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        pickupLat = aDecoder.decodeObject(forKey: "pickup_lat") as? String
        pickupLng = aDecoder.decodeObject(forKey: "pickup_lng") as? String
        pickupLocation = aDecoder.decodeObject(forKey: "pickup_location") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if customerId != nil{
            aCoder.encode(customerId, forKey: "customer_id")
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
        if favouriteType != nil{
            aCoder.encode(favouriteType, forKey: "favourite_type")
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
        
    }
    
}
