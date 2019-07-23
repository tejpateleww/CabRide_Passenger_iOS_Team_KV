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


class CarCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource
{


    
    @IBOutlet weak var iconSelectedCard: UIImageView!
    
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var btnSelectCard: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var arrCarLists : [[String:Any]]!
    var aryCards = [CardsList]()
    var pickerView = UIPickerView()
    var LoginDetail : LoginModel = LoginModel()
    var cardDetailModel : AddCardModel = AddCardModel()
    @IBOutlet weak var txtSelectPaymentMethod: UITextField!
    var paymentType = String()
    var CardID = String()
    
//    weak var delegateOfbookingSelection : didSelectBooking!
    override func viewDidLoad() {
        super.viewDidLoad()


        getDataFromJSON()
        
        do
        {
            LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        }
        catch
        {
            AlertMessage.showMessageForError("error")
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            do
            {
                self.cardDetailModel = try UserDefaults.standard.get(objectType: AddCardModel.self, forKey: "cards")!
                self.aryCards = self.cardDetailModel.cards
            }
            catch
            {
                AlertMessage.showMessageForError("error")
                return
            }
        }
        
        
        pickerView.delegate = self
        
        
        let data = self.aryCards[0]
        
        iconSelectedCard.image = UIImage(named: setCardIcon(str: data.cardType)) //UIImage(named: setCardIcon(str: data["Type"] as! String))
        
        self.lblCardName.text = data.cardHolderName
        self.lblCardNumber.isHidden = false
        self.lblCardNumber.text = data.formatedCardNo
        self.CardID = data.id
        
        paymentType = "card"
        
    }

    func getDataFromJSON()
    {
        if let dictData = UtilityClass.getDataFromJSON(strJSONFileName: "carList") as? [String : Any]
        {
            arrCarLists = dictData["car_class"] as? [[String : Any]]
            collectionView.reloadData()
        }
    }

    @IBAction func txtSelectPaymentMethod(_ sender: UITextField)
    {
        txtSelectPaymentMethod.inputView = pickerView
    }
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
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

    //MARK:- CollectionView Delegate and Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCarLists?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarsCollectionViewCell", for: indexPath as IndexPath) as! CarsCollectionViewCell
        if (self.arrCarLists.count != 0 && indexPath.row < self.arrCarLists.count)
        {
            let dictOnlineCars = arrCarLists[indexPath.row]

            if let imageURL = dictOnlineCars["Image"] as? String
            {
                cell.imgOfCarModels.image = UIImage.init(named: imageURL)
            }

            if let strModelName = dictOnlineCars["Name"] as? String
            {
                cell.lblModelName.text = strModelName
            }
            if let strPrice = dictOnlineCars["BaseFare"] as? String
            {
                cell.lblPrice.text = "\(Currency) \(strPrice)"
            }
            if let strArrivalTime = dictOnlineCars["Sort"] as? String
            {
                cell.lblArrivalTime.text = "ETA \(strArrivalTime) min."
            }
            cell.lblModelName.font = UIFont.regular(ofSize: 7)
            cell.lblPrice.font = UIFont.regular(ofSize: 7)
            cell.lblArrivalTime.font = UIFont.regular(ofSize: 7)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (self.arrCarLists.count != 0 && indexPath.row < self.arrCarLists.count)
        {
            let dictOnlineCars = arrCarLists[indexPath.row]
            
            print(dictOnlineCars)
            
            if let cell = self.collectionView.cellForItem(at: indexPath)  as? CarsCollectionViewCell
            {
                if let imageURL = dictOnlineCars["Image"] as? String
                {
                    let FinalString = imageURL.replacingOccurrences(of: "UnSelect", with: "Select")
                    cell.imgOfCarModels.image = UIImage.init(named: FinalString)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if (self.arrCarLists.count != 0 && indexPath.row < self.arrCarLists.count)
        {
            let dictOnlineCars = arrCarLists[indexPath.row]
            
            print(dictOnlineCars)
            
            if let cell = self.collectionView.cellForItem(at: indexPath)  as? CarsCollectionViewCell
            {
                if let imageURL = dictOnlineCars["Image"] as? String
                {
                    cell.imgOfCarModels.image = UIImage.init(named: imageURL)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let numberOfCars = ( self.arrCarLists.count > 3) ? 4 : 3
        let CellWidth = ( UIScreen.main.bounds.width - 30 ) / CGFloat(numberOfCars)
        return CGSize(width: CellWidth , height: self.collectionView.frame.size.height)
    }

    @IBAction func btnBookNow(_ sender: Any)
    {
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
