//
//  SelectYourLocationViewController.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 14/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit
import TTSegmentedControl
import CoreLocation


protocol SelectPickUpLocationDelegate {
    func DidPickupLocation(SelectedLocation:CLLocation?, AddressName: String)
}


class SelectYourLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var tblView: UITableView!
    //    @IBOutlet var viewSelectedLocation: UIView!
    
    @IBOutlet weak var viewSelectedLocation: TTSegmentedControl!
    @IBOutlet var viewCurrentLocation: UIView!
    
    @IBOutlet var viewTimeBTNS: UIView!
    @IBOutlet var btnCurrentLocation: UIButton!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    
    @IBOutlet var viewSelectedPoint: UIView!
    
    @IBOutlet weak var lblStartPoint: UILabel!
    
//    var parallaxEffect: RKParallaxEffect!
    var selectedStartingPoint = CLLocation()
    
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    var defaultLocation = CLLocation()
    
    var StartingPoint:String = ""
    var StartingPointLatitude = Double()
    var StartingPointLongitude = Double()
    
    var arrOfferList :[[String:Any]] = []
    var locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    var Delegate:SelectPickUpLocationDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        viewSelectedLocation.layer.cornerRadius = 10.0
        //            viewSelectedLocation.frame.height/2
        //        viewSelectedLocation.layer.masksToBounds = true
        viewSelectedPoint.layer.cornerRadius = 10.0
        //            viewSelectedPoint.frame.height/2
        viewSelectedPoint.layer.masksToBounds = true
        viewCurrentLocation.layer.cornerRadius = 10.0
        viewCurrentLocation.layer.masksToBounds = true
        
        //TODO:
//        self.webserviceForGetOffers()
        //        viewCurrentLocation.layer.cornerRadius = 10.0
        //viewCurrentLocation.frame.height/2
        //        viewCurrentLocation.layer.masksToBounds = true
        
        //        viewSelectedLocation.itemTitles = ["Self Pick Up","Delivery"]
        //        viewSelectedLocation.didSelectItemWith = { (index, title) ->  () in
        //
        //            if index == 1 {
        //                let DeliveryLocation = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryViewController") as! DeliveryViewController
        //                DeliveryLocation.SelectDeliveryDelegate = self
        //                self.navigationController?.pushViewController(DeliveryLocation, animated: true)
        //            }
        //        }
        //        viewSelectedLocation.isUserInteractionEnabled = true
        //        viewSelectedLocation.useShadow = true
        //        viewSelectedLocation.allowDrag = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineMyCurrentLocation()
        
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //TODO:
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviLightBlueColor, naviTitle: "Select Your Location", leftImage: kBack_Icon, rightImage: "", isTranslucent: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    //MARK:- IBAction Method
    
    @IBAction func btnCurrentLocationAction(_ sender: Any) {
        self.getAddressForLatLong(latitude: String(self.doublePickupLat), Longintude: String(self.doublePickupLng))
    }
    
    
    
    @IBAction func btnContinue(_ sender: Any) {
        if self.StartingPoint != "" {
            self.Delegate.DidPickupLocation(SelectedLocation: CLLocation(latitude: self.StartingPointLatitude, longitude: self.StartingPointLongitude), AddressName: self.StartingPoint)
        } else {
            
            //TODO:
            //            Utilities.showToastMSG(MSG: "Please select your current location.")
        }
    }
    
    
    // MARK:- Webservice Call
    
