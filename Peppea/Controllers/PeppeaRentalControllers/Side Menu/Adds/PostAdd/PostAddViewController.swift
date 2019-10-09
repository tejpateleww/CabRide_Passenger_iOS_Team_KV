//
//  PostAddViewController.swift
//  Peppea
//
//  Created by EWW078 on 09/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class PostAddViewController: BaseViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var carNameTxtField: UITextField!
    
    
    
    @IBOutlet weak var btnAddVehicle: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavBarWithBack(Title: "Post a Add", IsNeedRightButton: false)
    }
    
    func setUpUI() {
        
        self.btnAddVehicle.layer.cornerRadius = self.btnAddVehicle.frame.height / 2.0
        self.btnAddVehicle.layer.masksToBounds = true
    }

    @IBAction func selectProfilePicButtonClicked(_ sender: Any) {
        
        
        
    }
    
}
