//
//  ThemeTextField.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ThemeTextFieldLoginRegister: SkyFloatingLabelTextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedLineHeight = 1.0
        self.lineHeight = 0.5
        self.tintColor = ThemeColor
        self.selectedTitleColor = ThemeColor
        self.placeholderColor = ThemeColor
        self.textColor = ThemeColor
        self.font = UIFont.regular(ofSize: 15)
        self.titleFormatter = { $0 }
        
    }

}


class ThemeTextField : UITextField
{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.regular(ofSize: 15)
        self.textColor = ThemeColor
    }
}
