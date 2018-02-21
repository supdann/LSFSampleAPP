//
//  ProfessorDetailsViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 09.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit

class ProfessorDetailsViewController: UIViewController{
    
    @IBOutlet weak var controllerTitleLabel: UILabel!
    @IBOutlet weak var profNameLabel: UILabel!
    @IBOutlet weak var consultationTimeLabel: UILabel!
    @IBOutlet weak var personalStatusLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var weblinkLabel: UILabel!
    @IBOutlet weak var buildingLabel: UILabel!
    
    var controllerTitleStr: String?
    var profNameStr: String?
    var consultationTimeStr: String?
    var personalStatusStr: String?
    var statusStr: String?
    var addressStr: String?
    var emailStr: String?
    var contactStr: String?
    var roomStr: String?
    var weblinkStr: String?
    var buildingStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Views
        self.controllerTitleLabel.text = self.controllerTitleStr
        self.profNameLabel.text = self.profNameStr
        self.consultationTimeLabel.text = self.consultationTimeStr
        self.personalStatusLabel.text = self.personalStatusStr
        self.statusLabel.text = self.statusStr
        self.addressLabel.text = self.addressStr
        self.emailLabel.text = self.emailStr
        self.contactLabel.text = self.contactStr
        self.roomLabel.text = self.roomStr
        self.weblinkLabel.text = self.weblinkStr
        self.buildingLabel.text = self.buildingStr
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
