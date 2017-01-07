//
//  PaymentViewController.swift
//  HelloWorld
//
//  Created by Rishabh Bector on 1/1/17.
//  Copyright © 2017 Rishabh Bector. All rights reserved.
//

import UIKit
import CoreData
import Stripe
import AFNetworking
import Alamofire
import SwiftyJSON

class PaymentViewController: UIViewController {
    
    var gradientLayer: CAGradientLayer!
    var stripeToken: STPToken! = nil
    var stripeTokenSTR: String? = nil
    var lastDigits: String? = nil
    
    // Persistent Variables
    
    var cardID: String? = nil
    
    
    
    ////////////////////   USER INTERFACE   ////////////////////
    
    

    // Every time view loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Recall CardID from Persistence
        
               
        self.cardID = CoreDataManager.sharedInstance.recall(key: "CardID")
      
        // Get card digits from Roger
        
        if self.cardID != nil && self.cardID != "" {
            
            let headers: HTTPHeaders = ["Authorization":"Bearer fsds"]
            
            Alamofire.request("https://qa.okroger.ai/traveler/\(SlackAPIManager.sharedInstance.userID)/cards?test=true", headers: headers).responseString { (response) in
                
                let json = JSON(data:response.data!)
                
                print("R: Received Card ID = ")
                print(json)
                
                self.lastDigits = String(describing: json[0]["last4"])
                
                self.cards.text = "Card ending in " + self.lastDigits!
            
            }
            
            
        }
        else {
            self.cards.text = "No Card"
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        createGradient()
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
    
    
    
    @IBOutlet weak var cnum: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var cvc: UITextField!
    @IBOutlet weak var cards: UILabel!
    

    
    
    ////////////////////   STRIPE   ////////////////////
    
    
    // Add a credit card for a User
    
    @IBAction func addCard(sender: AnyObject) {
        
        var stripCard = STPCard()
        
        view.endEditing(true)
        
        if self.date.text!.isEmpty == false {
            
            let expirationDate = self.date.text!.components(separatedBy: "/")
            let expMonth = UInt(Int(expirationDate[0])!)
            let expYear = UInt(Int(expirationDate[1])!)
            
            // Send the card info to Stripe to get the token
            
            stripCard.number = self.cnum.text
            stripCard.cvc = self.cvc.text
            stripCard.expMonth = expMonth
            stripCard.expYear = expYear
        }
        
        
        if STPCardValidator.validationState(forCard: stripCard) != .valid {
            self.handleError()
        }
        else {
        
        let card = self.cnum.text!
        let index = card.index(card.startIndex, offsetBy: 12)
        self.lastDigits = card.substring(from: index)

        
        STPAPIClient.shared().createToken(withCard: stripCard, completion: { (token, error) -> Void in
            
            
        self.postStripeToken(token: token!)
        })
        }
    }
    
    // In case the card doesn't exist
    
    func handleError() {
        
        UIAlertView(title: "Invalid Card",
                    message: "",
                    delegate: nil,
                    cancelButtonTitle: "OK").show()
        
    }
    
    // What to do after we recieve the Stripe Token
    
    func postStripeToken(token: STPToken) {
        
        print("R: Received Stripe Token! = ")
        print(token)
        
        self.stripeToken = token
        self.stripeTokenSTR = token.description
        
        self.cnum.text = ""
        self.date.text = ""
        self.cvc.text = ""
    
        self.cards.text = "Card ending in " + self.lastDigits!
        
        // Exchange StripeToken with CardID from Roger
        
        let params: Parameters = ["stripeToken": self.stripeTokenSTR]
    
        let headers: HTTPHeaders = ["Authorization":"Bearer fsds"]
        
        Alamofire.request("https://qa.okroger.ai/traveler/\(SlackAPIManager.sharedInstance.userID)/card?test=true",
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers).responseString { (results) in
                            
            let json = JSON(data:results.data!)
                            
            print("CardID Attempt Response = ")
            print(json)
            
            self.cardID = String(describing: json[0]["cardId"])
                            
            

            CoreDataManager.sharedInstance.save(key: "CardID", name: self.cardID!)
                            
        }
    }
    
    
    // Remove All Cards
    

    @IBAction func removeCards() {
        
        
        let alertController = UIAlertController(title: "Remove Cards?", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .destructive) { (action:UIAlertAction!) in
            
            self.cards.text = "No Card"
            
            CoreDataManager.sharedInstance.save(key: "CardID", name: "")
            
            // Remove cards request to Roger
            
            let headers: HTTPHeaders = ["Authorization":"Bearer fsds"]
            
            Alamofire.request("https://qa.okroger.ai/traveler/\(SlackAPIManager.sharedInstance.userID)/card/\(self.cardID)?test=true",
                              method: .delete,
                              headers: headers)

        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    
    
    

    


}
