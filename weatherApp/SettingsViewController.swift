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
import ZMSwiftRangeSlider



class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    
    
    //  @IBOutlet weak var control3: BetterSegmentedControl!
    
    var tempCelcius:Bool = Bool()
    var vc = ViewController()
    var wd = WeatherData()
    var segmentedControlLabel:[[String]] = []
    var cellLabelTitle:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.revealCitySelectPage), name: NSNotification.Name(rawValue: "revealCitySelectPage"), object: nil)
        
        // Temperature Unit control
        
        segmentedControlLabel = [["°C","°F"], ["Yes", "No"]]
        cellLabelTitle = ["Temperature Unit", "Manually Select \n Location"]
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.tableView.alpha = 1
            
        })
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func revealCitySelectPage() {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        self.present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
    func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        
        if sender.index == 1 {
            
            print("Temperature is farenheit")
            
            selectedUnit = .farenheit
            
        }
        else {
            
            selectedUnit = .celsius
            
        }
        if unitChanged{
            tableView.reloadData()
        }
        
        userDefaults.set(selectedUnit.rawValue, forKey: "savedUnit")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadiCarousel"), object: nil)
        
      
        
        
    }
    
    func rangeSliderValueDidChange(/*_ sender: MARKRangeSlider*/) {
        print("slidervaluechanged)")
    }
    
    
    
    func navigationSegmentedControl2ValueChanged(_ sender: BetterSegmentedControl){
        
        if sender.index == 0 {
        
            print("Manually enter location")
            
            manualLocation = true
            
        }
        else {
            
            
            print("Dont Manually enter location")
            manualLocation = false
            city = ""
            latitude = 0
            longitude = 0
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateLocation"), object: nil)
        }
        
        if locationSettingChanged{
            tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell    {
        if indexPath.row == 0 {
            let cell:SegmentedControlCell = self.tableView.dequeueReusableCell(withIdentifier: "segmentedCell")! as! SegmentedControlCell
            
            switch selectedUnit {
            case .farenheit:
                do{
                    try cell.segmentedControl.setIndex(1, animated: false)
                }catch _{
                    print ("no such index")
                }
                
            case .celsius:
                
                do{
                    try cell.segmentedControl.setIndex(0, animated: false) //setIndex(0)
                }catch _{
                    print ("no such index")
                }
            default:
                print("*>*>*> something's not right")
            }
            
            cell.SegmentedCellLabel.text = self.cellLabelTitle[indexPath.row]
            
            cell.segmentedControl.titles = self.segmentedControlLabel[indexPath.row]
            
            cell.segmentedControl.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
            
          

            
            return cell
            
            
        }else if indexPath.row == 1 {
            
            let cell:segmentedControlCell2 = self.tableView.dequeueReusableCell(withIdentifier: "segmentedCell2")! as! segmentedControlCell2
            cell.segmentedCell2Control.titles = self.segmentedControlLabel[indexPath.row]
            cell.selectCityButton.backgroundColor = .clear
            cell.selectCityButton.layer.cornerRadius = 5
            cell.selectCityButton.layer.borderWidth = 1
            cell.selectCityButton.setTitleColor(Colors.cyan, for: .normal)
            cell.selectCityButton.setTitleColor(Colors.cyanLight, for: .disabled)
            if manualLocation{
               cell.selectCityButton.isEnabled = true
                
               cell.selectCityButton.layer.borderColor = Colors.cyan.cgColor
                
            }else{
                cell.selectCityButton.isEnabled = false
                cell.selectCityButton.layer.borderColor = Colors.cyanLight.cgColor
            }
            
            
            if manualLocation == false {
                
                do{
                    try cell.segmentedCell2Control.setIndex(1, animated: false)
                }catch _{
                    print ("no such index")
                }
                
            }else{
                
                do{
                    try cell.segmentedCell2Control.setIndex(0, animated: false)
                }catch _{
                    print ("no such index")
                }
            }
            cell.segmentedCell2Control.addTarget(self, action: #selector(SettingsViewController.navigationSegmentedControl2ValueChanged(_:)), for: .valueChanged)
        
            return cell
        }else if indexPath.row == 2{
            
           let cell:rangeCell1 = self.tableView.dequeueReusableCell(withIdentifier: "rangeCell1")! as! rangeCell1
            let heavyJacketTempSlider = cell.heavyJacketTemperature
            
            var unit:String = String()
            
            switch selectedUnit {
                
            case .farenheit:
                
                unit = "°F"
                
            case .celsius:
                
                unit = "°C"
                
            default:
                unit = "°C"
                
            }
            
            
            cell.label.text = "\(Int(round(heavyJacketTempSlider!.value))) \(unit)"
           //  = "\(heavyJacketTempSlider!.value)"
            
            return cell
        }else{
            let cell:rangeCell = self.tableView.dequeueReusableCell(withIdentifier: "rangeCell")! as! rangeCell
            
         
            
          /*  rangeSlider.addTarget(self, action: #selector(SettingsViewController.rangeSliderValueDidChange(_:)), for: .valueChanged)
             rangeSlider.setMinValue(0.0, maxValue: 1.0)
             rangeSlider.setLeftValue(0.2, rightValue: 0.7)
            rangeSlider.minimumDistance = 0.2
            rangeSlider.tintColor = Colors.purp*/
            
        //  view.addSubview(rangeSlider)
            
            return cell
            
        }
        
        }
        
        
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 90
        }else if indexPath.row == 2 {
            return 95
            
        }else if indexPath.row == 3 {
            return 90
        }else{
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
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
