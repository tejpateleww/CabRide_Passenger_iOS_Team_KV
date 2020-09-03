//
//  SearchForCompanyViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 27/08/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

protocol SearchForCompanyViewControllerDelegate {
    func didSelectCompanyName(dictCompanyDetails : [String:Any])
}

class SearchForCompanyViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {

    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    var arrCompanyLists = [[String:Any]]()
    var arrfilteredTableData = [[String:Any]]()
    var isFilteredData = Bool()
    var delegate : SearchForCompanyViewControllerDelegate!
    @IBOutlet weak var tblCompanyLists: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.delegate = self

        navigationItem.titleView = searchBar

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }


    // ----------------------------------------------------
    // MARK:- Tableview Delegate and Datasource methods
    // ----------------------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFilteredData)
        {
            return arrfilteredTableData.count
        }
        return arrCompanyLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        var dictData = arrCompanyLists[indexPath.row]
        if(isFilteredData)
        {
            dictData = arrfilteredTableData[indexPath.row]
        }

        cell.textLabel?.text = (dictData["company_name"] as! String)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var dictData = arrCompanyLists[indexPath.row]
        if(isFilteredData)
        {
            dictData = arrfilteredTableData[indexPath.row]
        }

        delegate?.didSelectCompanyName(dictCompanyDetails: dictData)

        self.dismiss(animated: true, completion: nil)
    }


    // ----------------------------------------------------
    // MARK:- Searchbar Delegate Methods
    // ----------------------------------------------------
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(searchString?.count == 0)
        {
            isFilteredData = false

        }
        else
        {
            isFilteredData = true
            arrfilteredTableData = arrCompanyLists.filter({($0["company_name"] as! String).lowercased().contains(searchString!.lowercased())})
        }


        self.tblCompanyLists.reloadData()
        //        print(arrfilteredTableData)
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
