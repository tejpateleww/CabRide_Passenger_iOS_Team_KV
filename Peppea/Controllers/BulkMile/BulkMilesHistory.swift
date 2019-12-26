//
//  BulkMilesHistory.swift
//  Peppea
//
//  Created by EWW082 on 16/08/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class BulkMilesHistory: BaseViewController {

    
    //MARK:- Outlets
    
    @IBOutlet var tblBulkMileHistory: UITableView!
    
    @IBOutlet var lblPurchasePlan: UILabel!
    @IBOutlet var lblAvailableBalance: UILabel!
    var PurchasePlan:String = "0.00"
    
    //MARK:- Variables
    private let refreshControl = UIRefreshControl()
    var arrBulkMileHistory:[BulkMileData] = []
    var NeedToReload:Bool = false
    var PageLimit = 10
    var PageNumber = 1
    var selectedCell = -1
//        [Int]()
    var data = [(String, String)]()
    var isRefresh = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblAvailableBalance.text = "\(SingletonClass.sharedInstance.BulkMilesBalance) \(MeasurementSign)"
        self.lblPurchasePlan.text = "\(String(format: "%.2f",  Double(self.PurchasePlan)!) ) \(MeasurementSign)"
        self.RegisterNibs()
        self.setNavBarWithBack(Title: "Bulk Mile History", IsNeedRightButton: true)
        self.LoadNewData()
        // Do any additional setup after loading the view.
        
        // Add Refresh Control to Table View
            if #available(iOS 10.0, *) {
               self.tblBulkMileHistory.refreshControl = refreshControl
            } else {
               self.tblBulkMileHistory.addSubview(refreshControl)
            }
        
        refreshControl.addTarget(self, action: #selector(self.refreshHistoryData(_:)), for: .valueChanged)
        refreshControl.tintColor = ThemeColor // UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
        }
    

    @objc private func refreshHistoryData(_ sender: Any) {
        self.LoadNewData()
        // Fetch Weather Data
        isRefresh = true
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func LoadMoreData() {
        self.PageNumber += 1
        self.webserviceForBulkMilesBooking(pageNo: self.PageNumber)
    }
    
    func LoadNewData() {
        self.PageNumber = 1
        self.arrBulkMileHistory.removeAll()
        self.tblBulkMileHistory.reloadData()
        self.webserviceForBulkMilesBooking(pageNo: self.PageNumber)
    }

    
}


//MARK:- Custom Methods

extension BulkMilesHistory {
    
    func RegisterNibs() {
        let arrNibs = [MyTripTableViewCell.identifier,
                       MyTripDescriptionTableViewCell.identifier,
                       FooterTableViewCell.identifier]
        for nib in arrNibs {
            self.tblBulkMileHistory.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        }
    }
    
