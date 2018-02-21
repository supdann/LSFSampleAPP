//
//  EventDetailsViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 09.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit
import UIEmptyState

class EventDetailsViewController: UIViewController{
    
    @IBOutlet weak var controllerTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var eventIDLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    
    var controllerTitle: String?
    var titleStr: String?
    var languageStr: String?
    var eventID: Int?
    var courseStr: String?
    var informationStr: String?
    
    var appointments = [Appointment]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Views
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.controllerTitleLabel.text = self.controllerTitle
        self.titleLabel.text = self.titleStr
        self.languageLabel.text = self.languageStr
        self.eventIDLabel.text = String(self.eventID!)
        self.courseLabel.text = self.courseStr
        self.informationLabel.text = self.informationStr
        
        // Set the data source and delegate
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        
        // Optionally remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.reloadEmptyStateForTableView(self.tableView)
        
        // EventID unwrapping can be forced because no segue can be performed without having selected
        // an event with a valid ID
        APIManager.sharedInstance.getAppointments(byEventID: self.eventID!){(appointments,error) in
            
            guard let appointments = appointments else {
                return
            }
            
            self.appointments.removeAll()
            self.appointments.append(contentsOf: appointments)
            
            self.tableView.reloadData()
            self.reloadEmptyStateForTableView(self.tableView)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = AppointmentCell.instantiateFromNib()!
        
        cell.professorLabel.text = "\(appointments[indexPath.row].pid)"
        
        cell.infoLabel.text = appointments[indexPath.row].appointment_info
        
        cell.roomLabel.text = appointments[indexPath.row].room

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension EventDetailsViewController: UIEmptyStateDelegate, UIEmptyStateDataSource {
    
    var emptyStateImage: UIImage? {
        return nil
    }
    
    var emptyStateTitle: NSAttributedString {
        let attrs = [NSAttributedStringKey.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.00),
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        return NSAttributedString(string: "No appointments for this lecture.", attributes: attrs)
    }
    
}
