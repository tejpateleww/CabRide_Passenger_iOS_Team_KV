//
//  HistoryFilterPopUpViewController.swift
//  Peppea
//
//  Created by eww090 on 12/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class HistoryFilterPopUpViewController: BaseViewController
{

    
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var txtFromDate: SkyFloatingLabelTextField!
     @IBOutlet weak var txtToDate: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
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
