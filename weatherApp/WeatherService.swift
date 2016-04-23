//
//  WeatherService.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2015-12-26.
//  Copyright © 2015 ratatat. All rights reserved.
//

import Foundation


protocol WeatherServiceDelegate {
    
    func setWeather(weather: Weather)
}

class WeatherService {
    
    var delegate: WeatherServiceDelegate?
    
    func getWeather(city:String){
        
        let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&appid=ee9e52e7756ed0fc6073f1f5abee5fb2"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
    
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
    
        let json = JSON(data: data!)
            
            if json != nil {
         
            
        //let lon  = json["coord"]["lon"].double
        //let lat  = json["coord"]["lat"].double
        let tempdec = json["main"]["temp"].double! - 273.1
        let temp = round(tempdec*10)/10
        let name = json["name"].string
        let desc = json["weather"][0]["description"].string
        let icon = json["weather"][0]["icon"].string
        
            
            
        
        let weather = Weather(cityName: name!, temperature: temp, description: desc!, icon: icon!)
            
            if self.delegate != nil {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.delegate?.setWeather(weather)
                })
                
            }
            
        }else{
            
            print("Aint no Fucking Data in weather man")
        }
        }
    
        task.resume()
        
        
     
    }
}
