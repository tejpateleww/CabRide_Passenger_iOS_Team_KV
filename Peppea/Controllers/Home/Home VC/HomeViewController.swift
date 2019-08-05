//
//  HomeViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 29/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

enum locationType: String {
    case pickUp = "pickUp"
    case dropOff = "dropOff"
}

enum HomeViews{
    case requestAccepted
    case rideConfirmation
    case rideStart
    case filter
    case ratings
    case waiting
    case booking
    case completeTrip
    case askForTip
    case none
}

class HomeViewController: BaseViewController,GMSMapViewDelegate,didSelectDateDelegate
{

    //MARK:- IBOutles
    @IBOutlet weak var btnCurrentLocation: UIButton!

    @IBOutlet weak var btnViewTop: UIButton!
    var LoginDetail : LoginModel = LoginModel()
    var addCardReqModel : AddCard = AddCard()
    var CardListReqModel : CardList = CardList()
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropLocation: UITextField!
    @IBOutlet weak var btnBookLater: UIButton!
    @IBOutlet weak var mapViewContainer: UIView!
    var currentLocationMarkerText = String()
    @IBOutlet weak var viewPickupLocation: UIView!
    @IBOutlet weak var viewDropOffLocation: UIView!
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintStackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var markerView: UIImageView!
    @IBOutlet weak var markerContainerView: UIView!
    @IBOutlet weak var lblBuildNumber: UILabel!
    @IBOutlet weak var locationView: UIView!
    
    let window = UIApplication.shared.keyWindow

    //MARK:- Variables
    var isPickupLocation = Bool()
    lazy var geocoder = CLGeocoder()
    var driverInfoVC : DriverInfoPageViewController?
    var ratingInfoVC : DriverRatingAndTipViewController?
    var stopAnimatingCamera = Bool()
    var mapView = GMSMapView()
    //    lazy var marker = GMSMarker()
    var pulseArray = [CAShapeLayer]()
    var booingInfo = BookingInfo()
    var selectedTimeStemp = ""
    
    /// Pickup and Dropoff Address
    var pickupAndDropoffAddress = (pickUp: "", dropOff: "")
    
    var vehicleId = String()
    var estimateFare = String()
    var bookingType = String()
    var estimateData = [EstimateFare]()

    //MARk:- PolyLine Variables
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    var driverMarker: GMSMarker!
    var destinationMarker = GMSMarker()
    var pickupMarker = GMSMarker()

    //MARK:- Location Manager
    let locationManager = CLLocationManager()
    var defaultLocation = CLLocation()
    var pickupLocation = CLLocationCoordinate2D()
    var destinationLocation = CLLocationCoordinate2D()
//    var zoomLevel: Float = 16.0


    //MARK:- Container viewcontrollers views
    @IBOutlet weak var carListContainerView: UIView!
    @IBOutlet weak var driverInfoContainerView: UIView!
    @IBOutlet weak var driverRatingContainerView: UIView!


    //MARK:- DidSet Methods
    var hideBookLaterButtonFromDroplocationField: Bool = true
    {
        didSet
        {
            self.btnBookLater.isHidden = hideBookLaterButtonFromDroplocationField

            if(hideBookLaterButtonFromDroplocationField == false)
            {
                self.containerView.isHidden = true
            }
            else
            {
                self.containerView.isHidden = false
            }
        }
    }

