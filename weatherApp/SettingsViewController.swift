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
    @IBOutlet weak var control2: BetterSegmentedControl!
    @IBOutlet weak var control3: BetterSegmentedControl!
    
    var tempCelcius:Bool = Bool()
    var vc = ViewController()
    var wd = WeatherData()
   
   
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
       
       
     
        
        control1.titles = ["°C","°F"]
        control1.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        control1.alwaysAnnouncesValue = true
        control1.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
        if unit == "°C"{
            do{
           try control1.setIndex(0)
            }catch _{
                print ("no such index")
            }
        }else{
            do{
                try control1.setIndex(1)
            }catch _{
                print ("no such index")
            }
        }
        
        control2.titles = ["Yes","No"]
        control2.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        control2.alwaysAnnouncesValue = true
        control2.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
     
        control3.titles = ["Yes","No"]
        control3.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        control3.alwaysAnnouncesValue = true
        control3.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
        
        print("Heres what im using for Units \(unit)")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    func navigationSegmentedControlValueChanged(sender: BetterSegmentedControl) {
        if sender.index == 1 {
            
            print("Temperature is celcius")
            
            vc.changeUniit()
            
            wd.getweather()
         //   vc.iCarouselView.reloadData()
            
            
           
        }
        else {
            print("Temperature is farenheit")
         vc.changeUniit()
            wd.getweather()
         //   vc.iCarouselView.reloadData()
        }
        
    }
    



}
