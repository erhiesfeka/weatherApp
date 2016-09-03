//
//  SettingsViewController.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-09-02.
//  Copyright © 2016 ratatat. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class SettingsViewController: UIViewController {
    @IBOutlet weak var control1: BetterSegmentedControl!
    
    var tempCelcius:Bool = Bool()
    var tempUnit:String = String()
    var weatherData:WeatherData = WeatherData()
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
      
        
        
        control1.titles = ["°C","°F"]
        control1.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        control1.alwaysAnnouncesValue = true
        control1.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
        print(control1.titles)
        print("This is the unit mother fucker! \(tempUnit)")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
