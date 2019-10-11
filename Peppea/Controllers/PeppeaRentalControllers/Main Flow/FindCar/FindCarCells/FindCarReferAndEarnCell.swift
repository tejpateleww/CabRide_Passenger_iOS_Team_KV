//
//  FindCarReferAndEarnCellTableViewCell.swift
//  Peppea
//
//  Created by EWW078 on 01/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class FindCarReferAndEarnCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setUpUI() {
        
        self.cellView.layer.cornerRadius = 8.0
        //Note: As we have added shaddow by "Custom Class", not to give masks to bounds
//        self.cellView.layer.masksToBounds = true
        
        self.cellView.borderWidth = 1.5
        self.cellView.borderColor = UIColor.lightGray
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
