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
