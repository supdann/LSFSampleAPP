//
//  AboutViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 2.03.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import SideMenu

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
}
