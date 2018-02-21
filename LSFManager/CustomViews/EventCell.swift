//
//  EventCell.swift
//  LSFManager
//
//  Created by Daniel Montano on 25.01.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
}
