//
//  BaseViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 29/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



    func setNavBarWithMenu(Title:String, IsNeedRightButton:Bool){

        

        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.black

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear


        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "iconMenu"), style: .plain, target: self, action: #selector(self.OpenMenuAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        if Title == "Home"
        {
            //            let titleImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
            //            titleImage.contentMode = .scaleAspectFit
            //            titleImage.image = UIImage(named: "Title_logo")
            ////            titleImage.backgroundColor  = themeYellowColor
            //             self.navigationItem.titleView = titleImage
            self.title = Title
                //.uppercased()
        }
        else
        {
            self.navigationItem.title = Title.uppercased()
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black ,NSAttributedString.Key.font: UIFont(name: AppRegularFont, size: 20)!] ///



    }

    func setNavBarWithBack(Title:String, IsNeedRightButton:Bool, barColor: UIColor = UIColor.black, titleFontColor: UIColor = UIColor.black, backBarButtonColor: UIColor = UIColor.white) {
                self.navigationController?.navigationBar.isTranslucent = true

        if Title == "Home" {
            let titleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            titleImage.contentMode = .scaleAspectFit
            titleImage.image = UIImage(named: "Title_logo")
            self.navigationItem.titleView = titleImage
        } else {
            self.navigationItem.title = Title
                //.uppercased().localizedUppercase
        }

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : titleFontColor, NSAttributedString.Key.font: UIFont(name: AppRegularFont, size: 20)!] ///
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "iconLeftArrow"), style: .plain, target: self, action: #selector(self.btnBackAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        ///White color of a Back Bar Button Item
        self.navigationItem.leftBarButtonItem?.tintColor = backBarButtonColor
            //.white
        self.navigationController?.view.backgroundColor = .white


        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = barColor
            //UIColor.black
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isTranslucent = false


        if UserDefaults.standard.value(forKey: "i18n_language") != nil {
            if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if language == "sw" {
                    //                    btnLeft.semanticContentAttribute = .forceLeftToRight

                    //                    image = UIImage.init(named: "icon_BackWhite")?.imageFlippedForRightToLeftLayoutDirection()
                }
            }
        }
    }


    func setupNavigationBarColor(_ navigationController: UINavigationController?) {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isTranslucent = false
    }


    // MARK:- Navigation Bar Button Action Methods

    @objc func OpenMenuAction()
    {
        sideMenuController?.revealMenu()
    }

    @objc func btnBackAction()
    {
        if self.navigationController?.children.count == 1 {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    @objc func btnCallAction() {

//        let contactNumber = helpLineNumber
//        if contactNumber == "" {
//            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
//            }
//        }
//        else
//        {
//            callNumber(phoneNumber: contactNumber)
//        }
    }


    private func callNumber(phoneNumber:String) {

        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
