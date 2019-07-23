//
//  FlatRateListViewController.swift
//  TESLUXE
//
//  Created by Excellent WebWorld on 24/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class FlatRateListViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource
{

    
//    @IBOutlet var constrainXPositionViewSelection: NSLayoutConstraint!
//    @IBOutlet var btnCityDestination: UIButton!
//
//    @IBOutlet var viewSelected: UIView!
//    @IBOutlet var btnMountainDestination: UIButton!
    
    @IBOutlet var tblView: UITableView!
    var arrFlatRateListCityDEstination = [FlatRateData]()
    
    var arrFlatRateListMountainDEstination = [[String : AnyObject]]()
//    var delegateFlatRate : delegateforFlatRateSelection!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.webserviceforFlatRateList()
//        btnMountainDestination.isSelected = false
//        btnCityDestination.isSelected = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setNavBarWithBack(Title: "Flat Rate", IsNeedRightButton: true)
//          Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlackColor, naviTitle: "Flat Rate", leftImage: kBack_Icon, rightImage: "")
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
//        if btnCityDestination.isSelected
//        {
            return arrFlatRateListCityDEstination.count
//        }
//        else
//        {
//            return arrFlatRateListMountainDEstination.count
//        }
        //        if section == 0 {
        //
        //            if aryData.count == 0 {
        //                return 1
        //            }
        //            else {
        //                return aryData.count
        //            }
        //        }
        //        else {
        //            return 1
        //        }
        
//        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlatRateViewCell") as! FlatRateViewCell
        
        cell.selectionStyle = .none
        
//        cell.viewAddress.layer.cornerRadius = 10
//        cell.viewAddress.clipsToBounds = true
//        cell.viewPrice.layer.cornerRadius = 5
//        cell.viewPrice.clipsToBounds = true
//        if btnCityDestination.isSelected
//        {
            let dictTemp = arrFlatRateListCityDEstination[indexPath.row]
//
            cell.lblPickupLocation.text = dictTemp.pickupLocation
            cell.lblDropOffLocation.text = dictTemp.dropoffLocation
//
            var flatRatePrice = "$ " + dictTemp.rate
//
//            if let price = dictTemp["Price"] as? Int
//            {
//                flatRatePrice = "$ \(String(price))"
//            }
//            else if let tripprice = dictTemp["Price"] as? String
//            {
//                flatRatePrice = "$ \(tripprice)"
//            }
            cell.btnPrice.setTitle(flatRatePrice, for: .normal)
//        }
//        else
//        {
//             let dictTemp = arrFlatRateListCityDEstination[indexPath.row]
//            cell.lblPickupLocation.text = dictTemp["PickupLocation"] as! String
//            cell.lblDropOffLocation.text = dictTemp["DropoffLocation"] as! String
//        }
     
        return cell

        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
//        if btnCityDestination.isSelected
//        {
//            let dictTemp = arrFlatRateListCityDEstination[indexPath.row]
//            self.delegateFlatRate.didSelectFlateRatePackage(dictTemp)
//        }
//        else
//        {
//            let dictTemp = arrFlatRateListCityDEstination[indexPath.row]
//            self.delegateFlatRate.didSelectFlateRatePackage(dictTemp)
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
//    {
//        return true
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func webserviceforFlatRateList()
    {
//        getFixRateList
        UtilityClass.showHUD(with: self.view)
        UserWebserviceSubclass.getFixRateList(strURL: "") { (json, status) in
             UtilityClass.hideHUD()
            if status
            {
                let FlatRateListDetails = FlatRateListModel.init(fromJson: json)
                do
                {
                    try self.arrFlatRateListCityDEstination = FlatRateListDetails.Ratedata
                    self.tblView.reloadData()
                }
                catch
                {
                    UtilityClass.hideHUD()
                    AlertMessage.showMessageForError("error")
                }
            }
            else
            {
                 UtilityClass.hideHUD()
            }
        }
    }
//    @IBAction func btnMountainDEstinationClicked(_ sender: Any)
//    {
//        btnMountainDestination.isSelected = true
//        btnCityDestination.isSelected = false
//        self.constrainXPositionViewSelection.constant = self.btnCityDestination.frame.size.width
//
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations:
//            {
//
//                self.btnMountainDestination.setTitleColor(ThemeRedColor, for: .normal)
//                self.btnCityDestination.setTitleColor(ThemeGrayColor, for: .normal)
//
//                self.view.layoutIfNeeded()
//                self.tblView.reloadData()
//        }, completion: nil)
//    }
//
//
//    @IBAction func btnCityDEstinationClicked(_ sender: Any)
//    {
//        btnMountainDestination.isSelected = false
//        btnCityDestination.isSelected = true
//        self.constrainXPositionViewSelection.constant = 0
//
//
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations:
//            {
//
//                self.btnCityDestination.setTitleColor(ThemeRedColor, for: .normal)
//                self.btnMountainDestination.setTitleColor(ThemeGrayColor, for: .normal)
//
//                self.view.layoutIfNeeded()
//                self.tblView.reloadData()
//        }, completion: nil)
//    }
//
}
