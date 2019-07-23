//
//  AppDelegate.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SideMenuSwift
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupSideMenu()
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey(googlApiKey)
        GMSPlacesClient.provideAPIKey(googlApiKey)
//        Fabric.with([Crashlytics.self])
//        UserDefaults.standard.set(true, forKey: "isUserLogin")
        

        
        return true
    }



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // MARK:- Setup Side menu

    func setupSideMenu()
    {
        SideMenuController.preferences.basic.menuWidth = SCREEN_WIDTH - 60 //((SCREEN_WIDTH * 25) / 100)
        SideMenuController.preferences.basic.defaultCacheKey = "0"
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.statusBarBehavior = .none
        SideMenuController.preferences.basic.direction = .left

    }

    // MARK:- Login & Logout Methods

    func GoToHome() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let CustomSideMenu = storyborad.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! SideMenuController
        let NavHomeVC = UINavigationController(rootViewController: CustomSideMenu)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = NavHomeVC
    }


    func GoToLogin() {

        let storyborad = UIStoryboard(name: "LoginRegister", bundle: nil)
        let Login = storyborad.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let NavHomeVC = UINavigationController(rootViewController: Login)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = NavHomeVC

    }

    func GoToLogout() {

//        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//            print("\(key) = \(value) \n")
//
//            if key == "Token" || key  == "i18n_language" {
//
//            }
//            else {
//                UserDefaults.standard.removeObject(forKey: key)
//            }
//        }
//        //        UserDefaults.standard.set(false, forKey: kIsSocketEmited)
//        //        UserDefaults.standard.synchronize()
//
//        SingletonClass.sharedInstance.strPassengerID = ""
//        UserDefaults.standard.removeObject(forKey: "profileData")
//        SingletonClass.sharedInstance.isUserLoggedIN = false
//        //                self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
//        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//
//        UserDefaults.standard.removeObject(forKey: "Passcode")
//        SingletonClass.sharedInstance.setPasscode = ""
//
//        UserDefaults.standard.removeObject(forKey: "isPasscodeON")
//        SingletonClass.sharedInstance.isPasscodeON = false
//
//        SingletonClass.sharedInstance.isPasscodeON = false
         UserDefaults.standard.set(false, forKey: "isUserLogin")
        self.GoToLogin()
    }

 

}