//    func webserviceForGetOffers() {
//        let dictParam = [String:Any]()
//        webserviceForGetAllOffers(dictParam as AnyObject) { (result, status) in
//            if status {
//                self.arrOfferList = result["data"] as! [[String : Any]]
//                self.tblView.reloadData()
//            } else {
//                print(result)
//                if let ErrorMessages = (result as! NSDictionary).object(forKey: "error") as? [String] {
//                    let strMSG = ErrorMessages[0]
//                    Utilities.showAlert(appName, message: strMSG, vc: self)
//                } else if let ErrorMessage = (result as! NSDictionary).object(forKey: "error") as? String {
//                    let strMSG = ErrorMessage
//                    Utilities.showAlert(appName, message: strMSG, vc: self)
//                }
//            }
//        }
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK : - TableView Method -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfferList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        //        var customCell = UITableViewCell()
        
        //        if indexPath.row == 0
        //        {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationFirstCell") as! SelectLocationFirstCell
        //
        //
        //            //            cell.viewCell.backgroundColor = UIColor.white
        //            //            cell.viewCell.layer.shadowColor = UIColor.darkGray.cgColor
        //            //            cell.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        //            //            cell.viewCell.layer.shadowOpacity = 0.4
        //            //            cell.viewCell.layer.shadowRadius = 1
        //            //
        //            //            cell.viewCell.layer.cornerRadius = 10
        //            //
        //            cell.layer.zPosition = (indexPath.row == 0) ? 1 : 0
        //
        //            customCell = cell
        //        }
        //        else
        //        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationOffersListCell") as! SelectLocationOffersListCell
        
        //        cell.viewCell.layer.cornerRadius = 10
        //        cell.viewCell.layer.borderWidth = 1
        //        cell.viewCell.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.viewCEll.backgroundColor = UIColor.white
        cell.viewCEll.layer.shadowColor = UIColor.darkGray.cgColor
        cell.viewCEll.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.viewCEll.layer.shadowOpacity = 0.4
        cell.viewCEll.layer.shadowRadius = 1
        
        cell.viewCEll.layer.cornerRadius = 10
        
        if let img =  arrOfferList[indexPath.row]["image"] as? String  {
            cell.imgOfferBanner.sd_setShowActivityIndicatorView(true)
            cell.imgOfferBanner.sd_setIndicatorStyle(.gray)
            cell.imgOfferBanner.sd_setImage(with: URL(string:"\(WebserviceURLs.kOfferImageBaseURL)\(img)")!)
        }
        cell.selectionStyle = .none
        
        
        //        cell.viewCell.layer.masksToBounds = true
        
        
        //        cellMenu.imgDetail?.image = UIImage.init(named:  "\(arrMenuIcons[indexPath.row])")
        //        cellMenu.selectionStyle = .none
        //
        //        cellMenu.lblTitle.text = arrMenuTitle[indexPath.row]
        
        //            customCell = cell
        //        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        tblView.deselectRow(at: indexPath, animated: true)
        //        let  viewController = self.storyboard?.instantiateViewController(withIdentifier: "VehicleEditViewController") as! VehicleEditViewController
        //        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //
        //        if indexPath.row == 0
        //        {
        //            return 70
        //        }
        //        else
        //        {
        return 100
        //        }
        
    }
    
    // Selected Location Delegate
    
    
    func getAddressForLatLong(latitude:String, Longintude:String) {
        self.StartingPointLatitude = Double(latitude)!
        self.StartingPointLongitude = Double(Longintude)!
        
        let location = CLLocation(latitude: Double(latitude)!, longitude: Double(Longintude)!)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            //            lblStartPoint.text = "Unable to Find Address for Location"
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                var addressString:String = ""
                if let Address = placemark.addressDictionary as? [String:Any] {
                    addressString =  (Address["FormattedAddressLines"] as! [String]).joined(separator: ", ")
                }
                else {
                    if let SubLocality = placemark.subLocality, let City = placemark.locality, let State = placemark.administrativeArea, let Postalcode = placemark.postalCode , let country = placemark.country {
                        addressString = "\(SubLocality), \(City), \(State) \(Postalcode), \(country)"
                    }
                }
                self.StartingPoint = addressString
                lblStartPoint.text = self.StartingPoint

                //TODO:
                //                if let ParentPage = self.parent as? SearchYourLocationViewController {
//                    ParentPage.CurrentLocationData = (self.StartingPoint,self.StartingPointLatitude,self.StartingPointLongitude)
//                }
            
            } else {
                //                lblStartPoint.text = "No Address Found"
            }
        }
    }
    
    //    func getAddressForLatLng(latitude: String, longitude: String, markerType: String) {
    //
    //        let url = NSURL(string: "\(baseUrlForGetAddress)latlng=\(latitude),\(longitude)&key=\(Google_Api_Key)")
    //
    //            let autoCompleteHTTPs = NSURL(string: "\(baseUrlForAutocompleteAddress)input=35&location=\(latitude),\(longitude)&radius=1000&sensor=true&key=\(Google_Api_Key)&components=&language=en")
    //            print("autoCompleteHTTPs Link is : \(autoCompleteHTTPs)")
    //
    //            print("Link is : \(url)")
    //
    //            do {
    //                let data = NSData(contentsOf: url! as URL)
    //                let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
    //                if let result = json["results"] as? [[String:AnyObject]] {
    //                    if result.count > 0 {
    //
    //                        if let resString = result[0]["formatted_address"] as? String {
    //
    //                            self.lblStartPoint.text = resString
    //                            self.StartingPoint = resString
    //                            self.StartingPointLatitude = Double(latitude)!
    //                            self.StartingPointLongitude = Double(longitude)!
    //
    //
    //                        }
    //                        else if let address = result[0]["address_components"] as? [[String:AnyObject]] {
    //
    //                            if address.count > 1 {
    //
    //                                var streetNumber = String()
    //                                var streetStreet = String()
    //                                var streetCity = String()
    //                                var streetState = String()
    //
    //                                for i in 0..<address.count {
    //
    //                                    if i == 0 {
    //                                        if let number = address[i]["long_name"] as? String {
    //                                            streetNumber = number
    //                                        }
    //                                    }
    //                                    else if i == 1 {
    //                                        if let street = address[i]["long_name"] as? String {
    //                                            streetStreet = street
    //                                        }
    //                                    }
    //                                    else if i == 2 {
    //                                        if let city = address[i]["long_name"] as? String {
    //                                            streetCity = city
    //                                        }
    //                                    }
    //                                    else if i == 3 {
    //                                        if let state = address[i]["long_name"] as? String {
    //                                            streetState = state
    //                                        }
    //                                    }
    //                                    else if i == 4 {
    //                                        if let city = address[i]["long_name"] as? String {
    //                                            streetCity = city
    //                                        }
    //                                    }
    //                                }
    //
    //                                //                    let zip = address[6]["short_name"] as? String
    //                                print("\n\(streetNumber) \(streetStreet), \(streetCity), \(streetState)")
    //
    //                                self.lblStartPoint.text = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
    //                                self.StartingPoint = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
    //                                self.StartingPointLatitude = Double(latitude)!
    //                                self.StartingPointLongitude = Double(longitude)!
    //
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //            catch {
    //                print("Not Geting Address")
    //            }
    //    }
    
}


extension SelectYourLocationViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //        if self.StartingPoint == "" {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        self.doublePickupLat = location.coordinate.latitude
        self.doublePickupLng = location.coordinate.longitude
        
        //        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        //            self.DeliveryMapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

