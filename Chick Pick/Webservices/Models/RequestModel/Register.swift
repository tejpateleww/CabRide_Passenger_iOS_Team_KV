//
//  Register.swift
//  Peppea
//
//  Created by Mayur iMac on 29/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit

class RegistrationModel : RequestModel {
    
    /*
    "email:nidhi@excellentwebworld.in
    mobile_no:9426143434
    first_name:Mayur
    last_name:Patel
    lat:23.8656565
    lng:72.654656
    device_token:sadfdfs65c4dwfvwdv6edbv16efbef1b165165
    device_type:android OR ios OR web
    password:123456"
     passport_licence_image
     */
    

    var email : String = ""
    var mobile_no : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var lat : String = ""
    var lng : String = ""
    var device_token : String = ""
    var device_type : String = ""
    var password : String = ""
    var social_id : String = ""
    var social_type : String = ""
    
    
//    var address : String = ""
//    var dob : String = ""
//    var RefarralCode : String = ""
//    var gender : String = ""
//    var ProfileImage : UIImage = UIImage()
//    var user_type : String = ""
//    var company_name : String = ""
//    var company_id :  String = ""
    
}


class OTPModel : RequestModel {
    var OTP : String = ""
}


//class RegisterUser : RequestModel {
//  
//}
