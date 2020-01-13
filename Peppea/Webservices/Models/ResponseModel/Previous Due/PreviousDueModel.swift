//
//  PreviousDueModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 3, 2020

import Foundation
import SwiftyJSON


class PreviousDueModel : NSObject, NSCoding{
    
    var amount : String!
    var bookingId : String!
    var cardId : String!
    var createdAt : String!
    var customerId : String!
    var dropoffLocation : String!
    var id : String!
    var paidPaymentType : String!
    var paymentResponse : String!
    var paymentType : String!
    var pickupLocation : String!
    var referenceId : String!
    var requestId : String!
    var status : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        amount = json["amount"].stringValue
        bookingId = json["booking_id"].stringValue
        cardId = json["card_id"].stringValue
        createdAt = json["created_at"].stringValue
        customerId = json["customer_id"].stringValue
        dropoffLocation = json["dropoff_location"].stringValue
        id = json["id"].stringValue
        paidPaymentType = json["paid_payment_type"].stringValue
        paymentResponse = json["payment_response"].stringValue
        paymentType = json["payment_type"].stringValue
        pickupLocation = json["pickup_location"].stringValue
        referenceId = json["reference_id"].stringValue
        requestId = json["request_id"].stringValue
        status = json["status"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if amount != nil{
            dictionary["amount"] = amount
        }
        if bookingId != nil{
            dictionary["booking_id"] = bookingId
        }
        if cardId != nil{
            dictionary["card_id"] = cardId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if customerId != nil{
            dictionary["customer_id"] = customerId
        }
        if dropoffLocation != nil{
            dictionary["dropoff_location"] = dropoffLocation
        }
        if id != nil{
            dictionary["id"] = id
        }
        if paidPaymentType != nil{
            dictionary["paid_payment_type"] = paidPaymentType
        }
        if paymentResponse != nil{
            dictionary["payment_response"] = paymentResponse
        }
        if paymentType != nil{
            dictionary["payment_type"] = paymentType
        }
        if pickupLocation != nil{
            dictionary["pickup_location"] = pickupLocation
        }
        if referenceId != nil{
            dictionary["reference_id"] = referenceId
        }
        if requestId != nil{
            dictionary["request_id"] = requestId
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
        amount = aDecoder.decodeObject(forKey: "amount") as? String
        bookingId = aDecoder.decodeObject(forKey: "booking_id") as? String
        cardId = aDecoder.decodeObject(forKey: "card_id") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        customerId = aDecoder.decodeObject(forKey: "customer_id") as? String
        dropoffLocation = aDecoder.decodeObject(forKey: "dropoff_location") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        paidPaymentType = aDecoder.decodeObject(forKey: "paid_payment_type") as? String
        paymentResponse = aDecoder.decodeObject(forKey: "payment_response") as? String
        paymentType = aDecoder.decodeObject(forKey: "payment_type") as? String
        pickupLocation = aDecoder.decodeObject(forKey: "pickup_location") as? String
        referenceId = aDecoder.decodeObject(forKey: "reference_id") as? String
        requestId = aDecoder.decodeObject(forKey: "request_id") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if amount != nil{
            aCoder.encode(amount, forKey: "amount")
        }
        if bookingId != nil{
            aCoder.encode(bookingId, forKey: "booking_id")
        }
        if cardId != nil{
            aCoder.encode(cardId, forKey: "card_id")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if customerId != nil{
            aCoder.encode(customerId, forKey: "customer_id")
        }
        if dropoffLocation != nil{
            aCoder.encode(dropoffLocation, forKey: "dropoff_location")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if paidPaymentType != nil{
            aCoder.encode(paidPaymentType, forKey: "paid_payment_type")
        }
        if paymentResponse != nil{
            aCoder.encode(paymentResponse, forKey: "payment_response")
        }
        if paymentType != nil{
            aCoder.encode(paymentType, forKey: "payment_type")
        }
        if pickupLocation != nil{
            aCoder.encode(pickupLocation, forKey: "pickup_location")
        }
        if referenceId != nil{
            aCoder.encode(referenceId, forKey: "reference_id")
        }
        if requestId != nil{
            aCoder.encode(requestId, forKey: "request_id")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        
    }
    
}
