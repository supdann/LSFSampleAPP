//
//  LectureSearchResultsViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 07.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit
import UIEmptyState
import SideMenu


// LPA ist just an abbreviation for Lectures Professors and Appointments
enum LPAListType {
    case Event
    case Professor
    case Appointment
    case None
}

enum LPATopLeftButtonType {
    case Back
    case Menu
}

class LPASearchResultsViewController: UIViewController, UIEmptyStateDelegate, UIEmptyStateDataSource {
    
    var events = [Event]()
    var professors = [Professor]()
    var appointments = [Appointment]()
    
    var selectedEvent: Event?
    var selectedProfessor: Professor?
    
    var tableTitle: String?
    var listType: LPAListType = .None
    var topLeftButtonType: LPATopLeftButtonType = .Menu
    var emptyTableStr: String = "Not set yet"
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SETUP VIEWS
        if let title = self.tableTitle {
            tableTitleLabel.text = title
        }
        
        // Setup tableview delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set the data source and delegate
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        
        // Optionally remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.reloadEmptyStateForTableView(self.tableView)
        
        // Check if either the back button or the menu button should be displayed
        if(self.topLeftButtonType == .Menu){
            menuButton.isHidden = false
            backButton.isHidden = true
        }else if(self.topLeftButtonType == .Back){
            menuButton.isHidden = true
            backButton.isHidden = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    var emptyStateImage: UIImage? {
        return nil
    }
    
    var emptyStateTitle: NSAttributedString {
        let attrs = [NSAttributedStringKey.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.00),
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        return NSAttributedString(string: emptyTableStr, attributes: attrs)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
            
        case "EventDetailsSegue":
            
            let destinationVC = segue.destination as! EventDetailsViewController
            destinationVC.controllerTitle = "Event Details"
            destinationVC.titleStr = selectedEvent!.title
            destinationVC.languageStr = selectedEvent!.language
            destinationVC.eventID = selectedEvent!.event_id
            destinationVC.courseStr = selectedEvent!.course
            destinationVC.informationStr = selectedEvent!.information
            
        case "PersonDetailsSegue":
            
            let destinationVC = segue.destination as! ProfessorDetailsViewController
            destinationVC.controllerTitleStr = "Professor Details"
            destinationVC.profNameStr = selectedProfessor!.name
            destinationVC.consultationTimeStr = selectedProfessor!.consultation_time
            destinationVC.personalStatusStr = selectedProfessor!.personalstatus
            destinationVC.statusStr = selectedProfessor!.status
            destinationVC.addressStr = selectedProfessor!.business_address
            destinationVC.emailStr = selectedProfessor!.business_email
            destinationVC.contactStr = selectedProfessor!.contact_info
            destinationVC.roomStr = selectedProfessor!.business_room
            destinationVC.weblinkStr = selectedProfessor!.web_link
            destinationVC.buildingStr = selectedProfessor!.building
            return
        default:
            return
        }
    }
    
}

extension LPASearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.listType {
            
        case .Event:
            return events.count
        case .Professor:
            return professors.count
        case .Appointment:
            return appointments.count
        case .None:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.listType {
            
        case .Event:
            let cell = EventCell.instantiateFromNib()!
            cell.eventTitleLabel.text = events[indexPath.row].title
            return cell
        case .Professor:
            let cell = ProfessorCell.instantiateFromNib()!
            cell.professorName.text = professors[indexPath.row].name
            return cell
        case .Appointment:
            let cell = ProfessorCell.instantiateFromNib()!
            return cell
        case .None:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.listType {
            
        case .Event:
            self.selectedEvent = events[indexPath.row]
            self.performSegue(withIdentifier: "EventDetailsSegue", sender: self)
        case .Professor:
            self.selectedProfessor = professors[indexPath.row]
            self.performSegue(withIdentifier: "PersonDetailsSegue", sender: self)
        case .Appointment:
            break
        case .None:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
