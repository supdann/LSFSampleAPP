//
//  ProfessorCell.swift
//  LSFManager
//
//  Created by Daniel Montano on 08.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit

class ProfessorCell: UITableViewCell {
    
    @IBOutlet weak var professorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
}
