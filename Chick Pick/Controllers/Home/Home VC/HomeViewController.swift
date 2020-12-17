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
import NVActivityIndicatorView

import Alamofire
import SwiftyJSON

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

enum Rent_Type: String{
    case fix_rate = "fix_rate"
    case standard_rate = "standard_rate"
    case bulk_miles = "bulk_miles"
}

enum payment_type: String {
    case cash = "cash"
    case card = "card"
    case wallet = "wallet"
    case bulk_miles = "bulk_miles"
}

class HomeViewController: BaseViewController, GMSMapViewDelegate, didSelectDateDelegate, ARCarMovementDelegate
{

    //MARK:- IBOutles
    @IBOutlet var imgArrow: UIImageView!
    @IBOutlet var lblSwipeToBook: UILabel!
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
    @IBOutlet weak var viewMainActivityIndicator: UIView!
    @IBOutlet weak var viewActivityAnimation: NVActivityIndicatorView!
    
    let window = UIApplication.shared.keyWindow

    //MARK:- Variables
    var isPickupLocation = Bool()
    lazy var geocoder = CLGeocoder()
    var driverInfoVC : DriverInfoPageViewController?
    var ratingInfoVC : DriverRatingAndTipViewController?
    var completeVC : CompleteViewController?
    var nearByDrivers : [Driver]?
    var nearByDriversMarkerPins : [GMSMarker]?

    var stopAnimatingCamera = Bool()
    var mapView = GMSMapView()
    var pulseArray = [CAShapeLayer]()
    var booingInfo = BookingInfo()
    var selectedTimeStemp = ""
    var moveMent: ARCarMovement!
    var oldCoordinate : CLLocationCoordinate2D?
    /// Pickup and Dropoff Address
    var pickupAndDropoffAddress = (pickUp: "", dropOff: "")
    
//    var vehicleId = String()
//    var estimateFare = String()
//    var bookingType = String()
    var estimateData = [EstimateFare]()

    //MARk:- PolyLine Variables
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var NearByDriverTimer: Timer?
//    var EstimateTime: Timer!
//    var driverMarker: GMSMarker!
    var destinationMarker = GMSMarker()
    var pickupMarker : GMSMarker?
    var arrivedRoutePath: GMSPath?

    //MARK:- Location Manager
    let locationManager = CLLocationManager()
    var defaultLocation = CLLocation()
    var pickupLocation = CLLocationCoordinate2D()
    var destinationLocation = CLLocationCoordinate2D()
//    var zoomLevel: Float = 16.0
    var dictForRejectCurrentReq = (bookingId: "",customerId: "")
 


    //MARK:- Container viewcontrollers views
    @IBOutlet weak var carListContainerView: UIView!
    @IBOutlet weak var driverInfoContainerView: UIView!
    @IBOutlet weak var driverRatingContainerView: UIView!
    @IBOutlet weak var completeContainerView: UIView!


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
                (self.children.first as! CarCollectionViewController).getDataFromJSON()
            }
        }
    }

    var isExpandCategory:  Bool  = false {
        didSet {
            constraintStackViewBottom.constant = isExpandCategory ? 0 : (-containerHeightConstraint.constant + 135)

            if(isExpandCategory)
            {
                self.lblSwipeToBook.text = ""
                UIView.animate(withDuration: 0.2) {
                    self.imgArrow.transform = CGAffineTransform.identity
                }
            }
            else
            {
                self.lblSwipeToBook.text = "Swipe up to Book"
                UIView.animate(withDuration: 0.2) {
                    self.imgArrow.transform = CGAffineTransform(rotationAngle: .pi)
                }
            }


            self.view.endEditing(true)
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState], animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                
            }
        }
    }
    
    var PaymentType: String = payment_type.cash.rawValue
    var Card_id:String = ""
    var RentType:String = Rent_Type.standard_rate.rawValue
    var fixRateId:String = ""
    var BulkDistance:String = ""

    //MARK:- View Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewMainActivityIndicator.isHidden = true

        lblSwipeToBook.text = ""
        SocketIOManager.shared.establishConnection()
