//
//  AddCard.swift
//  Chick Pick
//
//  Created by Mayur iMac on 09/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
class AddCard : RequestModel {
    var customer_id: String = ""
    var card_no: String = ""
    var card_holder_name: String = ""
    var exp_date_month: String = ""
    var exp_date_year: String = ""
    var cvv: String = ""
}
