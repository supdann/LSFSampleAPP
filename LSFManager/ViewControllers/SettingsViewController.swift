//
//  SettingsViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 08.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var publicAddressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Views
        applyWhiteGrayTextFieldStyle(textfield: publicAddressTextField)
        applyWhiteGrayTextFieldStyle(textfield: portTextField)
        applyHTWGreenButtonStyle(button: saveButton)
        clearStatusLabel()
        
        // Load User Settings
        loadFromUserDefaults()
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard let address = publicAddressTextField.text, let portText = portTextField.text else {
            showErrorMessage(msg: "Error. Verify address and port.")
            return
        }
        
        // Try to parse the port text
        guard let port = Int(portText) else {
            showErrorMessage(msg: "Port not valid")
            return
        }
    
        SettingsManager.sharedInstance.address = address
        SettingsManager.sharedInstance.port = port
        
        do {
            try SettingsManager.sharedInstance.saveToUserDefaults()
            showSuccessMessage(msg: "Settings saved successfully.")
        } catch let e {
            showErrorMessage(msg: e.localizedDescription)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////                  Setting Methods                   /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    func loadFromUserDefaults(){
        SettingsManager.sharedInstance.loadFromUserDefaults()
        
        guard let address = SettingsManager.sharedInstance.address, let port = SettingsManager.sharedInstance.port else {
            showErrorMessage(msg: "Settings could not be loaded.")
            return
        }
        
        publicAddressTextField.text = address
        portTextField.text = String(port)
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////                   HELPER METHODS                   /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    func showErrorMessage(msg: String){
        statusLabel.textColor = UIColor.red
        statusLabel.text = msg
    }
    
    func showSuccessMessage(msg: String){
        statusLabel.textColor = Constants.htwGreen
        statusLabel.text = msg
    }
    
    func clearStatusLabel(){
        statusLabel.text = ""
    }
    
    func applyHTWGreenButtonStyle(button: UIButton){
        button.layer.cornerRadius = 8.0
        button.backgroundColor = Constants.htwGreen
    }
    
    func applyWhiteGrayTextFieldStyle(textfield: UITextField){
        textfield.setLeftPaddingPoints(10.0)
        textfield.layer.cornerRadius = 8.0
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
    }
    
}
