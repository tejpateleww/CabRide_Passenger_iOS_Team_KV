//
//  ChangePassword.swift
//  Chick Pick
//
//  Created by Mayur iMac on 09/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
class ChangePassword : RequestModel {
    var customer_id: String = ""
    var old_password: String = ""
    var new_password: String = ""
 }

/*
 "old_password:12345678
 new_password:123456
 customer_id:20"
 */
