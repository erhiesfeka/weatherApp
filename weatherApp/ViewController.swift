//
//  ViewController.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2015-12-26.
//  Copyright © 2015 ratatat. All rights reserved.
//

import UIKit
import CoreLocation
import BetterSegmentedControl




    var selectedItem :Int = Int()
    var description:String = String()
    var currentDesc:String = String()
    var tempNow:Int = Int()
     var unit:String = String()
    var latitude:Double = Double()
    var longitude:Double = Double()
    var tempFaren:Int = 0




class ViewController: UIViewController, CLLocationManagerDelegate, iCarouselDataSource, iCarouselDelegate, HolderViewDelegate {
    
    var weatherData:WeatherData = WeatherData()
    var hourlyTemp:[(time: String, tempForhour: Int)] = [] // hourly temp for 2 days in the future/ every three hours
    var minMaxDailyTemp:[(min: Int, max: Int)] = []// plus 7 days
    var iconDaily:[String] = []
    var iconHourly:[String] = []
    var timezone = ""
    var dailyDate: [String] = []
    let lManager = CLLocationManager()
    var label =  String()
    var i = Int()
    var carouselIndex:Int = Int()
    var city:String = String()
    var holderView = HolderView(frame: CGRectZero)
    
    
    var hourly = true
    


    
    // Labels Declared
    @IBOutlet weak var carouselLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    // @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var whatToWearLabel: UILabel!
    @IBOutlet weak var iCarouselView: iCarousel!
 
    @IBAction func revealPopUp(sender: AnyObject) {
       
        print("settings button reveals popup")
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sbPopUpID") as! PopUpViewController
        
        self.addChildViewController(popOverVC)
       
        popOverVC.view.frame = self.view.frame
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMoveToParentViewController(self)
        print("This is unit when the settings button is pressed \(unit)")
        
    }
    
 
 
    @IBAction func changeUnit(sender: AnyObject) {
        
        if tempFaren == 1 {
            
            tempFaren = 2
            
        }else if tempFaren == 2{
            tempFaren = 1
        }else{
            
            tempFaren = 0
        }
        
        getWeather(0.5)
    }
    
