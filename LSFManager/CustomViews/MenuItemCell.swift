//
//  MenuItem.swift
//  LSFManager
//
//  Created by Daniel Montano on 08.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
}
