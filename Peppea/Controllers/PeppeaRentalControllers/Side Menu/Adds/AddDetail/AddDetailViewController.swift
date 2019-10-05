//
//  AddDetailViewController.swift
//  Peppea
//
//  Created by EWW078 on 05/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class AddDetailViewController: BaseViewController {

     var topBarHeight: CGFloat = 0.0
    @IBOutlet weak var topConstraintContainerView: NSLayoutConstraint!

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblView.tableFooterView = UIView()
        
        self.btnSave.layer.cornerRadius = self.btnSave.frame.height / 2.0
        self.btnSave.layer.masksToBounds = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavBarWithBack(Title: "Add Details", IsNeedRightButton: false)
        
        self.title = "Add Details"
        
        //Transperant
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        ///Note: For setting left ar button item's color to white
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        //Naviugatipm bar title color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        ///Stretching Top constraint of a Top View.
        let navigationbarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        let StatusBarHeight = UIApplication.shared.statusBarFrame.height
        topBarHeight = navigationbarHeight + StatusBarHeight
        self.topConstraintContainerView.constant = 0 - topBarHeight

    }
    
}

extension AddDetailViewController : UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var customCell = UITableViewCell()
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDetailHeaderCell") as! AddDetailHeaderCell
            
            
            cell.selectionStyle = .none
            
            customCell = cell
        }
        else  if indexPath.section == 1 {
            
             let cell = tableView.dequeueReusableCell(withIdentifier: "AddDetailsDropDownCell") as! AddDetailsDropDownCell

            cell.detailTypeLbl.text = "Vehicle Model"
            
            customCell = cell
        }
        else  if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDetailsDropDownCell") as! AddDetailsDropDownCell
            
            cell.detailTypeLbl.text = "Charge Per KM"
            
            customCell = cell
        }
        else  if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDetailsDropDownCell") as! AddDetailsDropDownCell
            
            cell.detailTypeLbl.text = "No of. Seats"
            
            customCell = cell
        }

       
       
        customCell.selectionStyle = .none
        return customCell
        
    }
    
}


extension AddDetailViewController : UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        tblView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if indexPath.section == 0 {
        
            ///HEader cEll
            return 223 + topBarHeight
        }
        else {

            return 60.0
        }

    }
    
}