    var isExpandCategory:  Bool  = false {
        didSet {
            constraintStackViewBottom.constant = isExpandCategory ? 0 : (-containerHeightConstraint.constant + 135)
            
            self.view.endEditing(true)
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState], animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                
            }
        }
    }


    //MARK:- View Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
     
        SocketIOManager.shared.establishConnection()
        
        if SingletonClass.sharedInstance.bookingInfo != nil {
            self.booingInfo = SingletonClass.sharedInstance.bookingInfo!
        }
        
        self.btnViewTop.addTarget(self, action: #selector(setBottomViewOnclickofViewTop), for: .touchUpInside)

        self.webserviceForCardList()
        self.setupGoogleMaps()
        self.setupLocationManager()
        self.setupNavigationController()
        self.setupViewCategory()
        
        if self.booingInfo.status == "pending" {
            setupTripStatu(status: .pending)
        } else if self.booingInfo.status == "accepted" {
            self.routeDrawMethod(origin: "\(self.booingInfo.pickupLat ?? ""),\(self.booingInfo.pickupLng ?? "")", destination: "\(self.booingInfo.dropoffLat ?? ""),\(self.booingInfo.dropoffLng ?? "")")
            setupCarMarker(res: self.booingInfo)
            setupTripStatu(status: .accepted)
        } else if self.booingInfo.status == "traveling" {
            self.routeDrawMethod(origin: "\(self.booingInfo.pickupLat ?? ""),\(self.booingInfo.pickupLng ?? "")", destination: "\(self.booingInfo.dropoffLat ?? ""),\(self.booingInfo.dropoffLng ?? "")")
            setupCarMarker(res: self.booingInfo)
            setupTripStatu(status: .traveling)
        } else if self.booingInfo.status == "completed" {
            setupTripStatu(status: .completed)
        }
        
        #if targetEnvironment(simulator)
            lblBuildNumber.isHidden = false
        lblBuildNumber.text = "Build : \(Bundle.main.buildVersionNumber ?? "") \t\t Booking ID: \(self.booingInfo.id ?? "")"
        #else
        lblBuildNumber.isHidden = true
        
        if UIDevice.current.name == "iPad red" || UIDevice.current.name == "Eww’s iPhone 7" || UIDevice.current.name == "Administrator’s iPhone" {
            lblBuildNumber.isHidden = false
            lblBuildNumber.text = "Build : \(Bundle.main.buildVersionNumber ?? "") \t\t Booking ID: \(self.booingInfo.id ?? "")"
        }
        #endif
        self.setupNavigationController()

        self.perform(#selector(self.btnCurrentLocation(_:)), with: self, afterDelay: 1)
        
        
        let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "iconUnSelectedstar"), style: .plain, target: self, action: #selector(self.btnFavouriteAddress(_:)))
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = mapViewContainer.frame
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (CLLocationManager.authorizationStatus() == .denied) || CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .notDetermined {
            let alert = UIAlertController(title: AppName.kAPPName, message: "Please enable location from settings", preferredStyle: .alert)
            let enable = UIAlertAction(title: "Enable", style: .default) { (temp) in
                
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(URL(string: "App-Prefs:root=Privacy&path=LOCATION") ?? url, options: [:], completionHandler: nil)
                }
//                App-Prefs:root=Privacy&path=LOCATION"
//                guard let locationUrl = URL(string: "App-Prefs:root=Privacy&path=LOCATION") else {
//                    return
//                }
//                UIApplication.shared.openURL(locationUrl)
            }
            alert.addAction(enable)
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.timer.invalidate()
    }
    
    @objc func btnFavouriteAddress(_ sender: UIButton) {
        
        if txtPickupLocation.text!.isBlank {
            
            UtilityClass.showAlert(title: AppName.kAPPName, message: "Please select pickup location", alertTheme: .warning)
            return
        }
        
        if txtDropLocation.text!.isBlank {
            
            UtilityClass.showAlert(title: AppName.kAPPName, message: "Please select destination location", alertTheme: .warning)
            return
        }
        
        let alert = UIAlertController(title: AppName.kAPPName, message: "Choose your favourite location", preferredStyle: .actionSheet)
        
        let Home = UIAlertAction(title: "Home", style: .default) { (action) in
            self.webserviceForAddToFavouriteAddress(addresType: "Home")
        }
        
        let Office = UIAlertAction(title: "Office", style: .default) { (action) in
            self.webserviceForAddToFavouriteAddress(addresType: "Office")
        }
        
        let Other = UIAlertAction(title: "Other", style: .default) { (action) in
            self.webserviceForAddToFavouriteAddress(addresType: "Other")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Home)
        alert.addAction(Office)
        alert.addAction(Other)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupTripStatu(status: TripStauts) {
        
        switch status {
            case .pending:
                print("")
            case .accepted:
                self.hideAndShowView(view: .requestAccepted)
                self.isExpandCategory = true
            case .traveling:
                self.hideAndShowView(view: .rideStart)
                self.isExpandCategory = true
            case .completed:
                self.hideAndShowView(view: .ratings)
                self.isExpandCategory = true
        }
    }


    //MARK:- Setup Methods

    func setupNavigationController()
    {
        setNavBarWithMenu(Title: "Home", IsNeedRightButton: false)
    }

    func setupViewCategory() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.containerView.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.containerView.addGestureRecognizer(swipeDown)
    }

    func setupGoogleMaps()
    {
        mapView = GMSMapView(frame: mapViewContainer.bounds)
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "styleMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }

        mapViewContainer.addSubview(mapView)
    }

    func setUpCustomMarker()
    {
        //        let markerImage = UIImage(named: "iconMarker")
        //        let markerView = UIImageView(image: markerImage)
        //        marker.position = defaultLocation.coordinate
        //        marker.iconView = markerView
        //        marker.map = mapView
//        markerContainerView.isHidden = false
        markerContainerView.layer.cornerRadius = (markerContainerView.frame.size.width)/2.0
        mapView.isMyLocationEnabled = false
        //        createPulse()

    }
    
    func setupCarMarker(res : BookingInfo)
    {
        mapView.isMyLocationEnabled = false
        if self.driverMarker == nil {
            
            
            var DoubleLat = Double()
            var DoubleLng = Double()
            
            if let lat = res.driverInfo?.lat, let doubleLat = Double(lat) {
                DoubleLat = doubleLat
            }
            
            if let lng = res.driverInfo?.lng, let doubleLng = Double(lng) {
                DoubleLng = doubleLng
            }
            
            let DriverCordinate = CLLocationCoordinate2D(latitude: DoubleLat , longitude: DoubleLng)
            self.driverMarker = GMSMarker(position: DriverCordinate) // self.originCoordinate
            self.driverMarker.icon = UIImage(named: iconCar)
            self.driverMarker.map = self.mapView
        }
        else {
            self.driverMarker.icon = UIImage.init(named: iconCar)
        }
        
    }

    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setBackButtonWhileBookLater() {
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "iconBack"), style: .plain, target: self, action: #selector(self.btnBackButtonWhileBookLater))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    @objc func btnBackButtonWhileBookLater() {
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "iconMenu"), style: .plain, target: self, action: #selector(self.OpenMenuAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        if let VC = self.children.first as? CarCollectionViewController {
            
            VC.btnBookNow.setTitle("Book Now", for: .normal)
            VC.strPromoCode = ""
            VC.vehicleId = ""
            VC.selectedTimeStemp = ""
        }
    
