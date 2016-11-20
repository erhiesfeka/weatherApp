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
import UserNotifications
import GooglePlaces

enum tempUnit: String{
    
    case celsius = "°C"
    case farenheit = "°F"
    case unknownDefault = "Unit"
    
}
// Global Variables
var selectedItem :Int = Int()
var description:String = String()
var currentDesc:String = String()
var tempNow:Int = Int()
var latitude:Double? = Double()
var longitude:Double? = Double()
var selectedUnit:tempUnit = .unknownDefault
var city:String? = String()
var manualLocation = false
//Global Function
func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}


class ViewController: UIViewController, CLLocationManagerDelegate, weatherDataDelegate, iCarouselDataSource, iCarouselDelegate, HolderViewDelegate, decideWeatherDelegate  {
    
    // ViewController class Variables
    var weatherData:WeatherData = WeatherData()
    var decider:Decider = Decider()
    var clothesDecision:[String] = []
    var precipIntensityDecision:[String] = []
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
    
    var holderView = HolderView(frame: CGRect.zero)
    let blurEffectView = UIVisualEffectView()
    var unit:String = String()
    var hourly = false
    var precipType:[String] = []
    var finalDecision:[String] = []
    
    
    // Outlets Declared
    
    @IBOutlet weak var carouselLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var whatToWearLabel: UILabel!
    @IBOutlet weak var iCarouselView: iCarousel!
    @IBOutlet weak var reloadButton: UIButton!
    
    // Settings Button to reveal popup
    @IBAction func revealPopUp(_ sender: AnyObject) {
        
        openSettings()
        
    }
    
    
    
    // ReloadData debug option
    @IBAction func reloadData(_ sender: AnyObject) {
        
        self.getWeather()
    }
    
    func openSettings(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView.effect = blurEffect
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
        
        print("settings button reveals popup")
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        print("This is unit when the settings button is pressed \(self.unit)")
    }
    func reloadiCarouselData() {
        
        self.getWeather()
        self.iCarouselView.reloadData()
        print("iwascalled")
    }
    
    func removePopUP(){
        self.blurEffectView.effect = nil
        self.blurEffectView.removeFromSuperview()
    }
    
