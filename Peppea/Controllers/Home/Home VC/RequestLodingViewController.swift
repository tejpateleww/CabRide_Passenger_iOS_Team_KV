//
//  RequestLodingViewController.swift
//  Peppea
//
//  Created by EWW074 on 07/02/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RequestLodingViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var viewActivityAnimation: NVActivityIndicatorView!
    
    // MARK: - Variable
    var customerId = ""
    var bookingId = ""
    var parentVc : UIViewController?
    
    // MARK: - Base Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewActivityAnimation.startAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewActivityAnimation.stopAnimating()
    }
    
    // MARK: - Action
    
    @IBAction func btnBookingRequestCancelAction(_ sender: UIButton) {
        
        viewActivityAnimation.stopAnimating()
        let param = ["customer_id":customerId, "booking_id":bookingId]

        if let homeVC = parentVc as? HomeViewController {
            homeVC.emitSocket_CancelBookingBeforeAccept(param: param)
        }
        
        viewActivityAnimation.stopAnimating()
        if isModal() {            
            self.dismiss(animated: false, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }

}
