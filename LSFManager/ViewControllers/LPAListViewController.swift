//
//  LPAListViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 07.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit
import UIEmptyState
import SideMenu

class LPASearchResultsViewController: UIViewController, UIEmptyStateDelegate, UIEmptyStateDataSource {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var events = [Event]()
    var professors = [Professor]()
    var appointments = [Appointment]() {
        didSet {
            sortedAppointments = sortAppointments(appointments: appointments)
        }
    }
    var sortedAppointments = [[Appointment]]()
    
    var selectedEvent: Event?
    var selectedProfessor: Professor?
    
    var tableTitle: String?
    var listType: LPAListType = .None
    var topLeftButtonType: TopLeftButtonType = .Menu
    var emptyTableStr: String = "Not set yet"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let title = self.tableTitle {
            tableTitleLabel.text = title
        }
        
        tableView.reloadData()
        self.reloadEmptyStateForTableView(tableView)
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
    
    
    func sortAppointments(appointments: [Appointment]) -> [[Appointment]]{
        
        var sortedAppointments = Array(repeating: [Appointment](), count: 14)
        
        for appointment in appointments {
            if(appointment.appointment_type == .Lecture){
                
                var weekOffset = 0;
                
                if appointment.frequency == 2 {
                    weekOffset += 7
                }
                
                // This is one of the code blocks that still need
                // some refactoring.
                switch appointment.day! {
                    
                case "Montag":
                    if(appointment.frequency == 0){
                        sortedAppointments[0].append(appointment)
                        sortedAppointments[0+weekOffset].append(appointment)
                    }else{
                        sortedAppointments[0+weekOffset].append(appointment)
                    }
                case "Dienstag":
                    if(appointment.frequency == 0){
                        sortedAppointments[1].append(appointment)
                        sortedAppointments[1+weekOffset].append(appointment)
                    }else{
                        sortedAppointments[1+weekOffset].append(appointment)
                    }
                case "Mittwoch":
                    if(appointment.frequency == 0){
                        sortedAppointments[2].append(appointment)
                        sortedAppointments[2+weekOffset].append(appointment)
                    }else{
                        sortedAppointments[2+weekOffset].append(appointment)
                    }
                case "Donnerstag":
                    if(appointment.frequency == 0){
                        sortedAppointments[3].append(appointment)
                        sortedAppointments[3+weekOffset].append(appointment)
                    }else{
                        sortedAppointments[3+weekOffset].append(appointment)
                    }
                case "Freitag":
                    if(appointment.frequency == 0){
                        sortedAppointments[4].append(appointment)
                        sortedAppointments[4+weekOffset].append(appointment)
                    }else{
                        sortedAppointments[4+weekOffset].append(appointment)
                    }
                case "Samstag":
                    if(appointment.frequency == 0){
                        sortedAppointments[5].append(appointment)
                        sortedAppointments[5+weekOffset].append(appointment)
                    }else{
                        sortedAppointments[5+weekOffset].append(appointment)
                    }
                case "Sonntag":
                    if(appointment.frequency == 0){
                        sortedAppointments[6].append(appointment)
                        sortedAppointments[6+weekOffset].append(appointment)
                    }else{
                        sortedAppointments[6+weekOffset].append(appointment)
                    }
                default:
                    break
                }
            }
        }
        return sortedAppointments
    }
}

extension LPASearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.listType == .Appointment {
            return sortedAppointments.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let date = " - (xx.xx.xxxx)"
        
        if(self.listType == .Appointment){
            if(section == 0 || section == 7){
                return "Monday\(date)"
            }
            else if(section == 1 || section == 8){
                return "Tuesday\(date)"
            }
            else if(section == 2 || section == 9){
                return "Wednesday\(date)"
            }
            else if(section == 3 || section == 10){
                return "Thursday\(date)"
            }
            else if(section == 4 || section == 11){
                return "Friday\(date)"
            }
            else if(section == 5 || section == 12){
                return "Saturday\(date)"
            }
            else if(section == 6 || section == 13){
                return "Sunday\(date)"
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.listType == .Appointment {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.listType {
            
        case .Event:
            return events.count
        case .Professor:
            return professors.count
        case .Appointment:
            return sortedAppointments[section].count
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
            
            let cell = TimedAppointmentCell.instantiateFromNib()!
            
            var appointment = sortedAppointments[indexPath.section][indexPath.row]
            
            cell.startLabel.text = "\(appointment.getStartTimeText())"
            
            cell.endLabel.text = "\(appointment.getEndTimeText())"
            
            cell.titleLabel.text = "\(appointment.event_id)"
            
            if let room = appointment.room {
                cell.locationLabel.text = "\(room)"
            }
            
            if let title = appointment.title {
                cell.titleLabel.text = title
            }
            
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
    
    // Rows height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
