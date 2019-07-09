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
    var phonenumber : String = ""
    var email : String = ""
    var password : String = ""
    var password_confirmation : String = ""
    var country : String = ""
}


class OTPModel : RequestModel {
    var OTP : String = ""
}


class RegisterUser : RequestModel {
    var FirstName : String = ""
    var LastName : String = ""
    var DateOfBirth : String = ""
    var RafarralCode : String = ""
    var Female : String = ""
    var ProfileImage : UIImage = UIImage()
    var Token : String = ""
    var DeviceType : String = ""
}
