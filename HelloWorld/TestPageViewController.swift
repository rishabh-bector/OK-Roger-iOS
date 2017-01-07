//
//  TestPageViewController.swift
//  HelloWorld
//
//  Created by Rishabh Bector on 12/27/16.
//  Copyright © 2016 Rishabh Bector. All rights reserved.
//

import Foundation
import UIKit

class TutorialPageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
    }
}

extension 
