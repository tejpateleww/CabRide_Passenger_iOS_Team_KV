//
//  UpdateVehicleInfo.swift
//  Chick Pick
//
//  Created by Apple on 11/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation


class UpdateVehicleInfo : RequestModel {
    
    var driver_id: String = ""
    var vehicle_type: String = ""
    var plate_number: String = ""
    var year_of_manufacture: String = ""
    var vehicle_model: String = ""
    var no_of_passenger: String = ""
    var car_left: String = ""
    var car_right: String = ""
    var car_front: String = ""
    var car_back: String = ""
}