    func localNotification(){
        UIApplication.shared.cancelAllLocalNotifications()
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var dateFire = NSDate()
        
        var fireComponents = calendar.components([.day, .month,.year,.hour,.minute], from:dateFire as Date)
        
        if (fireComponents.hour! >= 7) {
            dateFire=dateFire.addingTimeInterval(86400)  // Use tomorrow's date
            
            fireComponents=calendar.components([.day, .month,.year,.hour,.minute], from:dateFire as Date)
        }
        
        
        fireComponents.hour = 7
        fireComponents.minute = 0
        
        dateFire = calendar.date(from: fireComponents)! as NSDate
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = dateFire as Date
        localNotification.alertBody = "A new day has begun! Don't get caught outside with the wrong clothes for the weather!"
        localNotification.repeatInterval = NSCalendar.Unit.day
        localNotification.applicationIconBadgeNumber = 1
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
        
        
        
    }
    
    
    func getWeather() {
        
        self.weatherData.getweather()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "startDeciding"), object: nil)
        
    }
    
    func setWeather(weather: WeatherStruct) {
        //     print("****ViewController setweather")
        //      print("***hourly temp: \(weather.hourlyTemp)")
        //      print("**** IconHourly \(weather.iconHourly)")
        
        if weather.hourlyTemp.count != 7 {
            
            
            delay(3.0) {
                self.getWeather()
            }
            
        }else{
            
            self.unit = weather.unit
            //  self.unit = selectedUnit.rawValue
            print( "This is what you should use for units \(self.unit)")
            self.cityLabel.text = city
            self.hourlyTemp =  weather.hourlyTemp
            self.iconHourly = weather.iconHourly
            self.iconDaily = weather.iconDaily
            print(self.iconDaily)
            self.minMaxDailyTemp = weather.minMaxDailyTemp
            self.dailyDate = weather.dailyDate
            self.precipType = weather.precipitationType
            self.removeHolderView()
            self.iCarouselView.alpha = 1
            self.iCarouselView.type = iCarouselType.linear
            self.iCarouselView.reloadData()
            
        }
    }
    
    func decideWeather(decision: DecisionStruct) {
        self.clothesDecision = decision.clothesDecision
        self.precipIntensityDecision = decision.precipDecision
        self.finalDecision = decision.finalDecision
        
        print(">>>>> Decision \(self.clothesDecision)")
    }
    
    
    func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            hourly = false
            carouselLabel.text = dailyDate[carouselIndex]
            
            
        }
        else {
            
            hourly = true
            carouselLabel.text = hourlyTemp[carouselIndex].time
            
        }
        
        iCarouselView.reloadData()
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Location Manager Called")
        let myCurrentloc = locations[locations.count-1]
        
        latitude = myCurrentloc.coordinate.latitude
        longitude = myCurrentloc.coordinate.longitude
        
        CLGeocoder().reverseGeocodeLocation(myCurrentloc) { (myPlacements, geoError) -> Void in
            
            if let myPlacement = myPlacements?.first {
                city = myPlacement.locality!
                
                self.lManager.stopUpdatingLocation()
            }
            
        }
        
    }
    
    func openCityAlert(){
        
        //create alert controller
        
        let alert = UIAlertController(title: "Location services off", message: "Turn on location services from your phone's settings or enter location manually",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        //create Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(cancel)
        
        //createe OK action
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
            
            self.openSettings()
            
        }
        
        alert.addAction(ok)
        
        print (" THis is my city: \(city)")
        
        if city == "" {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        self.weatherData.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadiCarouselData), name: NSNotification.Name(rawValue: "reloadiCarousel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.removePopUP), name: NSNotification.Name(rawValue: "removePopUP"), object: nil)
        self.decider.addObserver()
        
        localNotification()
        
        self.decider.delegate = self
        addHolderView()
        
        self.getWeather()
        self.iCarouselView.reloadData()
        
        print("Latitude and Longitude are: \(latitude) && \(longitude)")
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.reloadiCarouselData), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                openCityAlert()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            default:
                print("...")
            }
        } else {
            print("Location services are not enabled")
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if manualLocation == false{
                self.lManager.desiredAccuracy = kCLLocationAccuracyBest
                self.lManager.requestAlwaysAuthorization()
                self.lManager.startUpdatingLocation()
                lManager.delegate = self
            }
        }
        
        
        let control = BetterSegmentedControl(
            frame: CGRect(x: self.view.bounds.width * 0.25, y: self.view.bounds.height * 0.80, width: self.view.bounds.width * 0.50, height: 25.0),
            titles: ["Daily", "Current"],
            index: 0,
            backgroundColor: .clear,
            titleColor: .black,
            indicatorViewBackgroundColor:  Colors.pink,
            selectedTitleColor: Colors.labelBlue)
        control.cornerRadius = 8.0
        
        control.titleFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        
        control.addTarget(self, action: #selector(ViewController.navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(control)
        
        
    }
    func willEnterForeground() {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var weatherView : UIView!
        var tempLabel: UILabel
        var decisionLabel: UILabel
        var imageView: UIImageView
        let backgroundView = UIImageView()
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        //imageView.backgroundColor = Colors.blue
        
        if view == nil {
            
            let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 250, height: 260),
                                        byRoundingCorners: [.topLeft, .topRight],
                                        cornerRadii: CGSize(width: 8.0, height: 8.0))
            
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            
            weatherView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 370))
            weatherView.contentMode = .scaleAspectFit
            weatherView.layer.cornerRadius = 12.0
            //weatherView.layer.borderWidth = 4
            //weatherView.layer.borderColor =  UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
            weatherView.backgroundColor = Colors.white
            
            imageView.center = weatherView.center
            imageView.contentMode = .scaleAspectFit
            imageView.layer.borderColor =  UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
            imageView.contentMode = .scaleAspectFit
            
            backgroundView.frame = maskPath.bounds
            backgroundView.layer.masksToBounds = true
            backgroundView.contentMode = .scaleToFill
            backgroundView.tintColor = Colors.pink
            backgroundView.layer.mask = shape
            
            tempLabel = UILabel(frame:CGRect(x: 0, y: 450, width: 250, height: 60))
            tempLabel.backgroundColor = UIColor.clear
            tempLabel.textAlignment = NSTextAlignment.center
            tempLabel.center = backgroundView.center
            tempLabel.textAlignment = NSTextAlignment.center
            tempLabel.font = UIFont(name:"Optima-Regular", size: 45.0)
            tempLabel.tag = 1
            tempLabel.textColor = UIColor.white
            
            decisionLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 250, height: 60))
            decisionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            if #available(iOS 8.2, *) {
                decisionLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
            } else {
                // Fallback on earlier versions
                decisionLabel.font = UIFont(name:"Optima-Regular", size: 16)
            }
            decisionLabel.numberOfLines = 3
            decisionLabel.textAlignment = NSTextAlignment.center
            decisionLabel.backgroundColor = UIColor.clear
            
            decisionLabel.tag = 2
            decisionLabel.textColor = Colors.bottomLabelBlue
            decisionLabel.center = CGPoint(x: backgroundView.frame.origin.x + 128 , y: backgroundView.frame.origin.y + 310)
            
            
            carouselLabel.textColor = Colors.labelBlue
            
            // tempLabel.font.
            weatherView.addSubview(backgroundView)
            weatherView.addSubview(tempLabel)
            weatherView.addSubview(decisionLabel)
            //  weatherView.addSubview(imageView)
            
            
        }else{
            
            weatherView = view
            tempLabel = weatherView.viewWithTag(1) as! UILabel!
            decisionLabel = weatherView.viewWithTag(2) as! UILabel!
            
            view!.alpha = 1.0
        }
        
        
        
        
        if hourly {
            backgroundView.image = UIImage(named: "\(iconHourly[index]).jpg")
            tempLabel.text = "\(hourlyTemp[index].tempForhour)\(self.unit)"
            
            if self.clothesDecision.count != 0 && self.precipType.count != 0 {
                decisionLabel.text = "\(self.clothesDecision[index]). \(self.finalDecision[index])"
                
            }
        }else{
            backgroundView.image = UIImage(named: "\(iconDaily[index]).jpg")
            tempLabel.text = "\(minMaxDailyTemp[index].max)\(self.unit) | \(minMaxDailyTemp[index].min)\(self.unit)"
            
            if self.clothesDecision.count != 0 && self.precipType.count != 0{
                decisionLabel.text = "\(self.clothesDecision[index]). \(self.finalDecision[index])"
                
            }
        }
        
        
        return weatherView
        
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        
        switch (option)
        {
        case .spacing:
            return value * 1.1
            
        case .fadeMax:
            return 0.0
        case .fadeMin:
            return 0.0
        case .fadeRange:
            return  1.0
            
        case .fadeMinAlpha:
            return 0.2
            
        // Error cannot convert return expression
        default:
            return value
        }
        
        
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        return hourlyTemp.count
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        if hourlyTemp.count != 0 {
            
            carouselIndex = iCarouselView.currentItemIndex
            
            if hourly{
                carouselLabel.text = hourlyTemp[carouselIndex].time
            }else{
                carouselLabel.text = dailyDate[carouselIndex]
                
            }
            
        }
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        let DetailedCardView:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardView")
        // self.presentViewController(viewController, animated: true, completion: nil)
        
        selectedItem = index
        
        self.present(DetailedCardView, animated: true, completion: nil)
        
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
        button.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height)
        button.addTarget(self, action: #selector(ViewController.buttonPressed(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func buttonPressed(_ sender: UIButton!) {
        view.backgroundColor = Colors.white
        holderView = HolderView(frame: CGRect.zero)
        addHolderView()
    }
    
    
    
    
    
}

