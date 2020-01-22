//
//  FavouriteAddressViewController.swift
//  Peppea
//
//  Created by Apple on 05/08/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

protocol FavouriteLocationDelegate {
    func didEnterFavouriteDestination(Source: [String: AnyObject])
}

class FavouriteAddressViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var tableView: UITableView!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    var aryData = [favouriteAddressListModel]()
    var delegateForFavourite: FavouriteLocationDelegate!
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarWithBack(Title: "Favourites", IsNeedRightButton: true)
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        webserviceForGetAddressList()
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    
    func webserviceForGetAddressList() {
        UserWebserviceSubclass.favouriteAddressListService(strURL: SingletonClass.sharedInstance.loginData.id) { (response, status) in
            print(response)
            if status {
                self.aryData.removeAll()
                let res = response.dictionary?["data"]?.array
                if res?.count == 0 {
                     self.tableView.reloadData()
                    return
                }
                for item in res! {
                    self.aryData.append(favouriteAddressListModel(fromJson: item))
                }
                self.tableView.reloadData()
            } else {
                AlertMessage.showMessageForError(response.dictionary?["message"]?.string ?? "")
            }
        }
    }
    
    func webserviceForDeleteFavouriteAddress(addressId: String) {
        let model = deleteFavouriteAddressReqAddress()
        model.customer_id = SingletonClass.sharedInstance.loginData.id
        model.favourite_address_id = addressId
        
        UserWebserviceSubclass.deleteFavouriteAddressListService(Promocode: model) { (response, status) in
            print(response)
            if status {
                AlertMessage.showMessageForSuccess(response.dictionary?["message"]?.string ?? "")
                self.webserviceForGetAddressList()
            } else {
                AlertMessage.showMessageForError(response.dictionary?["message"]?.string ?? "")
            }
        }
    }
}

// ----------------------------------------------------
// MARK:- TableView Methods
// MARK:-
// ----------------------------------------------------

extension FavouriteAddressViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if aryData.count == 0 ? false : true {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No favourite locations found"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return aryData.count == 0 ? 1 : aryData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteAddressTableViewCell", for: indexPath) as! favouriteAddressTableViewCell
        cell.selectionStyle = .none
        let currentData = aryData[indexPath.row]
        
        if currentData.favouriteType.lowercased() == "home" {
            cell.imgAddressType.image = UIImage(named: "iconHome")
        } else if currentData.favouriteType.lowercased() == "office" {
            cell.imgAddressType.image = UIImage(named: "iconOffice")
        } else if currentData.favouriteType.lowercased() == "other" {
            cell.imgAddressType.image = UIImage(named: "iconOthers")
        }
        
        cell.imgAddressType.setImageColor(color: ThemeColor)
        cell.lblAddressTitle.text = currentData.favouriteType.uppercased()
        cell.lblAddressDescription.text = currentData.dropoffLocation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dataDict = aryData[indexPath.row]
        
        if (dataDict.dropoffLocation) != nil {
            
            var dict = [String:AnyObject]()
            dict["Address"] = dataDict.dropoffLocation as AnyObject
            dict["Lat"] = dataDict.dropoffLat as AnyObject
            dict["Lng"] = dataDict.dropoffLng as AnyObject
            
            delegateForFavourite?.didEnterFavouriteDestination(Source: dict)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let Delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            print("Delete button tapped")
            
            let currentId =  self.aryData[editActionsForRowAt.row].id
            let alert = UIAlertController(title: AppName.kAPPName, message: "Are you want to sure to remove this address?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.webserviceForDeleteFavouriteAddress(addressId: currentId ?? "")
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }      
        return [Delete]
    }
    
}
