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
     "email:dev.elop.er.eww@gmail.com
     mobile_no:9924455777
     first_name:Mayur
     last_name:Patel
     dob:1992-07-07
     gender:male
     lat:23.8656565
     lng:72.654656
     device_token:sadfdfs65c4dwfvwdv6edbv16efbef1b165165
     device_type:1
     address:Nikol bapunagar
     password:123456
     profile_image:(optional)"
     */
    
    var mobile_no : String = ""
    var email : String = ""
    var password : String = ""
//    var password_confirmation : String = ""
    var address : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var dob : String = ""
    var RefarralCode : String = ""
    var gender : String = ""
    var ProfileImage : UIImage = UIImage()
    var device_token : String = ""
    var device_type : String = ""
    var lat : String = ""
    var lng : String = ""
}


class OTPModel : RequestModel {
    var OTP : String = ""
}


//class RegisterUser : RequestModel {
//  
//}
