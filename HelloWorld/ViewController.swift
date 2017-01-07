//
//  ViewController.swift
//  HelloWorld
//
//  Created by Rishabh Bector on 12/27/16.
//  Copyright © 2016 Rishabh Bector. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var gradientLayer: CAGradientLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (SlackAPIManager.sharedInstance.hasOAuthToken()) {
            print("R: Restarted")
            SlackAPIManager.sharedInstance.recallAuthentication()
            self.performSegue(withIdentifier: "navcontrol", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMessage() {
        let alertController = UIAlertController(title: "Hello World",
                                                message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func createGradient() {
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(red: 86/255, green: 109/255, blue: 148/255, alpha: 1.0).cgColor
        let color2 = UIColor(red: 89/255, green: 86/255, blue: 148/255, alpha: 1.0).cgColor
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.3, 1.0]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        createGradient()
    }

    @IBAction func loadInitialData() {
        if (!SlackAPIManager.sharedInstance.hasOAuthToken())
        {
            SlackAPIManager.sharedInstance.startOAuth2Login()
            
        }
        else
        {
            
            //SlackAPIManager.sharedInstance.fetchUserData()
            self.performSegue(withIdentifier: "navcontrol", sender: nil)
        }
    }
    
    @IBAction func checkToken() {
        
        let output:String = SlackAPIManager.sharedInstance.status
        
        print("R: Slack Login Status = " + output)
        
        if output == "notraveler" {
            UIAlertView(title: "Oh No",
                        message: "It appears that you are not a Roger traveler.",
                        delegate: nil,
                        cancelButtonTitle: "OK").show()
        }
        else if output == "unclear" {
            UIAlertView(title: "Please Sign In",
                        message: "",
                        delegate: nil,
                        cancelButtonTitle: "OK").show()
        }
        else if output == "good" {
            
            SlackAPIManager.sharedInstance.status = "unclear"
            self.performSegue(withIdentifier: "navcontrol", sender: nil)
        }
        

        
    }

}
