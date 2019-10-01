//
//  FindCarTrendingCarsCell.swift
//  Peppea
//
//  Created by EWW078 on 01/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class FindCarTrendingCarsCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension FindCarTrendingCarsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //        let numberOfCars = ( self.arrCarLists.vehicleTypeList.count > 3) ? 4 : 3
        
        let CellWidth = ( UIScreen.main.bounds.width - 10 ) / CGFloat(3)
        return CGSize(width: CellWidth , height: self.collectionView.frame.size.height)
        //        return CGSize(width: 50, height: 50)
    }
    
    
}
extension FindCarTrendingCarsCell :UICollectionViewDataSource {
    
    //MARK:-  --- CollectionView Delegate and Datasource Methods ---
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCarsCollectionViewCell", for: indexPath as IndexPath) as! TrendingCarsCollectionViewCell
        
        return cell
    }
    
    
    
    
    
    
}




extension FindCarTrendingCarsCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        if (self.arrCarLists.vehicleTypeList.count != 0 && indexPath.row < self.arrCarLists.vehicleTypeList.count)
//        {
//            let dictOnlineCars = arrCarLists.vehicleTypeList[indexPath.row]
//            vehicleId = dictOnlineCars.id
//            self.collectionView.reloadData()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
//        if (self.arrCarLists.vehicleTypeList.count != 0 && indexPath.row < self.arrCarLists.vehicleTypeList.count)
//        {
//            let dictOnlineCars = arrCarLists.vehicleTypeList[indexPath.row]
//            if let cell = self.collectionView.cellForItem(at: indexPath)  as? CarsCollectionViewCell
//            {
//                if let imageURL = dictOnlineCars.unselectImage //["Image"] as? String
//                {
//                    cell.imgOfCarModels.sd_setImage(with: URL(string: NetworkEnvironment.baseImageURL + imageURL), completed: nil) //.image = UIImage.init(named: imageURL)
//                }
//            }
//        }
    } //did deleselct item method ends here
} //Extension ends here
