//
//  CoreDataManager.swift
//  HelloWorld
//
//  Created by Rishabh Bector on 1/1/17.
//  Copyright © 2017 Rishabh Bector. All rights reserved.
//


////////////////////   CORE DATA MANAGER   ////////////////////

// Manages saving and retrieving data from device DataModel //



import Foundation
import CoreData
import Pantry

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    func save(key: String, name: String) {
        
        print("R: Storing Data to Persistence = ")
        print("Key: " + key + ", Value: " + name)
        Pantry.pack(name, key: key)
        
    }
    
    func recall(key: String) -> String? {
        
        
        
        if let out: String = Pantry.unpack(key) {
            
            print("R: Recalling Data = ")
            print("Key: " + key + ", Value: " + out)
            
            return out
            
        } else {
            
            return nil
            
        }

    }

}