    func webserviceForBulkMilesBooking(pageNo: Int) {
        
        let param = SingletonClass.sharedInstance.loginData.id + "/" + "\(pageNo)"
        UserWebserviceSubclass.BulkMilesBookingHistory(strURL: param) { (response, status) in
            print(response)
            UtilityClass.hideHUD()
            
            if(status) {
                var arrResponseData = [BulkMileData]()
                
                if let arrayResponse = response.dictionary?["data"]?.array {
                    arrResponseData = arrayResponse.map({ (item) -> BulkMileData in
                        return BulkMileData.init(fromJson: item)
                    })
                }
                
                if arrResponseData.count == self.PageLimit {
                    self.NeedToReload = true
                } else {
                    self.NeedToReload = false
                }
                
                if self.PageNumber == 1 {
                    self.arrBulkMileHistory = arrResponseData
                } else {
                    for BookingObj in arrResponseData {
                        self.arrBulkMileHistory.append(BookingObj)
                    }
                }
                
                //                self.pastBookingHistoryModelDetails = self.pastBookingHistoryModelDetails.filter({$0.driverId != "0"})
                self.tblBulkMileHistory.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    func setBulkMileHistoryData(BulkMileBookingHistory : BulkMileData) -> [(String, String)]{
        
        if BulkMileBookingHistory.status == "canceled" {
            let tempArray = [("Status" , BulkMileBookingHistory.status)]  as! [(String,String)]
            return tempArray
        } else {
            var tempArray = [("Pick Up Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: BulkMileBookingHistory.pickupTime, dateFormat: "dd-MM-YYYY HH:mm:ss") ),
                             ("Drop Off Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: BulkMileBookingHistory.dropoffTime, dateFormat: "dd-MM-YYYY HH:mm:ss")),
                             ("Booking Fee" , BulkMileBookingHistory.bookingFee),
                             ("Base Fare" , BulkMileBookingHistory.baseFare),
                             //                ("Time Cost :" , BulkMileBookingHistory.id),
                ("Subtotal" , BulkMileBookingHistory.subTotal),
                //                ("Other Charges" , BulkMileBookingHistory.subTotal),
                //                ("Cancellation Charges" , BulkMileBookingHistory.cancellationCharge),
                //                ("Promocode" , BulkMileBookingHistory.promocode),
                ("Total Paid To Driver" , BulkMileBookingHistory.grandTotal)
                
                ] as! [(String,String)]
            
            if(BulkMileBookingHistory.promocode.count != 0)
            {
                tempArray.insert( ("Promocode" , BulkMileBookingHistory.promocode), at: tempArray.count-1)
            }
            
            return tempArray
        }
        
    }

    
}


//MARK:- Tableview methods

extension BulkMilesHistory: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrBulkMileHistory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedCell == section {
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
            let dataResponseHeader = self.arrBulkMileHistory[indexPath.section]
            cell.lblName.text = "\(dataResponseHeader.driverFirstName ?? "") \(dataResponseHeader.driverLastName ?? "")"
            cell.lblBookin.text = "Booking Id : \(dataResponseHeader.id ?? "")"
            cell.lblPickup.text = dataResponseHeader.pickupLocation
            cell.lblDropoff.text = dataResponseHeader.dropoffLocation
            cell.btnSendReceipt.isHidden = true
            cell.lblKM.isHidden = false
            cell.lblKM.text =  " \(dataResponseHeader.distance ?? "") \(MeasurementSign)"
//            if self.tripType.rawValue.lowercased() != "past" {
            UtilityClass.viewCornerRadius(view: cell.btnSendReceipt, borderWidth: 1, borderColor: .white)
                
                //                cell.btnSendReceipt.layer.cornerRadius = view.frame.height/2
                //                cell.btnSendReceipt.layer.masksToBounds = true
                //                cell.btnSendReceipt.layer.borderWidth = borderWidth
                //                cell.btnSendReceipt.layer.borderColor = borderColor.cgColor
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
        if selectedCell == indexPath.section{
//            let index = selectedCell.firstIndex(of: indexPath.section)
//            selectedCell.remove(at: index!)
//            if self.arrBulkMileHistory.count > indexPath.row {
                self.selectedCell = -1
                self.data = self.setBulkMileHistoryData(BulkMileBookingHistory: self.arrBulkMileHistory[indexPath.section])
//                tableView.removeAllSubviews()
                tableView.reloadData()
//            }
            //            self.data = self.tripType.getDescription(BulkMileBookingHistory: self.BulkMileBookingHistoryModelDetails[indexPath.row])
            //            tableView.removeAllSubviews()
            //            tableView.reloadData()
        }
        else{
            if self.arrBulkMileHistory.count > indexPath.row {
                self.data =  self.setBulkMileHistoryData(BulkMileBookingHistory: self.arrBulkMileHistory[indexPath.section])
                selectedCell = indexPath.section
                tableView.reloadData()
//                let rect =  tableView.rect(forSection: indexPath.section)
//                let imageView = UIImageView(frame: CGRect(x: 10, y: rect.minY, width: rect.width - 20, height: rect.height))
//                            imageView.image = #imageLiteral(resourceName: "iconBirdSmallBar")
//
//                imageView.alpha = 0.8
//                imageView.contentMode = .scaleAspectFit
//                tableView.removeAllSubviews()
//                tableView.addSubview(imageView)
            }
        }
        if indexPath.section == 9{
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
//        isDataLoading = false
    }
    
    //Pagination
    /*
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        print("scrollViewDidEndDragging")
        if ((collectionTableView.tableView.contentOffset.y + collectionTableView.tableView.frame.size.height) >= collectionTableView.tableView.contentSize.height) {
            //            if !isDataLoading{
            //                isDataLoading = true
            //                self.pageNo = self.pageNo + 1
            //                webserviceOfPastbookingpagination(index: self.pageNo)
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        print("indexPath.section: ", indexPath.section )
        print("indexPath.row: ", indexPath.row )
        print("self.BulkMileBookingHistoryModelDetails.count: ", self.BulkMileBookingHistoryModelDetails.count)
        
        
        
        //        if indexPath.section == (self.BulkMileBookingHistoryModelDetails.count - 1) {
        //            if !isDataLoading{
        //                isDataLoading = true
        //                 self.isRefresh = true
        ////                webserviceCallForHistoryList(index: self.pageNo)
        //                if self.tripType.rawValue.lowercased() == "past" {
        //                    self.pageNoPastBooking = self.pageNoPastBooking + 1
        //                    webserviceCallForGettingPastHistory(pageNo: self.pageNoPastBooking)
        //                } else {
        //                    self.pageNoPastUpcoming = self.pageNoPastUpcoming + 1
        //                    webserviceForUpcommingBooking(pageNo: self.pageNoPastUpcoming)
        //                }
        //            }
        //        }
    }
    
    */
    
    
}
