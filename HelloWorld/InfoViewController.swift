//
//  InfoViewController.swift
//  HelloWorld
//
//  Created by Rishabh Bector on 1/3/17.
//  Copyright © 2017 Rishabh Bector. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var gradientLayer: CAGradientLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}
