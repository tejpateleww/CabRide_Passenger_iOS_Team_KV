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

        if Title == "Home" {
            //            let titleImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
            //            titleImage.contentMode = .scaleAspectFit
            //            titleImage.image = UIImage(named: "Title_logo")
            ////            titleImage.backgroundColor  = themeYellowColor
            //             self.navigationItem.titleView = titleImage
            self.title = title?.uppercased()
        } else {
            self.navigationItem.title = Title.uppercased()
        }

        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.black

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear


        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "iconMenu"), style: .plain, target: self, action: #selector(self.OpenMenuAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton

        if IsNeedRightButton == true {
            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    func setNavBarWithBack(Title:String, IsNeedRightButton:Bool) {
        //        self.navigationController?.navigationBar.isTranslucent = false

        if Title == "Home" {
            let titleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            titleImage.contentMode = .scaleAspectFit
            titleImage.image = UIImage(named: "Title_logo")
            self.navigationItem.titleView = titleImage
        } else {
            self.navigationItem.title = Title.uppercased().localizedUppercase
        }
        self.navigationController?.navigationBar.barTintColor = ThemeColor;
        self.navigationController?.navigationBar.tintColor = ThemeColor;


        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ThemeColor]
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_BackWhite"), style: .plain, target: self, action: #selector(self.btnBackAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationController?.view.backgroundColor = .white

        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2


        if IsNeedRightButton == true {
            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        if UserDefaults.standard.value(forKey: "i18n_language") != nil {
            if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if language == "sw" {
                    //                    btnLeft.semanticContentAttribute = .forceLeftToRight

                    //                    image = UIImage.init(named: "icon_BackWhite")?.imageFlippedForRightToLeftLayoutDirection()
                }
            }
        }
    }


    // MARK:- Navigation Bar Button Action Methods

    @objc func OpenMenuAction(){
        sideMenuController?.revealMenu()
    }

    @objc func btnBackAction()
    {
        self.navigationController?.popViewController(animated: true)
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
