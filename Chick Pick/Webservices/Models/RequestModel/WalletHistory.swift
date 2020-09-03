//
//  WalletHistory.swift
//  Chick Pick
//
//  Created by Mayur iMac on 09/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation


class WalletHistory : RequestModel {
    var customer_id: String = ""
    var page: String = ""
    var from_date: String = ""
    var to_date: String = ""
    var payment_type: String = ""
    var transaction_type: String = ""
    
//    for FILTER
//    1) date filer
//    from_date: 2019-07-21
//    to_date : 2019-07-26
//    2) payment type filer
//    payment_type : cash,card,wallet,m_pesa
//    3) transaction type filter
//    transaction_type : booking,booking_commission
}
