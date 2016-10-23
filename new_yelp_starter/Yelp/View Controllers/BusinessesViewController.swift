//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import MBProgressHUD


class BusinessesViewController: UIViewController {
    
    
    // Search Var
    var searchBar: UISearchBar!
    var searchKeys: SearchKeys?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var filters = [String : AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        if searchKeys == nil {
            searchKeys = SearchKeys()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Display HUD right before the request is made
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.label.text = "Loading Restaurant"
        
        Business.search(with: "Thai") { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                
                self.tableView.reloadData()
                // end refresh controll action when finish fetch data
                refreshControl.endRefreshing()
                
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                
            }
        }
        
        
        initSearchBar()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterSegue" {
            if let navController = segue.destination as? UINavigationController {
                let filterVC = navController.topViewController as! FiltersViewController
                filterVC.delegate = self
            }
        }
        else if segue.identifier == "mapSegue" {
            let nav = segue.destination as! UINavigationController
            let nextVC = nav.topViewController as! MapViewController
            
            let business = businesses
            nextVC.businesses = business
        }
        else if segue.identifier == "resDetailSegue" {
            let selectedRow = tableView.indexPathForSelectedRow?.row
            let des = segue.destination as! BusinessDetailViewController
            des.business = businesses[selectedRow!]
        }
    }
    
    func doSearch(searchKeys: SearchKeys) {
        Business.search(with: searchKeys.name, sort: nil, categories: nil, deals: nil) { (businesses: [Business]?, error: Error?) in
            
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
    }
}

// SEARCH FEATURE
extension BusinessesViewController: UISearchBarDelegate{
    
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.tintColor = UIColor.white
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchKeys?.name = searchBar.text
        searchKeys?.offset = 0
        doSearch(searchKeys: searchKeys!)
    }
}

// TABLEVIEW
extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
}

// DELEGATE
extension BusinessesViewController: FiltersViewControllerDelegate{
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateValue filters: [String : AnyObject]) {
        print("I got signal from filter")
        
        Business.search(with: "Thai", sort: filters["sort"].map { YelpSortMode(rawValue: $0 as! Int) }!, categories: filters["categories"] as! [String]?, deals: filters["deal"] as! Bool?) { (businesses: [Business]?, error: Error?) in
            
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // Display HUD right before the request is made
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.label.text = "Loading Restaurant"
        
        Business.search(with: "Thai") { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
                // end refresh controll action when finish fetch data
                refreshControl.endRefreshing()
                
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}





