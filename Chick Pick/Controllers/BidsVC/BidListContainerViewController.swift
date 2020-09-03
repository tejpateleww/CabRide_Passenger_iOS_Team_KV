//
//  BidListContainerViewController.swift
//  Flivery User
//
//  Created by eww090 on 28/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class BidListContainerViewController: BaseViewController {
    
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var scrollObject: UIScrollView!
    @IBOutlet weak var viewLineHeight: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setNavBarWithBack(Title: "Bid List", IsNeedRightButton: false)
        
        let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "iconPlusBar"), style: .plain, target: self, action: #selector(self.addTapped))
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        // Do any additional setup after loading the view.
    }
    
    @objc func addTapped() {
        print("Add Tapped")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PostABidViewController") as! PostABidViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnMyBid(_ sender: Any) {
        
        scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        constraintLeading.constant = 0
    }
    
    @IBAction func btnOpenBid(_ sender: Any) {
        
        scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
        constraintLeading.constant = viewLineHeight.frame.width
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
