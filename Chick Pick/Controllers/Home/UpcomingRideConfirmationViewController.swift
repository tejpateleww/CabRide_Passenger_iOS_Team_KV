//
//  UpcomingRideConfirmationViewController.swift
//  Peppea
//
//  Created by eww090 on 13/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class UpcomingRideConfirmationViewController: UIViewController {

    
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var lblFromLocation: UILabel!
    @IBOutlet weak var lblToLocation: UILabel!
    @IBOutlet weak var lblBookingDate: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        viewPopUp.roundCorners([.topLeft, .topRight], radius: 10)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnOkClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    

}
