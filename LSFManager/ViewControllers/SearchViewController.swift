//
//  LectureSearchViewController.swift
//  LSFManager
//
//  Created by Daniel Montano on 07.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SideMenu

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var searchTitle: String?
    var searchDescription: String?
    var searchType: SearchType = .None
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Views
        searchTitleLabel.text = searchTitle
        
        searchTextField.setLeftPaddingPoints(10.0)
        searchTextField.layer.cornerRadius = 8.0
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        
        searchTextField.delegate = self
        
        searchButton.layer.cornerRadius = 8.0
        searchButton.backgroundColor = Constants.htwGreen
        
        statusLabel.text = ""
        
        loadingView.type = .ballClipRotateMultiple
        loadingView.color = Constants.htwGreen
        
    }
    
    func searchButtonPressedFunc(){

        self.statusLabel.text = ""
        
        if let searchText = self.searchTextField.text {
            
            // Check if the length of the search criteria is long enough to make API Query
            // Single character search should be avoided
            if(searchText.count <= 1){
                statusLabel.text = "Your search criteria should contain at least 2 letters"
                return
            }
            
            loadingView.startAnimating()
            startSearch(searchText: searchText)
            
        }
    }
    
    func startSearch(searchText: String){
        
        if(searchType == .Professor){
            
            APIManager.sharedInstance.getProfessors(byName: searchText){(professors, error) in
                
                self.loadingView.stopAnimating()
                
                if let err = error {
                    self.statusLabel.text = "\(err.errorDescription)"
                    self.view.endEditing(true)
                    return
                }
                
                if let professors = professors {
                    APIManager.sharedInstance.professorsCache = professors
                    self.performSegue(withIdentifier: "PersonSearchResultsSegue", sender: self)
                }else {
                    self.statusLabel.text = "There was an error processing your request."
                }
                
            }
        }
        if(searchType == .Event){
            
            APIManager.sharedInstance.getEvents(byName: searchText){ (events:[Event]?, error:CustomError?) in
                
                self.loadingView.stopAnimating()
                
                if let err = error {
                    self.statusLabel.text = "\(err.errorDescription)"
                    self.view.endEditing(true)
                    return
                }
                
                guard let events = events else {
                    self.statusLabel.text = "There was an error processing your request."
                    return
                }
                
                APIManager.sharedInstance.eventsCache = events
                self.performSegue(withIdentifier: "LectureSearchResultsSegue", sender: self)
                
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonPresed(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchButtonPressedFunc()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
            
        case "PersonSearchResultsSegue":
            let destinationVC = segue.destination as! LPASearchResultsViewController
            destinationVC.listType = .Professor
            destinationVC.professors = APIManager.sharedInstance.professorsCache
            destinationVC.tableTitle = "Person search results"
            destinationVC.emptyTableStr = "No results found for \"\(self.searchTextField.text!)\""
            destinationVC.topLeftButtonType = .Back
        case "LectureSearchResultsSegue":
            let destinationVC = segue.destination as! LPASearchResultsViewController
            destinationVC.listType = .Event
            destinationVC.events = APIManager.sharedInstance.eventsCache
            destinationVC.tableTitle = "Lecture search results"
            destinationVC.emptyTableStr = "No results found for \"\(self.searchTextField.text!)\""
            destinationVC.topLeftButtonType = .Back
        default:
            return
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonPressedFunc()
        return true
    }
    
}
