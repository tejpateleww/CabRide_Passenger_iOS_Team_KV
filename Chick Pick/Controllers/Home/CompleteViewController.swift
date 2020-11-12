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
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setTotal(strTotal: String) {
        lblTotal.text = "Total: \(Currency)\(strTotal)"
    }
    @IBAction func btnOkAction(_ sender: Any) {
        let homeVC = self.parent as? HomeViewController
        homeVC?.hideAndShowView(view: .ratings)
    }
}