//        setupAfterComplete()
    }
    
    func didSelectDateAndTime(date: String, timeStemp: String)
    {
        selectedTimeStemp = timeStemp
        if(txtDropLocation.text?.count == 0)
        {
            txtLocation(txtDropLocation as! ThemeTextField)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let VC = self.children.first as? CarCollectionViewController
                {
                    VC.btnBookNow.titleLabel?.lineBreakMode = .byWordWrapping
                    VC.btnBookNow.titleLabel?.textAlignment = .center
                    VC.btnBookNow.setTitle("Schedule a ride\n\(date)", for: .normal)
                    self.setBackButtonWhileBookLater()
                    VC.selectedTimeStemp = timeStemp
                }
            }
        }
        else
        {
            
            // Because btn title change after reinitialized
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let VC = self.children.first as? CarCollectionViewController
                {
                    VC.btnBookNow.titleLabel?.lineBreakMode = .byWordWrapping
                    VC.btnBookNow.titleLabel?.textAlignment = .center
                    VC.btnBookNow.setTitle("Schedule a ride\n\(date)", for: .normal)
                    self.setBackButtonWhileBookLater()
                    VC.selectedTimeStemp = timeStemp
                }
            }
           
            
//            self.btnBookNow.titleLabel?.lineBreakMode = .byWordWrapping
//            self.btnBookNow.titleLabel?.textAlignment = .center

            //            UtilityClass.changeDateFormat(from: "yyyy-MM-dd hh:mm:ss", toFormat: "dd-MM-yyyy", date: Date())

