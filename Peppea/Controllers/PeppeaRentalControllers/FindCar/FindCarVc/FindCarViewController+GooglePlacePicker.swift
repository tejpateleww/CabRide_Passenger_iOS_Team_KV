//
//  FindCarViewController+GoogleAutoComplete.swift
//  Peppea
//
//  Created by EWW078 on 03/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import GooglePlaces


extension FindCarViewController : GMSAutocompleteViewControllerDelegate {
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
//        print("Place attributions: \(place.attributions)")
        
        self.selectedPlace = place
        //For reloading name in it
        self.tblView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)

    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    
    //Custom" Method
    
    func openGooglePlacePicker() {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

//        autocompleteController.autocompleteBounds = bounds

        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//            UInt(GMSPlaceField.placeID.rawValue))!
//        autocompleteController.placeFields = fields
        
        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .address
//        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
    
    
    
}
