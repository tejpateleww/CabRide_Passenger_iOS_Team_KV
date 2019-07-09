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


class CarCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var collectionView: UICollectionView!
    var arrCarLists : [[String:Any]]!
//    weak var delegateOfbookingSelection : didSelectBooking!
    override func viewDidLoad() {
        super.viewDidLoad()


        getDataFromJSON()
        // Do any additional setup after loading the view.
    }

    func getDataFromJSON()
    {
        if let dictData = UtilityClass.getDataFromJSON(strJSONFileName: "carList") as? [String : Any]
        {
            arrCarLists = dictData["car_class"] as? [[String : Any]]
            collectionView.reloadData()
        }
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


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let numberOfCars = ( self.arrCarLists.count > 3) ? 4 : 3
        let CellWidth = ( UIScreen.main.bounds.width - 30 ) / CGFloat(numberOfCars)
        return CGSize(width: CellWidth , height: self.collectionView.frame.size.height)
    }

    @IBAction func btnBookNow(_ sender: Any) {
        //self.delegateOfbookingSelection?.didSelectBookNow?()
        let homeVC = self.parent as? HomeViewController
//        homeVC?.hideAndShowView(view: .requestAccepted)


        homeVC?.isExpandCategory = false
        homeVC?.setUpCustomMarker()
        homeVC?.timer.invalidate()
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
