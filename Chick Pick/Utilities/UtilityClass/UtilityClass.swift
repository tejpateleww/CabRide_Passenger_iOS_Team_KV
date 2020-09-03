//
//  UtilityClass.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import SwiftMessages

var instance: DataClass? = nil
class DataClass {

    var str = ""

    var laAnimation: AnimationView?
    var viewBackFull: UIView?


    class func getInstance() -> DataClass? {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            if instance == nil {
                instance = DataClass()
            }
        }
        return instance
    }
}

extension NSObject {
    static var className : String {
        return String(describing: self)
    }
}

let forceLogoutMsg = "Response status code was unacceptable: 403."

//MARK: - Message Alert Show
struct AlertMessage {
    static var messageBar = MessageBarController()

    static  func showMessageForError(_ strTitle: String) {
        
        forceLogout.forcefullyLogout(strTitle: strTitle)
        messageBar.MessageShow(title: strTitle as NSString, alertType: MessageView.Layout.cardView, alertTheme: .error, TopBottom: true)
    }
    static func showMessageForSuccess(_ strTitle: String) {
        forceLogout.forcefullyLogout(strTitle: strTitle)
        messageBar.MessageShow(title: strTitle as NSString, alertType: MessageView.Layout.cardView, alertTheme: .success, TopBottom: true)
    }
    static func showCustomeMessage(title strTitle: String,description strDescription : String) {
        forceLogout.forcefullyLogout(strTitle: strDescription)
        messageBar.showCustomMessage(title: strTitle, description: strDescription, TopBottom: true)
    }
}

struct forceLogout {
    static func forcefullyLogout(strTitle: String) {
     
        if strTitle == forceLogoutMsg {
            
            if let menuVC = (UIApplication.shared.keyWindow)?.rootViewController?.children.first?.children.last as? SideMenuTableViewController {
                menuVC.webserviceForLogout()
            }
            else if let menuVC = (UIApplication.shared.keyWindow)?.rootViewController?.children.first?.children.first as? SideMenuTableViewController {
                menuVC.webserviceForLogout()
            }
            return
        }
    }
}

class UtilityClass : NSObject
{
    
    static var messageBar = MessageBarController()

    class func showAlert(title:String,message:String,alertTheme:Theme) {
        
        forceLogout.forcefullyLogout(strTitle: message)
        messageBar.MessageShow(title: message as NSString, alertType: MessageView.Layout.cardView, alertTheme: alertTheme, TopBottom: true)
    }
    
    class func viewCornerRadius(view : UIView,borderWidth:CGFloat,borderColor:UIColor)
    {
        view.layer.cornerRadius = view.frame.height/2
        view.layer.masksToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
    }

    class func EmptyMessage(message:String, viewController:UIViewController) -> UILabel {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
//        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        return messageLabel

//        viewController.tableView.backgroundView = messageLabel;
//        viewController.tableView.separatorStyle = .none;
    }

    class func showDefaultAlertView(withTitle title: String?, message: String?, buttons buttonArray: [Any]?, completion block: @escaping (_ buttonIndex: Int) -> Void) {

        let strTitle = title

        let alertController = UIAlertController(title: strTitle, message: message, preferredStyle: .alert)
        for buttonTitle in buttonArray ?? [] {
            guard let buttonTitle = buttonTitle as? String else {
                continue
            }
            var action: UIAlertAction?
            if (buttonTitle.lowercased() == "cancel") {
                action = UIAlertAction(title: buttonTitle, style: .destructive, handler: { action in
                    let index = (buttonArray as NSArray?)?.index(of: action.title ?? "")
                    block(index!)
                })
            } else {
                action = UIAlertAction(title: buttonTitle, style: .default, handler: { action in
                    let index = (buttonArray as NSArray?)?.index(of: action.title ?? "")
                    block(index!)
                })
            }

            if let action = action {
                alertController.addAction(action)
            }
        }
        self.topMostController()?.present(alertController, animated: true)

    }

