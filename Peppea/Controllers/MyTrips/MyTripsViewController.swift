//
//  MyTripsViewController.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 04/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class MyTripsViewController: BaseViewController
{

    @IBOutlet weak var collectionTableView: HeaderTableViewController!

    var tripType = MyTrips.past
    var data = [(String, String)]()
    var pageNo: Int = 1
    private let refreshControl = UIRefreshControl()
    var isRefresh = Bool()


    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionTableView()
        webserviceCallForGettingPastHistory()

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            collectionTableView.tableView.refreshControl = refreshControl
        } else {
            collectionTableView.tableView.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = ThemeColor // UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavBarWithBack(Title: "My Trips", IsNeedRightButton: false)

    }


    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        isRefresh = true
        webserviceCallForGettingPastHistory()
    }

    var pastBookingHistoryModelDetails = [PastBookingHistoryResponse]()
    {
        didSet
        {
            self.collectionTableView.tableView.reloadData()
        }
    }

    
    private func setCollectionTableView(){
        collectionTableView.isSizeToFitCellNeeded = true
        collectionTableView.indicatorColor = .black
        collectionTableView.titles = MyTrips.titles
        collectionTableView.parentVC = self
        collectionTableView.indicatorColor = .black
        collectionTableView.textColor = .black
        collectionTableView.registerNibs = [MyTripTableViewCell.identifier,
                                            MyTripDescriptionTableViewCell.identifier,
                                            FooterTableViewCell.identifier]
        collectionTableView.cellInset = UIEdgeInsets.zero
        collectionTableView.spacing = 0
        
        collectionTableView.didSelectItemAt = {
            indexpaths in
            if indexpaths.indexPath != indexpaths.previousIndexPath{
                self.tripType = MyTrips.allCases[indexpaths.indexPath.item]
//                self.setData()
                self.selectedCell = []
                self.collectionTableView.tableView.removeAllSubviews()
                self.collectionTableView.tableView.reloadData()
            }
        }
    }
    var selectedCell = [Int]()


    func setData()
    {
       self.data = self.tripType.getDescription(pastBookingHistory: self.pastBookingHistoryModelDetails[0])
    }

    func webserviceCallForGettingPastHistory()
    {

        let model = PastBookingHistory()
        model.customer_id = "1"//SingletonClass.sharedInstance.loginData.id
        model.page = "1"


        let strURL = model.customer_id + "/" + model.page

        if(!isRefresh)
        {
            UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        }


        UserWebserviceSubclass.pastBookingHistory(strURL: strURL) { (response, status) in
            UtilityClass.hideHUD()
            self.isRefresh = false
            if(status)
            {
                if let arrayResponse = response.dictionary?["data"]?.array {
                    self.pastBookingHistoryModelDetails = arrayResponse.map({ (item) -> PastBookingHistoryResponse in

                        return PastBookingHistoryResponse.init(fromJson: item)


                    })
                }

                self.pastBookingHistoryModelDetails = self.pastBookingHistoryModelDetails.filter({$0.driverId != "0"})

                self.collectionTableView.tableView.reloadData()
                  self.refreshControl.endRefreshing()
            }
            else
            {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }


        }
    }
}

extension MyTripsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.pastBookingHistoryModelDetails.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedCell.contains(section){
            return 1 + self.data.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.identifier)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTripTableViewCell.identifier, for: indexPath) as! MyTripTableViewCell
            let dataResponseHeader = self.pastBookingHistoryModelDetails[indexPath.section]
            cell.lblName.text = "\(dataResponseHeader.driverFirstName ?? "") \(dataResponseHeader.driverLastName ?? "")"
            cell.lblBookin.text = "Booking Id : \(dataResponseHeader.id ?? "")"
            cell.lblPickup.text = dataResponseHeader.pickupLocation
            cell.lblDropoff.text = dataResponseHeader.dropoffLocation
            cell.setup()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTripDescriptionTableViewCell.identifier, for: indexPath) as! MyTripDescriptionTableViewCell

            cell.lblTitle.text = data[indexPath.row - 1].0 + ":"
            cell.lblDescription.text = data[indexPath.row - 1].1
            let color = indexPath.row == data.count ? UIColor.orange : UIColor.white
            cell.lblDescription.textColor = color
            cell.lblTitle.textColor = color
            cell.setup()
            return cell
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCell.contains(indexPath.section){
            let index = selectedCell.firstIndex(of: indexPath.section)
            selectedCell.remove(at: index!)
            self.data = self.tripType.getDescription(pastBookingHistory: self.pastBookingHistoryModelDetails[indexPath.row])
            tableView.removeAllSubviews()
            tableView.reloadData()
        }
        else{
            self.data = self.tripType.getDescription(pastBookingHistory: self.pastBookingHistoryModelDetails[indexPath.row])
            selectedCell.append(indexPath.section)
            tableView.reloadData()
            let rect =  tableView.rect(forSection: indexPath.section)
            let imageView = UIImageView(frame: CGRect(x: 10, y: rect.minY, width: rect.width - 20, height: rect.height))
            //            imageView.image = #imageLiteral(resourceName: "bird-icon")

            imageView.alpha = 0.8
            imageView.contentMode = .scaleAspectFit
            tableView.removeAllSubviews()
            tableView.addSubview(imageView)
        }
        if indexPath.section == 9{
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }

    }
    
    
}