//
//  AppDelegate+PeppeaRental.swift
//  Peppea
//
//  Created by EWW078 on 26/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import SideMenuSwift


extension AppDelegate {
    
    
}


//Navigation
extension AppDelegate {
    
    func goToPeppeaRentalLogin() {
        
        
        let storyborad = UIStoryboard(name: "Rental_LoginRegister", bundle: nil)
        let Login = storyborad.instantiateViewController(withIdentifier: "RentalLoginViewController") as! RentalLoginViewController
        let NavHomeVC = UINavigationController(rootViewController: Login)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = NavHomeVC
    }
    
    func goToRentalHome(bookingInfo: BookingInfo? = nil) {
        
        let storyborad = UIStoryboard(name: "Rental_Main", bundle: nil)
        let CustomSideMenu = storyborad.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! SideMenuController
        let NavHomeVC = UINavigationController(rootViewController: CustomSideMenu)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = NavHomeVC
        
    }
    
}
