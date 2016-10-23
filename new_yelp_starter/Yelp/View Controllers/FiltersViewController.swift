//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Pj Nguyen on 10/19/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit


@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateValue filters: [String: AnyObject])
}

class FiltersViewController: UIViewController {
    let categories = [["name" : "Afghan", "code": "afghani"],
                      ["name" : "African", "code": "african"],
                      ["name" : "American, New", "code": "newamerican"],
                      ["name" : "American, Traditional", "code": "tradamerican"],
                      ["name" : "Arabian", "code": "arabian"],
                      ["name" : "Argentine", "code": "argentine"],
                      ["name" : "Armenian", "code": "armenian"],
                      ["name" : "Asian Fusion", "code": "asianfusion"],
                      ["name" : "Asturian", "code": "asturian"],
                      ["name" : "Australian", "code": "australian"],
                      ["name" : "Austrian", "code": "austrian"],
                      ["name" : "Baguettes", "code": "baguettes"],
                      ["name" : "Bangladeshi", "code": "bangladeshi"],
                      ["name" : "Barbeque", "code": "bbq"],
                      ["name" : "Basque", "code": "basque"]]
    
    //SeeAll var
    var didCategoriesExpand = false
    let numSeeAll = 6
    
    var clickedValue: Int!
    
    // Filters Stored List to send to Business Controller
    var filters = [String: AnyObject]()
    
    // SwitchCell variable
    var switchStates = [Int: Bool]()
    var delegate: FiltersViewControllerDelegate?
    
    // SortBy variable
    var didSortByExpand = false
    let sortOptionValues = ["Best Match", "Distance", "Rating"]
    
    let sectionTitles = ["Deal","Sort By", "Category" ,""]
    var selectedRowIndex = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // On Back
    @IBAction func onBack(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // On Search
    @IBAction func onSearch(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        print("sort value \(selectedRowIndex)")
        var selectedCategories = [String]()
        let selectedSort: Int = 2
        for (index, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[index]["code"]!)
            }
        }
        filters["categories"] = selectedCategories as AnyObject?
        filters["sort"] = selectedSort as AnyObject?
        delegate?.filtersViewController!(filtersViewController: self, didUpdateValue: filters)
    }
}


// UITableView Setting
extension FiltersViewController: UITableViewDataSource, UITableViewDelegate{
    
    // number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            if didSortByExpand {
                return 44
            }
            else {
                return indexPath.row == selectedRowIndex ? 44 : 0
            }
        default:
            return 44
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            if didCategoriesExpand {
                return categories.count
            }
            else {
                return numSeeAll + 1
            }
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if !didCategoriesExpand {
                // if click on "See All"
                if indexPath.row == numSeeAll {
                    didCategoriesExpand = true
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        //offering deal cell
        case 0:
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            switchCell.switchButton.isOn = false
            switchCell.categoryLable.text = "Offering a Deal"
            switchCell.delegate = self
            
            if switchCell.switchButton.isOn{
                filters["deal"] = true as AnyObject?
            }
            else{
                filters["deal"] = false as AnyObject?
            }
            return switchCell
            
        // drop cell section
        case 1:
            let dropCell = tableView.dequeueReusableCell(withIdentifier: "DropCell") as! DropCell
            dropCell.delegate = self
            
            switch indexPath.row {
            case 0:
                dropCell.dropLable.text = sortOptionValues[indexPath.row]
                
                if didSortByExpand{
                    dropCell.dropImage.image = UIImage(named: "unchecked")
                    
                }
                else{
                    dropCell.dropImage.image = UIImage(named: "Arrow")
                }
            case 1:
                dropCell.dropLable.text = sortOptionValues[indexPath.row]
                if didSortByExpand{
                    dropCell.dropImage.image = UIImage(named: "unchecked")
                    
                }
                else{
                    dropCell.dropImage.image = UIImage(named: "checked")
                }
            case 2:
                dropCell.dropLable.text = sortOptionValues[indexPath.row]
                if didSortByExpand{
                    dropCell.dropImage.image = UIImage(named: "unchecked")
                    
                }
                else{
                    dropCell.dropImage.image = UIImage(named: "checked")
                }
            default:
                break
            }
            return dropCell
        //categories cell section
        case 2:
            
            if didCategoriesExpand {
                let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
                switchCell.categoryLable.text = categories[indexPath.row]["name"]
                switchCell.delegate = self
                switchCell.switchButton.isOn = switchStates[indexPath.row] ?? false
                return switchCell
            }
            else {
                if indexPath.row < numSeeAll {
                    let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
                    switchCell.categoryLable.text = categories[indexPath.row]["name"]
                    switchCell.delegate = self
                    switchCell.switchButton.isOn = switchStates[indexPath.row] ?? false
                    return switchCell
                }
                else {
                    let switchCell = tableView.dequeueReusableCell(withIdentifier: "SeeAllCell")! as UITableViewCell
                    return switchCell
                }
            }
        default:
            return UITableViewCell()
        }
    }
}

extension FiltersViewController: SwitchCellDelegate, DropCellDelegate{
    
    // Switch Cell Delegate
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let ip = tableView.indexPath(for: switchCell)
        if ip?.section == 0 {
            filters["deal"] = value as AnyObject?
        }
        else{
            switchStates[ip!.row] = value
        }
        //print("filter vc got signal from switch cell \(switchStates[ip!.row])")
    }
    
    // Drop Cell Delegate
    func dropCell(dropCell: DropCell, didClick imageClicked: UIImage) {
        if let ip = tableView.indexPath(for: dropCell) {
            if ip.section == 1 {
                switch imageClicked {
                case UIImage(named: "Arrow")!:
                    didSortByExpand = true
                case UIImage(named: "checked")!:
                    didSortByExpand = false
                case UIImage(named: "unchecked")!:
                    didSortByExpand = false
                default:
                    break
                }
                if let selectedIndex = tableView.indexPath(for: dropCell) {
                    selectedRowIndex = selectedIndex.row
                }
                tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.automatic)
            }
        }
    }
}
