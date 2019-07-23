//
//  PeppeaBusinessBannerViewController.swift
//  Peppea
//
//  Created by eww090 on 13/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class PeppeaBusinessBannerViewController: BaseViewController
{

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarWithBack(Title: "", IsNeedRightButton: false)
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
    
    
    @IBAction func btnGetStartedClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PeppeaBusinessSetupViewController") as! PeppeaBusinessSetupViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
