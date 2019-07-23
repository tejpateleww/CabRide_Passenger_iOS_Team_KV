//
//  UpdatePersonalInfo.swift
//  Pappea Driver
//
//  Created by Apple on 12/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

class UpdatePersonalInfo : RequestModel
{
    var customer_id: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var gender: String = ""
    var address: String = ""
    var dob: String = ""
}
