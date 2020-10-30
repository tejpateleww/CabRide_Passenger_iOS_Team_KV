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
import FBSDKCoreKit
//import Fabric
//import Crashlytics
import Firebase
import FirebaseMessaging
import UserNotifications
import CoreLocation



let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var window: UIWindow?
    var instanceIDTokenMessage = String()
    var gcmMessageIDKey = String()
    let locationManager = CLLocationManager()
    var defaultLocation = CLLocation()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupSideMenu()
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey(googlApiKey)
        GMSPlacesClient.provideAPIKey(googlApiKey)
        FirebaseApp.configure()
        setupPushNotification(application: application)
        locationPermission()
        //        Fabric.with([Crashlytics.self])
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Forcefully light mode
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        if(UserDefaults.standard.object(forKey: "userProfile") != nil) {
            do {
                SingletonClass.sharedInstance.loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!.loginData
                SingletonClass.sharedInstance.walletBalance = SingletonClass.sharedInstance.loginData.walletBalance
                SingletonClass.sharedInstance.BulkMilesBalance = SingletonClass.sharedInstance.loginData.BulkMilesBalance
            }
            catch {
                //            AlertMessage.showMessageForError("error")
                //            return
            }
        }
        return true
    }
    
    
    func setupPushNotification(application : UIApplication)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.instanceIDTokenMessage  = "Remote InstanceID token: \(result.token)"
                UserDefaults.standard.set(result.token, forKey: "Token")
                UserDefaults.standard.synchronize()
            }
        }
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print(#function, response)
        
        
        //        let content = response.notification.request.content
        let userInfo = response.notification.request.content.userInfo
        if userInfo["gcm.notification.type"] == nil { return }
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        print("USER INFo : ",userInfo)
        print("KEY : ",key)
        
        if userInfo["gcm.notification.type"] as! String == "booking_chat" {
            
            if let response = userInfo["gcm.notification.data"] as? String {
                let jsonData = response.data(using: .utf8)!
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                if let dic = (dictionary as? [[String: Any]])?.first{
                    print(dic)
                    
                    let state = UIApplication.shared.applicationState
                    
                    if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController?.children.first?.children.last {
                        
                        if let vc : ChatViewController = (vc as? ChatViewController) {
                            
                            if let senderID = dic["sender_id"] as? String {
                                if senderID == vc.receiver_id {
                                    vc.webServiceForGetChatHistory()
                                }
                            }
                        } else {
                            if state == .inactive {
                                NotificationCenter.default.addObserver(self, selector: #selector(loadChatVC), name: NotificationSetHomeVC, object: nil)
                                SingletonClass.sharedInstance.userInfo = dic
                                UtilityClass.showAlert(title: "sender_id", message: dic["sender_id"] as? String ?? "\(dic["sender_id"] as? Int ?? 0)", alertTheme: .info)
                            }
                            if !vc.isKind(of: SplashViewController.self) {
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let controller = storyboard.instantiateViewController(withIdentifier: ChatViewController.className) as? ChatViewController {
                                    controller.strBookingId = dic["booking_id"] as? String ?? ""
                                    controller.receiver_id =  dic["sender_id"] as? String ?? "\(dic["sender_id"] as? Int ?? 0)"
                                    
                                    UtilityClass.showAlert(title: "sender_id", message: dic["sender_id"] as? String ?? "\(dic["sender_id"] as? Int ?? 0)", alertTheme: .info)
                                    vc.navigationController?.pushViewController(controller, animated: false)
                                }
                            }
                        }
                        
                    }
                    //                    }
                } else {
                    completionHandler()
                }
            }
        }
    }
    
    @objc func loadChatVC(){
        let storyboard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: ChatViewController.className) as? ChatViewController {
            let userinfo = SingletonClass.sharedInstance.userInfo
            controller.receiver_id = userinfo?["SenderID"] as? String ?? ""
            (self.window?.rootViewController as? UINavigationController)?.pushViewController(controller, animated: false)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(#function, notification.request.content.userInfo)
        //        let content = notification.request.content
        
        
        let userInfo = notification.request.content.userInfo
        if userInfo["gcm.notification.type"] == nil { return }
        
        
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        print("USER INFo : ",userInfo)
        print("KEY : ",key)
        
        
        
        if userInfo["gcm.notification.type"] as! String == "booking_chat" {
            
            if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController?.children.first?.children.last {
                if let vc : ChatViewController = (vc as? ChatViewController) {
                    
                    if let response = userInfo["gcm.notification.data"] as? String {
                        let jsonData = response.data(using: .utf8)!
                        let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                        
                        if let dic = (dictionary as? [[String: Any]])?.first{
                            print(dic)
                            
                            if let senderID = dic["sender_id"] as? String {
                                if senderID == vc.receiver_id || dic["booking_id"] as? String ==  vc.strBookingId {
                                    
                                    
                                    let chat = MessageObject(isSender: false, name: dic["sender_name"] as? String ?? "", image: "", id: "", sender_id: dic["sender_id"] as? String ?? "", receiver_id: dic["receiver_id"] as? String ?? "", message: dic["message"] as? String ?? "", created_date: dic["created_at"] as? String ?? "", bookingId: dic["booking_id"] as? String ?? "", sender_type: dic["sender_type"] as? String ?? "", receiver_type: dic["receiver_type"] as? String ?? "")
                                    
                                    //                                    let chat = MessageObject(ReceiverID: dic["ReceiverID"] as? String ?? "", Message: dic["Message"] as? String ?? "", SenderNickname: dic["sender_nickname"] as? String ?? "", SenderName: dic["sender_name"] as? String ?? "", SenderID: dic["SenderID"] as? String ?? "", Date: dic["Date"] as? String ?? "", ChatId: dic["chat_id"] as? String ?? "")
                                    print(chat)
                                    
                                    vc.arrData.append(chat)
                                    let indexPath = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                    vc.tblVw.insertRows(at: [indexPath], with: .bottom)
                                    let path = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                    vc.tblVw.scrollToRow(at: path, at: .bottom, animated: true)
                                } else{
                                    //                                    NotificationCenter.default.post(name: NotificationBadges, object: content)
                                    completionHandler([.alert, .sound])
                                }
                            }
                        }
                    }
                } else {
                    //                    NotificationCenter.default.post(name: NotificationBadges, object: content)
                    completionHandler([.alert, .sound])
                }
            } else {
                //                NotificationCenter.default.post(name: NotificationBadges, object: content)
                completionHandler([.alert, .sound])
            }
        }
        else if userInfo["gcm.notification.type"] as! String == "verify_customer" {
            completionHandler([.alert, .sound])
        }
        else if userInfo["gcm.notification.type"] as! String == "request_code_for_complete_trip" {
            completionHandler([.alert, .sound])
        }
        //            completionHandler([.alert, .sound])
        
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
        if (CLLocationManager.authorizationStatus() == .denied) || CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .notDetermined {
            let alert = UIAlertController(title: AppName.kAPPName, message: "Please enable location from settings", preferredStyle: .alert)
            let enable = UIAlertAction(title: "Enable", style: .default) { (temp) in
                
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(URL(string: "App-Prefs:root=Privacy&path=LOCATION") ?? url, options: [:], completionHandler: nil)
                }
                //                guard let locationUrl = URL(string: "prefs:root =LOCATION_SERVICES") else {
                //                    return
                //                }
                //                UIApplication.shared.openURL(locationUrl)
            }
            alert.addAction(enable)
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
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
        SideMenuController.preferences.basic.statusBarBehavior = .slide
        SideMenuController.preferences.basic.direction = .left
        
    }
    
    // MARK:- Login & Logout Methods
    
    func GoToHome(bookingInfo: BookingInfo? = nil) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let CustomSideMenu = storyborad.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! SideMenuController
        let NavHomeVC = NavigationController(rootViewController: CustomSideMenu)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = NavHomeVC
    }
    
    
    func GoToChooseServices(bookingInfo: BookingInfo? = nil) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let CustomSideMenu = storyborad.instantiateViewController(withIdentifier: "ChooseServiceViewController") as! ChooseServiceViewController
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
        
        //        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first?.children.first as! HomeViewController
        //1. Clear Singleton class
        SingletonClass.sharedInstance.clearSingletonClass()
        
        //2. Clear all userdefaults
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
            //            print("\(key) = \(value) \n")
            if key == "Token" || key  == "i18n_language" {
            }
            else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        //3. Set isLogin USer Defaults to false
        UserDefaults.standard.set(false, forKey: "isUserLogin")
        self.GoToLogin()
    }
    
}


// MARK:- CLLocationManagerDelegate
//1
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationPermission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted:
            break
        case .denied:
            //            mapView.isHidden = false
            break
        case .notDetermined:
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            print("")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        defaultLocation = location
        
        SingletonClass.sharedInstance.myCurrentLocation = defaultLocation
        
    }
}
