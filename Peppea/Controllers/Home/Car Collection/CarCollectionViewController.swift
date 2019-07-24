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


class CarCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource,didSelectDateDelegate {
 
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
    var pickerView = UIPickerView()
    var LoginDetail : LoginModel = LoginModel()
    var cardDetailModel : AddCardModel = AddCardModel()
   
    var paymentType = String()
    var CardID = String()
    var vehicleId = ""
    
    // ----------------------------------------------------
    // MARK:- --- Base Methods ---
    // ----------------------------------------------------
//    weak var delegateOfbookingSelection : didSelectBooking!
    override func viewDidLoad() {
        super.viewDidLoad()

        getDataFromJSON()
        
         pickerView.delegate = self
        do {
            LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
        
        if UserDefaults.standard.object(forKey: "cards") != nil {
            //
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                do {
                    self.cardDetailModel = try UserDefaults.standard.get(objectType: AddCardModel.self, forKey: "cards")!
                    self.aryCards = self.cardDetailModel.cards

                    if(self.aryCards.count != 0)
                    {
                        let data = self.aryCards[0]

                        self.iconSelectedCard.image = UIImage(named: setCardIcon(str: data.cardType)) //UIImage(named: setCardIcon(str: data["Type"] as! String))

                        self.lblCardName.text = data.cardHolderName
                        self.lblCardNumber.isHidden = false
                        self.lblCardNumber.text = data.formatedCardNo
                        self.CardID = data.id


                        self.paymentType = "card"
                    }
                    
                } catch {
                    AlertMessage.showMessageForError("error")
                    return
                }
            }
        }
    }

    func getDataFromJSON()
    {
//        if let dictData = UtilityClass.getDataFromJSON(strJSONFileName: "carList") as? [String : Any]
//        {
//            arrCarLists = dictData["car_class"] as? [[String : Any]]
//            collectionView.reloadData()
//        }
        
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

    @IBAction func txtSelectPaymentMethod(_ sender: UITextField)
    {
        txtSelectPaymentMethod.inputView = pickerView
    }
    
    //-------------------------------------------------------------
    // MARK: - --- PickerView Methods ---
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aryCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let data = aryCards[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let centerOfmyView = myView.frame.size.height / 4
        
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:centerOfmyView, width:40, height:26))
        myImageView.contentMode = .scaleAspectFit
        
