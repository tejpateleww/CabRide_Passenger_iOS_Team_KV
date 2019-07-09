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
        self.setUpButton(button: btnCheckForDefaultScreen)

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
//        self.chooseService?.valueLabelPosition = .right
        self.chooseService.trackWidth = (viewContainer.frame.width)
        self.chooseService.backgroundColor = .clear
        self.chooseService.tintColor = .clear
        self.chooseService.maximumValue = 5.0
        self.chooseService.minimumValue = 0.0
//        self.chooseService.valueLabels
//        self.chooseService?.isValueLabelRelative = false
        self.chooseService.thumbImage = UIImage(named: "imgSliderImage")

        self.chooseService.value = [2.5]

    }


    @objc func sliderChanged(_ slider: MultiSlider) {
        if (slider.value.first == 5.0) {
            chooseService.value = [5.0]
        } else if (slider.value.first == 0.0){
            chooseService.value = [0]
        } else {
            chooseService.value = [2.5]
        }

//        print("\(slider.value)")
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
