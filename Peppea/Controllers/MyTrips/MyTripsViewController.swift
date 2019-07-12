//
//  MyTripsViewController.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 04/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class MyTripsViewController: BaseViewController
{
  
    @IBOutlet weak var collectionTableView: HeaderTableViewController!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionTableView()
        data = tripType.getDescription()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavBarWithBack(Title: "My Trips", IsNeedRightButton: false)
       
    }
    var tripType = MyTrips.past
    var data = [(String, String)]()
    
    
    private func setCollectionTableView(){
        collectionTableView.isSizeToFitCellNeeded = true
        collectionTableView.indicatorColor = .black
        collectionTableView.titles = MyTrips.titles
        collectionTableView.parentVC = self
        collectionTableView.indicatorColor = .black
        collectionTableView.textColor = .black
        collectionTableView.registerNibs = [MyTripTableViewCell.identifier,
                                            MyTripDescriptionTableViewCell.identifier,
                                            FooterTableViewCell.identifier]
        collectionTableView.cellInset = UIEdgeInsets.zero
        collectionTableView.spacing = 0
        
        collectionTableView.didSelectItemAt = {
            indexpaths in
            if indexpaths.indexPath != indexpaths.previousIndexPath{
                self.tripType = MyTrips.allCases[indexpaths.indexPath.item]
                self.data = self.tripType.getDescription()
                self.selectedCell = []
                self.collectionTableView.tableView.removeAllSubviews()
                self.collectionTableView.tableView.reloadData()
            }
        }
    }
    var selectedCell = [Int]()
}

extension MyTripsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedCell.contains(section){
            return 1 + data.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.identifier)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCell.contains(indexPath.section){
           let index = selectedCell.firstIndex(of: indexPath.section)
            selectedCell.remove(at: index!)
            tableView.removeAllSubviews()
            tableView.reloadData()
        }
        else{
            selectedCell.append(indexPath.section)
            tableView.reloadData()
            let rect =  tableView.rect(forSection: indexPath.section)
            let imageView = UIImageView(frame: CGRect(x: 10, y: rect.minY, width: rect.width - 20, height: rect.height))
//            imageView.image = #imageLiteral(resourceName: "bird-icon")
            imageView.alpha = 0.8
            imageView.contentMode = .scaleAspectFit
            tableView.removeAllSubviews()
            tableView.addSubview(imageView)
        }
        if indexPath.section == 9{
             tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTripTableViewCell.identifier, for: indexPath) as! MyTripTableViewCell
            cell.setup()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTripDescriptionTableViewCell.identifier, for: indexPath) as! MyTripDescriptionTableViewCell
            cell.lblTitle.text = data[indexPath.row - 1].0 + ":"
            cell.lblDescription.text = data[indexPath.row - 1].1
            let color = indexPath.row == data.count ? UIColor.orange : UIColor.white
            cell.lblDescription.textColor = color
            cell.lblTitle.textColor = color
            cell.setup()
            return cell
        }
    }
    
    
    
}
