//
//  SideMenuTableViewController.swift
//  Peppea User
//
//  Created by Excellent Webworld on 28/06/19.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    var ProfileData = NSDictionary()
    var arrMenuTitle = [String]()

    
     var selectedIndex = 0
    var loginModelDetails : LoginModel = LoginModel()
    var logoutRequestModel : logoutModel = logoutModel()
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SetRating), name: NSNotification.Name(rawValue: "rating"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.setProfileData), name: NSNotification.Name(rawValue: "UpdateProfile"), object: nil)
//        self.setProfileData()
        
        let storyboardName = self.storyboard?.value(forKey: "name") as? String ?? ""

        if storyboardName == "Rental_Main" {

            arrMenuTitle = ["Profile", "Post a Add", "My Add", "Trip History", "Logout"]
            
        }else{

            arrMenuTitle = ["My Trips", "Payments", "Wallet", "Favourite", "Bulk Mile", "Invite Friends", "Bid My Trip", "Flat Rate","Peppea Business", "Logout"]//["My Bookings","Payment Options","Favourites","Invite Friends","Pass","Help","Logout"]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
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
        setData()
    }
    func setData()
    {
        var profile = loginModelDetails.loginData
        
        lblName.text = profile!.firstName + " " + profile!.lastName
        lblRating.text = profile?.email
        let strImage = imagBaseURL + profile!.profileImage
        self.imgProfile.sd_setImage(with: URL(string: strImage), completed: nil)// .sd_setImage(with: URL(string: strImage), for: .normal, completed: nil)
    }
    @objc func SetRating()
    {
//        if let Rating = ProfileData.object(forKey: "rating") as? String {
//            self.lblRating.text = Rating
//        } else {
//            //            self.lblRating.text = SingletonClass.sharedInstance.passengerRating
//        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.contentMode = .scaleAspectFill
        
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenuTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell") as! ContentTableViewCell
        cellMenu.selectionStyle = .none
        cellMenu.lblTitle.text = arrMenuTitle[indexPath.row]

        return cellMenu
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let HomePage = self.parent?.children.first?.children.first as? HomeViewController
        
        
        let storyboardName = self.storyboard?.value(forKey: "name") as? String ?? ""
        
        if storyboardName == "Rental_Main" {
            
            //MARK: Peppea Rental Flow
            
            if (arrMenuTitle[indexPath.row] == "Profile") {

                //MARK: Profile
                self.gotoProfileVC()

            }
            else if (arrMenuTitle[indexPath.row] == "My Add") {
                
                
                let findCarVC = self.parent?.children.first?.children.first as? FindCarViewController
                let storyborad = UIStoryboard(name: "Rental_Main", bundle: nil)
                let myAddsVC = storyborad.instantiateViewController(withIdentifier: "MyAddsViewController") as! MyAddsViewController
                
                //self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                findCarVC?.navigationController?.pushViewController(myAddsVC, animated: true)
                sideMenuController?.hideMenu()
            }
            else if (arrMenuTitle[indexPath.row] == "Trip History") {
                ///MARK: Trip History
                
                let findCarVC = self.parent?.children.first?.children.first as? FindCarViewController
                let storyborad = UIStoryboard(name: "Rental_Main", bundle: nil)
                let rentalHistoryVC = storyborad.instantiateViewController(withIdentifier: "RentalHistoryViewController") as! RentalHistoryViewController
                
                //        let NextPage =
                
                //self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                findCarVC?.navigationController?.pushViewController(rentalHistoryVC, animated: true)
                sideMenuController?.hideMenu()
            }
            else if (arrMenuTitle[indexPath.row] == "Logout")
            {
                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    //                                    (UIApplication.shared.delegate as! AppDelegate).GoToLogout()
                    self.webserviceForLogout()
                }
                
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                sideMenuController?.hideMenu()
                return
            }
        }else{
            
            ///Peppea flow
            if arrMenuTitle[indexPath.row] == "Peppea Business"
            {
                
                let storyboradTrip = UIStoryboard(name: "LoginRegister", bundle: nil)
                let NextPage = storyboradTrip.instantiateViewController(withIdentifier: "PeppeaBusinessBannerViewController") as! PeppeaBusinessBannerViewController
                HomePage?.navigationController?.pushViewController(NextPage, animated: true)
                sideMenuController?.hideMenu()
                return
            }
            if arrMenuTitle[indexPath.row] == "My Trips"
            {
                
                let storyboradTrip = UIStoryboard(name: "MyTrips", bundle: nil)
                let NextPage = storyboradTrip.instantiateViewController(withIdentifier: "MyTripsViewController") as! MyTripsViewController
                HomePage?.navigationController?.pushViewController(NextPage, animated: true)
                sideMenuController?.hideMenu()
                return
            }
            
            if arrMenuTitle[indexPath.row] == "Payments"
            {
                let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                NextPage.OpenedForPayment = false
                HomePage?.navigationController?.pushViewController(NextPage, animated: true)
                sideMenuController?.hideMenu()
                return
            }
            if arrMenuTitle[indexPath.row] == "Invite Friends"
            {
                let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
                HomePage?.navigationController?.pushViewController(NextPage, animated: true)
                sideMenuController?.hideMenu()
                return
            }
            
            if arrMenuTitle[indexPath.row] == "Wallet"
            {
                let storyboradWallet = UIStoryboard(name: "Wallet", bundle: nil)
                let NextPage = storyboradWallet.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                HomePage?.navigationController?.pushViewController(NextPage, animated: true)
                sideMenuController?.hideMenu()
                return
            }
            
            if arrMenuTitle[indexPath.row] == "Flat Rate"
            {
                let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "FlatRateListViewController") as! FlatRateListViewController
                NextPage.Delegate = HomePage
                HomePage?.navigationController?.pushViewController(NextPage, animated: true)
                sideMenuController?.hideMenu()
                return
            }
            if arrMenuTitle[indexPath.row] == "Bid My Trip"
            {
                let storyboradBid = UIStoryboard(name: "Bid", bundle: nil)
                let NextPage = storyboradBid.instantiateViewController(withIdentifier: "BidListContainerViewController") as! BidListContainerViewController
                HomePage?.navigationController?.pushViewController(NextPage, animated: true)
                sideMenuController?.hideMenu()
                return
                
                
            }
            if arrMenuTitle[indexPath.row] == "Favourite"
            {
                let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteAddressViewController") as! FavouriteAddressViewController
                HomePage?.navigationController?.pushViewController(NextPage, animated: true)
                sideMenuController?.hideMenu()
                return
            }
            
            if arrMenuTitle[indexPath.row] == "Bulk Mile"
            {
                let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "BulkMileVC") as! BulkMileVC
                HomePage?.navigationController?.pushViewController(NextPage, animated: true)
                sideMenuController?.hideMenu()
                return
            }
            
            if (arrMenuTitle[indexPath.row] == "Logout")
            {
                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    //                                    (UIApplication.shared.delegate as! AppDelegate).GoToLogout()
                    self.webserviceForLogout()
                }
                
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                sideMenuController?.hideMenu()
                return
            }

            
            
        }
        
        
        
    }

    func webserviceForLogout()
    {
        
        let profile = loginModelDetails.loginData
        logoutRequestModel.customer_id = (profile?.id)!
        logoutRequestModel.device_token = ""
        if let token = UserDefaults.standard.object(forKey: "Token") as? String
        {
            logoutRequestModel.device_token = token
        }

        
        
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        let strURL = logoutRequestModel.customer_id + "/" + logoutRequestModel.device_token
        UserWebserviceSubclass.Logout(strURL: strURL) { (json, status) in
            UtilityClass.hideHUD()
            
            if status{
                
                UserDefaults.standard.set(false, forKey: "isUserLogin")
                self.removeAllSocketFromMemory()
                (UIApplication.shared.delegate as! AppDelegate).GoToLogout()
            }
            else
            {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
    func removeAllSocketFromMemory()
    {
//        self.parent?.children.first?.children.first as! HomeViewController
        if let homeVC = self.parent?.children.first?.children.first as? HomeViewController {
            homeVC.allSocketOffMethods()
        }
        
//        let socket = (UIApplication.shared.delegate as! AppDelegate).socket
////        socket?.off(SocketData.kReceiveGetEstimateFare)
////        socket?.off(SocketData.kNearByDriverList)
////        socket?.off(SocketData.kAskForTipsToPassengerForBookLater)
////        socket?.off(SocketData.kAskForTipsToPassenger)
////        socket?.off(SocketData.kAcceptBookingRequestNotification)
////        socket?.off(SocketData.kRejectBookingRequestNotification)
////        socket?.off(SocketData.kCancelTripByDriverNotficication)
////        socket?.off(SocketData.kPickupPassengerNotification)
////        socket?.off(SocketData.kBookingCompletedNotification)
////        socket?.off(SocketData.kAcceptAdvancedBookingRequestNotification)
////        socket?.off(SocketData.kRejectAdvancedBookingRequestNotification)
////        socket?.off(SocketData.kAdvancedBookingPickupPassengerNotification)
////        socket?.off(SocketData.kReceiveHoldingNotificationToPassenger)
////        socket?.off(SocketData.kAdvancedBookingTripHoldNotification)
////        socket?.off(SocketData.kReceiveDriverLocationToPassenger)
////        socket?.off(SocketData.kAdvancedBookingDetails)
////        socket?.off(SocketData.kInformPassengerForAdvancedTrip)
////        socket?.off(SocketData.kAcceptAdvancedBookingRequestNotify)
////        socket?.off(SocketData.kArrivedDriverBookNowRequest)
////        socket?.off(SocketData.kArrivedDriverBookLaterRequest)
////        socket?.off(SocketData.kReceiveTollFeeToDriverBookLater)
////        socket?.off(SocketData.kReceiveTollFeeToDriver)
//        socket?.disconnect()
    }

 
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45
    }
    

    /*
     @objc func setProfileData() {
        ProfileData = SingletonClass.sharedInstance.dictProfile
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.sd_setShowActivityIndicatorView(true)
        self.imgProfile.sd_setIndicatorStyle(.white)
        self.imgProfile.sd_setImage(with: URL(string: ProfileData.object(forKey: "Image") as! String), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
        //        self.imgProfile.sd_setImage(with: URL(string: ProfileData.object(forKey: "Image") as! String), completed: nil)
        self.lblName.text = ProfileData.object(forKey: "Fullname") as? String
        
        if let Rating = ProfileData.object(forKey: "rating") as? String {
            self.lblRating.text = Rating
        } else {
            self.lblRating.text = SingletonClass.sharedInstance.passengerRating
        }
    }
    
  */
    @IBAction func btnProfilePickClicked(_ sender: Any)
    {

        self.gotoProfileVC()

    }
    
    
    func gotoProfileVC() {
        
        let findCarVC = self.parent?.children.first?.children.first as? FindCarViewController
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        //        let NextPage =
        
        //self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        findCarVC?.navigationController?.pushViewController(profileVC, animated: true)
        sideMenuController?.hideMenu()
    }

}
