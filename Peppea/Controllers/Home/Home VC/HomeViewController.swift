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
    case filter
    case ratings
    case waiting
    case booking
    case none
}

class HomeViewController: BaseViewController {


    //MARK:- IBOutles
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropLocation: UITextField!
    @IBOutlet weak var btnBookLater: UIButton!
    @IBOutlet weak var mapViewContainer: UIView!

    @IBOutlet weak var viewPickupLocation: UIView!
    @IBOutlet weak var viewDropOffLocation: UIView!
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintStackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var markerView: UIImageView!
    @IBOutlet weak var markerContainerView: UIView!

    let window = UIApplication.shared.keyWindow

    //MARK:- Variables
    var isPickupLocation = Bool()
    lazy var geocoder = CLGeocoder()
    var driverInfoVC : DriverInfoPageViewController?
    var stopAnimatingCamera = Bool()
    var mapView = GMSMapView()
    //    lazy var marker = GMSMarker()
    var pulseArray = [CAShapeLayer]()


    //MARk:- PolyLine Variables
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!

    //MARK: Location Manager
    let locationManager = CLLocationManager()
    var defaultLocation = CLLocation()
    var zoomLevel: Float = 16.0


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

            //            if(hideBookLaterButtonFromDroplocationField == false)
            //            {
            //                self.containerView.isHidden = true
            //            }
            //            else
            //            {
            //                self.containerView.isHidden = false
            //            }
        }
    }

    var isExpandCategory:  Bool  = false {
        didSet {

            if !isExpandCategory {
                constraintStackViewBottom.constant = -containerHeightConstraint.constant + 50// + view.safeAreaInsets.bottom //+ headerHeightContraint.constant

            }
            else if isExpandCategory {
                constraintStackViewBottom.constant = 0
            }

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
        // Do any additional setup after loading the view.

        self.setupGoogleMaps()
        self.setupLocationManager()
        self.setupNavigationController()
        self.setupViewCategory()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = mapViewContainer.frame
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.timer.invalidate()
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
        //        let markerImage = UIImage(named: "iconPin")
        //        let markerView = UIImageView(image: markerImage)
        //        marker.position = defaultLocation.coordinate
        //        marker.iconView = markerView
        //        marker.map = mapView
        markerContainerView.isHidden = false
        markerContainerView.layer.cornerRadius = (markerContainerView.frame.size.width)/2.0
        mapView.isMyLocationEnabled = false
        //        createPulse()

    }

    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
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

    //MARK:- Pulse Methods

    func createPulse() {

        for _ in 0...2 {
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
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")

        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                var addressString:String = ""
                if let thoroughfare = placemark.thoroughfare, let City = placemark.locality, let State = placemark.administrativeArea, let Postalcode = placemark.postalCode , let country = placemark.country {
                    addressString = "\(thoroughfare), \(City), \(State) \(Postalcode), \(country)"
                }

                if(markerType == .pickUp)
                {
                    txtPickupLocation.text = addressString
                }
                else
                {
                    txtDropLocation.text = addressString
                }
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
                            self.drawRoute(routeDict: dictionary)
                        }
                    }
                    catch
                    {
                        print("error while drawing route")
                    }
                    }
                } )
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
        //        containerRideConfirmation.isHidden = !(view == .rideConfirmation)
        driverInfoContainerView.isHidden = !(view == .requestAccepted || view == .waiting)
        driverRatingContainerView.isHidden = !(view == .ratings)
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
        case .waiting :
            guard let driverVC = self.driverInfoVC else { return }
            driverVC.viewWaiting.isHidden = false
            driverVC.cancelBtn.isHidden = true
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
    }


}


// MARK: - CLLocationManagerDelegate
//1
extension HomeViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        //        mapView.isMyLocationEnabled = true
        //        mapView.settings.myLocationButton = false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        defaultLocation = location
        self.getAddressForLatLng(latitude: "\(defaultLocation.coordinate.latitude)", Longintude: "\(defaultLocation.coordinate.longitude)", markerType: .pickUp)
        if(!stopAnimatingCamera)
        {
            stopAnimatingCamera = true
            mapView.camera = GMSCameraPosition(target: defaultLocation.coordinate, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
        }
    }
}


// MARK: - GMSAutocompleteViewControllerDelegate
extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        if(isPickupLocation)
        {
            txtPickupLocation.text = "\(place.name ?? "") \(place.formattedAddress ?? "")"
        }
        else
        {
            txtDropLocation.text = "\(place.name ?? "") \(place.formattedAddress ?? "")"
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


        self.routeDrawMethod(origin: txtPickupLocation.text, destination: txtDropLocation.text)
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}



extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}