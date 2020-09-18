//
//  CarCollectionViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 01/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyAttributes

//@objc protocol didSelectBooking {
//
//    @objc optional func didSelectBookNow()
//
//}


class CarCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,didSelectDateDelegate, didSelectPaymentDelegate {
   
    

    // ----------------------------------------------------
    // MARK:- --- Outlets ---
    // ----------------------------------------------------

    @IBOutlet weak var iconSelectedCard: UIImageView!
    @IBOutlet weak var btnBookNow: ThemeButton!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var btnSelectCard: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtSelectPaymentMethod: UITextField!
    
    @IBOutlet weak var viewPromocode: UIView!
    
    
    
    // ----------------------------------------------------
    // MARK: - --- Globle Declaration Methods ---
    // ----------------------------------------------------
    
    var arrCarLists : VehicleListModel = VehicleListModel()
    //: [[String:Any]]!
    var aryCards = [CardsList]()
    var LoginDetail : LoginModel = LoginModel()
    var cardDetailModel : AddCardModel = AddCardModel()

    var FlatRate = String()
    var FlatRateId = String()
    var paymentType = String()
    var RentType = String()
    var CardID = String()
    var Distance = String()
    var vehicleId = ""
    var estimateFare = ""
    var selectedTimeStemp = ""
    var strPromoCode = ""
    var isTripSchedule = false
    var selectedIndex : IndexPath!
    // ----------------------------------------------------
    // MARK:- --- Base Methods ---
    // ----------------------------------------------------
    //    weak var delegateOfbookingSelection : didSelectBooking!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconSelectedCard.image = UIImage(named: "iconCash")

        getDataFromJSON()
        
        do {
            guard let userData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile") else {
                return
            }
            LoginDetail = userData
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
        
//        if UserDefaults.standard.object(forKey: "cards") != nil {
//            //
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                do {
//
//                    guard let cardData = try UserDefaults.standard.get(objectType: AddCardModel.self, forKey: "cards") else {
//                        return
//                    }
//
//                    self.cardDetailModel = cardData
//                    self.aryCards = self.cardDetailModel.cards
//
//                    if(self.aryCards.count != 0)
//                    {
//                        let data = self.aryCards[0]
//                        self.CardID = data.id
//                        self.paymentType = "card"
//                    }
//
//                } catch {
//                    AlertMessage.showMessageForError("error")
//                    return
//                }
//            }
//        }
        
//        UserDefaults.standard.set(PaymentType, forKey: "PaymentType")
//        UserDefaults.standard.set(dictData, forKey: "PaymentTypeData")
        
        if UserDefaults.standard.object(forKey: "PaymentType") != nil {
            if let type = UserDefaults.standard.object(forKey: "PaymentType") as? String {
                self.paymentType = type
                
                if let PaymentObject = UserDefaults.standard.object(forKey: "PaymentTypeData") as? [String:Any] {
                    didSelectPaymentType(PaymentTypeTitle: PaymentObject["CardNum"] as! String, PaymentType:  PaymentObject["CardNum2"] as! String, PaymentTypeID: "", PaymentNumber: "", PaymentHolderName: "", dictData: PaymentObject)
                }
            }
        }
        else {
//            self.paymentType = payment_type.cash.rawValue
            didSelectPaymentType(PaymentTypeTitle: "Select Payment Method", PaymentType: "", PaymentTypeID: "", PaymentNumber: "", PaymentHolderName: "", dictData: nil)
        }
        
        btnBookNow.setTitle("Not Available", for: .normal)
    }

