//
//  FilterCheckBoxButton.swift
//  Peppea
//
//  Created by EWW078 on 17/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class FilterCheckBoxButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.5
        
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true

        self.setImage(nil, for: .normal)
        self.setImage(UIImage(named: "check-mark"), for: .selected)
    
    }
    
    
    

}
