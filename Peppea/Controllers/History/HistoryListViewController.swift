//
//  HistoryListViewController.swift
//  Peppea
//
//  Created by eww090 on 10/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class HistoryListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{

    
     @IBOutlet weak var tableView: UITableView!
//     var arrHistoryData = [String]()
    var loginModelDetails : LoginModel = LoginModel()
    var walletHistoryRequest : WalletHistory = WalletHistory()
    
    var pageNo: Int = 1
    private let refreshControl = UIRefreshControl()
  
    var arrHistoryData = [walletHistoryListData]()
    {
        didSet
        {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.webserviceCallForHistoryList()
        let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "iconFilter"), style: .plain, target: self, action: #selector(self.btnFilterClicked(_:)))
        
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        self.setNavBarWithBack(Title: "History", IsNeedRightButton: false)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }

    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        webserviceCallForHistoryList()
    }

    
    @IBAction func btnFilterClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryFilterPopUpViewController") as! HistoryFilterPopUpViewController
        self.navigationController?.present(viewController, animated: true, completion: nil)
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
        cellMenu.lblPaymentType.text = dictData.transactionType
        
        return cellMenu
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
    func webserviceCallForHistoryList()
    {
        
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        
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
        walletHistoryRequest.page = "\(pageNo)"
        UtilityClass.showHUD(with: self.view)
        
        UserWebserviceSubclass.walletHistoryList(WalletHistoryModel: walletHistoryRequest) { (json, status) in
            UtilityClass.hideHUD()
            
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

}
