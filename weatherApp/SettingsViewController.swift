//
//  SettingsViewController.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-09-02.
//  Copyright © 2016 ratatat. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import GooglePlaces


class SettingsViewController: UIViewController {
    @IBOutlet weak var control1: BetterSegmentedControl!
    @IBOutlet weak var control2: BetterSegmentedControl!
 
    
    //  @IBOutlet weak var control3: BetterSegmentedControl!
    
    var tempCelcius:Bool = Bool()
    var vc = ViewController()
    var wd = WeatherData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        control1.titles = ["°C","°F"]
        control1.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        control1.alwaysAnnouncesValue = true
        
        switch selectedUnit {
        case .farenheit:
            do{
                try control1.set(1, animated: false)
            }catch _{
                print ("no such index")
            }
            
        case .celsius:
            
            do{
                try control1.set(0, animated: false) //setIndex(0)
            }catch _{
                print ("no such index")
            }
        default:
            print("*>*>*> something's not right")
        }
        
        control1.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        
         control2.titles = ["Yes","No"]
         control2.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
         control2.alwaysAnnouncesValue = true
        
        do{
            try control2.set(2, animated: false)
        }catch _{
            print ("no such index")
        }
         control2.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControl2ValueChanged(_:)), for: .valueChanged)
        
        
        
         /*
         control3.titles = ["Yes","No"]
         control3.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
         control3.alwaysAnnouncesValue = true
         control3.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControlValueChanged(_:)), for: .valueChanged)*/
        
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
     
        
        if sender.index == 1 {
            
            print("Temperature is farenheit")
       
            selectedUnit = .farenheit
            
        }
        else {
           
            selectedUnit = .celsius
            
        }
        
        
        userDefaults.set(selectedUnit.rawValue, forKey: "savedUnit")
        
       
       
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadiCarousel"), object: nil)
       
        
        
    }
    
    func navigationSegmentedControl2ValueChanged(_ sender: BetterSegmentedControl){
        if sender.index == 1 {
            
            print("Manually enter location")
           
            let autocompleteController = GMSAutocompleteViewController()
             autocompleteController.delegate = self
            self.present(autocompleteController, animated: true, completion: nil)
            
            
        }
        else {
            
             print("Dont Manually enter location")
            
        }
        
    }
    
    


    
    
}

extension SettingsViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        print("Place Longitude: ", place.coordinate.longitude)
        print("Place Latitude: ", place.coordinate.latitude)
        self.dismiss(animated: true, completion: nil)
        self.view.removeFromSuperview()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