  /*  func changeUniit(){
        if tempFaren == 1 {
            
            tempFaren = 2
            
        }else if tempFaren == 2{
            tempFaren = 1
        }else{
            
            tempFaren = 0
        }
        
        getWeather(0.5)
 
    
    }*/
  

    
    

    
    func openCityAlert(){
        
        //create alert controller
        
        let alert = UIAlertController(title: "City", message: "Please Enter City Name",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        //create Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(cancel)
        
        //createe OK action
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in

            
            let textFeild = alert.textFields?[0]
            let cityName = textFeild?.text!
            
            self.cityLabel.text = cityName!
            
        }
        
        alert.addAction(ok)
        
        //Add text Feild
        alert.addTextFieldWithConfigurationHandler { (textFeild:UITextField) -> Void in
            
            textFeild.placeholder = "City Name"
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
  
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    

    
    // MARK: Weather Service Delegate
    

    func getWeather(waitTime: Double) {
        
        weatherData.getweather()
        
        delay(waitTime) {
            
            unit = self.weatherData.unit
            print( "This is what you should use for units \(unit)")
            self.cityLabel.text = self.city
            self.hourlyTemp =  self.weatherData.hourlyTemp
            self.iconHourly = self.weatherData.iconHourly
            self.iconDaily = self.weatherData.iconDaily
            self.minMaxDailyTemp = self.weatherData.minMaxDailyTemp
            self.dailyDate = self.weatherData.dailyDate
            self.removeHolderView()
            // self.whatToWearLabel.text = weather.decideClothes()
            self.iCarouselView.alpha = 1
            self.iCarouselView.type = iCarouselType.Linear
            self.iCarouselView.reloadData()
            
            
        }
        
    }
    
    
    func navigationSegmentedControlValueChanged(sender: BetterSegmentedControl) {
        if sender.index == 0 {
            hourly = true
            carouselLabel.text = hourlyTemp[carouselIndex].time
        }
        else {
            hourly = false
            carouselLabel.text = dailyDate[carouselIndex]
        }
        
        iCarouselView.reloadData()
        
    }


    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
         let myCurrentloc = locations[locations.count-1]
        
        latitude = myCurrentloc.coordinate.latitude
        longitude = myCurrentloc.coordinate.longitude
        
         
         CLGeocoder().reverseGeocodeLocation(myCurrentloc) { (myPlacements, geoError) -> Void in
         
           if let myPlacement = myPlacements?.first {
             self.city = myPlacement.locality!
        
            print(">>> My City is \(self.city)")
            
            self.getWeather(3.0)
            self.lManager.stopUpdatingLocation()
      
            }
            
         }
 
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib
         addHolderView()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        self.lManager.desiredAccuracy = kCLLocationAccuracyBest
        self.lManager.requestAlwaysAuthorization()
        self.lManager.startUpdatingLocation()
        lManager.delegate = self
        
        let control = BetterSegmentedControl(
            frame: CGRect(x: self.view.bounds.width * 0.25, y: self.view.bounds.height * 0.75, width: self.view.bounds.width * 0.50, height: 25.0),
            titles: ["Hourly", "Daily"],
            index: 0,
            backgroundColor: .clearColor(),
            titleColor: .blackColor(),
            indicatorViewBackgroundColor:  UIColor.lightGrayColor(),
            selectedTitleColor: .whiteColor())
        control.cornerRadius = 8.0
        
        control.titleFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        
        control.addTarget(self, action: #selector(ViewController.navigationSegmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(control)
        
        
    }
    
    
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        var weatherView : UIView!
        var tempLabel: UILabel
        var imageView: UIImageView
        
        imageView = UIImageView(frame: CGRectMake(0, 0, 100, 200))
        //imageView.backgroundColor = Colors.blue
        
        if view == nil {
            weatherView = UIView(frame: CGRectMake(0, 0, 200, 300))
            
            weatherView.contentMode = .ScaleAspectFit
            weatherView.layer.cornerRadius = 8.0
            weatherView.layer.borderWidth = 4
            weatherView.layer.borderColor =  UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
           // weatherView.backgroundColor = Colors.red
            
            imageView.center = weatherView.center
            imageView.contentMode = .ScaleAspectFit
            
            imageView.layer.borderColor =  UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        
            tempLabel = UILabel(frame:CGRectMake(0, 0, 200, 20))
            imageView.contentMode = .ScaleAspectFit
            tempLabel.backgroundColor = UIColor.clearColor()
            tempLabel.textAlignment = NSTextAlignment.Center
            tempLabel.center = CGPointMake(100 , 284)
           
            
            
            
        
            tempLabel.font = tempLabel.font.fontWithSize(20)
            tempLabel.tag = 1
            weatherView.addSubview(tempLabel)
            weatherView.addSubview(imageView)

            
        }else{
            
            weatherView = view
            tempLabel = weatherView.viewWithTag(1) as! UILabel!
         
            view!.alpha = 1.0
        }
        
        if hourly {
        imageView.image = UIImage(named: "\(iconHourly[index])")
        tempLabel.text = "\(hourlyTemp[index].tempForhour) \(unit)"
        
            
            
           
        }else{
            imageView.image = UIImage(named: "\(iconDaily[index])")
            tempLabel.text = "\(minMaxDailyTemp[index].max) \(unit) | \(minMaxDailyTemp[index].min) \(unit)"
          
            
        }
        
       
        return weatherView
        
        
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        
        switch (option)
        {
        case .Spacing:
            return value * 1.1
            
        case .FadeMax:
            return 0.0
        case .FadeMin:
            return 0.0
        case .FadeRange:
            return  1.0
            
        case .FadeMinAlpha:
            return 0.2
            
        // Error cannot convert return expression
        default:
            return value
        }
        
        
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        
     //  let numberOfItemsInArray = Int(imageArray.count) + 1
        
        return hourlyTemp.count
        
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        
        if hourlyTemp.count != 0 {
                
            carouselIndex = iCarouselView.currentItemIndex
            
            if hourly{
              carouselLabel.text = hourlyTemp[carouselIndex].time
            }else{
              carouselLabel.text = dailyDate[carouselIndex]
               
            }
        
        }
    }
    
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        
        let DetailedCardView:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardView")
        // self.presentViewController(viewController, animated: true, completion: nil)
        
        selectedItem = index
        
        self.presentViewController(DetailedCardView, animated: true, completion: nil)
        
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
        
    }

    func removeHolderView(){
        
       holderView.removeFromSuperview()
      // holderView = nil
    }
    
    func animateLabel() {
        
      //  holderView.removeFromSuperview()
        
    }
    
    func addButton() {
        let button = UIButton()
        button.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        button.addTarget(self, action: #selector(ViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }
    
    func buttonPressed(sender: UIButton!) {
        view.backgroundColor = Colors.white
        holderView = HolderView(frame: CGRectZero)
        addHolderView()
    }
    


    
}

