//
//  LoginViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 07.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

protocol ModalClosedDelegate {
    
    func loginModalClosed()
    
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var delegate: ModalClosedDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Setup Views
        statusLabel.text = ""
        usernameTextField.setLeftPaddingPoints(10.0)
        usernameTextField.layer.cornerRadius = 8.0
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        
        passwordTextField.setLeftPaddingPoints(10.0)
        passwordTextField.layer.cornerRadius = 8.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        
        self.loginButton.layer.cornerRadius = 8.0
        self.loginButton.backgroundColor = Constants.htwGreen
        
        loadFromUserDefaults()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.closeModal()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        if username == "" || password == "" {
            showErrorMessage(msg: "Verify your input!")
            return
        }
        
        APIManager.sharedInstance.authenticate(username: username, password: password, callback: { (access_token,error) in
            if let err = error {
                self.showErrorMessage(msg: err.errorDescription)
                return
            }
            
            if let token = access_token {
                print(token)
                
                // Set the access token so it can be used by the API Manager
                APIManager.sharedInstance.access_token = access_token
                
                // If login was successfull then save the username and password
                // in the user defaults.
                SettingsManager.sharedInstance.defaultUsername = username
                SettingsManager.sharedInstance.defaultPass = password
                
                try! SettingsManager.sharedInstance.saveToUserDefaults()
                
                self.closeModal()
            }else {
                self.showErrorMessage(msg: "error retrieving access token")
            }
        })
    }
    
    /// Helper Method to close modal
    func closeModal(){
        self.delegate?.loginModalClosed()
        self.dismiss(animated: true, completion: nil)
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////                  Setting Methods                   /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    func loadFromUserDefaults(){
        SettingsManager.sharedInstance.loadFromUserDefaults()
        
        guard let username = SettingsManager.sharedInstance.defaultUsername, let password = SettingsManager.sharedInstance.defaultPass else {
            showErrorMessage(msg: "Settings could not be loaded.")
            return
        }
        
        usernameTextField.text = username
        passwordTextField.text = String(password)
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
}
