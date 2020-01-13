//
//  Extensions.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIViewController {

    func setNavigationClear() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: UIControl.State.highlighted)

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key .foregroundColor : UIColor.white]

    }

    func setNavigationFontBlack() {
        UINavigationBar.appearance().tintColor = UIColor.black
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.highlighted)

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key .foregroundColor : UIColor.black]
    }

    func isModal() -> Bool {
        if (presentingViewController != nil) {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }

}

extension String {


    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func encodeUTF8() -> String? {

        //If I can create an NSURL out of the string nothing is wrong with it
        if let _ = URL(string: self) {

            return self
        }

        //Get the last component from the string this will return subSequence
        let optionalLastComponent = self.split { $0 == "/" }.last


        if let lastComponent = optionalLastComponent {

            //Get the string from the sub sequence by mapping the characters to [String] then reduce the array to String
            let lastComponentAsString = lastComponent.map { String($0) }.reduce("", +)


            //Get the range of the last component
            if let rangeOfLastComponent = self.range(of: lastComponentAsString) {
                //Get the string without its last component
                let stringWithoutLastComponent = self.substring(to: rangeOfLastComponent.lowerBound)


                //Encode the last component
                if let lastComponentEncoded = lastComponentAsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) {


                    //Finally append the original string (without its last component) to the encoded part (encoded last component)
                    let encodedString = stringWithoutLastComponent + lastComponentEncoded

                    //Return the string (original string/encoded string)
                    return encodedString
                }
            }
        }

        return nil;
    }


    func htmlDecoded()->String {

        guard (self != "") else { return self }

        var newStr = self

        let entities = [
            "&quot;"    : "\"",
            "&ldquo;"   : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            "&nbsp;"    : "\n",



            ]

        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }



    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) == nil

        }
    }
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
//    var isInValidPassword: Bool {
//        get {
//            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
//            if trimmed.count >= 6
//            {
//                return false
//            }
//            else
//            {
//                return true
//            }
//        }
//    }
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern:"[A-Z0-9a-z._%+-]{2,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }


    //validate PhoneNumber
    var isPhoneNumber: Bool {

        let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
        var filtered:String!

        let inputString:[String] = self.components(separatedBy: charcter)
        filtered = inputString.joined(separator: "") as String
        return  self == filtered

    }



    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date

    }
}

extension UIView {
    
    //-------------------------------------
    // MARK:- Instantiate View
    //-------------------------------------
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    //-------------------------------------------
    // MARK:- identifier Variable for View, Cells
    //-------------------------------------------
    
    static var identifier: String{
        return String(describing: self)
    }
    
    //-------------------------------------
    // MARK:- Remove All Subviews
    //-------------------------------------
    
    func removeAllSubviews(){
        self.subviews.forEach({
            if(!$0.isKind(of: UIRefreshControl.self))
            {
                $0.removeFromSuperview()
            }
        })
    }
    //-------------------------------------
    // MARK:- Add Subview with animation
    //-------------------------------------
    func customAddSubview(_ view: UIView){
        self.isHidden = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.autoresizingMask = [.flexibleHeight]
        self.bounds.size = view.frame.size
        view.frame = self.bounds
        
        UIView.transition(with: self,
                          duration: 0.4,
                          options: .curveEaseInOut,
                          animations: {
                            self.removeAllSubviews()
                            self.addSubview(view)
        }, completion: nil)
        
    }
    func addSubviewWithTransition(_ view: UIView, mainView: UIView){
        
        self.isHidden = false
        let xOffset: CGFloat = self.frame.minX
        
        self.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleWidth, .flexibleHeight]
        view.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleWidth, .flexibleHeight]
        view.bounds.size.width = self.bounds.width
        self.bounds.size.height = max(self.bounds.height, view.bounds.height)
        
        let tempView = UIView(frame: CGRect(x: xOffset + self.bounds.width, y: 62,
                                            width: self.bounds.width, height: view.frame.height))
        
        view.frame.origin.x = 0
        tempView.frame.origin.x = xOffset
        self.frame.origin.x = -xOffset - self.bounds.width
        tempView.addSubview(view)
        mainView.addSubview(tempView)
        
        UIView.animate(withDuration: 0.7, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            tempView.removeFromSuperview()
            self.removeAllSubviews()
            self.bounds.size.height = view.bounds.height
            self.frame.origin.x = xOffset
            self.addSubview(view)
        }
        
    }
    
    func addVisualFormatConstraints(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        let constraint = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary)
        addConstraints(constraint)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}


// MARK:- UIColor

extension UIColor {

    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex         = String(hex.suffix(from: index))
        }

        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}


//MARK:- UIFont

let AppRegularFont:String = "ProximaNova-Regular"
let AppBoldFont:String = "ProximaNova-Bold"
let AppSemiboldFont:String = "ProximaNova-Semibold"

extension UIFont {
    
    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name:  AppRegularFont, size: size)!
    }
    class func semiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppSemiboldFont, size: size)!
    }
    class func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppBoldFont, size: size)!
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Bundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}


extension UITextField {
   
    func setCurrencyLeftView() {
        
        let LeftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        LeftLabel.font = self.font
        LeftLabel.textAlignment = .left
        LeftLabel.text = Currency
        LeftLabel.textColor = UIColor.black
        LeftLabel.backgroundColor = UIColor.white
        LeftLabel.backgroundColor = .clear
        self.leftView = LeftLabel
        self.leftViewMode = .always
    }
    
}
