//
//  ViewController.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2015-12-26.
//  Copyright © 2015 ratatat. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController, WeatherServiceDelegate, ForecastWeatherDelegate, CLLocationManagerDelegate, iCarouselDataSource, iCarouselDelegate {
    
    let weatherService = WeatherService()
    let forecastWeather = ForecastWeather()
    let lManager = CLLocationManager()
    var label =  String()
    var imageArray :NSMutableArray = NSMutableArray()
    var iconArray :NSMutableArray = NSMutableArray()
    var tempArray :NSMutableArray = NSMutableArray()
    var dateArray:NSMutableArray = NSMutableArray()
    var descrptionArray:NSMutableArray = NSMutableArray()
    var date:NSDate = NSDate()
    var i = Int()
    var carouselIndex:Int = Int()
    var currentWeatherIcon = UIImage()
    var currentTemp = String()
    
    
    
    
    // Labels Declared
    @IBOutlet weak var carouselLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    // @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var whatToWearLabel: UILabel!
    @IBOutlet weak var iCarouselView: iCarousel!
    
    
    @IBAction func setCityTapped(sender: AnyObject) {
        
        openCityAlert()
        
    }
    
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
            
            // This is the link to weather service
            self.weatherService.getWeather(cityName!)
            self.forecastWeather.getForecast(cityName!)
            
        }
        
        alert.addAction(ok)
        
        //Add text Feild
        alert.addTextFieldWithConfigurationHandler { (textFeild:UITextField) -> Void in
            
            textFeild.placeholder = "City Name"
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func decider ( temperature: Double){
        
        if (temperature < 0 ) {
            
            
            label = " It will be \(temperature) degrees at. Have a winter jacket handy today"
            
        }else if (temperature > 0 && temperature < 10 ) {
            
            whatToWearLabel.text = " It will be \(temperature) degrees. Have a jacket handy today"
            
        } else if (temperature > 13 && temperature < 20){
            
            whatToWearLabel.text = " It will be \(temperature) degrees . Have a sweater handy"
            
            
        } else if (temperature > 20 && temperature < 25) {
            
            whatToWearLabel.text = "It will be \(temperature) degrees . Wear a T shirt and shorts"
            
        } else {
            
            whatToWearLabel.text = "It will be \(temperature) degrees . Carry a water bottle, Fucking hot"
            
        }
        
    }
    
    // MARK: Weather Service Delegate
    
    func setWeather(weather:Weather) {
        
        cityLabel.text = weather.cityName
        currentTemp = "\(weather.temperature)°C"
        tempLabel.text = "\(weather.temperature)°C"
        descriptionLabel.text = weather.description
        currentWeatherIcon = UIImage(named: "\(weather.icon)")!
        //  image.image = UIImage(named: "\(weather.icon).png")
        //cityButton.setTitle(weather.cityName, forState: UIControlState.Normal)
        print("your City is \(weather.cityName)")
        
    }
    
    
    func setForecast(forecast:Forecast) {
        
        iconArray = forecast.iconArray
        tempArray = forecast.tempArray
        dateArray = forecast.dateArray
        
        self.decider(tempArray[i] as! Double)
        
        imageArray = [ "\(iconArray[0]).png", "\(iconArray[1]).png", "\(iconArray[3]).png", "\(iconArray[4]).png", "\(iconArray[5]).png"]
        iCarouselView.alpha = 1
        iCarouselView.type = iCarouselType.Linear
        iCarouselView.reloadData()
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*
         
         let myCurrentloc = locations[locations.count-1]
         let mylat = "\(myCurrentloc.coordinate.latitude)"
         let mylon = "\(myCurrentloc.coordinate.longitude)"
         
         print(">> This is my  latitude \(mylat)")
         print(">> This is my  longitude \(mylon)")
         
         if (locations.count>1) {
         
         
         }
         
         //geo coder
         
         CLGeocoder().reverseGeocodeLocation(myCurrentloc) { (myPlacements, geoError) -> Void in
         
         if let myPlacement = myPlacements?.first {
         
         let citylocality = myPlacement.locality
         print(">>> My City is \(citylocality)")
         // self.weatherService.getWeather(citylocality!)
         // self.forecastWeather.getForecast(citylocality!)
         }
         }
         
         */
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.forecastWeather.delegate = self
        self.weatherService.delegate = self
        
        self.lManager.desiredAccuracy = kCLLocationAccuracyBest
        self.lManager.requestAlwaysAuthorization()
        self.lManager.startUpdatingLocation()
        lManager.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var weatherView : UIView!
        var tempLabel: UILabel
        var imageView: UIImageView
        imageView = UIImageView(frame: CGRectMake(0, 0, 100, 200))
        
        if view == nil {
            weatherView = UIView(frame: CGRectMake(0, 0, 200, 300))
            
            weatherView.contentMode = .ScaleAspectFit
            weatherView.layer.cornerRadius = 8.0
            weatherView.layer.borderWidth = 4
            weatherView.layer.borderColor =  UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
            
            imageView.center = CGPointMake(110,130)
            imageView.contentMode = .ScaleAspectFit
            
            imageView.layer.borderColor =  UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
            
            
            
            tempLabel = UILabel(frame:weatherView.bounds)
            tempLabel.backgroundColor = UIColor.clearColor()
            tempLabel.center = CGPointMake(180, 284)
            //tempLabel.textAlignment = .Center
            tempLabel.font = tempLabel.font.fontWithSize(20)
            tempLabel.tag = 1
            weatherView.addSubview(tempLabel)
            weatherView.addSubview(imageView)
            
        }else{
            
            weatherView = view
            tempLabel = weatherView.viewWithTag(1) as! UILabel!
            view!.alpha = 1.0
        }
        
        if index == 0 {
            
            imageView.image = currentWeatherIcon
            tempLabel.text = currentTemp
            
            return weatherView
            
        }else{
            
            imageView.image = UIImage(named: "\(imageArray.objectAtIndex(index))")
            i = index + 1
            tempLabel.text = "\(tempArray[i])°C"
            return weatherView
        }
        
        
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
        
        return imageArray.count
        
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        
        if iconArray.count != 0 {
            
            if iCarouselView.currentItemIndex == 0{
                
                carouselLabel.text = "Current Weather"
                
            }else{
                
                carouselIndex = iCarouselView.currentItemIndex + 1
                date = NSDate(timeIntervalSince1970: (dateArray[carouselIndex] as! Double))
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "hh:mm a, MMM dd"
                dateFormatter.timeZone = NSTimeZone()
                let localDate = dateFormatter.stringFromDate(date)
                carouselLabel.text = "\(localDate)"
                
            }
            
            
        }
        
    }
    
    
}

