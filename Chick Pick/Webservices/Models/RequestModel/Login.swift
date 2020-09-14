//
//  Login.swift
//  Peppea
//
//  Created by Mayur iMac on 29/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation

class loginModel : RequestModel {
    var username : String = ""
    var password : String = ""
    var device_type : String = ""
    var lat : String = ""
    var lng : String = ""
    var device_token : String = ""
}


/*
 
 username: (dev.elop.er.eww@gmail.com) or (9924455777)
 lat:23.8656565
 lng:72.654656
 device_token:sadfdfs65c4dwfvwdv6edbv16efbef1b165165
 device_type:'ios', 'android', 'web'
 password:123456
 
 */


class SocialLoginModel : RequestModel {
    var email : String = ""
    var social_id : String = ""
    var social_type : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var lat : String = ""
    var lng : String = ""
    var device_token : String = ""
    var device_type : String = ""
}

/*
 
 "social_id:9898989898
 social_type:facebook
 first_name:Mayur
 last_name:Shiroya
 lat:23.8656565
 lng:72.654656
 device_token:sadfdfs65c4dwfvwdv6edbv16efbef1b165165
 device_type::'ios', 'android', 'web'"
 
 */
