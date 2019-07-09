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

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SetRating), name: NSNotification.Name(rawValue: "rating"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.setProfileData), name: NSNotification.Name(rawValue: "UpdateProfile"), object: nil)
//        self.setProfileData()
        arrMenuTitle = ["My Bookings","Payment Options","Favourites","Invite Friends","Pass","Help","Logout"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func SetRating() {
        if let Rating = ProfileData.object(forKey: "rating") as? String {
            self.lblRating.text = Rating
        } else {
            //            self.lblRating.text = SingletonClass.sharedInstance.passengerRating
        }
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

    /*
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let HomePage = self.parent?.childViewControllers.first?.childViewControllers.first as? HomeViewController

        if arrMenuTitle[indexPath.row] == "New Booking" {

        }
        else if arrMenuTitle[indexPath.row] == "My Bookings"
        {
            //                        NotificationCenter.default.post(name: OpenMyBooking, object: nil)
            let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
            HomePage?.navigationController?.pushViewController(NextPage, animated: true)
        }
        else if arrMenuTitle[indexPath.row] == "Payment Options"
        {

            if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0
            {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                HomePage?.navigationController?.pushViewController(next, animated: true)
            }
            else
            {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
                HomePage?.navigationController?.pushViewController(next, animated: true)
            }

        }
        else if arrMenuTitle[indexPath.row] == "Wallet"
        {
            if (SingletonClass.sharedInstance.isPasscodeON)
            {

                if SingletonClass.sharedInstance.setPasscode == ""
                {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                    viewController.strStatusToNavigate = "Wallet"
                    HomePage?.navigationController?.pushViewController(viewController, animated: true)
                }
                else
                {

                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                    viewController.strStatusToNavigate = "Wallet"
                    HomePage?.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            else
            {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                HomePage?.navigationController?.pushViewController(next, animated: true)
            }
        }
        else if arrMenuTitle[indexPath.row] == "Favourites"
        {


            let next = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
            HomePage?.navigationController?.pushViewController(next, animated: true)
        }
        else if arrMenuTitle[indexPath.row] == "Invite Friends"
        {
            //                        NotificationCenter.default.post(name: OpenInviteFriend, object: nil)
            let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
            HomePage?.navigationController?.pushViewController(NextPage, animated: true)

        }else if arrMenuTitle[indexPath.row] == "Pass"
        {

            //                        NotificationCenter.default.post(name: OpenFavourite, object: nil)
            let PassStoryBoard = UIStoryboard(name: "Pass", bundle: nil)

            let next = PassStoryBoard.instantiateViewController(withIdentifier: "OffersViewController") as! OffersViewController
            HomePage?.navigationController?.pushViewController(next, animated: true)
        }
        else if arrMenuTitle[indexPath.row] == "Help"
        {
            //                        NotificationCenter.default.post(name: OpenHelp, object: nil)

            let HelpStoryBoard = UIStoryboard(name: "Help", bundle: nil)
            let next = HelpStoryBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            HomePage?.navigationController?.pushViewController(next, animated: true)
        }
        else if arrMenuTitle[indexPath.row] == "Settings"
        {
            //                        NotificationCenter.default.post(name: OpenSetting, object: nil)
            let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "SettingPasscodeVC") as! SettingPasscodeVC
            HomePage?.navigationController?.pushViewController(NextPage, animated: true)
        }
        else if arrMenuTitle[indexPath.row] == "Become a \(appName) Driver"
        {

            let myUrl = appURL
            if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }

            // or outside scope use this
            guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        }
        else if (arrMenuTitle[indexPath.row] == "Logout")
        {
            RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to logout?".localized, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Logout".localized, "Cancel".localized], tap: {(alert, buttonIndex) in
                if (buttonIndex == 2)
                {

                    HomePage?.stopTimertoUpdateLocation()
                    (UIApplication.shared.delegate as! AppDelegate).GoToLogout()
                }
            })

        }


        sideMenuController?.hideMenu()
        
    }


    func removeAllSocketFromMemory()
    {
        let socket = (UIApplication.shared.delegate as! AppDelegate).socket
        socket?.off(SocketData.kReceiveGetEstimateFare)
        socket?.off(SocketData.kNearByDriverList)
        socket?.off(SocketData.kAskForTipsToPassengerForBookLater)
        socket?.off(SocketData.kAskForTipsToPassenger)
        socket?.off(SocketData.kAcceptBookingRequestNotification)
        socket?.off(SocketData.kRejectBookingRequestNotification)
        socket?.off(SocketData.kCancelTripByDriverNotficication)
        socket?.off(SocketData.kPickupPassengerNotification)
        socket?.off(SocketData.kBookingCompletedNotification)
        socket?.off(SocketData.kAcceptAdvancedBookingRequestNotification)
        socket?.off(SocketData.kRejectAdvancedBookingRequestNotification)
        socket?.off(SocketData.kAdvancedBookingPickupPassengerNotification)
        socket?.off(SocketData.kReceiveHoldingNotificationToPassenger)
        socket?.off(SocketData.kAdvancedBookingTripHoldNotification)
        socket?.off(SocketData.kReceiveDriverLocationToPassenger)
        socket?.off(SocketData.kAdvancedBookingDetails)
        socket?.off(SocketData.kInformPassengerForAdvancedTrip)
        socket?.off(SocketData.kAcceptAdvancedBookingRequestNotify)
        socket?.off(SocketData.kArrivedDriverBookNowRequest)
        socket?.off(SocketData.kArrivedDriverBookLaterRequest)
        socket?.off(SocketData.kReceiveTollFeeToDriverBookLater)
        socket?.off(SocketData.kReceiveTollFeeToDriver)
        socket?.disconnect()
    }

 */
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
    
    
    @IBAction func btnProfilePickClicked(_ sender: Any)
    {

        let HomePage = self.parent?.childViewControllers.first?.childViewControllers.first as? HomeViewController
        let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        HomePage?.navigationController?.pushViewController(NextPage, animated: true)
        sideMenuController?.hideMenu()

    }
*/
}
