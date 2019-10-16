//
//  PostAddViewController.swift
//  Peppea
//
//  Created by EWW078 on 09/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class PostAddViewController: BaseViewController, ImagePickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
    

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var carNameTxtField: UITextField!
    
    var imagePicker: ImagePicker!

    
    @IBOutlet weak var btnAddVehicle: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
//        self.imagePicker = ImagePicker.present(<#T##ImagePicker#>)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavBarWithBack(Title: "Post a Add", IsNeedRightButton: false)
        self.navigationItem.title = "Post a Add"
        
        profileImageView.image = profileImageView.image?.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = ThemeColor
    }
    
    func setUpUI() {
        
        self.btnAddVehicle.layer.cornerRadius = self.btnAddVehicle.frame.height / 2.0
        self.btnAddVehicle.layer.masksToBounds = true
    }

    @IBAction func selectProfilePicButtonClicked(_ sender: UIButton) {
        
        self.imagePicker.present(from: self.view)

        
        
    }
    
    
    func didSelect(image: UIImage?) {
        
        self.profileImageView.image = image
    }
    
}

