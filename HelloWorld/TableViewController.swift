//
//  TableViewController.swift
//  HelloWorld
//
//  Created by Rishabh Bector on 12/29/16.
//  Copyright © 2016 Rishabh Bector. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Console"
        
        // this will be non-nil if a blur effect is applied
        guard tableView.backgroundView == nil else {
            return
        }
    }
    
    ////////////////////   USER LOGOUT   ////////////////////
    
    @IBAction func logout() {
        
        let alertController = UIAlertController(title: "Log Out?", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .destructive) { (action:UIAlertAction!) in
            
        
            
        SlackAPIManager.sharedInstance.authToken = ""
        SlackAPIManager.sharedInstance.userID = ""
        SlackAPIManager.sharedInstance.userIDtst = ""
        SlackAPIManager.sharedInstance.userData = nil
            
        CoreDataManager.sharedInstance.save(key: "SlackToken", name: "")
        CoreDataManager.sharedInstance.save(key: "UserID", name: "")
        
        self.performSegue(withIdentifier: "logout", sender: nil)
            
        }
            
        alertController.addAction(OKAction)
            
        self.present(alertController, animated: true, completion:nil)
        
    }
}
