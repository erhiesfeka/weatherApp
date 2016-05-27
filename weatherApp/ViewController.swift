//
//  ViewController.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2015-12-26.
//  Copyright © 2015 ratatat. All rights reserved.
//

import UIKit
import CoreLocation


    var currentTemp:String = String()
    var tempArray :[Int] = [Int]()
    var selectedItem :Int = Int()
    var description:String = String()
    var currentDesc:String = String()
    var tempNow:Int = Int()


class ViewController: UIViewController, WeatherServiceDelegate, ForecastWeatherDelegate, CLLocationManagerDelegate, iCarouselDataSource, iCarouselDelegate, HolderViewDelegate {
    
    let weatherService = WeatherService()
    let forecastWeather = ForecastWeather()
    let lManager = CLLocationManager()
    var label =  String()
    var imageArray :NSMutableArray = NSMutableArray()
    var iconArray :NSMutableArray = NSMutableArray()
    var descArray :NSMutableArray = NSMutableArray()
    var dateArray:NSMutableArray = NSMutableArray()
    var date:NSDate = NSDate()
    var i = Int()
    var carouselIndex:Int = Int()
    var currentWeatherIcon = String()
    var city:String = String()
    var holderView = HolderView(frame: CGRectZero)
    

    
    // Labels Declared
    @IBOutlet weak var carouselLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    // @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var whatToWearLabel: UILabel!
    @IBOutlet weak var iCarouselView: iCarousel!
    
 
  
    @IBAction func showMe(sender: AnyObject) {
        
    let erhies:WeatherData = WeatherData()
        
        erhies.getweather()
    }
 
    
    
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
    
    func setWeather(weather:Weather) {
        currentTemp = "\(weather.temperature)"
        tempNow = weather.temperature
        self.currentWeatherIcon =  "\(weather.icon)"
        
        delay(3.0) {
            
            self.cityLabel.text = weather.cityName
                       self.tempLabel.text = "\(weather.temperature)°C"
            self.descriptionLabel.text = weather.description
            currentDesc = weather.description
            
        }
      
    
    }
    
    
    func setForecast(forecast:Forecasty) {
        let date = NSDate()
        let currentDate = (date.timeIntervalSince1970)
        let weather = Decider()
        
        imageArray = forecast.iconArray
        tempArray = forecast.tempArray
        dateArray = forecast.dateArray
        descArray = forecast.descArray
        
        imageArray.insertObject(currentWeatherIcon, atIndex: 0)
        tempArray.insert(tempNow, atIndex: 0)
        dateArray.insertObject(currentDate, atIndex: 0)
        
        
       
        delay(3.0) {
            
            self.removeHolderView()
            self.whatToWearLabel.text = weather.decideClothes()
            self.iCarouselView.alpha = 1
            self.iCarouselView.type = iCarouselType.Linear
            self.iCarouselView.reloadData()
        }
      
       
        print (imageArray, tempArray, dateArray)
        
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
         let myCurrentloc = locations[locations.count-1]
         
         CLGeocoder().reverseGeocodeLocation(myCurrentloc) { (myPlacements, geoError) -> Void in
         
           if let myPlacement = myPlacements?.first {
             self.city = myPlacement.locality!
        
            print(">>> My City is \(self.city)")
            self.weatherService.getWeather(self.city)
            self.forecastWeather.getForecast(self.city)
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
        
        self.forecastWeather.delegate = self
        self.weatherService.delegate = self
        
        self.lManager.desiredAccuracy = kCLLocationAccuracyBest
        self.lManager.requestAlwaysAuthorization()
        self.lManager.startUpdatingLocation()
        lManager.delegate = self
        
        
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
        
            tempLabel.font = tempLabel.font.fontWithSize(20)
            tempLabel.tag = 1
            weatherView.addSubview(tempLabel)
            weatherView.addSubview(imageView)

            
        }else{
            
            weatherView = view
            tempLabel = weatherView.viewWithTag(1) as! UILabel!
         
            view!.alpha = 1.0
        }
        
        imageView.image = UIImage(named: "\(imageArray.objectAtIndex(index))")
        tempLabel.text = "\(tempArray[index])°C"
       
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
        
        return imageArray.count
        
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        
        if imageArray.count != 0 {
                
            carouselIndex = iCarouselView.currentItemIndex 
            date = NSDate(timeIntervalSince1970: (dateArray[carouselIndex] as! Double))
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm a, MMM dd"
            dateFormatter.timeZone = NSTimeZone()
            let localDate = dateFormatter.stringFromDate(date)
            carouselLabel.text = "\(localDate)"
        
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
        view.subviews.map({ $0.removeFromSuperview() })
        holderView = HolderView(frame: CGRectZero)
        addHolderView()
    }
    
}