//        self.allSocketOnMethods()  // Added by Bhumi Jani
        
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
            
            if (self.booingInfo.bookingType == "book_now" || (self.booingInfo.bookingType == "book_later" && self.booingInfo.onTheWay == "1")) {
                
                self.routeDrawMethod(origin: "\(self.booingInfo.driverInfo.lat ?? ""),\(self.booingInfo.driverInfo.lng ?? "")", destination: "\(self.booingInfo.customerInfo.lat ?? ""),\(self.booingInfo.customerInfo.lng ?? "")", isTripAccepted: true)
                setupTripStatu(status: .accepted)
            }
            
        } else if self.booingInfo.status == "traveling" {
            self.routeDrawMethod(origin: "\(self.booingInfo.pickupLat ?? ""),\(self.booingInfo.pickupLng ?? "")", destination: "\(self.booingInfo.dropoffLat ?? ""),\(self.booingInfo.dropoffLng ?? "")", isTripAccepted: true)
             setupTripStatu(status: .traveling)
            
        } else if self.booingInfo.status == "completed" {
            setupTripStatu(status: .completed)
            
        } else {
            setupTripStatu(status: .pending)
        }
        
        self.setupNavigationController()
//        LocationTracker.shared.locateMeOnLocationChange { [weak self]  _  in
//            self?.moveCar()
//        }
        moveMent = ARCarMovement()
        moveMent.delegate = self

        self.perform(#selector(self.btnCurrentLocation(_:)), with: self, afterDelay: 1)
        _ = UIBarButtonItem(image: UIImage(named: "iconFavorite"), style: .plain, target: self, action: #selector(self.btnFavouriteAddress(_:)))
        self.navigationItem.rightBarButtonItem = nil
//        self.navigationItem.rightBarButtonItem = rightNavBarButton
        
        // openChatbox
        
        if let DriverInfoPage = self.children[1] as? DriverInfoPageViewController {
            DriverInfoPage.OpenChatBox = {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                viewController.strBookingId = self.booingInfo.id
                viewController.receiver_id =  "\(self.booingInfo.driverInfo.id ?? 0)"
                viewController.receiver_name = "\(self.booingInfo.driverInfo.firstName ?? "") \(self.booingInfo.driverInfo.lastName ?? "")"
                viewController.receiverImage = "\(NetworkEnvironment.baseImageURL + self.booingInfo.driverInfo.profileImage)"
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: 0, width: mapViewContainer.frame.width, height: mapViewContainer.frame.height)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.containerView.isHidden = false
        (self.children.first as! CarCollectionViewController).getDataFromJSON()
        viewMainActivityIndicator.layer.zPosition = 1
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (CLLocationManager.authorizationStatus() == .denied) || CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .notDetermined {
            let alert = UIAlertController(title: AppName.kAPPName, message: "Please enable location from settings", preferredStyle: .alert)
            let enable = UIAlertAction(title: "Enable", style: .default) { (temp) in
                
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(URL(string: "App-Prefs:root=Privacy&path=LOCATION") ?? url, options: [:], completionHandler: nil)
                }
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

    
    @IBAction func btnBookingRequestCancelAction(_ sender: UIButton) {
        
        viewMainActivityIndicator.isHidden = true
        viewActivityAnimation.stopAnimating()
        
        let param = ["customer_id":dictForRejectCurrentReq.customerId, "booking_id":dictForRejectCurrentReq.bookingId]        
        emitSocket_CancelBookingBeforeAccept(param: param)
    }
    
    // ----------------------------------------------------
    // MARK:- Timer methods
    // ----------------------------------------------------
    
    @objc func nearByDriversList() {
        let myLocation = SingletonClass.sharedInstance.myCurrentLocation
        
        let param = ["customer_id": SingletonClass.sharedInstance.loginData.id ?? "", "current_lng": myLocation.coordinate.longitude, "current_lat": myLocation.coordinate.latitude] as [String : Any]
        emitSocket_NearByDriver(param: param)
    }
    
    func startNearByDriverTimer() {
        if NearByDriverTimer == nil {
             NearByDriverTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(nearByDriversList), userInfo: nil, repeats: true)
        }
    }
    
    func stopNearByDriverTimer() {
        for marker in nearByDriversMarkerPins ?? [] {
            marker.map = nil
        }
        nearByDriversMarkerPins?.removeAll()
        
//        clearMap()
        NearByDriverTimer?.invalidate()
        NearByDriverTimer = nil
    }
    

    // ----------------------------------------------------
    // MARK:- Live Tracking of car methods
    // ----------------------------------------------------

    func moveCar() {
        if let myLocation = LocationTracker.shared.lastLocation,
            pickupMarker == nil {
            pickupMarker = GMSMarker(position: myLocation.coordinate)
            pickupMarker?.icon = UIImage(named: iconCar)
            pickupMarker?.map = self.mapView
            self.mapView.updateMap(toLocation: myLocation, zoomLevel: 16)
        } else if let myLocation = LocationTracker.shared.lastLocation, let myLastLocation = LocationTracker.shared.previousLocation {
            let degrees = myLastLocation.coordinate.bearing(to: myLocation.coordinate)
            
            if pickupMarker == nil {
                pickupMarker = GMSMarker(position: myLocation.coordinate)
                pickupMarker?.icon = UIImage(named: iconCar)
                pickupMarker?.map = self.mapView
                self.mapView.updateMap(toLocation: myLocation, zoomLevel: 16)
            }
            
            updateMarker(marker: pickupMarker!, coordinates: myLocation.coordinate, degrees: degrees, duration: 0.3)
        }
    }

    func updateMarker(marker: GMSMarker, coordinates: CLLocationCoordinate2D, degrees: CLLocationDegrees, duration: Double) {
        // Keep Rotation Short
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        marker.rotation = degrees
        marker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        CATransaction.commit()

        // Movement
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        marker.position = coordinates

        // Center Map View
        let camera = GMSCameraUpdate.setTarget(coordinates)
        mapView.animate(with: camera)

        CATransaction.commit()
    }

    //-------------------------------------------------------------
    // MARK: - ARCar Movement Delegate Method
    //-------------------------------------------------------------
    func arCarMovementMoved(_ Marker: GMSMarker) {
        pickupMarker = Marker
        pickupMarker?.map = mapView
    }


    // ----------------------------------------------------
    // MARK:-
    // ----------------------------------------------------
    
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
            startNearByDriverTimer()
        case .accepted:
            self.hideAndShowView(view: .requestAccepted)
            self.isExpandCategory = true
        case .traveling:
            self.hideAndShowView(view: .rideStart)
            self.isExpandCategory = true
        case .completed:
            //                self.hideAndShowView(view: .ratings)
            self.hideAndShowView(view: .completeTrip)
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
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: mapViewContainer.frame.width, height: mapViewContainer.frame.height))
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

    /*
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
 */

    func setupLocationManager()
    {
        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
            DispatchQueue.main.async {
                VC.btnBookNow.setAttributedTitle(nil, for: .normal)
                VC.btnBookNow.setTitle("Book Now", for: .normal)
                VC.strPromoCode = ""
                VC.promoCodeId = ""
                VC.vehicleId = ""
                VC.selectedTimeStemp = ""
                VC.isTripSchedule = false
                print("How \(VC)")
            }
        }
        else
        {
            print(self.children.first ?? "Hello")
        }
    
//        setupAfterComplete()
    }
    
    
    func CallForGetEstimate() {
        if self.txtPickupLocation.text != "" && self.txtDropLocation.text != "" { //&& self.booingInfo.id == "" { Commented by Bhumi jani as After complete trip emit call for estimate fare was not working and need to restart app everytime
            
            var promocode = "0"
            
            if let CarCollection = self.children[0] as? CarCollectionViewController {
                if CarCollection.promoCodeId.count > 0 {
                    promocode = CarCollection.promoCodeId
                }
            }
            let param: [String: Any] = ["customer_id" : SingletonClass.sharedInstance.loginData.id ?? "",
                                        "pickup_lng":pickupLocation.longitude,
                                        "pickup_lat":pickupLocation.latitude,
                                        "dropoff_lat":destinationLocation.latitude,
                                        "dropoff_lng":destinationLocation.longitude,
                                        "promocode_id":promocode]
            
            self.emitSocket_GetEstimateFare(param: param)
            let isLogin = UserDefaults.standard.bool(forKey: "isUserLogin")
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//                if self.booingInfo.id == nil || self.booingInfo.id == "" {
                if isLogin {
                    self.CallForGetEstimate()
                }
//                }
            }
        }
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
        }
    }
    func webserviceForCardList()
    {

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
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PeppeaBookLaterViewController") as! PeppeaBookLaterViewController
        next.delegateOfSelectDateAndTime = self
        self.navigationController?.present(next, animated: true, completion: nil)
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
    func currentLocationAction(isCurrentLocationTapped: Bool = false) {
        
        if isCurrentLocationTapped {
             clearMap()
        }
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        mapView.camera = camera

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
        locationManager.startUpdatingLocation()
        UtilityClass.hideHUD()
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
    
//    func tempPolyLine()
//    {
//        let geocoder = CLGeocoder()
//
//        geocoder.geocodeAddressString("SURAT", completionHandler: { placemarks, error in
//            if error == nil {
//                if (placemarks?.count ?? 0) > 0 {
//                    let placemark = placemarks?[0] as? CLPlacemark
//                    let location = placemark?.location
//                    let coordinate = location?.coordinate
//                    print("the coordinates are \(coordinate)")
//                }
//            }
//        })
//    }

    func routeDrawMethod(origin: String?, destination: String?, isTripAccepted : Bool)
    {
        arrivedRoutePath = nil
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                print("The direction URL is \(directionsURLString)")
                let directionsURL = NSURL(string: directionsURLString)
                DispatchQueue.main.async(execute: {
                    if let directionsData = NSData(contentsOf: directionsURL! as URL)
                    {
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            // get Distance between Pickup Location & Drop OFF Location
                            
                            if let routes = dictionary["routes"] as? [[String:Any]] {
                                if(routes.count != 0)
                                {
                                    if let RouteObject = routes[0]["legs"] as? [[String:Any]] {
                                        if let Distance = RouteObject[0]["distance"] as? [String:Any] {
                                            if let DistanceText = Distance["text"] as? String {
                                                let distance = DistanceText.components(separatedBy: " ")[0]
                                                if let CarCollection = self.children[0] as? CarCollectionViewController {
                                                    CarCollection.Distance = distance
                                                }
                                            } else {
                                                print("no")
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    return
                                }
                            }
                            let status = dictionary["status"] as! String

                            if status == "OK" {
                                
                                let strPickupCoordinate = origin?.components(separatedBy: ",")
                                var pickupDoubleLat = Double()
                                var pickupDoubleLng = Double()
                                
                                if let lat = strPickupCoordinate?[0], let doubleLat = Double(lat) {
                                    pickupDoubleLat = doubleLat
                                }
                                
                                if let lng = strPickupCoordinate?[1], let doubleLng = Double(lng) {
                                    pickupDoubleLng = doubleLng
                                }
                                
                                let pickupCoordinate = CLLocationCoordinate2D(latitude: pickupDoubleLat , longitude: pickupDoubleLng)
                                self.pickupMarker?.map = nil
                                self.pickupMarker = GMSMarker(position: pickupCoordinate) // self.originCoordinate
                                self.pickupMarker?.icon = isTripAccepted ? UIImage(named: iconCar) : UtilityClass.image(UIImage(named:iconMarker), scaledTo: CGSize(width: 30, height: 30))
                                self.pickupMarker?.map = self.mapView
                                 self.mapView.isMyLocationEnabled = true
                                if isTripAccepted
                                {
//                                    self.driverMarker = self.pickupMarker
//                                    self.pickupMarker.map = nil
                                    self.mapView.isMyLocationEnabled = false
                                }

                                let strDestinationCoordinate = destination?.components(separatedBy: ",")
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
                        catch {
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
            self.polyline.strokeColor = ThemeOrange // UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.polyline.strokeWidth = 3.0
            self.polyline.map = self.mapView
            self.arrivedRoutePath = GMSPath(fromEncodedPath: points as! String)!
            let bounds = GMSCoordinateBounds(path: path)
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 140))
        }
    }

    @objc func animatePolylinePath() {

        DispatchQueue.main.async(execute: {
            if (self.i < self.path.count()) {
                self.animationPath.add(self.path.coordinate(at: self.i))
                self.animationPolyline.path = self.animationPath
                self.animationPolyline.strokeColor = ThemeOrange //UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                self.animationPolyline.strokeWidth = 3
                self.animationPolyline.map = self.mapView
                self.i += 1
            } else {
                self.i = 0
                self.animationPath = GMSMutablePath()
                self.animationPolyline.map = nil
            }
        })
    }
    
    //MARK:- Map Methods
    
    func setNearByDriversOnMap() {
        
        for marker in nearByDriversMarkerPins ?? [] {
            marker.map = nil
        }
        nearByDriversMarkerPins?.removeAll()
        nearByDriversMarkerPins = [GMSMarker]()
        
        for data in nearByDrivers ?? [] {
            let lat = CLLocationDegrees(exactly: data.location.last!) ?? 0.0
            let lng = CLLocationDegrees(exactly: data.location.first!) ?? 0.0
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            print("location: \(location)")
            let marker = GMSMarker()
            marker.position = location
//            marker.snippet = data.name!
            marker.icon = UIImage(named: iconCar)
            marker.map = mapView
            
            nearByDriversMarkerPins?.append(marker)
        }
    }
    
    
    // MARK: - Navigation
    func hideAndShowView(view: HomeViews){
        locationView.isHidden = view == .booking ? false : true
//        containerRideConfirmation.isHidden = !(view == .rideConfirmation)
        driverInfoContainerView.isHidden = !(view == .requestAccepted || view == .waiting || view == .rideStart)
        driverRatingContainerView.isHidden = !(view == .ratings || view == .askForTip)
        carListContainerView.isHidden = !(view == .booking)
        completeContainerView.isHidden = !(view == .completeTrip)
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
            stopNearByDriverTimer()
            
        case .waiting :
            guard let driverVC = self.driverInfoVC else { return }
            driverVC.viewWaiting.isHidden = false
            driverVC.cancelBtn.isHidden = true
            driverVC.setData(bookingData: self.booingInfo)
            stopNearByDriverTimer()
            
        case .rideStart:
            guard let driverVC = self.driverInfoVC else { return }
            driverVC.viewWaiting.isHidden = true
            driverVC.cancelBtn.isHidden = true
            driverVC.setData(bookingData: self.booingInfo)
            stopNearByDriverTimer()
            
        case .completeTrip:
            guard let vc = self.completeVC else { return }
            vc.setTotal(strTotal: self.booingInfo.grandTotal, strFair: self.booingInfo.tripFare, strCahrge: self.booingInfo.pastDuePayment)
            stopNearByDriverTimer()
            
        case .ratings:
            guard let ratingVC = self.ratingInfoVC else { return }
            ratingVC.viewType = .ratings
            ratingVC.setData(bookingData: self.booingInfo)
            stopNearByDriverTimer()
            
        case .askForTip:
            guard let ratingVC = self.ratingInfoVC else { return }
            ratingVC.viewType = .askForTip
            ratingVC.setData(bookingData: self.booingInfo)
            stopNearByDriverTimer()
            
        default:
            startNearByDriverTimer()
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
        
        if let vc = segue.destination as? CompleteViewController{
            completeVC = vc
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
        model.favourite_type = addresType.lowercased()
        model.pickup_lat = "\(pickupLocation.latitude)"
        model.pickup_lng = "\(pickupLocation.longitude)"
        model.pickup_location = txtPickupLocation.text ?? ""
        
        UserWebserviceSubclass.addFavouriteAddressListService(Promocode: model) { (response, status) in
//            print(response)
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
        if(!stopAnimatingCamera)
        {
            stopAnimatingCamera = true
            mapView.camera = GMSCameraPosition(target: defaultLocation.coordinate, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
        }
        if SocketIOManager.shared.socket.status == .connected {
            self.emitSocket_UpdateCustomerLatLng(param: ["customer_id": SingletonClass.sharedInstance.loginData.id ?? "", "lat": location.coordinate.latitude, "lng": location.coordinate.longitude])
        }
    }


    func liveTrackingForTrip(lat : String , lng : String)
    {
        let newCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(lat) ?? 0.00) ?? 0.00, longitude:CLLocationDegrees(exactly: Double(lng) ?? 0.00) ?? 0.00)
        
        if pickupMarker == nil {
            self.pickupMarker = GMSMarker(position: newCoordinate) // self.originCoordinate
            self.pickupMarker?.icon = UIImage(named: iconCar) // isTripAccepted ? UIImage(named: iconCar) : UtilityClass.image(UIImage(named:iconMarker), scaledTo: CGSize(width: 30, height: 30))
            self.pickupMarker?.map = self.mapView
        }
        
        if self.arrivedRoutePath != nil {
            if !GMSGeometryIsLocationOnPathTolerance(pickupMarker!.position, self.arrivedRoutePath!, true, 200) {
                if self.booingInfo.status == "traveling" {
                    self.routeDrawMethod(origin: "\(lat),\(lng)", destination: "\(self.booingInfo.dropoffLat ?? ""),\(self.booingInfo.dropoffLng ?? "")", isTripAccepted: true)
                } else {
                    self.routeDrawMethod(origin: "\(lat),\(lng)", destination: "\(self.booingInfo.pickupLat ?? ""),\(self.booingInfo.pickupLng ?? "")", isTripAccepted: true)
                }
            }
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: newCoordinate.latitude, longitude: newCoordinate.longitude, zoom: zoomLevel)
        
        mapView.animate(to: camera)
       
        self.moveMent.arCarMovement(marker: pickupMarker!, oldCoordinate: oldCoordinate ?? newCoordinate, newCoordinate: newCoordinate, mapView: self.mapView)
        oldCoordinate = newCoordinate
    }
}


// MARK: - GMSAutocompleteViewControllerDelegate
extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if self.RentType == Rent_Type.fix_rate.rawValue {
            self.RemoveFlatRate()
        }
        
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
//            hideBookLaterButtonFromDroplocationField = false
        }
        
       
        if let CarCollection = self.children[0] as? CarCollectionViewController {
            CarCollection.FlatRate  = ""
            CarCollection.collectionView.reloadData()
        }
        
        if SocketIOManager.shared.socket.status == .connected {
            self.emitSocket_UpdateCustomerLatLng(param: ["customer_id": SingletonClass.sharedInstance.loginData.id ?? "", "lat": pickupLocation.latitude, "lng": pickupLocation.longitude])
        }
        self.CallForGetEstimate()
        
        self.routeDrawMethod(origin: "\(pickupLocation.latitude),\(pickupLocation.longitude)", destination: "\(destinationLocation.latitude),\(destinationLocation.longitude)", isTripAccepted: false)
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
        self.mapView.delegate = self
    }
    
    /// Setup After Complete trip or Cancel trip
    func setupAfterComplete() {
        self.booingInfo = BookingInfo()
        self.txtDropLocation.text = ""
        self.destinationLocation = CLLocationCoordinate2D()
        self.currentLocationAction()
        self.carListContainerView.isHidden = false
        self.driverInfoContainerView.isHidden = true
        self.driverRatingContainerView.isHidden = true
        self.completeContainerView.isHidden = true
//        self.viewPickupLocation.isHidden = true
        self.viewDropOffLocation.isHidden = false
//        self.containerView.isHidden = true
//        self.hideBookLaterButtonFromDroplocationField = false
        
        locationView.isHidden = false
        mapView.isMyLocationEnabled = true
        self.estimateData = []
        
        if let VC = self.children.first as? CarCollectionViewController {
    
            VC.btnBookNow.setTitle("Book Now", for: .normal)
            VC.strPromoCode = ""
            VC.promoCodeId = ""
            VC.vehicleId = ""
            VC.stackViewPromoCode.isHidden = true
            VC.collectionView.reloadData()
            startNearByDriverTimer()
        }
    }
}



//MARK:- Fix Rates Delegate Method
extension HomeViewController : FlatRateDelegate {
    
    func RemoveFlatRate() {
        
        self.fixRateId = ""
        if self.RentType == Rent_Type.fix_rate.rawValue {
                self.RentType = Rent_Type.standard_rate.rawValue
        }
        
        if let CarCollection = self.children[0] as? CarCollectionViewController {
            CarCollection.FlatRate  = ""
            CarCollection.collectionView.reloadData()
        }
    }
    
    func SetFlatRateBooking(FlatRateObject: FlatRateData) {
        self.fixRateId = FlatRateObject.id
        self.RentType = Rent_Type.fix_rate.rawValue
        
        if let CarCollection = self.children[0] as? CarCollectionViewController {
            CarCollection.FlatRate  = FlatRateObject.rate
            CarCollection.FlatRateId = FlatRateObject.id
            CarCollection.RentType = self.RentType
            CarCollection.collectionView.reloadData()
        }
        
        
        txtPickupLocation.text = FlatRateObject.pickupLocation
        pickupLocation =  CLLocationCoordinate2D(latitude: (FlatRateObject.pickupLat as NSString).doubleValue, longitude: (FlatRateObject.pickupLng as NSString).doubleValue)
        pickupAndDropoffAddress.pickUp = txtPickupLocation.text ?? ""
        
        txtDropLocation.text = FlatRateObject.dropoffLocation
        destinationLocation =  CLLocationCoordinate2D(latitude: (FlatRateObject.dropoffLat as NSString).doubleValue, longitude: (FlatRateObject.dropoffLng as NSString).doubleValue)
        pickupAndDropoffAddress.dropOff = txtDropLocation.text ?? ""
        
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
        
        self.CallForGetEstimate()
        self.routeDrawMethod(origin: "\(pickupLocation.latitude),\(pickupLocation.longitude)", destination: "\(destinationLocation.latitude),\(destinationLocation.longitude)", isTripAccepted: false)
    }
}

extension HomeViewController: FavouriteLocationDelegate {
    func didEnterFavouriteDestination(Source: [String : AnyObject]) {
        txtDropLocation.text = Source["Address"] as? String
        
//        strDropoffLocation = Source["Address"] as! String
//        doubleDropOffLat = Double(Source["Lat"] as! String)!
//        doubleDropOffLng = Double(Source["Lng"] as! String)!
        
        
        pickupAndDropoffAddress.dropOff = Source["Address"] as! String
        
        destinationLocation = CLLocationCoordinate2D(latitude: Double(Source["Lat"] as! String)!, longitude: Double(Source["Lng"] as! String)!)
        
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
        
        if let CarCollection = self.children[0] as? CarCollectionViewController {
            CarCollection.FlatRate  = ""
            CarCollection.collectionView.reloadData()
        }
        
        if SocketIOManager.shared.socket.status == .connected {
            self.emitSocket_UpdateCustomerLatLng(param: ["customer_id": SingletonClass.sharedInstance.loginData.id ?? "", "lat": pickupLocation.latitude, "lng": pickupLocation.longitude])
        }
        
        self.CallForGetEstimate()
        
        self.routeDrawMethod(origin: "\(pickupLocation.latitude),\(pickupLocation.longitude)", destination: "\(destinationLocation.latitude),\(destinationLocation.longitude)", isTripAccepted: false)
    }
}


extension GMSMapView {
    func updateMap(toLocation location: CLLocation, zoomLevel: Float? = nil) {
        if let zoomLevel = zoomLevel {
            let cameraUpdate = GMSCameraUpdate.setTarget(location.coordinate, zoom: zoomLevel)
            animate(with: cameraUpdate)
        } else {
            animate(toLocation: location.coordinate)
        }
    }
}


extension CLLocationCoordinate2D {

    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }

        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)

        let lat2 = degreesToRadians(point.latitude);
        let lon2 = degreesToRadians(point.longitude);

        let dLon = lon2 - lon1;

        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        let degree = radiansToDegrees(radiansBearing)
        return (degree >= 0) ? degree : (360 + degree)
    }
}
