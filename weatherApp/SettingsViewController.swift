//
//  SettingsViewController.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-09-02.
//  Copyright © 2016 ratatat. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class SettingsViewController: UIViewController, mainViewControllerDelegate {
    @IBOutlet weak var control1: BetterSegmentedControl!
    
    var tempCelcius:Bool = Bool()
    var tempUnit:String = String()
    let vc = ViewController()
   
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
       
       
       self.vc.delegate = self
        self.vc.callDelegate()
        
        control1.titles = ["°C","°F"]
        control1.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        control1.alwaysAnnouncesValue = true
        control1.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
        print(control1.titles)
       
     
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func weatherDataReceived(data: String) {
    
        print("This is the received data \(data)")

    }
    
    func navigationSegmentedControlValueChanged(sender: BetterSegmentedControl) {
        if sender.index == 0 {
            print("Turning lights on.")
            
           
        }
        else {
            print("Turning lights off.")
          
        }
        
        
    }
    



}
