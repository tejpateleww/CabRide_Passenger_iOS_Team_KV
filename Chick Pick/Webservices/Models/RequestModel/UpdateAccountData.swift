//
//  UpdateAccountData.swift
//  Chick Pick
//
//  Created by Apple on 11/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

class UpdateAccountData : RequestModel {
    var driver_id: String = ""
    var account_holder_name: String = ""
    var bank_name: String = ""
    var bank_branch: String = ""
    var account_number: String = ""
}
