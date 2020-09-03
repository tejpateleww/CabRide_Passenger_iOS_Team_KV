//
//  ReviewRatingReqModel.swift
//  Peppea
//
//  Created by Apple on 26/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation

class ReviewRatingReqModel : RequestModel {
    
    var booking_id : String = ""
    var rating : String = ""
    var comment : String = ""
}
