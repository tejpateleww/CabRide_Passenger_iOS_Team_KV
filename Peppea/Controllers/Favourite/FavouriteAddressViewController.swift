//
//  FavouriteAddressViewController.swift
//  Peppea
//
//  Created by Apple on 05/08/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class FavouriteAddressViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var tableView: UITableView!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    var aryData = [favouriteAddressListModel]()
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                let res = response.dictionary?["data"]?.array
                
                if res?.count == 0 {
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
}

extension FavouriteAddressViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if aryData.count == 0 ? false : true
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }
        
        return aryData.count == 0 ? 1 : aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteAddressTableViewCell", for: indexPath) as? favouriteAddressTableViewCell else {
//            let cellNodataFound = tableView.dequeueReusableCell(withIdentifier: "favouriteAddressNotFound", for: indexPath) as? favouriteAddressTableViewCell
            return UITableViewCell(frame: .zero)
        }
        
//        if aryData.count == 0 {
//            let cellNodataFound = tableView.dequeueReusableCell(withIdentifier: "favouriteAddressNotFound", for: indexPath) as? favouriteAddressTableViewCell
//            return UITableViewCell(frame: .zero)
//        }
        
        let currentData = aryData[indexPath.row]
        cell.imgAddressType.image = UIImage()
        cell.lblAddressTitle.text = currentData.favouriteType.uppercased()
        cell.lblAddressDescription.text = currentData.dropoffLocation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
