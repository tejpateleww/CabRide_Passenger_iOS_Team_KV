//
//  MyMileVC.swift
//  Peppea
//
//  Created by EWW80 on 08/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class MyMileVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

    @IBOutlet weak var mymileTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        mymileTableView.register(UINib(nibName: "MyMileTableViewCell", bundle: nil), forCellReuseIdentifier: "MyMileTableViewCell")
        let headerNib = UINib.init(nibName: "HeaderView", bundle: Bundle.main)
        mymileTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }
    
    
    func setNavigationItem() {
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 15, width: 40, height: 40))
        //        imageView.contentMode = .scaleAspectFit
        //        let image = UIImage(named: "iconBird")?.withRenderingMode(.alwaysOriginal)
        //        imageView.image = image
        //        let item = UIBarButtonItem(customView: imageView)
        //        self.navigationItem.rightBarButtonItem = item
        
        let barButton = UIButton()
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        backButton.setImage(UIImage(named: "iconBird"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        barButton.addSubview(backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMileTableViewCell", for: indexPath) as! MyMileTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
}
