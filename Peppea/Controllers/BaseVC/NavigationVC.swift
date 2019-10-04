//
//  NavigationVC.swift
//  Peppea
//
//  Created by Apple on 06/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation

class NavigationController: UINavigationController, UINavigationBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        for viewController in viewControllers {
            // You need to do this because the push is not called if you created this controller as part of the storyboard
            addButton(viewController.navigationItem)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        addButton(viewController.navigationItem)
        super.pushViewController(viewController, animated: animated)
    }
    
    func addButton(_ item: UINavigationItem?) {
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "iconEmergencyCall"), style: .plain, target: self, action: #selector(action))
        
        if item?.rightBarButtonItem == nil {
            item?.rightBarButtonItems = [barButtonItem]
        }
        else
        {
            item?.rightBarButtonItems = [self.navigationItem.rightBarButtonItem,barButtonItem] as? [UIBarButtonItem]
        }
    }
    
    @objc func action(_ button: UIBarButtonItem?) {
        dialNumber(number: "123456789")
    }
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
}
