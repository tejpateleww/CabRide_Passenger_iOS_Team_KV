//
//  ThemeButton.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class ThemeButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.size.height/2
        self.backgroundColor = ThemeColor
        self.setTitleColor(.white, for: .normal)
    }

    var isVehicleAvailable: Bool = false {
        didSet {
            if isVehicleAvailable {
                let str = "Book Now".withTextColor(.white).withBackgroundColor(ThemeColor)
                self.setAttributedTitle(str, for: .normal)
//                self.setTitle("Book Now", for: .normal)
//                self.setTitleColor(ThemeColor, for: .normal)
                self.backgroundColor = ThemeColor
                
                self.titleLabel?.font = UIFont.bold(ofSize: 18)
            } else {
                let str = "Not Available".withTextColor(.white).withBackgroundColor(ThemeColor)
                self.setAttributedTitle(str, for: .normal)
//                self.setTitle("Not Available", for: .normal)
//                self.setTitleColor(.white, for: .normal)
                self.backgroundColor = ThemeColor
                self.titleLabel?.font = UIFont.bold(ofSize: 18)
            }
        }
    }
    
}
