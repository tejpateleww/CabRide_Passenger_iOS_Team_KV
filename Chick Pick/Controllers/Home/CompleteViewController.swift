//
//  CompleteViewController.swift
//  Chick Pick
//
//  Created by EWW071 on 10/11/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblFair: UILabel!
    @IBOutlet weak var lblCharge: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setTotal(strTotal: String, strFair: String, strCahrge: String) {
        if strCahrge == "0" || strCahrge == "" {
            lblFair.isHidden = true
            lblCharge.isHidden = true
        } else {
            lblFair.isHidden = false
            lblCharge.isHidden = false
        }
        lblTotal.isHidden = false
        lblTotal.text = "Total: \(Currency)\(strTotal)"
        lblFair.text = "Trip Fair: \(Currency)\(strFair)"
        lblCharge.text = "Cancellation Charge: \(Currency)\(strCahrge)"
    }
    @IBAction func btnOkAction(_ sender: Any) {
        let homeVC = self.parent as? HomeViewController
        homeVC?.hideAndShowView(view: .ratings)
    }
}
