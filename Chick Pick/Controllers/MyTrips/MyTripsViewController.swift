//
//  MyTripsViewController.swift
//  Chick Pick
//
//  Created by EWW-iMac Old on 04/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyTripsViewController: BaseViewController
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
        webserviceCallForGettingPastHistory(pageNo: 1)
        
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
        isRefresh = true
        self.LoadNewData()
    }
    
    func LoadMoreData() {
        
        self.PageNumber += 1
        if self.tripType.rawValue.lowercased() == "past" {
            self.webserviceCallForGettingPastHistory(pageNo: self.PageNumber)
        } else {
            self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }
    }
    
    func LoadNewData() {
        self.PageNumber = 1
        //        self.pastBookingHistoryModelDetails.removeAll()
        //        self.collectionTableView.tableView.reloadData()
        if self.tripType.rawValue.lowercased() == "past" {
            self.webserviceCallForGettingPastHistory(pageNo: self.PageNumber)
        } else if self.tripType.rawValue.lowercased() == "upcoming" {
            self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }else{
            self.webserviceForCurrentBooking(pageNo: self.PageNumber)
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
        collectionTableView.registerNibs = [MyTripTableViewCell.identifier,
                                            MyTripDescriptionTableViewCell.identifier,
                                            FooterTableViewCell.identifier, NoDataFoundTblCell.identifier]
        collectionTableView.cellInset = UIEdgeInsets.zero
        collectionTableView.spacing = 0
        
        collectionTableView.didSelectItemAt = {
            indexpaths in
            if indexpaths.indexPath != indexpaths.previousIndexPath {
                self.tripType = MyTrips.allCases[indexpaths.indexPath.item]
                self.selectedCell = -1
                self.LoadNewData()
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
        
         if arrResponseData.count < 10 {
             self.didEndReached = true
         } else {
             self.didEndReached = false
         }
        
        if self.pageNoPastBooking == 1 {
            self.pastBookingHistoryModelDetails = arrResponseData
        } else {
            self.pastBookingHistoryModelDetails.append(contentsOf: arrResponseData)
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

extension MyTripsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.pastBookingHistoryModelDetails.count > 0) ? self.pastBookingHistoryModelDetails.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedCell == section {
            return 1 + self.data.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.pastBookingHistoryModelDetails.count > 0 {
            return tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.identifier)
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.pastBookingHistoryModelDetails.count > 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyTripTableViewCell.identifier, for: indexPath) as! MyTripTableViewCell
                let dataResponseHeader = self.pastBookingHistoryModelDetails[indexPath.section]
                cell.lblName.text = "\(dataResponseHeader.driverFirstName ?? "") \(dataResponseHeader.driverLastName ?? "")"
                cell.lblBookin.text = "Booking Id : \(dataResponseHeader.id ?? "")"
                cell.lblDate.text = UtilityClass.convertTimeStampToFormat(unixtimeInterval: dataResponseHeader.bookingTime, dateFormat: "yyyy/MM/dd HH:mm")
                
                cell.lblPickup.text = dataResponseHeader.pickupLocation
                cell.lblDropoff.text = dataResponseHeader.dropoffLocation
                cell.btnSendReceipt.isHidden = true
                cell.lblKM.isHidden = true
                if self.tripType.rawValue.lowercased() != "past" {
                    cell.btnSendReceipt.isHidden = false
                    cell.btnSendReceipt.setTitle("Cancel request", for: .normal)
                    cell.btnSendReceipt.titleLabel?.font = UIFont.regular(ofSize: 14)
                    cell.btnSendReceipt.tag = indexPath.section
                    cell.btnSendReceipt.addTarget(self, action: #selector(self.cancelTrip(_:)), for: .touchUpInside)
                    
                    UtilityClass.viewCornerRadius(view: cell.btnSendReceipt, borderWidth: 1, borderColor: .black)
                    
                    //                cell.btnSendReceipt.layer.cornerRadius = view.frame.height/2
                    //                cell.btnSendReceipt.layer.masksToBounds = true
                    //                cell.btnSendReceipt.layer.borderWidth = borderWidth
                    //                cell.btnSendReceipt.layer.borderColor = borderColor.cgColor
                    
                }
                
                cell.setup()
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyTripDescriptionTableViewCell.identifier, for: indexPath) as! MyTripDescriptionTableViewCell
                
                if data[indexPath.row - 1].0 == "Other Charges" {
                    cell.lblTitle.text = data[indexPath.row - 1].0
                    cell.lblTitle.font = .bold(ofSize: cell.lblTitle.font.pointSize)
                    cell.lblDescription.text = ""
                } else {
                    //                let upcoming = data.map{$0.1}.contains("Upcoming")
                    cell.lblTitle.font = .regular(ofSize: cell.lblTitle.font.pointSize)
                    cell.lblTitle.text = data[indexPath.row - 1].0 + ":"
                    //                if data[indexPath.row - 1].0.lowercased().contains("time") || upcoming || data[indexPath.row - 1].0.lowercased().contains("status") {
                    cell.lblDescription.text = "\(data[indexPath.row - 1].1)"
                    //                } else {
                    //                    cell.lblDescription.text = "\(Currency) \(data[indexPath.row - 1].1)"
                    //                }
                }
                
                //            let color = indexPath.row == data.count ? ThemeOrange : UIColor.black
                cell.lblDescription.textColor = .black
                cell.lblTitle.textColor = .black
                cell.setup()
                
                return cell
            }
        } else {
            let NoDataCell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundTblCell.identifier) as! NoDataFoundTblCell
            
            return NoDataCell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedCell == indexPath.section {
            selectedCell = -1
            //            if self.pastBookingHistoryModelDetails.count > indexPath.row {
            self.data = self.tripType.getDescription(pastBookingHistory: self.pastBookingHistoryModelDetails[indexPath.section])
            tableView.removeAllSubviews()
            tableView.reloadData()
            
            if self.data.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        else{
            //            if self.pastBookingHistoryModelDetails.count > indexPath.row {
            self.data = self.tripType.getDescription(pastBookingHistory: self.pastBookingHistoryModelDetails[indexPath.section])
            selectedCell = indexPath.section
            tableView.reloadData()
            if self.data.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: 0, section: selectedCell), at: .top, animated: false)
            }
        }
        if indexPath.section == 9{
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.pastBookingHistoryModelDetails.count > 0 {
            return UITableView.automaticDimension
        }
        return 400.0
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
        if ((collectionTableView.tableView.contentOffset.y + collectionTableView.tableView.frame.size.height) >= collectionTableView.tableView.contentSize.height) {
            if !isDataLoading && !didEndReached {
                isDataLoading = true
                self.LoadMoreData()
//                self.pageNoPastBooking = self.pageNoPastBooking + 1
//                webserviceCallForGettingPastHistory(pageNo: self.pageNoPastBooking)
            }
        }
    }
}