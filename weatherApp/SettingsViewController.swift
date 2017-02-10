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



class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var control1: BetterSegmentedControl!
    @IBOutlet weak var control2: BetterSegmentedControl!
    @IBOutlet weak var selectCityButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func Select(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        self.present(autocompleteController, animated: true, completion: nil)
        
    }
 
    
    //  @IBOutlet weak var control3: BetterSegmentedControl!
    
    var tempCelcius:Bool = Bool()
    var vc = ViewController()
    var wd = WeatherData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Temperature Unit control
        
        control1.titles = ["°C","°F"]
        control1.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        control1.alwaysAnnouncesValue = true
        
        switch selectedUnit {
        case .farenheit:
            do{
                try control1.setIndex(1, animated: false)
            }catch _{
                print ("no such index")
            }
            
        case .celsius:
            
            do{
                try control1.setIndex(0, animated: false) //setIndex(0)
            }catch _{
                print ("no such index")
            }
        default:
            print("*>*>*> something's not right")
        }
        
        //Manually set location COntrol
        if manualLocation == false{
            selectCityButton.isEnabled = false
            selectCityButton.setTitleColor(UIColor.gray, for: .normal)
        }else{
            selectCityButton.setTitleColor(UIColor.red, for: .normal)
        }
        
        control1.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        
         control2.titles = ["Yes","No"]
         control2.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
         control2.alwaysAnnouncesValue = true
        
        
        if manualLocation == false {
            
        do{
            try control2.setIndex(1, animated: false)
        }catch _{
            print ("no such index")
        }
         
        }else{
            
            do{
                try control2.setIndex(0, animated: false)
            }catch _{
                print ("no such index")
            }
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
        if sender.index == 0 {
            selectCityButton.isEnabled = true
            print("Manually enter location")
            
            manualLocation = true
            
           selectCityButton.setTitleColor(UIColor.red, for: .normal)
        }
        else {
         
             selectCityButton.isEnabled = false
             print("Dont Manually enter location")
             manualLocation = false
             city = ""
             latitude = 0
             longitude = 0
             selectCityButton.setTitleColor(UIColor.gray, for: .normal)
             NotificationCenter.default.post(name: Notification.Name(rawValue: "updateLocation"), object: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell    {
        
        let cell:SegmentedControlCell = self.tableView.dequeueReusableCell(withIdentifier: "segmentedCell")! as! SegmentedControlCell
        
        
        cell.SegmentedCellLabel.text = "Temperature Unit"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        //  selectedPeripheral = peripherals[indexPath.row]
        //   selectedPeripheral?.delegate = self
        
        tableView.reloadData()
        
    }

    
}

extension SettingsViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        city = place.name
        print("Place Longitude: ", place.coordinate.longitude)
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        print("Place Latitude: ", place.coordinate.latitude)
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "clickClose"), object: nil)
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
