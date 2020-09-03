//
//  FilterByViewController.swift
//  Peppea
//
//  Created by EWW078 on 09/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class FilterByViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func checkBoxTypeButtonClicked(_ sender: Any) {
        
        let button = sender as! UIButton
        
        button.isSelected = !button.isSelected
        
//        if button.isSelected {
//            
//            //Deselecting
//            button.isSelected = false
//            button.tintColor = UIColor.darkGray
//        }else{
//            
//            button.isSelected = true
//            button.tintColor = ThemeColor
//            
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