//            self.btnBookNow.setTitle("Schedule a ride\n\(date)", for: .normal)
        }
    }
    func webserviceForCardList()
    {
//        self.aryCardData.removeAll()
        
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        do {
            LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
        
        CardListReqModel.customer_id = LoginDetail.loginData.id
        UserWebserviceSubclass.CardInList(cardListModel: CardListReqModel) { (json, status) in
            if status
            {
                let CardListDetails = AddCardModel.init(fromJson: json)
                do
                {
                    try UserDefaults.standard.set(object: CardListDetails, forKey: "cards")
                }
                catch
                {
                    UtilityClass.hideHUD()
                    AlertMessage.showMessageForError("error")
                }
            }
            else
            {
                AlertMessage.showMessageForError("error")
            }
        }
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
    
    //MARK:- Other Methods
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {


            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
                self.isExpandCategory = false
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
                self.isExpandCategory = true

            default:
                break
            }
        }
    }

    @objc func setBottomViewOnclickofViewTop()
    {
        self.isExpandCategory = !self.isExpandCategory
    }
    
    //MARK:- Pulse Methods

    func createPulse()
    {

        for _ in 0...2
        {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: ((self.markerContainerView?.superview?.frame.size.width )! )/2, startAngle: 0, endAngle: 2 * .pi , clockwise: true)
            let pulsatingLayer = CAShapeLayer()
            pulsatingLayer.path = circularPath.cgPath
            pulsatingLayer.lineWidth = 2.5
            pulsatingLayer.fillColor = UIColor.clear.cgColor
            pulsatingLayer.lineCap = CAShapeLayerLineCap.round
            pulsatingLayer.position = CGPoint(x: (markerContainerView?.frame.size.width)! / 2.0, y: (markerContainerView?.frame.size.width)! / 2.0)
            markerContainerView?.layer.addSublayer(pulsatingLayer)
            pulseArray.append(pulsatingLayer)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.animatePulsatingLayerAt(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.animatePulsatingLayerAt(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.animatePulsatingLayerAt(index: 2)
                })
            })
        })
    }

    func animatePulsatingLayerAt(index:Int) {

        //Giving color to the layer
        pulseArray[index].strokeColor = ThemeColor.cgColor

        //Creating scale animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9

        //Creating opacity animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0

        // Grouping both animations and giving animation duration, animation repat count
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.duration = 2.3
        groupAnimation.repeatCount = .greatestFiniteMagnitude
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        //adding groupanimation to the layer
        pulseArray[index].add(groupAnimation, forKey: "groupanimation")

    }

    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {

        let fLat: Float = Float((self.mapView.camera.target.latitude).degreesToRadians)
        let fLng: Float = Float((self.mapView.camera.target.longitude).degreesToRadians)
        let tLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let tLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        if degree >= 0 {
            return degree
        } else {
            return 360 + degree
        }
    }
    func currentLocationAction(isCurrentLocationTapped: Bool = false)
    {
        
        if isCurrentLocationTapped {
             clearMap()
        }
       
        
//        self.destinationLocationMarker.map = nil
//        self.currentLocationMarker.map = nil
//        self.strLocationType = self.currentLocationMarkerText
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        mapView.camera = camera
        
//        MarkerCurrntLocation.isHidden = false
        
        self.doublePickupLat = (defaultLocation.coordinate.latitude)
        self.doublePickupLng = (defaultLocation.coordinate.longitude)
        
        let strLati: String = "\(self.doublePickupLat)"
        let strlongi: String = "\(self.doublePickupLng)"
        pickupLocation = defaultLocation.coordinate
        
        let address = "\(geocodeAddress)\(defaultLocation.coordinate.latitude),\(defaultLocation.coordinate.longitude)&key=\(googlApiKey)"
        
        
        // Get Perfect address using Google API
        WebService.shared.getMethod(url: URL(string: address)!, httpMethod: .get) { (response, status) in
            
            if status {
                self.txtPickupLocation.text = response.dictionary!["results"]!.array!.first!.dictionary!["formatted_address"]!.stringValue
                self.pickupAndDropoffAddress.pickUp = self.txtPickupLocation.text ?? ""
            } else {
                // Get address using Google API is not working
                self.getAddressForLatLng(latitude: strLati, Longintude: strlongi, markerType: .pickUp)
            }
        }
//        getAddressForLatLng(latitude: strLati, Longintude: strlongi, markerType: .pickUp)
    }
    
    //MARK:- Setup Pickup and Destination Location

    func placepickerMethodForLocation(isPickupLocation : Bool)
    {
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.autocompleteBounds = bounds
        present(acController, animated: true, completion: nil)
    }
    @IBAction func btnCurrentLocation(_ sender: UIButton)
    {
        if txtPickupLocation.text!.isBlank {
            currentLocationAction()
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                                  longitude: defaultLocation.coordinate.longitude,
                                                  zoom: zoomLevel)
            mapView.camera = camera
        }
        
        UtilityClass.hideHUD()
        
