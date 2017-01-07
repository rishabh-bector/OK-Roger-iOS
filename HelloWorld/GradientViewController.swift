//
//  GradientViewController.swift
//  HelloWorld
//
//  Created by Rishabh Bector on 12/29/16.
//  Copyright © 2016 Rishabh Bector. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class GradientViewController: UIViewController {
    
    static let sharedInstance = GradientViewController()
    @IBOutlet weak var jsonoutlet: UILabel!
    @IBOutlet weak var jsonoutlet2: UILabel!
    
    var userData:JSON = nil

    
    var gradientLayer: CAGradientLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
        createGradient()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createGradient() {
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(red: 86/255, green: 109/255, blue: 148/255, alpha: 1.0).cgColor
        let color2 = UIColor(red: 89/255, green: 86/255, blue: 148/255, alpha: 1.0).cgColor
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.3, 1.0]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction fileprivate func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    func fetchUserData() {
        
        let headers: HTTPHeaders = ["Authorization":"Bearer fsds"]
        let parameters: Parameters = ["test":"true"]
        
        SlackAPIManager.sharedInstance.userIDtst = "03c28b64-dc27-4933-9d33-6228cf5287a6"
        
        Alamofire.request("https://qa.okroger.ai/traveler/\(SlackAPIManager.sharedInstance.userID)",
                           method: .get,
                           parameters: parameters,
                           encoding: URLEncoding.default,
                           headers: headers).responseJSON { (resp) in
                
                self.userData = JSON(data:resp.data!)
                
                
                print("R: Received QA response! = ")
                print(self.userData)
                
                let udata = self.userData
                
                let firstname = String(describing: udata["firstName"])
                let lastname = String(describing: udata["lastName"])
                let email = String(describing: udata["email"])
                let phone = String(describing: udata["phone"])
                
                
                self.jsonoutlet.text = "Welcome to Roger, " + firstname
                self.jsonoutlet2.text = "Hey there " + firstname + "! This is your Roger console. Here you can add payment options and view your profile. More will be available soon!"
                //self.jsonoutlet3.text = phone
                
                
        }
        
    }

    
}
