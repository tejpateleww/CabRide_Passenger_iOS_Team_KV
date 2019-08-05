//
//  addFavouriteAddressReqModel.swift
//  Peppea
//
//  Created by Apple on 05/08/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation

class addFavouriteAddressReqModel : RequestModel {
    var customer_id: String = ""
    var favourite_type: String = ""
    var pickup_location: String = ""
    var pickup_lat: String = ""
    var pickup_lng: String = ""
    var dropoff_location: String = ""
    var dropoff_lat: String = ""
    var dropoff_lng: String = ""
}
