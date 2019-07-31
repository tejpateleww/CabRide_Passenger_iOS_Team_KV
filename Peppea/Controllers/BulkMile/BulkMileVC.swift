//
//  BulkMileVC.swift
//  Peppea
//
//  Created by EWW80 on 08/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class BulkMileVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var arrBulkMileList = [BulkMileListDataModel]()
    @IBOutlet weak var cardTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webserviceCallForBulkMile()
        self.setNavBarWithBack(Title: "Bulk Mile", IsNeedRightButton: false)
        cardTableView.register(UINib(nibName: "BulkMileTableViewCell", bundle: nil), forCellReuseIdentifier: "BulkMileTableViewCell")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBulkMileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BulkMileTableViewCell", for: indexPath) as! BulkMileTableViewCell

        let bulkMileData = arrBulkMileList[indexPath.row]
        
        cell.btnPurchase.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.btnPurchase.tag = indexPath.row
        cell.lblDescription.text = bulkMileData.descriptionField
        cell.lblPriceRange.text = "\(Currency) \(bulkMileData.actualPrice ?? "0.00")"
        cell.lblDistance.text = "\(bulkMileData.miles ?? "0.00") miles"

        var DoubleValidity = Double()
        if let validity = bulkMileData.validity, let doubleLat = Double(validity) {
            DoubleValidity = doubleLat
        }

         cell.lblValidity.text = "\(bulkMileData.validity ?? "0.00") \(bulkMileData.validityType ?? "")"
        if(DoubleValidity > 1.0)
        {
             cell.lblValidity.text = "\(bulkMileData.validity ?? "0.00") \(bulkMileData.validityType ?? "")s"
        }


        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        print(buttonTag)
    }

    func webserviceCallForBulkMile()
    {

        UserWebserviceSubclass.getBulkMile(strURL: "") { (response, status) in
            if(status)
            {
                if let arrayResponse = response.dictionary?["data"]?.array {
                    self.arrBulkMileList = arrayResponse.map({ (item) -> BulkMileListDataModel in

                        return BulkMileListDataModel.init(fromJson: item)


                    })
                }
                self.cardTableView.reloadData()
//                self.refreshControl.endRefreshing()
            }
            else
            {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }

        }
    }
    
    
}
