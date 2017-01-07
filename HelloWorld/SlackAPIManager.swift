//
//  SlackAPIManager.swift
//  HelloWorld
//
//  Created by Rishabh Bector on 12/30/16.
//  Copyright © 2016 Rishabh Bector. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SlackAPIManager {
    static let sharedInstance = SlackAPIManager()
    
    var clientID: String = "20914017059.121059616608"
    var clientSecret: String = "9658f26f19fd874d1372f1c494d92383"
    
    var authToken: String = ""
    var userID: String = ""
    var userIDtst: String = ""
    
    var userData: JSON = nil
    
    var status: String = "unclear"
    
    
    ////////////////////   SLACK -> QA ROGER OAUTH2   ////////////////////
    
    
    
    
    func hasOAuthToken() -> Bool {
        
        let token = CoreDataManager.sharedInstance.recall(key: "SlackToken")
        
        if((token) != nil && (token) != "") {
            self.status = "good"
            return true
        }
        return false
    }
    
    func recallAuthentication() {
        
        self.userID = CoreDataManager.sharedInstance.recall(key: "UserID")!
        self.authToken = CoreDataManager.sharedInstance.recall(key: "SlackToken")!
        
    }
    
    func startOAuth2Login()
    {
        let authPath = "https://qa.okroger.ai/traveler/authorize?redirect_uri=okroger-slack-ios://ios.okroger.ai"
        
        var authURL = URLRequest(url: URL(string: authPath)!)
        
        UIApplication.shared.openURL(authURL.url!)
        
    }
    
    func processOAuthS1Response(url: URL)  {
        
        var returnVal:String = ""
        
        print("R: Slack Response URL = ")
        print(url)
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        var code:String?
        var state:String?
        
        if let queryItems = components?.queryItems
        {
            for queryItem in queryItems
            {
                if (queryItem.name.lowercased() == "code")
                {
                    code = queryItem.value
                    break
                }
            }
            
            for queryItem in queryItems
            {
                if (queryItem.name.lowercased() == "state")
                {
                    state = queryItem.value
                    break
                }
            }

        }
        
        if let receivedCode = code
        {
            //let tokenParams: Parameters = ["code": receivedCode, "redirect_uri": "`okroger-slack-ios://ios.okroger.ai", "test": "true"]
            //let tokenParams: Parameters = ["code": receivedCode, "redirect_uri":"okroger-slack-ios://ios.okroger.ai"]
            //let headers: HTTPHeaders = ["Authorization":"Bearer fsds"]
            
            
            
            print("R: Authentication Code = ")
            print(receivedCode)
            print("R: Authentication State = ")
            print(state!)
            
            Alamofire.request("https://qa.okroger.ai/traveler/token?code=\(receivedCode)&redirect_uri=okroger-slack-ios://ios.okroger.ai",
                              method: .post).responseString { (results) in

                print("R: QA Results = ")
            
                print(results)
                
                
                
                
                let json = JSON(data:results.data!)
                //print(json)
                
                
                
                self.authToken = String(describing: json["authToken"])
                self.userID = String(describing: json["travelerId"])
                
                
                
                print("R: Successfully obtained token + userid! = ")
                print(self.authToken)
                print(self.userID)
                                
                if json["code"] == "TRAVELER_UNKNOWN" {
                    self.status = "notraveler"
                }
                if !(json["authToken"] == nil) {
                    self.status = "good"
                    
                    CoreDataManager.sharedInstance.save(key: "SlackToken", name: self.authToken)
                    CoreDataManager.sharedInstance.save(key: "UserID", name: self.userID)
                    
                }
                                
                
            }
            
        
        }
        
        
    }
    
    
    ////////////////////   APP <-> ROGER INTERACTION   ////////////////////
    
    
    func fetchUserData() -> JSON {
        
        let headers: HTTPHeaders = ["Authorization":"Bearer fsds"]
        let params = ["test":"true"]
        
        self.userIDtst = "03c28b64-dc27-4933-9d33-6228cf5287a6"
        
        Alamofire.request("https://qa.okroger.ai/traveler/\(self.userID)",
                                     method: .get,
                                     parameters: params,
                                     headers: headers).responseJSON { (resp) in
        
        self.userData = JSON(data:resp.data!)
        
                                        
        print("R: Received QA response! = ")
        print(self.userData)
                                        
        
        
                              
        }
        return self.userData
    }
    
    func getStoredData() -> JSON {
        return self.userData
    }
}
