//
//  HistoryListViewController.swift
//  Peppea
//
//  Created by eww090 on 10/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class HistoryListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{

    
     @IBOutlet weak var tableView: UITableView!
     var arrHistoryData = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "iconFilter"), style: .plain, target: self, action: #selector(self.btnFilterClicked(_:)))
        
        self.navigationItem.rightBarButtonItem = rightNavBarButton
          self.setNavBarWithBack(Title: "History", IsNeedRightButton: false)
         self.navigationItem.rightBarButtonItem?.tintColor = .black
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnFilterClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryFilterPopUpViewController") as! HistoryFilterPopUpViewController
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
        cellMenu.selectionStyle = .none
        
        return cellMenu
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
    

}
