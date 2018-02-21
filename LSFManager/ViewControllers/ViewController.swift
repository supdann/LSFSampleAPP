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
        
        setupViews()
        
    }
    
    @IBAction func authButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    @IBAction func menuButtonPresed(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
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
        
        // If there is an active access token then delete it
        if authSuccess {
            APIManager.sharedInstance.access_token = nil
            authSuccess = false
            self.authButton.layer.borderColor = Constants.htwGreen.cgColor
            self.authButton.setTitleColor(Constants.htwGreen, for: .normal)
            self.authButton.setTitle("Login", for: .normal)
            return
        }
        
        APIManager.sharedInstance.checkAccessToken(){(error) in
            if let error = error {
                if (error.code == CustomErrors.tokenNotValidError.code){
                    let alertController = UIAlertController(title: "Session expired", message:
                        "Your session has expired. Please login again.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    APIManager.sharedInstance.access_token = nil
                }
                self.authButton.layer.cornerRadius = 8.0
                self.authButton.layer.borderWidth = 1.0
                self.authButton.layer.borderColor = Constants.htwGreen.cgColor
                self.authButton.setTitleColor(Constants.htwGreen, for: .normal)
                self.authButton.setTitle("Login", for: .normal)
                
                return
            }

            self.authButton.layer.borderColor = UIColor.red.cgColor
            self.authButton.setTitleColor(UIColor.red, for: .normal)
            self.authButton.setTitle("Logout", for: .normal)
            self.authSuccess = true

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
        default:
            return
        }
    }
}

extension ViewController: ModalClosedDelegate {
    func loginModalClosed() {
        setupViews()
    }
}

