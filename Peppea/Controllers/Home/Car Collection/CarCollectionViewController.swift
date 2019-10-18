//
//  CarCollectionViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 01/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import GoogleMaps
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
    
    // ----------------------------------------------------
    // MARK:- --- Base Methods ---
    // ----------------------------------------------------
    //    weak var delegateOfbookingSelection : didSelectBooking!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if UserDefaults.standard.object(forKey: "cards") != nil {
            //
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                do {
                    
                    guard let cardData = try UserDefaults.standard.get(objectType: AddCardModel.self, forKey: "cards") else {
                        return
                    }
                    
                    self.cardDetailModel = cardData
                    self.aryCards = self.cardDetailModel.cards

                    if(self.aryCards.count != 0)
                    {
                        let data = self.aryCards[0]
                        self.CardID = data.id
                        self.paymentType = "card"
                    }
                    
                } catch {
                    AlertMessage.showMessageForError("error")
                    return
                }
            }
        }

        didSelectPaymentType(PaymentType: "cash", PaymentTypeID: "", PaymentNumber: "", PaymentHolderName: "")
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
            self.collectionView.reloadData()
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
        
    }

    
    // Handle Booklater date and time
    func didSelectDateAndTime(date: String, timeStemp: String) 
    {

        self.btnBookNow.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnBookNow.titleLabel?.textAlignment = .center

        selectedTimeStemp = timeStemp
        self.btnBookNow.setTitle("Schedule a ride\n\(date)", for: .normal)
        let homeVC = self.parent as? HomeViewController
        homeVC?.setBackButtonWhileBookLater()
        homeVC?.selectedTimeStemp = timeStemp
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
                    
                    if dictOnlineCars.id == vehicleId {
                        self.estimateFare = (FlatRate == "") ? ( ((estimateFare?.contains(".") == true) ? estimateFare  : "\((Double((estimateMinute == "0" ? "0.0" : estimateFare)!)?.rounded(toPlaces: 2)) ?? 0.0)")!  ) : "\((Double((estimateMinute == "0" ? "0.0" : FlatRate))?.rounded(toPlaces: 2)) ?? 0.0)"
                    }
                    cell.lblPrice.text =  (FlatRate == "") ? ( ((estimateFare?.contains(".") == true) ? "\(Currency) \(estimateFare!)"  : "\(Currency) \((Double((estimateMinute == "0" ? "0.0" : estimateFare)!)?.rounded(toPlaces: 2)) ?? 0.0)")  ) : "\((Double((estimateMinute == "0" ? "0.0" : FlatRate))?.rounded(toPlaces: 2)) ?? 0.0)"
                    
                    cell.lblArrivalTime.text = "ETA \(estimateMinute == "0" ? "0" : estimateMinute ?? "0") min."
                }
            }

            cell.lblModelName.font = UIFont.semiBold(ofSize: 14.0)
            cell.lblPrice.font = UIFont.regular(ofSize: 14.0)
            cell.lblArrivalTime.font = UIFont.regular(ofSize: 14.0)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (self.arrCarLists.vehicleTypeList.count != 0 && indexPath.row < self.arrCarLists.vehicleTypeList.count)
        {
            let dictOnlineCars = arrCarLists.vehicleTypeList[indexPath.row]
            vehicleId = dictOnlineCars.id
            self.collectionView.reloadData()
        }
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
            
            homeVC?.isExpandCategory = false
            homeVC?.setUpCustomMarker()
            homeVC?.timer?.invalidate()
            UtilityClass.showHUDWithoutLottie(with: UIApplication.shared.keyWindow)
            animateGoogleMapWhenRotate(homeVC: homeVC)
            
            if sender.titleLabel?.text == "Book Now" {
                webserviceForBooking(bookingType: "book_now") // "book_now" // "book_later"
            } else {
                webserviceForBooking(bookingType: "book_later") // "book_now" // "book_later"
            }
        }
        else
        {
            UtilityClass.hideHUD()
            AlertMessage.showMessageForError(self.validations().1)
        }
    }
    

    
    @IBAction func btnBookLater(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PeppeaBookLaterViewController") as! PeppeaBookLaterViewController
        next.delegateOfSelectDateAndTime = self
        self.navigationController?.present(next, animated: true, completion: nil)
    }

    
    func didSelectPaymentType(PaymentType: String, PaymentTypeID: String, PaymentNumber: String, PaymentHolderName: String) {
        self.lblCardName.text = PaymentType
        self.paymentType = PaymentType
        self.lblCardNumber.isHidden = true
        if PaymentType == "card" {
            self.lblCardNumber.isHidden = false
            self.CardID = PaymentTypeID
            self.lblCardName.text = PaymentHolderName
            self.lblCardNumber.text = PaymentNumber
        }
    }
    
}