        var rowString = String()
        
        
        switch row {
            
        case 0:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 1:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 2:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 3:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 4:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 5:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 6:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 7:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 8:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 9:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 10:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
        //        myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        let data = aryCards[row]
        
        iconSelectedCard.image = UIImage(named: setCardIcon(str: data.cardType)) //UIImage(named: setCardIcon(str: data["Type"] as! String))
        
        self.lblCardName.text = data.cardHolderName
        self.lblCardNumber.isHidden = false
        self.lblCardNumber.text = data.formatedCardNo
        self.CardID = data.id
        
        paymentType = "card"
    }
    
    
    // Handle Booklater date and time
    func didSelectDateAndTime(date: String)
    {
//        if(txtDestinationLocation.text?.count == 0)
//        {
//            txtDestinationLocation(txtDestinationLocation)
//        }
//        else
//        {
            self.btnBookNow.titleLabel?.lineBreakMode = .byWordWrapping
            self.btnBookNow.titleLabel?.textAlignment = .center

            //            UtilityClass.changeDateFormat(from: "yyyy-MM-dd hh:mm:ss", toFormat: "dd-MM-yyyy", date: Date())

            self.btnBookNow.setTitle("Schedule a ride\n\(date)", for: .normal)
//        }
    }
    //MARK:-  --- CollectionView Delegate and Datasource Methods ---
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCarLists.vehicleTypeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarsCollectionViewCell", for: indexPath as IndexPath) as! CarsCollectionViewCell
        if (self.arrCarLists.vehicleTypeList.count != 0 && indexPath.row < self.arrCarLists.vehicleTypeList.count)
        {
            let dictOnlineCars = arrCarLists.vehicleTypeList[indexPath.row]

//            if let imageURL = dictOnlineCars["Image"] as? String
//            {
//                cell.imgOfCarModels.image = UIImage.init(named: imageURL)
//            }
//
//            if let strModelName = dictOnlineCars["Name"] as? String
//            {
//                cell.lblModelName.text = strModelName
//            }
//            if let strPrice = dictOnlineCars["BaseFare"] as? String
//            {
//                cell.lblPrice.text = "\(Currency) \(strPrice)"
//            }
//            if let strArrivalTime = dictOnlineCars["Sort"] as? String
//            {
//                cell.lblArrivalTime.text = "ETA \(strArrivalTime) min."
//            }
            
            if dictOnlineCars.unselectImage != nil
            {
                cell.imgOfCarModels.sd_setImage(with: URL(string: NetworkEnvironment.baseImageURL + dictOnlineCars.unselectImage), completed: nil) //image = UIImage.init(named: imageURL)
            }
            
            if let strModelName = dictOnlineCars.name // ["Name"] as? String
            {
                cell.lblModelName.text = strModelName.uppercased()
            }
            if let strPrice = dictOnlineCars.baseCharge // ["BaseFare"] as? String
            {
                cell.lblPrice.text = "\(Currency) \(strPrice)"
            }
            if let strArrivalTime = dictOnlineCars.sort // ["Sort"] as? String
            {
                cell.lblArrivalTime.text = "ETA \(strArrivalTime) min."
            }
            
            
            cell.lblModelName.font = UIFont.semiBold(ofSize: 9.5)
            cell.lblPrice.font = UIFont.regular(ofSize: 9.5)
            cell.lblArrivalTime.font = UIFont.regular(ofSize: 9.5)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (self.arrCarLists.vehicleTypeList.count != 0 && indexPath.row < self.arrCarLists.vehicleTypeList.count)
        {
            let dictOnlineCars = arrCarLists.vehicleTypeList[indexPath.row]

            print(dictOnlineCars)

           vehicleId = dictOnlineCars.id
            
            if let cell = self.collectionView.cellForItem(at: indexPath)  as? CarsCollectionViewCell
            {
                if let imageURL = dictOnlineCars.image // ["Image"] as? String
                {
//                    let FinalString = imageURL.replacingOccurrences(of: "UnSelect", with: "Select")
                    cell.imgOfCarModels.sd_setImage(with: URL(string: NetworkEnvironment.baseImageURL + imageURL), completed: nil) // .image = UIImage.init(named: FinalString)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if (self.arrCarLists.vehicleTypeList.count != 0 && indexPath.row < self.arrCarLists.vehicleTypeList.count)
        {
            let dictOnlineCars = arrCarLists.vehicleTypeList[indexPath.row]

            print(dictOnlineCars)

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
        CATransaction.begin()
        CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock({
            CATransaction.begin()
            CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock({
                CATransaction.begin()
                CATransaction.setValue(4, forKey: kCATransactionAnimationDuration)
                CATransaction.setCompletionBlock({
                    homeVC?.hideAndShowView(view: .requestAccepted)
                    homeVC?.isExpandCategory = true
                })
                homeVC?.mapView.animate(toBearing: CLLocationDirection(((homeVC?.getHeadingForDirection(fromCoordinate: (homeVC?.defaultLocation.coordinate)!, toCoordinate: (homeVC?.defaultLocation.coordinate)!))! - 30) ))
                homeVC?.view.layoutIfNeeded()
                CATransaction.commit()
            })
            homeVC?.mapView.animate(toZoom: 13)
            homeVC?.view.layoutIfNeeded()
            CATransaction.commit()
        })
        homeVC?.mapView.animate(toViewingAngle: 45)
        homeVC?.view.layoutIfNeeded()
        CATransaction.commit()
    }
    
    // ----------------------------------------------------
    // MARK: --- Actions ---
    // ----------------------------------------------------
    @IBAction func btnBookNow(_ sender: Any) {
        
        /*
         
         "booking_type: book_now or book_later
         customer_id:1
         vehicle_type_id:1
         pickup_location:Excellent WebWorld, Science City Road, Sola, Ahmedabad, Gujarat
         dropoff_location:Iscon Mega Mall, Sarkhej - Gandhinagar Highway, Ahmedabad, Gujarat
         pickup_lat:23.0726414
         pickup_lng:72.51423
         dropoff_lat:23.0305179
         dropoff_lng:72.5053514
         no_of_passenger:2
         payment_type:cash OR card OR wallet (if payment_type = 'card' then 'card_id' parameter (complusary))
         if booking_type = 'book_later' then  'pickup_date_time'(should be in timestamp) parameter (complusary)
         promocode(if applicable)"
         
         */
        //self.delegateOfbookingSelection?.didSelectBookNow?()
        let homeVC = self.parent as? HomeViewController
        //        homeVC?.hideAndShowView(view: .requestAccepted)
        
        
        homeVC?.isExpandCategory = false
        homeVC?.setUpCustomMarker()
        homeVC?.timer?.invalidate()
        animateGoogleMapWhenRotate(homeVC: homeVC)
        
        webserviceForBooking()
    }

    
    @IBAction func btnBookLater(_ sender: Any)
    {
        
//        if Connectivity.isConnectedToInternet()
//        {
//
//            let profileData = SingletonClass.sharedInstance.dictProfile
//
//            // This is For Book Later Address
//            if (SingletonClass.sharedInstance.isFromNotificationBookLater) {
        
                let next = self.storyboard?.instantiateViewController(withIdentifier: "PeppeaBookLaterViewController") as! PeppeaBookLaterViewController
                next.delegateOfSelectDateAndTime = self
//                SingletonClass.sharedInstance.isFromNotificationBookLater = false
        
                self.navigationController?.present(next, animated: true, completion: nil)
//            }
//            else {
//
//
//                let next = self.storyboard?.instantiateViewController(withIdentifier: "PeppeaBookLaterViewController") as! PeppeaBookLaterViewController
//                next.delegateOfSelectDateAndTime = self
//
//                self.navigationController?.present(next, animated: true, completion: nil)
//            }
//        }
//        else
//        {
//            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
//        }
    }

    
}
