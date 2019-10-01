//
//  FindCarPickUpDateCell.swift
//  Peppea
//
//  Created by EWW078 on 30/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class FindCarPickUpDateCell: UITableViewCell {

    @IBOutlet weak var btnFindCar: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpUI() {
        
        self.btnFindCar.layer.cornerRadius = 8.0
        self.btnFindCar.layer.masksToBounds = true
        
    }
    @IBAction func findCarButtonClicked(_ sender: Any) {
    }
}