//        setupAfterComplete()

    }
    @IBAction func txtLocation(_ sender: ThemeTextField)
    {
        if(sender.tag == 1)
        {
            placepickerMethodForLocation(isPickupLocation: true)
            isPickupLocation = true
        }
        else
        {
            placepickerMethodForLocation(isPickupLocation: false)
            isPickupLocation = false
        }
    }

    func getAddressForLatLng(latitude:String, Longintude:String, markerType: locationType) {
        let location = CLLocation(latitude: Double(latitude)!, longitude: Double(Longintude)!)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error,markerType: markerType)
        }
    }

    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, markerType: locationType) {
        // Update View
        if let error = error
        {
            print("Unable to Reverse Geocode Location (\(error))")

        }
        else
        {
            if let placemarks = placemarks, let placemark = placemarks.first {
                var addressString:String = ""
                if let thoroughfare = placemark.thoroughfare, let City = placemark.locality, let State = placemark.administrativeArea, let Postalcode = placemark.postalCode , let country = placemark.country {
                    addressString = "\(thoroughfare), \(City), \(State) \(Postalcode), \(country)"
                }

                if(markerType == .pickUp)
                {
                    txtPickupLocation.text = addressString
                    pickupAndDropoffAddress.pickUp = txtPickupLocation.text ?? ""
                }
                else
                {
                    txtDropLocation.text = addressString
                    pickupAndDropoffAddress.dropOff = txtDropLocation.text ?? ""
                }
                
               self.pickupLocation = placemark.location!.coordinate
            }
        }
    }

    //MARK:- PolyLine Methods


    func routeDrawMethod(origin: String?, destination: String?)
    {
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                let directionsURL = NSURL(string: directionsURLString)
                DispatchQueue.main.async(execute: {
                    if let directionsData = NSData(contentsOf: directionsURL! as URL)
                    {
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>

                            let status = dictionary["status"] as! String

                            if status == "OK" {
                                
                                var strPickupCoordinate = origin?.components(separatedBy: ",")
                                var pickupDoubleLat = Double()
                                var pickupDoubleLng = Double()
                                
                                if let lat = strPickupCoordinate?[0], let doubleLat = Double(lat) {
                                    pickupDoubleLat = doubleLat
                                }
                                
                                if let lng = strPickupCoordinate?[1], let doubleLng = Double(lng) {
                                    pickupDoubleLng = doubleLng
                                }
                                
                                let pickupCoordinate = CLLocationCoordinate2D(latitude: pickupDoubleLat , longitude: pickupDoubleLng)
                                self.pickupMarker.map = nil
                                self.pickupMarker = GMSMarker(position: pickupCoordinate) // self.originCoordinate
                                self.pickupMarker.icon = UtilityClass.image(UIImage(named: iconMarker), scaledTo: CGSize(width: 30, height: 30))//UIImage(named: iconMarker)
                                self.pickupMarker.map = self.mapView
                                
                                
                                var strDestinationCoordinate = destination?.components(separatedBy: ",")
                                var DoubleLat = Double()
                                var DoubleLng = Double()
                                
                                if let lat = strDestinationCoordinate?[0], let doubleLat = Double(lat) {
                                    DoubleLat = doubleLat
                                }
                                
                                if let lng = strDestinationCoordinate?[1], let doubleLng = Double(lng) {
                                    DoubleLng = doubleLng
                                }
                                
                                let destinationCoordinate = CLLocationCoordinate2D(latitude: DoubleLat , longitude: DoubleLng)
                                self.destinationMarker.map = nil
                                self.destinationMarker = GMSMarker(position: destinationCoordinate) // self.originCoordinate
                                self.destinationMarker.icon = UtilityClass.image(UIImage(named: iconMarker), scaledTo: CGSize(width: 30, height: 30))//UIImage(named: iconMarker)
                                self.destinationMarker.map = self.mapView
                                self.drawRoute(routeDict: dictionary)
                            } else {
                                
                            }
                        }
                        catch
                        {
                            print("error while drawing route")
                        }
                    }
                })
            }
        }
    }

    func drawRoute(routeDict: Dictionary<String, Any>) {

        let routesArray = routeDict ["routes"] as! NSArray

        if (routesArray.count > 0)
        {
            let routeDict = routesArray[0] as! Dictionary<String, Any>
            let routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary<String, Any>
            let points = routeOverviewPolyline["points"]
            self.path = GMSPath.init(fromEncodedPath: points as! String)!
            self.polyline.path = path
            self.polyline.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.polyline.strokeWidth = 3.0
            self.polyline.map = self.mapView

            let bounds = GMSCoordinateBounds(path: path)
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 80))

