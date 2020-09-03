//
//  LoaderClass.swift
//  Chick Pick
//
//  Created by EWW-iMac Old on 01/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class Loader{
    static let obj = DataClass()
    class func showHUD(with mainView: UIView?) {
        
        
        obj.viewBackFull = UIView(frame: CGRect(x: 0, y: 0, width: mainView?.frame.size.width ?? 0.0, height: mainView?.frame.size.height ?? 0.0))
        obj.viewBackFull?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let imgGlass = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))//239    115    40
        imgGlass.backgroundColor = UIColor.black.withAlphaComponent(0.0) //UIColor(red: 239/255, green: 115/255, blue: 40/255, alpha: 1.0)//
        self.loadAnimationNamed(named: "Loading", view: imgGlass, dataClass: obj)
        imgGlass.center = obj.viewBackFull?.center ?? CGPoint(x: 0, y: 0)
        imgGlass.layer.cornerRadius = 15.0
        imgGlass.layer.masksToBounds = true
        obj.viewBackFull?.addSubview(imgGlass)
        mainView?.addSubview(obj.viewBackFull ?? UIView())
    }
    
    class func loadAnimationNamed( named: String?, view mainView: UIView?, dataClass obj: DataClass?) {
        
        obj?.laAnimation = AnimationView(name: named ?? "")
        obj?.laAnimation?.frame = mainView?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)//CGRect(x: (mainView?.center.x ?? 0.0) / 2 - 3, y: 20, width: 140, height: 140)
        obj?.laAnimation?.contentMode = .scaleAspectFill
        obj?.laAnimation?.center = mainView?.center ?? CGPoint(x: 0, y: 0)
//        obj?.laAnimation?.play(fromProgress: 0,
//                               toProgress: 1,
//                               completion: { (finished) in
//                                if finished {
//
//                                } else {
//
//                                }
//        })
        obj?.laAnimation?.play(fromProgress: 0, toProgress: 1000, completion: { (finished) in
            
        })
        obj?.laAnimation?.layer.masksToBounds = true
        mainView?.setNeedsLayout()
        if let laAnimation = obj?.laAnimation {
            mainView?.addSubview(laAnimation)
        }
        
    }
    
    class func hideHUD() {
        
        DispatchQueue.main.async(execute: {
            obj.viewBackFull?.removeFromSuperview()
        })
        
    }
    
    var instance: DataClass? = nil
    class DataClass {
        
        var str = ""
        
        var laAnimation: AnimationView?//LOTAnimationView?
        var viewBackFull: UIView?
        
        
//        class func getInstance() -> Loader.DataClass? {
//           return instance
//        }
    }
}
