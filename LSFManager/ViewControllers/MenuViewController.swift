//
//  MenuViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 08.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit

enum MenuMode {
    case Professor
    case Student
    case None
}

class MenuTableViewController: UITableViewController {
    
    var menuMode: MenuMode = .Student
    
    let studentItems = [
        ("Home","HomeSegue"),
//        ("Appointments","AppointmentsSegue"),
        ("Lecture Search","LectureSearchViewSegue"),
        ("Person Search","PersonSearchViewSegue"),
        ("My Lectures","EventsOverviewSegue"),
        ("QR Code","QRCodeSegue"),
//        ("My Exams","ExamsOverviewSegue"),
        ("Settings","SettingsSegue")
    ]
    
    let professorItems = [
        ("Home","HomeSegue"),
        ("Lecture Search","LectureSearchViewSegue"),
        ("Person Search","PersonSearchViewSegue"),
        ("My Lectures","EventsOverviewSegue"),
        ("My Exams","ExamsOverviewSegue"),
        ("Settings","SettingsSegue")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Optionally remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
            
        case "HomeSegue":
            let homeVC = segue.destination as! ViewController
        case "LectureSearchViewSegue":
            let destinationVC = segue.destination as! SearchViewController
            destinationVC.searchTitle = "Lecture Search"
            destinationVC.searchType = .Event
        case "PersonSearchViewSegue":
            let destinationVC = segue.destination as! SearchViewController
            destinationVC.searchTitle = "Person Search"
            destinationVC.searchType = .Professor
        case "AppointmentsSegue":
            let destinationVC = segue.destination as! LPASearchResultsViewController
            destinationVC.topLeftButtonType = .Menu
        case "EventsOverviewSegue":
            let destinationVC = segue.destination as! LPASearchResultsViewController
            destinationVC.topLeftButtonType = .Menu
        case "ExamsOverviewSegue":
            let destinationVC = segue.destination as! LPASearchResultsViewController
            destinationVC.topLeftButtonType = .Menu
        case "QRCodeSegue":
            let destinationVC = segue.destination as! QRCodeViewController
            destinationVC.qrCodeImage = #imageLiteral(resourceName: "qrcode")
        case "SettingsSegue":
            let destinationVC = segue.destination as! SettingsViewController
        default:
            return
        }
    }
    
    func performSegueFunc(segueName: String){
        self.performSegue(withIdentifier: segueName, sender: nil)
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////               TABLEVIEW IMPLEMENTATION             /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.menuMode == .Professor {
            return professorItems.count
        }else if self.menuMode == .Student {
            return studentItems.count
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.menuMode == .Professor {
            performSegueFunc(segueName: professorItems[indexPath.row].1)
        }else if self.menuMode == .Student {
            performSegueFunc(segueName: studentItems[indexPath.row].1)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuItemCell.instantiateFromNib()!
        
        if self.menuMode == .Professor {
            cell.menuLabel.text = professorItems[indexPath.row].0
            cell.menuImage.image = UIImage(named: professorItems[indexPath.row].1)!
        }else if self.menuMode == .Student {
            cell.menuLabel.text = studentItems[indexPath.row].0
            cell.menuImage.image = UIImage(named: studentItems[indexPath.row].1)!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