    func getDataFromJSON()
    {

        if(UserDefaults.standard.object(forKey: "carList") == nil)
        {
            return
        }
        
        do {
            let vehiclelist = try UserDefaults.standard.get(objectType: VehicleListModel.self, forKey: "carList")!
            self.arrCarLists = vehiclelist
            checkAvailabilityOfCar()
            self.collectionView.reloadData()
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
    }

    func checkAvailabilityOfCar()
    {
        if(selectedIndex != nil)
        {
            if (self.arrCarLists.vehicleTypeList.count != 0 && selectedIndex.row < self.arrCarLists.vehicleTypeList.count)
            {
                let dictOnlineCars = arrCarLists.vehicleTypeList[selectedIndex.row]
                vehicleId = dictOnlineCars.id


                if let homeVc = self.parent as? HomeViewController {
                    if homeVc.estimateData.count != 0 {
                        let estimateCurrentData = homeVc.estimateData.filter{$0.vehicleTypeId == dictOnlineCars.id}.first

                        let estimateMinute = estimateCurrentData?.driverReachInMinute
                        let estimateFare = estimateCurrentData?.estimateTripFare

                        if dictOnlineCars.id == vehicleId {
                            self.estimateFare = (FlatRate == "") ? ( ((estimateFare?.contains(".") == true) ? estimateFare  : "\((Double((estimateMinute == "0" ? "0.0" : estimateFare)!)?.rounded(toPlaces: 2)) ?? 0.0)")!  ) : "\((Double((estimateMinute == "0" ? "0.0" : FlatRate))?.rounded(toPlaces: 2)) ?? 0.0)"
                        } else {
                            self.estimateFare = "0"
                        }
                    }
                }

                if !isTripSchedule {
                    if Float(self.estimateFare) != 0 {
                        btnBookNow.isVehicleAvailable = true
                    } else {
                        btnBookNow.isVehicleAvailable = false
                    }
                }

            }
        }
    }
    
    // Handle Booklater date and time
    func didSelectDateAndTime(date: String, timeStemp: String) 
    {

        self.btnBookNow.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnBookNow.titleLabel?.textAlignment = .center

        selectedTimeStemp = timeStemp
        
        
        let strSimpleStringDate = "\(date)".withTextColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        self.btnBookNow.backgroundColor = ThemeColor
        
        let attriString = "Schedule Premier\n".withFont(UIFont.bold(ofSize: 18)).withTextColor(.white) + strSimpleStringDate
        
        self.btnBookNow.setAttributedTitle(attriString, for: .normal)
//        self.btnBookNow.setTitle("Schedule Premier\n\(date)", for: .normal)
        self.btnBookNow.titleLabel?.font = UIFont.regular(ofSize: 15)
        let homeVC = self.parent as? HomeViewController
        homeVC?.setBackButtonWhileBookLater()
        homeVC?.selectedTimeStemp = timeStemp
        isTripSchedule = true
    }
    //MARK:-  --- CollectionView Delegate and Datasource Methods ---
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCarLists.vehicleTypeList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarsCollectionViewCell", for: indexPath as IndexPath) as! CarsCollectionViewCell
        if (self.arrCarLists.vehicleTypeList.count != 0 && indexPath.row < self.arrCarLists.vehicleTypeList.count)
        {
            let dictOnlineCars = arrCarLists.vehicleTypeList[indexPath.row]

            if dictOnlineCars.unselectImage != nil
            {
                cell.imgOfCarModels.sd_setImage(with: URL(string: NetworkEnvironment.baseImageURL + ((dictOnlineCars.id == vehicleId) ? dictOnlineCars.image :  dictOnlineCars.unselectImage)), completed: nil)
                cell.lblModelName.textColor = (dictOnlineCars.id == vehicleId) ? ThemeOrange : ThemeColor
            }
            
            if let strModelName = dictOnlineCars.name // ["Name"] as? String
            {
                cell.lblModelName.text = strModelName.uppercased()
            }
            
            if let homeVc = self.parent as? HomeViewController {
                if homeVc.estimateData.count != 0 {
                    let estimateCurrentData = homeVc.estimateData.filter{$0.vehicleTypeId == dictOnlineCars.id}.first
                    
                    let estimateMinute = estimateCurrentData?.driverReachInMinute
                    let estimateFare = estimateCurrentData?.estimateTripFare
                    
//                    if dictOnlineCars.id == vehicleId {
//                        self.estimateFare = (FlatRate == "") ? ( ((estimateFare?.contains(".") == true) ? estimateFare  : "\((Double((estimateMinute == "0" ? "0.0" : estimateFare)!)?.rounded(toPlaces: 2)) ?? 0.0)")!  ) : "\((Double((estimateMinute == "0" ? "0.0" : FlatRate))?.rounded(toPlaces: 2)) ?? 0.0)"
//                    }
                    self.estimateFare = (FlatRate == "") ? ( ((estimateFare?.contains(".") == true) ? estimateFare  : "\((Double(estimateFare ?? "0.00")?.rounded(toPlaces: 2)) ?? 0.0)")!  ) : "\((Double(FlatRate)?.rounded(toPlaces: 2)) ?? 0.0)"
//                    cell.lblPrice.text =  (FlatRate == "") ? ( ((estimateFare?.contains(".") == true) ? "\(Currency) \(estimateFare!)"  : "\(Currency) \((Double((estimateMinute == "0" ? "0.0" : estimateFare)!)?.rounded(toPlaces: 2)) ?? 0.0)")  ) : "\((Double((estimateMinute == "0" ? "0.0" : FlatRate))?.rounded(toPlaces: 2)) ?? 0.0)"
                    cell.lblPrice.text =  (FlatRate == "") ? ( ((estimateFare?.contains(".") == true) ? "\(Currency) \(estimateFare!)"  : "\(Currency) \((Double(estimateFare ?? "0.00")?.rounded(toPlaces: 2)) ?? 0.0)")  ) : "\((Double(FlatRate)?.rounded(toPlaces: 2)) ?? 0.0)"


                    cell.lblArrivalTime.text = "ETA \(estimateMinute == "0" ? "0" : estimateMinute ?? "0") min"
                } else {
                     cell.lblPrice.text =  "\(Currency) 0"
                    cell.lblArrivalTime.text = "ETA 0 min"
                }
            }

            cell.lblModelName.font = UIFont.bold(ofSize: 14.0)
            cell.lblPrice.font = UIFont.regular(ofSize: 14.0)
            cell.lblArrivalTime.font = UIFont.regular(ofSize: 14.0)
            
            cell.lblPrice.textColor = ThemeColor
            cell.lblArrivalTime.textColor = ThemeColor
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedIndex = indexPath
        checkAvailabilityOfCar()
         self.collectionView.reloadData()
        //TODO: - comment
        //Moved the below code in checkAvailabilityOfCar() function by Rahul

//        if (self.arrCarLists.vehicleTypeList.count != 0 && indexPath.row < self.arrCarLists.vehicleTypeList.count)
//        {
//            let dictOnlineCars = arrCarLists.vehicleTypeList[indexPath.row]
//            vehicleId = dictOnlineCars.id
//
//
//            if let homeVc = self.parent as? HomeViewController {
//                if homeVc.estimateData.count != 0 {
//                    let estimateCurrentData = homeVc.estimateData.filter{$0.vehicleTypeId == dictOnlineCars.id}.first
//
//                    let estimateMinute = estimateCurrentData?.driverReachInMinute
//                    let estimateFare = estimateCurrentData?.estimateTripFare
//
//                    if dictOnlineCars.id == vehicleId {
//                        self.estimateFare = (FlatRate == "") ? ( ((estimateFare?.contains(".") == true) ? estimateFare  : "\((Double((estimateMinute == "0" ? "0.0" : estimateFare)!)?.rounded(toPlaces: 2)) ?? 0.0)")!  ) : "\((Double((estimateMinute == "0" ? "0.0" : FlatRate))?.rounded(toPlaces: 2)) ?? 0.0)"
//                    } else {
//                        self.estimateFare = "0"
//                    }
//                }
//            }
//
//            if !isTripSchedule {
//                if Float(self.estimateFare) != 0 {
//                    btnBookNow.isVehicleAvailable = true
//                } else {
//                    btnBookNow.isVehicleAvailable = false
//                }
//            }
//
//            self.collectionView.reloadData()
//        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if (self.arrCarLists.vehicleTypeList.count != 0 && indexPath.row < self.arrCarLists.vehicleTypeList.count)
        {
            let dictOnlineCars = arrCarLists.vehicleTypeList[indexPath.row]
            if let cell = self.collectionView.cellForItem(at: indexPath)  as? CarsCollectionViewCell
            {
                if let imageURL = dictOnlineCars.unselectImage //["Image"] as? String
                {
                    cell.imgOfCarModels.sd_setImage(with: URL(string: NetworkEnvironment.baseImageURL + imageURL), completed: nil) //.image = UIImage.init(named: imageURL)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let numberOfCars = ( self.arrCarLists.vehicleTypeList.count > 3) ? 4 : 3
        let CellWidth = ( UIScreen.main.bounds.width - 10 ) / CGFloat(numberOfCars)
        return CGSize(width: CellWidth , height: self.collectionView.frame.size.height)
        //        return CGSize(width: 50, height: 50)
    }


    func animateGoogleMapWhenRotate(homeVC : HomeViewController?)
    {
        //        UtilityClass.showHUDWithoutLottie(with: UIApplication.shared.keyWindow)
        CATransaction.begin()
        CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock({
            CATransaction.begin()
            CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock({
                CATransaction.begin()
                CATransaction.setValue(4, forKey: kCATransactionAnimationDuration)
                CATransaction.setCompletionBlock({
                    // For Stop Animation on map
                    let pickup = homeVC?.pickupLocation

                    let cameraPosition = GMSCameraPosition.camera(withLatitude: pickup?.latitude ?? 0.0, longitude: pickup?.longitude ?? 0.0, zoom: zoomLevel)
                    homeVC?.mapView.animate(to: cameraPosition)

                    homeVC?.mapView.animate(toViewingAngle: 0)
                    homeVC?.mapView.animate(toZoom: zoomLevel)

//                    UtilityClass.showHUD(with: homeVC?.view)
                    UtilityClass.hideHUD()
                })
                homeVC?.mapView.animate(toBearing: CLLocationDirection(((homeVC?.getHeadingForDirection(fromCoordinate: (homeVC?.pickupLocation)!, toCoordinate: (homeVC?.pickupLocation)!))! - 30) ))
                homeVC?.view.layoutIfNeeded()
                CATransaction.commit()
            })
//            homeVC?.mapView.animate(toZoom: 13)
//            homeVC?.view.layoutIfNeeded()
//            CATransaction.commit()

                    homeVC?.mapView.animate(toViewingAngle: 45)
                    homeVC?.view.layoutIfNeeded()
              CATransaction.commit()
        })
        let pickup = homeVC?.pickupLocation
        let cameraPosition = GMSCameraPosition.camera(withLatitude: pickup?.latitude ?? 0.0, longitude: pickup?.longitude ?? 0.0, zoom: zoomLevel)
        homeVC?.mapView.animate(to: cameraPosition)
//        homeVC?.mapView.animate(toViewingAngle: 45)
//        homeVC?.view.layoutIfNeeded()
        CATransaction.commit()
    }
    
    // ----------------------------------------------------
    // MARK:- --- Actions ---
    // ----------------------------------------------------
    
    @IBAction func btnPromoCodeAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: AppName.kAPPName, message: "Enter promo code", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter promo code"
        }
        let saveAction = UIAlertAction(title: "Apply", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("firstName \(firstTextField.text ?? "")")
            
            if !firstTextField.text!.isBlank {
                self.webserviceForCheckPromocodeService(promoCode: firstTextField.text ?? "")
            }

        })
        saveAction.isEnabled = false
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alertController.textFields?[0],
                                               queue: OperationQueue.main) { (notification) -> Void in

                                                let textFieldName = alertController.textFields?[0] //as! UITextField
                                                saveAction.isEnabled = (textFieldName?.text?.isBlank)! == true ? false : true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnSelectPayment(_ sender: Any) {
        
        let PaymentPage = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        PaymentPage.Delegate = self
        PaymentPage.isFlatRateSelected  = (self.FlatRate != "")
        PaymentPage.OpenedForPayment = true
        let NavController = UINavigationController(rootViewController: PaymentPage)
        self.navigationController?.present(NavController, animated: true, completion: nil)
    }
    
    @IBAction func btnBookNow(_ sender: UIButton) {
        
        let homeVC = self.parent as? HomeViewController

        if(self.validations().0)
        {
            
            if btnBookNow.titleLabel?.text == "Not Available" {
                return
            }
            
            homeVC?.isExpandCategory = false
            homeVC?.setUpCustomMarker()
//            homeVC?.timer?.invalidate()
            
            
            // Bhavesh Comment these 2 lines at 27-Jan-2020
//            UtilityClass.showHUDWithoutLottie(with: UIApplication.shared.keyWindow)
//            animateGoogleMapWhenRotate(homeVC: homeVC)
            
            if sender.titleLabel?.text?.lowercased().contains("schedule".lowercased()) ?? false {
                webserviceForBooking(bookingType: "book_later") // "book_now" // "book_later"
            } else {
                if(btnBookNow.isVehicleAvailable)
                {
                    webserviceForBooking(bookingType: "book_now") // "book_now" // "book_later"
                }
                else
                {
                    print("\n\n\n NOT AVAILABLE \n\n\n")
                }
            }
        }
        else {
            UtilityClass.hideHUD()
            AlertMessage.showMessageForError(self.validations().1)
        }
    }
    
    @IBAction func btnBookLater(_ sender: Any) {
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "PeppeaBookLaterViewController") as! PeppeaBookLaterViewController
//        next.delegateOfSelectDateAndTime = self
//        self.navigationController?.present(next, animated: true, completion: nil)
    }

    
    
    func didSelectPaymentType(PaymentTypeTitle: String, PaymentType: String, PaymentTypeID: String, PaymentNumber: String, PaymentHolderName: String, dictData: [String : Any]?) {
        
        if UserDefaults.standard.object(forKey: "PaymentType") != nil {
            if let type = UserDefaults.standard.object(forKey: "PaymentType") as? String {
                self.paymentType = type
            }
        }
        
        if UserDefaults.standard.object(forKey: "PaymentType") != nil {
            if let type = UserDefaults.standard.object(forKey: "PaymentType") as? String {
                if type == PaymentType {
                    paymentTypeSelection(PaymentTypeTitle: PaymentTypeTitle, PaymentType: PaymentType, PaymentTypeID: PaymentTypeID, PaymentNumber: PaymentNumber, PaymentHolderName: PaymentHolderName, dictData: dictData)
                }
                else {
                    popupForPaymentType(PaymentTypeTitle: PaymentTypeTitle, PaymentType: PaymentType, PaymentTypeID: PaymentTypeID, PaymentNumber: PaymentNumber, PaymentHolderName: PaymentHolderName, dictData: dictData)
                }
            }
            else {
                popupForPaymentType(PaymentTypeTitle: PaymentTypeTitle, PaymentType: PaymentType, PaymentTypeID: PaymentTypeID, PaymentNumber: PaymentNumber, PaymentHolderName: PaymentHolderName, dictData: dictData)
            }
        }
        else {
            popupForPaymentType(PaymentTypeTitle: PaymentTypeTitle, PaymentType: PaymentType, PaymentTypeID: PaymentTypeID, PaymentNumber: PaymentNumber, PaymentHolderName: PaymentHolderName, dictData: dictData)
        }
    }
    
    func popupForPaymentType(PaymentTypeTitle: String, PaymentType: String, PaymentTypeID: String, PaymentNumber: String, PaymentHolderName: String, dictData: [String : Any]?) {
        
        let alert = UIAlertController(title: "Would You Like To Set \(PaymentTypeTitle) As Your Default Pay Mode?", message: "", preferredStyle: .alert)
        let useOnce = UIAlertAction(title: "USE ONCE", style: .default) { (ACT) in
            self.paymentTypeSelection(PaymentTypeTitle: PaymentTypeTitle, PaymentType: PaymentType, PaymentTypeID: PaymentTypeID, PaymentNumber: PaymentNumber, PaymentHolderName: PaymentHolderName, dictData: dictData)
        }
        let setAsDefault = UIAlertAction(title: "SET AS DEFAULT", style: .default) { (act) in
            UserDefaults.standard.set(PaymentType, forKey: "PaymentType")
            UserDefaults.standard.set(dictData, forKey: "PaymentTypeData")
            self.paymentTypeSelection(PaymentTypeTitle: PaymentTypeTitle, PaymentType: PaymentType, PaymentTypeID: PaymentTypeID, PaymentNumber: PaymentNumber, PaymentHolderName: PaymentHolderName, dictData: dictData)
        }
        alert.addAction(useOnce)
        alert.addAction(setAsDefault)
        self.present(alert, animated: true, completion: nil)
    }
    
    func paymentTypeSelection(PaymentTypeTitle: String, PaymentType: String, PaymentTypeID: String, PaymentNumber: String, PaymentHolderName: String, dictData: [String : Any]?) {
        self.lblCardName.text = PaymentTypeTitle
//        self.lblCardName.textColor = ThemeColor
        self.paymentType = PaymentType
        self.lblCardNumber.isHidden = true
        
        if (dictData?["Type"] as? String ?? "iconcard") == "iconWalletColor" {
            self.iconSelectedCard.image = UIImage(named: "iconWalletColor")
//            self.iconSelectedCard.tintColor = ThemeColor
//            self.iconSelectedCard.backgroundColor = ThemeColor
    
        } else {
            self.iconSelectedCard.image = PaymentTypeTitle.lowercased().contains("my mile") ? UIImage(named: "kms_black") : UIImage(named: dictData?["Type"] as? String ?? "iconcard")
            self.iconSelectedCard.tintColor = ThemeColor
//            self.iconSelectedCard.backgroundColor = .clear
        }
        
        if PaymentType == "card" {
            self.lblCardNumber.isHidden = false
            self.CardID = PaymentTypeID
            self.lblCardName.text = PaymentHolderName
            self.lblCardNumber.text = PaymentNumber
        }
//        self.viewPromocode.isHidden = false
        if self.paymentType == "bulk_miles" || self.paymentType == "co_bulk_miles" {
//            self.viewPromocode.isHidden = true
        }
    }
    
    
}