//            self.timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
        }
    }

    @objc func animatePolylinePath() {

        DispatchQueue.main.async(execute: {
            
            if (self.i < self.path.count()) {
                self.animationPath.add(self.path.coordinate(at: self.i))
                self.animationPolyline.path = self.animationPath
                self.animationPolyline.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                self.animationPolyline.strokeWidth = 3
                self.animationPolyline.map = self.mapView
                self.i += 1
            }
            else {
                self.i = 0
                self.animationPath = GMSMutablePath()
                self.animationPolyline.map = nil
            }
        })
    }



    // MARK: - Navigation

    func hideAndShowView(view: HomeViews){
        locationView.isHidden = true
        //        containerRideConfirmation.isHidden = !(view == .rideConfirmation)
        driverInfoContainerView.isHidden = !(view == .requestAccepted || view == .waiting || view == .rideStart)
        driverRatingContainerView.isHidden = !(view == .ratings || view == .askForTip)
        carListContainerView.isHidden = !(view == .booking)
        containerView.isHidden = (view == .none)
        viewSetup(view: view)
    }

    func viewSetup(view type: HomeViews){
        switch type{
        case .requestAccepted:
            guard let driverVC = self.driverInfoVC else { return }
            driverVC.viewWaiting.isHidden = true
            driverVC.cancelBtn.isHidden = false
            driverVC.setData(bookingData: self.booingInfo)
        case .waiting :
            guard let driverVC = self.driverInfoVC else { return }
            driverVC.viewWaiting.isHidden = false
            driverVC.cancelBtn.isHidden = true
            driverVC.setData(bookingData: self.booingInfo)
        case .rideStart:
            guard let driverVC = self.driverInfoVC else { return }
            driverVC.viewWaiting.isHidden = true
            driverVC.cancelBtn.isHidden = true
            driverVC.setData(bookingData: self.booingInfo)
        case .ratings:
            guard let driverVC = self.ratingInfoVC else { return }
            driverVC.viewType = .ratings
            driverVC.setData(bookingData: self.booingInfo)
        case .askForTip:
            guard let driverVC = self.ratingInfoVC else { return }
            driverVC.viewType = .askForTip
            driverVC.setData(bookingData: self.booingInfo)
        default:
            break
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? DriverInfoPageViewController{
            driverInfoVC = vc
            return
        }
        
        if let vc = segue.destination as? DriverRatingAndTipViewController{
            ratingInfoVC = vc
            return
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    func webserviceForAddToFavouriteAddress(addresType: String) {
        
        let model = addFavouriteAddressReqModel()
        model.customer_id = SingletonClass.sharedInstance.loginData.id
        model.dropoff_lat = "\(destinationLocation.latitude)"
        model.dropoff_lng = "\(destinationLocation.longitude)"
        model.dropoff_location = txtDropLocation.text ?? ""
        model.favourite_type = addresType
        model.pickup_lat = "\(pickupLocation.latitude)"
        model.pickup_lng = "\(pickupLocation.longitude)"
        model.pickup_location = txtPickupLocation.text ?? ""
        
        UserWebserviceSubclass.addFavouriteAddressListService(Promocode: model) { (response, status) in
            print(response)
            if status {
                UtilityClass.showAlert(title: AppName.kAPPName, message: response.dictionary?["message"]?.stringValue ?? "", alertTheme: .success)
            } else {
                UtilityClass.showAlert(title: AppName.kAPPName, message: response.dictionary?["message"]?.stringValue ?? "", alertTheme: .error)
            }
        }
    }
    
    
}


// MARK:- CLLocationManagerDelegate
//1
extension HomeViewController: CLLocationManagerDelegate {

    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            break
        case .denied:
            //            mapView.isHidden = false
            break
        case .notDetermined:
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            print("")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print (error)
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        defaultLocation = location
//        self.getAddressForLatLng(latitude: "\(defaultLocation.coordinate.latitude)", Longintude: "\(defaultLocation.coordinate.longitude)", markerType: .pickUp)
        if(!stopAnimatingCamera)
        {
            stopAnimatingCamera = true
            mapView.camera = GMSCameraPosition(target: defaultLocation.coordinate, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
        }
        
        
        if SocketIOManager.shared.socket.status == .connected {
            
            self.emitSocket_UpdateCustomerLatLng(param: ["customer_id": SingletonClass.sharedInstance.loginData.id ?? "", "lat": location.coordinate.latitude, "lng": location.coordinate.longitude])
        }
        
    }
}


// MARK: - GMSAutocompleteViewControllerDelegate
extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        if(isPickupLocation)
        {
            txtPickupLocation.text = "\(place.name ?? "") \(place.formattedAddress ?? "")"
            pickupLocation = place.coordinate
            
            pickupAndDropoffAddress.pickUp = txtPickupLocation.text ?? ""
        }
        else
        {
            txtDropLocation.text = "\(place.name ?? "") \(place.formattedAddress ?? "")"
            destinationLocation = place.coordinate
            pickupAndDropoffAddress.dropOff = txtDropLocation.text ?? ""
        }


        if(txtDropLocation.text?.isEmpty == false)
        {
            viewPickupLocation.isHidden = false
        }

        if(txtDropLocation.text?.isEmpty == false && txtPickupLocation.text?.isEmpty == false)
        {
            hideBookLaterButtonFromDroplocationField = true
        }
        else
        {
            hideBookLaterButtonFromDroplocationField = false
        }
        
        if txtPickupLocation.text != "" && txtDropLocation.text != "" {
            
            let param: [String: Any] = ["customer_id" : SingletonClass.sharedInstance.loginData.id ?? "",
                                        "pickup_lng":pickupLocation.longitude,
                                        "pickup_lat":pickupLocation.latitude,
                                        "dropoff_lat":destinationLocation.latitude,
                                        "dropoff_lng":destinationLocation.longitude]
            
            self.emitSocket_GetEstimateFare(param: param)
        }
        self.routeDrawMethod(origin: "\(pickupLocation.latitude),\(pickupLocation.longitude)", destination: "\(destinationLocation.latitude),\(destinationLocation.longitude)")
//        self.routeDrawMethod(origin: txtPickupLocation.text, destination: txtDropLocation.text)
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    func clearMap() {
        
        self.mapView.clear()
//        self.driverMarker = nil
        self.mapView.delegate = self
        
//        self.destinationLocationMarker.map = nil
        
        //        self.mapView?.stopRendering()
        //        self.mapView = nil
    }
    
    /// Setup After Complete trip or Cancel trip
    func setupAfterComplete() {
        
        self.txtDropLocation.text = ""
        self.currentLocationAction()
        self.carListContainerView.isHidden = false
        self.driverInfoContainerView.isHidden = true
        self.driverRatingContainerView.isHidden = true
        self.viewPickupLocation.isHidden = true
        self.viewDropOffLocation.isHidden = false
        self.containerView.isHidden = true
        self.hideBookLaterButtonFromDroplocationField = false
        
        locationView.isHidden = false
        mapView.isMyLocationEnabled = true
        
        
        if let VC = self.children.first as? CarCollectionViewController {
    
            VC.btnBookNow.setTitle("Book Now", for: .normal)
            VC.strPromoCode = ""
            VC.vehicleId = ""
        }
    }
}
