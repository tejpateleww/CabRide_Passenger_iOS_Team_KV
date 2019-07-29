//
//  HistoryListViewController.swift
//  Peppea
//
//  Created by eww090 on 10/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class HistoryListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, delegateFilterWalletHistory
{

    
     @IBOutlet weak var tableView: UITableView!
//     var arrHistoryData = [String]()
    var loginModelDetails : LoginModel = LoginModel()
    var walletHistoryRequest : WalletHistory = WalletHistory()
    var pageNo: Int = 0
    private let refreshControl = UIRefreshControl()
    var isRefresh = Bool()

    var arrHistoryData = [walletHistoryListData]()
    {
        didSet
        {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        }
        catch
        {
            AlertMessage.showMessageForError("error")
            return
        }
        let profile = loginModelDetails.loginData
        
        walletHistoryRequest.customer_id = profile!.id
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = ThemeColor // UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        self.webserviceCallForHistoryList(index: 1)
        let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "iconFilter"), style: .plain, target: self, action: #selector(self.btnFilterClicked(_:)))
        
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        self.setNavBarWithBack(Title: "History", IsNeedRightButton: false)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }

    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        isRefresh = true
        webserviceCallForHistoryList(index: 1)
    }

    
    @IBAction func btnFilterClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryFilterPopUpViewController") as! HistoryFilterPopUpViewController
        viewController.delegateWalletHistory = self
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    func delegateforFilteringWalletHistory(_ filterParam : [String : AnyObject])
    {
        if let tempPayment = filterParam["from_date"] as? String
        {
            walletHistoryRequest.from_date = filterParam["from_date"] as! String
        }
        if let tempPayment = filterParam["to_date"] as? String
        {
            walletHistoryRequest.to_date = filterParam["to_date"] as! String
        }
        if let tempPayment = filterParam["payment_type"] as? String
        {
            walletHistoryRequest.payment_type = filterParam["payment_type"] as! String
        }
        
        if let tempPayment = filterParam["transaction_type"] as? String
        {
            walletHistoryRequest.transaction_type = filterParam["transaction_type"] as! String
        }
        
     
        self.webserviceCallForHistoryList(index: 1)
        
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrHistoryData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
        cellMenu.selectionStyle = .none
        let dictData = self.arrHistoryData[indexPath.row]

        
        cellMenu.lblBookingID.text = "Booking Id #" + dictData.id
        cellMenu.lblAmount.text = Currency + " " + dictData.amount
        cellMenu.lblDateTime.text = dictData.createdAt
        cellMenu.lblPaymentType.text = dictData.paymentType
        
        return cellMenu
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
    func webserviceCallForHistoryList(index: Int)
    {
        
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        
      
        walletHistoryRequest.page = "\(pageNo)"

        if(!isRefresh)
        {
            UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        }
        
        UserWebserviceSubclass.walletHistoryList(WalletHistoryModel: walletHistoryRequest) { (json, status) in
            UtilityClass.hideHUD()
            self.isRefresh = false
            if status{
                
                UserDefaults.standard.set(true, forKey: "isUserLogin")
                
                let WalletHistoryListDetails = WalletHistoryListModel.init(fromJson: json)
//                do
//                {
                   self.arrHistoryData = WalletHistoryListDetails.walletHistorydata
//                }
//                catch
//                {
                    UtilityClass.hideHUD()
//                }
                self.tableView.reloadData()
                
                self.refreshControl.endRefreshing()
            }
            else{
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }

    }
    
    var isDataLoading:Bool=false
    var didEndReached:Bool=false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            //            if !isDataLoading{
            //                isDataLoading = true
            //                self.pageNo = self.pageNo + 1
            //                webserviceOfPastbookingpagination(index: self.pageNo)
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.arrHistoryData.count - 5) {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo = self.pageNo + 1
                webserviceCallForHistoryList(index: self.pageNo)
            }
        }
    }

}