    class func topMostController() -> UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController

        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }

        return topController
    }

    class func showHUD(with mainView: UIView?) {

        let obj = DataClass.getInstance()
        obj?.viewBackFull = UIView(frame: CGRect(x: 0, y: 0, width: mainView?.frame.size.width ?? 0.0, height: mainView?.frame.size.height ?? 0.0))
        obj?.viewBackFull?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let imgGlass = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))//239    115    40
        imgGlass.backgroundColor = UIColor.black.withAlphaComponent(0.0) //UIColor(red: 239/255, green: 115/255, blue: 40/255, alpha: 1.0)//
        self._loadAnimationNamed("Loading", view: imgGlass, dataClass: obj)
        imgGlass.center = obj?.viewBackFull?.center ?? CGPoint(x: 0, y: 0)
        imgGlass.layer.cornerRadius = 15.0
        imgGlass.layer.masksToBounds = true
        obj?.viewBackFull?.addSubview(imgGlass)
        mainView?.addSubview(obj?.viewBackFull ?? UIView())
    }
    
    class func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    class func showHUDWithoutLottie(with mainView: UIView?) {
        
        let obj = DataClass.getInstance()
        obj?.viewBackFull = UIView(frame: CGRect(x: 0, y: 0, width: mainView?.frame.size.width ?? 0.0, height: mainView?.frame.size.height ?? 0.0))
        obj?.viewBackFull?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let imgGlass = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))//239    115    40
        imgGlass.backgroundColor = UIColor.black.withAlphaComponent(0.0) //UIColor(red: 239/255, green: 115/255, blue: 40/255, alpha: 1.0)//
        //        self._loadAnimationNamed("Loading", view: imgGlass, dataClass: obj)
        imgGlass.center = obj?.viewBackFull?.center ?? CGPoint(x: 0, y: 0)
        imgGlass.layer.cornerRadius = 15.0
        imgGlass.layer.masksToBounds = true
        obj?.viewBackFull?.addSubview(imgGlass)
        mainView?.addSubview(obj?.viewBackFull ?? UIView())
    }

    class func _loadAnimationNamed(_ named: String?, view mainView: UIView?, dataClass obj: DataClass?) {

        obj?.laAnimation = AnimationView(name: named ?? "")
        obj?.laAnimation?.frame = mainView?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)//CGRect(x: (mainView?.center.x ?? 0.0) / 2 - 3, y: 20, width: 140, height: 140)
        obj?.laAnimation?.contentMode = .scaleAspectFill
        obj?.laAnimation?.center = mainView?.center ?? CGPoint(x: 0, y: 0)
        obj?.laAnimation?.play(fromProgress: 0,
                              toProgress: 1,
                              loopMode: LottieLoopMode.loop,
                              completion: { (finished) in
                                if finished {

                                } else {

                                }
        })
        obj?.laAnimation?.layer.masksToBounds = true
        mainView?.setNeedsLayout()
        if let laAnimation = obj?.laAnimation {
            mainView?.addSubview(laAnimation)
        }

    }
    
    
    class func image(_ originalImage: UIImage?, scaledTo size: CGSize) -> UIImage? {
        //avoid redundant drawing
        if originalImage?.size.equalTo(size) ?? false {
            return originalImage
        }
        
        //create drawing context
        UIGraphicsBeginImageContextWithOptions(size, _ : false, _ : 0.0)
        
        //draw
        originalImage?.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
        //capture resultant image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //return image
        return image
    }
    

    class func convertTimeStampToFormat(unixtimeInterval : String, dateFormat : String) -> String
    {

        if(unixtimeInterval.count != 0)
        {
            let date = Date(timeIntervalSince1970: Double(unixtimeInterval) as! TimeInterval)
            let dateFormatter = DateFormatter()
            //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = dateFormat //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
        return ""
    }
    

    class func setCornerRadiusButton(button : UIButton , borderColor : UIColor , bgColor : UIColor, textColor : UIColor)
    {
        button.layer.cornerRadius = button.frame.size.height / 2
        button.clipsToBounds = true
        button.backgroundColor = bgColor
        button.setTitleColor(textColor, for: .normal)
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 1.0
    }

    class func getDataFromJSON(strJSONFileName : String) -> Any?
    {
        if let path = Bundle.main.path(forResource: strJSONFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return jsonResult
            } catch {
                // handle error
            }
        }
        return nil
    }

    class func hideHUD() {
        let obj = DataClass.getInstance()

        DispatchQueue.main.async(execute: {
            obj?.viewBackFull?.removeFromSuperview()
        })

    }



}


extension String {
    
    enum DateFormatInputType: String {
        case dateWithSeconds = "yyyy-MM-dd HH:mm:ss"
        case dateWithOutSeconds = "yyyy-MM-dd HH:mm"
    }
    
    enum DateFormatOutputType: String {
        case fullDate = "d MMM, yyyy h:mm a"
        case onlyDate = "d MMM, yyyy"
        case onlyTime = "h:mm a"

    }

    func convertDateString(inputFormat: DateFormatInputType, outputFormat: DateFormatOutputType) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = inputFormat.rawValue
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outputFormat.rawValue
            return  dateFormatter.string(from: date)
 
        }else{
            print("Could not get the dat string from dateformattere")
            return ""
            
        }
        
    }
    
    
    func getDate(inputFormat: DateFormatInputType) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = inputFormat.rawValue
        
        if let date = dateFormatter.date(from: self) {
            return  date
        }else{
            print("Could not get the dat string from dateformattere")
            return nil
        }
        
    }
    
//    func Convert_To_dd_MMM_yyyy() -> String {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        if let date = dateFormatter.date(from: self) {
//            dateFormatter.dateFormat = "d MMM, yyyy"
//            return  dateFormatter.string(from: date)
//        }else{
//            print("Cant convert to date by dateformatter")
//
//            return ""
//        }
//    }
//
//    func Convert_To_HH_mm_a() -> String {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let date = dateFormatter.date(from: self) {
//            dateFormatter.dateFormat = "h:mm a"
//            return  dateFormatter.string(from: date)
//        }else{
//            print("Cant convert to date by dateformatter")
//            return ""
//        }
//    }
}

//final class CustomView: UIView {
//    private var shadowLayer: CAShapeLayer!
//    @IBInspectable public var isRounded : Bool = false
//    @IBInspectable public var CornerRadius: CGFloat = 5.0
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.backgroundColor = .clear
//        if shadowLayer == nil {
//            shadowLayer = CAShapeLayer()
//            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: isRounded ? (self.frame.size.height/2) : CornerRadius).cgPath
//            shadowLayer.fillColor = UIColor.white.cgColor
//            shadowLayer.shadowColor = UIColor.lightGray.cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 0.7, height: 0.7)
//            shadowLayer.shadowOpacity = 0.3
//            shadowLayer.shadowRadius = 1
//            layer.insertSublayer(shadowLayer, at: 0)
//
//            //layer.insertSublayer(shadowLayer, below: nil) // also works
//        }
//
//
//    }
//    
//}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

