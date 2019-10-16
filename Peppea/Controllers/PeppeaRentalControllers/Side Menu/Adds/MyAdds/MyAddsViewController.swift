//
//  MyAddsViewController.swift
//  Peppea
//
//  Created by EWW078 on 05/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class MyAddsViewController: BaseViewController {

    var arrayAdds: [[String:Any]] = []
    
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        arrayAdds = self.loadData()
        //Adding more elements
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBarWithBack(Title: "My Add", IsNeedRightButton: false)
        self.navigationItem.title = "My Add"
    }
  
    func loadData() -> [Dictionary<String,Any>] {
        
        
        let arrVehicles = [["Id":"111","vehiclemodel":"ford Figo","distance":"25","capicity":"5 seater","address":"30525 Linden Street PO Box 283 Lindstrom, MN 55045","carImage":"imgYellowCar"], ["Id":"112","vehiclemodel":"Mercedes Benz","distance":"15","capicity":"4 seater","address":"30525 Linden Street PO Box 283 London, MN 55045","carImage":"imgYellowCar"], ["Id":"113","vehiclemodel":"Verna Hundai","distance":"22","capicity":"5 seater","address":"US Main Street PO Box 283 London, MN 55045","carImage":"imgYellowCar"],["Id":"114","vehiclemodel":"Honda City","distance":"18","capicity":"5 seater","address":"111505 London Street PO Box 283 Lindstrom, MN 55055Z5","carImage":"imgYellowCar"],["Id":"228","vehiclemodel":"Scorpio","distance":"22","capicity":"5 seater","address":"30000 Linden Street PO Box 283 Lindstrom, MN 465001","carImage":"imgYellowCar"],["Id":"640","vehiclemodel":"ford Figo","distance":"25","capicity":"5 seater","address":"30525 Linden Street PO Box 283 Lindstrom, MN 55045","carImage":"imgYellowCar"]]
        
        return arrVehicles
        
    }
}

// MARK: - Table view data source

extension MyAddsViewController : UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayAdds.count > 0 ? arrayAdds.count : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.arrayAdds.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAddsCell") as! MyAddsCell
            
            cell.selectionStyle = .none
            
            cell.uiSetup()
            
            
            let VehicleDict = self.arrayAdds[indexPath.row]
            
            
            
            
            cell.lblVehicleName.text = (VehicleDict["vehiclemodel"] as? String ?? "").capitalized
            
            if let capacity = VehicleDict["number_of_people"] as? String {
                cell.lblSeater.text = "\(capacity) seater"
            }
            
            
            return cell
            
        } else {
            
            let noDataCell = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! UITableViewCell
            
            return noDataCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tblView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath)
        self.didVehicleBook(CustomCell: cell!)
        
    }
    
    func didVehicleBook(CustomCell: UITableViewCell) {
        
//        let customIndexPath = self.tblView.indexPath(for: CustomCell)!
        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailViewController") as! AddDetailViewController
//        vehicleDetail.VehicleDetail = self.arrVehicles[customIndexPath.row] as [String : AnyObject]
//        vehicleDetail.vehicleFrom_To = (startDate,endDate)
//        vehicleDetail.startDisplayDate = self.DisplayPickupDate
//        vehicleDetail.endDisplayDate = self.DisplayDeliveryDate
//        vehicleDetail.selectedAddress = self.placeSelected?.formattedAddress ?? ""
//        vehicleDetail.selectedAddLat = self.placeSelected?.coordinate.latitude ?? 0.0
//        vehicleDetail.selectedAddLong = self.placeSelected?.coordinate.longitude ?? 0.0
//        vehicleDetail.selectedTripType = ""
//        //self.selectedTripType
//        vehicleDetail.VehicalCat_IDName = self.VehicalCat_IDName
        self.navigationController?.pushViewController(addDetailVC, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayAdds.count > 0 {
            return 110
            //150
        } else {
            return 200
        }
    }
    
    
    
}

