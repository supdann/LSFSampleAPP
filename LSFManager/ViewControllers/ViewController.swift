//
//  ViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 07.12.17.
//  Copyright © 2017 danielmontano. All rights reserved.
//

import UIKit
import SideMenu

class ViewController: UIViewController {

    @IBOutlet weak var authButton: UIButton!
    var authSuccess: Bool = false
    
    @IBOutlet weak internal var schedule1: UIView!
    @IBOutlet weak internal var schedule2: UIView!
    @IBOutlet weak internal var schedule3: UIView!
    @IBOutlet weak internal var schedule4: UIView!
    @IBOutlet weak internal var schedule5: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SETUP VIEWS
        
        // Define the menus
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        // Setup API Manager
        APIManager.sharedInstance.public_address = SettingsManager.sharedInstance.address
        APIManager.sharedInstance.port = SettingsManager.sharedInstance.port
        
        // If there is an active access token then delete it
        if authSuccess {
            APIManager.sharedInstance.access_token = nil
            authSuccess = false
            self.setupGreenBorderButton(button: self.authButton, buttonTitle: "Login")
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViews()
    }
    
    @IBAction func authButtonPressed(_ sender: UIButton) {
        
        // If the API Manager currently has a current token, then remove it
        if let _ = APIManager.sharedInstance.access_token {
            
            APIManager.sharedInstance.access_token = nil
            
            // Set No current successful auth
            self.authSuccess = false
            
            // Set the auth button to login
            self.setupGreenBorderButton(button: self.authButton, buttonTitle: "Login")
            
            return
        }
        
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    @IBAction func menuButtonPresed(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SettingsFromMainSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews(){
        
        // Load Schedule Overview
        APIManager.sharedInstance.getScheduleOverview(){ (scheduleLayers, error) in
            
            guard let scheduleLayers = scheduleLayers else {
                return
            }
            
            let scheduleView1 = ScheduleOverview.instantiateFromNib()!
            scheduleView1.data = scheduleLayers[0]
            self.schedule1.addSubview(scheduleView1)
            
            let scheduleView2 = ScheduleOverview.instantiateFromNib()!
            scheduleView2.data = scheduleLayers[1]
            self.schedule2.addSubview(scheduleView2)
            
            let scheduleView3 = ScheduleOverview.instantiateFromNib()!
            scheduleView3.data = scheduleLayers[2]
            self.schedule3.addSubview(scheduleView3)
            
            let scheduleView4 = ScheduleOverview.instantiateFromNib()!
            scheduleView4.data = scheduleLayers[3]
            self.schedule4.addSubview(scheduleView4)
            
            let scheduleView5 = ScheduleOverview.instantiateFromNib()!
            scheduleView5.data = scheduleLayers[4]
            self.schedule5.addSubview(scheduleView5)
            
        }
        
        APIManager.sharedInstance.checkAccessToken(){(type, error) in
            if let _ = error {
                self.setupGreenBorderButton(button: self.authButton, buttonTitle: "Login")
                return
            }
            self.authSuccess = true
            self.setupRedBorderButton(button: self.authButton, buttonTitle: "Logout")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
            
        case "LoginSegue":
            let loginViewController = segue.destination as! LoginViewController
            loginViewController.delegate = self
        case "SettingsFromMainSegue":
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.topLeftButtonType = .Back
        default:
            return
        }
    }
    
    func setupGreenBorderButton(button: UIButton, buttonTitle: String){
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = Constants.htwGreen.cgColor
        button.setTitleColor(Constants.htwGreen, for: .normal)
        button.setTitle(buttonTitle, for: .normal)
    }
    
    func setupRedBorderButton(button: UIButton, buttonTitle: String){
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitle(buttonTitle, for: .normal)
    }
    
}

extension ViewController: ModalClosedDelegate {
    func loginModalClosed() {
        setupViews()
    }
}

extension ViewController: UISideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        let menuTableViewController = SideMenuManager.default.menuLeftNavigationController?.viewControllers[0] as! MenuTableViewController
        
        APIManager.sharedInstance.checkAccessToken(){(type, error) in
            if let type = type {
                if type == 0 {
                    menuTableViewController.menuMode = .Student
                }else if type == 1 {
                    menuTableViewController.menuMode = .Professor
                }
            }else{
                menuTableViewController.menuMode = .None
            }
            menuTableViewController.tableView.reloadData()
            menuTableViewController.reloadEmptyState()
        }
    }

    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) { }

    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) { }

    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) { }
}




