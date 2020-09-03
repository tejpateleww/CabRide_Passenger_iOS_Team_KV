//
//  SettingsViewController.swift
//  Chick Pick
//
//  Created by EWW071 on 28/08/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var arrMenuTitle = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarWithBack(Title: "Settings", IsNeedRightButton: false)
        
        tableView.delegate = self
        tableView.dataSource = self

        arrMenuTitle = ["Profile", "Change Password", "Help", "FAQ"]
    }
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenuTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ThemeOrange
        
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell") as! ContentTableViewCell
        cellMenu.selectionStyle = .none
        cellMenu.lblTitle.text = arrMenuTitle[indexPath.row]
        
        return cellMenu
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrMenuTitle[indexPath.row] == "Profile"
        {
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
            return
        }
        
        if arrMenuTitle[indexPath.row] == "Change Password"
        {
            let storyborad = UIStoryboard(name: "LoginRegister", bundle: nil)
            let ChangePwVC = storyborad.instantiateViewController(withIdentifier: "ChangePwVC") as! ChangePwVC
            self.navigationController?.pushViewController(ChangePwVC, animated: true)
            return
        }
        
        if arrMenuTitle[indexPath.row] == "Help"
        {
            
            return
        }
        
        if arrMenuTitle[indexPath.row] == "FAQ"
        {
           
            return
        }
    }
}
