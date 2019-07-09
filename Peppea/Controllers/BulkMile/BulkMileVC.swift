//
//  BulkMileVC.swift
//  Peppea
//
//  Created by EWW80 on 08/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class BulkMileVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var cardTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
      cardTableView.register(UINib(nibName: "BulkMileTableViewCell", bundle: nil), forCellReuseIdentifier: "BulkMileTableViewCell")
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BulkMileTableViewCell", for: indexPath) as! BulkMileTableViewCell
        cell.btnPurchase.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
         cell.btnPurchase.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        print(buttonTag)
    }

}
