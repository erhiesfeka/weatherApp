//
//  ForecastWeather.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-01-31.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation
import UIKit


protocol ForecastWeatherDelegate {
    
    func setForecast(forecast: Forecasty)
   // func setWeather(weather: Weather)
}


class ForecastWeather {
    
    var delegate: ForecastWeatherDelegate?
   // static let sharedInstance = ForecastWeather()
  var tempArray: [Int] = []
  let iconArray = NSMutableArray()
  let dateArray = NSMutableArray()
  let descArray = NSMutableArray()
    
   
    
    func getForecast(city:String){
        
       let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let pathf = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityEscaped!)&mode=json&appid=ee9e52e7756ed0fc6073f1f5abee5fb2"
        let url = NSURL(string: pathf)
        let session = NSURLSession.sharedSession()
        let taskf = session.dataTaskWithURL(url!) { (dataf: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if dataf == nil {
                
                print ("dataf equals nil")
            }
            
            let jsonf = JSON(data: dataf!)
            
            if jsonf != nil {
                
                for index in 0...8 {
                    
                    self.tempArray.append(jsonf["list"][index]["main"]["temp"].int! - 273)
                    
                }
                
                for index in 0...8 {
                    
                    self.iconArray[index] = jsonf["list"][index]["weather"][0]["icon"].string!
                }
            
                for index in 0...8 {
                    
                 self.dateArray[index] = jsonf["list"][index]["dt"].double!
                }
                
             //please change this it is incorrect
                
                for index in 0...8 {
                    
                    self.descArray[index] = round((jsonf["list"][index]["main"]["temp"].double! - 273.15)*10)/10
                }
            
           let forecast = Forecasty(dateArray: self.dateArray, tempArray: self.tempArray, iconArray: self.iconArray, descArray: self.descArray)
                
            
            if self.delegate != nil {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.delegate?.setForecast(forecast)
                })
                
            }
           
            }else{
                
                print("Aint no Fucking Data in forecast man")
            }
            
        }
        
        taskf.resume()
        
    
    }
}
