//
//  QRCodeViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 08.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class QRCodeViewController: UIViewController {
    
    var qrCodeImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
}
