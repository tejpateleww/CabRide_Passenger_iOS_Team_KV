//
//  MyTripsViewController.swift
//  Chick Pick
//
//  Created by EWW-iMac Old on 04/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SwiftyJSON
class RentalHistoryViewController: BaseViewController
{

    @IBOutlet weak var collectionTableView: HeaderTableViewController!

    var tripType = MyTrips.past
    var data = [(String, String)]()
    var pageNoPastBooking: Int = 1
    var pageNoPastUpcoming: Int = 1
    private let refreshControl = UIRefreshControl()
    var isRefresh = Bool()

    var isDataLoading:Bool=false
    var didEndReached:Bool=false

    var NeedToReload:Bool = false
    var PageLimit = 10
    var PageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionTableView()
//        webserviceCallForGettingPastHistory(pageNo: 1)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            collectionTableView.tableView.refreshControl = refreshControl
        } else {
            collectionTableView.tableView.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = ThemeColor // UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
        
        self.collectionTableView.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavBarWithBack(Title: "Trip History", IsNeedRightButton: false)
        self.navigationItem.title = "Trip History"

    }

    @objc private func refreshWeatherData(_ sender: Any) {
        isRefresh = true
        self.LoadNewData()
        // Fetch Weather Data
//        if self.tripType.rawValue.lowercased() == "past" {
//            self.pageNoPastBooking = 1
//            webserviceCallForGettingPastHistory(pageNo: 1)
//        } else {
//            self.pageNoPastUpcoming = 1
//            webserviceForUpcommingBooking(pageNo: 1)
//        }
    }
    
    func LoadMoreData() {
        
        self.PageNumber += 1
        if self.tripType.rawValue.lowercased() == "past" {
            //TODO: Enable it when loading more dat
//           self.webserviceCallForGettingPastHistory(pageNo: self.PageNumber)
        } else {
            //TODO: Commented
//            self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }
        
    }
    
    func LoadNewData() {
        self.PageNumber = 1
//        self.pastBookingHistoryModelDetails.removeAll()
//        self.collectionTableView.tableView.reloadData()
        if self.tripType.rawValue.lowercased() == "past" {
            //TODO:
            //            self.webserviceCallForGettingPastHistory(pageNo: self.PageNumber)
        } else if self.tripType.rawValue.lowercased() == "upcoming" {
            //TODO:
            //            self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }else{
            //TODO:
//            self.webserviceForCurrentBooking(pageNo: self.PageNumber)
        }
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
        collectionTableView.registerNibs = [RentalPastHistoryCell.identifier,RentalCurrentHistoryCell.identifier,
                                            MyTripDescriptionTableViewCell.identifier,
                                            FooterTableViewCell.identifier, NoDataFoundTblCell.identifier]
        collectionTableView.cellInset = UIEdgeInsets.zero
        collectionTableView.spacing = 0
        
        collectionTableView.didSelectItemAt = {
            indexpaths in
            if indexpaths.indexPath != indexpaths.previousIndexPath {
                self.tripType = MyTrips.allCases[indexpaths.indexPath.item]
//                self.setData()
                self.selectedCell = -1
                
                if indexpaths.indexPath.item == 1 {
                    self.LoadNewData()
//                    self.webserviceForUpcommingBooking(pageNo: 1)
                } else {
                    self.LoadNewData()
//                    self.webserviceCallForGettingPastHistory(pageNo: 1)
                }
                self.collectionTableView.tableView.removeAllSubviews()
                self.collectionTableView.tableView.reloadData()
            }
        }
    }
    
    
    var selectedCell : Int = -1


    func setData()
    {
       self.data = self.tripType.getDescription(pastBookingHistory: self.pastBookingHistoryModelDetails[0])
    }

    func webserviceCallForGettingPastHistory(pageNo: Int) {

        let model = PastBookingHistory()
        model.customer_id = SingletonClass.sharedInstance.loginData.id
        model.page = "\(pageNo)"

        let strURL = model.customer_id + "/" + model.page

        if(!isRefresh)
        {
            UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        }


        UserWebserviceSubclass.pastBookingHistory(strURL: strURL) { (response, status) in
            UtilityClass.hideHUD()
            self.isRefresh = false
            if(status) {
                self.setDataAfterWebServiceCall(response: response)
            }
            else {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }

    func webserviceForUpcommingBooking(pageNo: Int) {
        
        let param = SingletonClass.sharedInstance.loginData.id + "/" + "\(pageNo)"
        UserWebserviceSubclass.upcomingBookingHistory(strURL: param) { (response, status) in
//            print(response)
            UtilityClass.hideHUD()
            self.isRefresh = false
            if(status) {
                self.setDataAfterWebServiceCall(response: response)
            }
            else {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }

    func webserviceForCurrentBooking(pageNo: Int) {

        let param = SingletonClass.sharedInstance.loginData.id + "/" + "\(pageNo)"
        UserWebserviceSubclass.currentBookingList(strURL: param) { (response, status) in
            //            print(response)
            UtilityClass.hideHUD()
            self.isRefresh = false
            if(status) {
                self.setDataAfterWebServiceCall(response: response)
            }
            else {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }


    func setDataAfterWebServiceCall(response:JSON)
    {
        var arrResponseData = [PastBookingHistoryResponse]()

        if let arrayResponse = response.dictionary?["data"]?.array {
            arrResponseData = arrayResponse.map({ (item) -> PastBookingHistoryResponse in
                return PastBookingHistoryResponse.init(fromJson: item)
            })
        }

        if arrResponseData.count == self.PageLimit {
            self.NeedToReload = true
        } else {
            self.NeedToReload = false
        }

        if self.PageNumber == 1 {
            self.pastBookingHistoryModelDetails = arrResponseData
        } else {
            for BookingObj in arrResponseData {
                self.pastBookingHistoryModelDetails.append(BookingObj)
            }
        }
        self.collectionTableView.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @objc func cancelTrip(_ sender: UIButton) {
        let dataResponseHeader = self.pastBookingHistoryModelDetails[sender.tag]
        webserviceForCancelTrip(bookingId: dataResponseHeader.id)
    }
    
    func webserviceForCancelTrip(bookingId: String) {
        
        let homeVC = self.parent?.children.first as? HomeViewController
        
        let model = CancelTripRequestModel()
        model.booking_id = bookingId
        UserWebserviceSubclass.CancelTripBookingRequest(bookingRequestModel: model) { (response, status) in
            
            if status {
                homeVC?.setupAfterComplete()
                self.webserviceForUpcommingBooking(pageNo: 1)
            } else {
                AlertMessage.showMessageForError(response.dictionary?["message"]?.stringValue ?? "Something went wrong")
            }
        }
    }
}

extension RentalHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       if selectedCell == section {
//
//            return 2
//        }
        return 1
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
         if self.tripType.rawValue.lowercased() == "past" {
            return tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.identifier)
         }
        return UIView()
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.tripType.rawValue.lowercased() == "past" {
 
                let cell = tableView.dequeueReusableCell(withIdentifier: RentalPastHistoryCell.identifier, for: indexPath) as! RentalPastHistoryCell

                    cell.lblName.attributedText = NSAttributedString(string: "John Doe", attributes:
                        [.underlineStyle: NSUnderlineStyle.thick.rawValue])
                    
                    cell.lblVehicleNo.attributedText = NSAttributedString(string: "GKB 645B", attributes:
                        [.underlineStyle: NSUnderlineStyle.thick.rawValue])
            
                    cell.lblBookin.text = "Booking Id : 1234567890"
            
                    cell.lblPickup.text = "Cupertino"

                    cell.lblDropoff.text = "Texas"
                            cell.lblKM.text = "10 KM"
            
            
                    cell.setup()
            
                return cell

        }else{
            
                let cell = tableView.dequeueReusableCell(withIdentifier: RentalCurrentHistoryCell.identifier, for: indexPath) as! RentalCurrentHistoryCell

                //self.pastBookingHistoryModelDetails[indexPath.section]
                cell.lblName.attributedText = NSAttributedString(string: "John Doe", attributes:
                    [.underlineStyle: NSUnderlineStyle.thick.rawValue])
            
                cell.lblVehicleNo.attributedText = NSAttributedString(string: "GKB 645B", attributes:
                    [.underlineStyle: NSUnderlineStyle.thick.rawValue])
                //"\(dataResponseHeader.driverFirstName ?? "") \(dataResponseHeader.driverLastName ?? "")"
                cell.lblBookin.text = "Booking Id : 1234567890"
                //"Booking Id : \(dataResponseHeader.id ?? "")"
                cell.lblPickup.text = "Cupertino"
                //dataResponseHeader.pickupLocation
                cell.lblDropoff.text = "Texas"
                cell.lblKM.text = "10 KM"
            
                if self.tripType.rawValue.lowercased() == "current" {

                    cell.btnTripProceed.setTitle("Complete Trip", for: .normal)
                    
                    cell.ratingsView.isHidden = false

                }else{

                    cell.btnTripProceed.setTitle("Trip Proceed", for: .normal)

                    cell.ratingsView.isHidden = true

                }

                cell.setup()
            
                return cell
            }
        
        //        } else {
        //            let NoDataCell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundTblCell.identifier) as! NoDataFoundTblCell
        //
        //            return NoDataCell
        //        }

    } ///cell for row ends here
  

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.pastBookingHistoryModelDetails.count > 0 {
        
          if self.tripType.rawValue.lowercased() == "past" {
                return 332.0
          }else{
             return 390.0
          }
            //UITableView.automaticDimension
//        }
//        return 400.0
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
//        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
//        print("scrollViewDidEndDragging")
        if ((collectionTableView.tableView.contentOffset.y + collectionTableView.tableView.frame.size.height) >= collectionTableView.tableView.contentSize.height) {
         
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }

    
}
