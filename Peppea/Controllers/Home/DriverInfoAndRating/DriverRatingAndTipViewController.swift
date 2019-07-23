//
//  DriverRatingAndTipViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 04/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import Cosmos

class DriverRatingAndTipViewController: UIViewController {

    @IBOutlet weak var imgDriverImage: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var btnTip20: UIButton!
    @IBOutlet weak var btnTip30: UIButton!
    @IBOutlet weak var btnTip40: UIButton!

    @IBOutlet weak var btnDone: ThemeButton!
    @IBOutlet var btnTips: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

       
        // Do any additional setup after loading the view.
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for btn in self.btnTips
        {
            btn.borderWidth = 1.0
            btn.borderColor = ThemeColor
            btn.layer.cornerRadius = btn.frame.size.width/2
            btn.layer.masksToBounds = true
            btn.titleLabel?.font = UIFont.regular(ofSize: 12)
            btn.setTitleColor(ThemeColor, for: .normal)
        }
    }

    func setupView()
    {
        viewRating.settings.filledImage = UIImage(named: "iconSelectedstar")
        viewRating.settings.emptyImage = UIImage(named: "iconUnSelectedstar")
        viewRating.settings.starSize = 30
        viewRating.settings.starMargin = 5
    }


    @IBAction func btnDone(_ sender: Any) {
        let homeVC = self.parent as? HomeViewController
        homeVC?.containerView.isHidden = true
        homeVC?.viewPickupLocation.isHidden = true
        homeVC?.hideBookLaterButtonFromDroplocationField = false
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
