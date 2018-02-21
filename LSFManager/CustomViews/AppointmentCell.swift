//
//  AppointmentCell.swift
//  LSFManager
//
//  Created by Daniel Montano on 09.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit

class AppointmentCell: UITableViewCell {
    
    @IBOutlet weak var professorLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var roomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
    }
}
