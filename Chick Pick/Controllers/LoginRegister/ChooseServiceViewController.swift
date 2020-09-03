//
//  ChooseServiceViewController.swift
//  PepPea
//
//  Created by Mayur iMac on 08/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import MultiSlider
class ChooseServiceViewController: UIViewController {

    @IBOutlet weak var chooseService: MultiSlider!
    @IBOutlet weak var btnLogout : UIButton!
    @IBOutlet weak var btnCheckForDefaultScreen : UIButton!
    @IBOutlet weak var viewContainer : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        UtilityClass.setCornerRadiusButton(button: btnLogout, borderColor: .white, bgColor: .clear, textColor: .white)
//        self.setUpButton(button: btnCheckForDefaultScreen)
        viewContainer.layer.cornerRadius = viewContainer.frame.width/2
        viewContainer.layer.masksToBounds = true

    }

    func setUpButton(button: UIButton)
    {
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
    }
    

    func setupSlider()
    {
        self.chooseService.thumbCount = 1
        self.chooseService.addTarget(self, action: #selector(sliderChanged(_:)), for: .touchUpInside)
        self.chooseService.trackWidth = (viewContainer.frame.width)
        self.chooseService.backgroundColor = .clear
        self.chooseService.tintColor = .clear
        self.chooseService.maximumValue = 5.0
        self.chooseService.minimumValue = 0.0
        self.chooseService.thumbImage = UIImage(named: "imgSliderImage")
        self.chooseService.value = [2.5]


    }

    @IBAction func btnDidSelectDefault(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    @objc func sliderChanged(_ slider: MultiSlider) {
        if (slider.value.first == 5.0) {
            chooseService.value = [5.0]
            didSelectTaxi(status: false)
        } else if (slider.value.first == 0.0){
            chooseService.value = [0]
            didSelectTaxi(status: true)
        } else {
            chooseService.value = [2.5]
        }
    }

    func didSelectTaxi(status : Bool)
    {
        var dictStatus = [String:Bool]()
        dictStatus["didSelectTaxi"] = status
        dictStatus["isDefaultScreen"] = btnCheckForDefaultScreen.isSelected
        UserDefaults.standard.set(dictStatus, forKey: "didSelectTaxiStatus")

        if(status == false)
        {
            UtilityClass.showDefaultAlertView(withTitle: "Upcoming", message: "Launching in January 2020. Prepare A car for Hire and make money", buttons: ["OK"]) { (value) in
                self.chooseService.value = [2.5]
            }
        }
        else
        {
            (UIApplication.shared.delegate as! AppDelegate).GoToHome()

        }
    }

    @IBAction func btnLogOut(_ sender: Any) {

         (UIApplication.shared.delegate as! AppDelegate).GoToLogout()
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
