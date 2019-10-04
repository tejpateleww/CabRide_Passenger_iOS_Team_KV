//
//  VehicleDetailMapViewCell.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 14/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit
import MapKit

class VehicleDetailMapViewCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet var viewCell: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var lblAddress: UILabel!
    
    var MapViewLatitude = Double()
    var MapViewlongitude = Double()
    var MapViewAddress:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.delegate  = self
        // Initialization code
    }
    
    
    func setUiSetUp() {
        
        self.viewCell.backgroundColor = UIColor.white
        self.viewCell.layer.shadowColor = UIColor.darkGray.cgColor
        self.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.viewCell.layer.shadowOpacity = 0.4
        self.viewCell.layer.shadowRadius = 1
        self.viewCell.layer.cornerRadius = 10
        self.viewCell.layer.masksToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPinonMap()
    {
//        let annotation = MKPointAnnotation()
        self.lblAddress.text = self.MapViewAddress
        let latitude  =  MapViewLatitude
        let longitude  =  MapViewlongitude
//        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        mapView.addAnnotation(annotation)
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: false)
    }
    
//    func mapView(_ mapView1: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
//    {
//        if !(annotation is MKUserLocation)
//        {
//            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
//            annotationView.image = UIImage(named:"Car_Target_pin")
//            return annotationView
//        }
//        return nil
//    }


}
