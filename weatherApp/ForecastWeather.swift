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
    
    func setForecast(forecast: Forecast)
}

class ForecastWeather {
    
    var delegate: ForecastWeatherDelegate?
    
    func getForecast(city:String){
        
       let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let pathf = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityEscaped!)&mode=json&appid=ee9e52e7756ed0fc6073f1f5abee5fb2"
        let url = NSURL(string: pathf)
        let session = NSURLSession.sharedSession()
        let taskf = session.dataTaskWithURL(url!) { (dataf: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print(dataf)
            
            if dataf == nil {
                print ("dataf equals nil")
            }
            
            let jsonf = JSON(data: dataf!)
            
            if jsonf != nil {
                
            let temp0 = round((jsonf["list"][0]["main"]["temp"].double! - 273.15)*10)/10
            let temp1 = round((jsonf["list"][1]["main"]["temp"].double! - 273.15)*10)/10
            let temp2 = round((jsonf["list"][2]["main"]["temp"].double! - 273.15)*10)/10
            let temp3 = round((jsonf["list"][3]["main"]["temp"].double! - 273.15)*10)/10
            let temp4 = round((jsonf["list"][4]["main"]["temp"].double! - 273.15)*10)/10
            let temp5 = round((jsonf["list"][5]["main"]["temp"].double! - 273.15)*10)/10
            
            
            let tempArray = NSMutableArray()
            
            tempArray[0] = temp0
            tempArray[1] = temp1
            tempArray[2] = temp2
            tempArray[3] = temp3
            tempArray[4] = temp4
            tempArray[5] = temp5
            
            
            let icon0 = jsonf["list"][0]["weather"][0]["icon"].string!
            let icon1 = jsonf["list"][1]["weather"][0]["icon"].string!
            let icon2 = jsonf["list"][2]["weather"][0]["icon"].string!
            let icon3 = jsonf["list"][3]["weather"][0]["icon"].string!
            let icon4 = jsonf["list"][4]["weather"][0]["icon"].string!
            let icon5 = jsonf["list"][5]["weather"][0]["icon"].string!
            
            let iconArray = NSMutableArray()
            
            iconArray[0] = icon0 
            iconArray[1] = icon1
            iconArray[2] = icon2
            iconArray[3] = icon3
            iconArray[4] = icon4
            iconArray[5] = icon5

            
            let date0 = jsonf["list"][0]["dt"].double!
            let date1 = jsonf["list"][1]["dt"].double!
            let date2 = jsonf["list"][2]["dt"].double!
            let date3 = jsonf["list"][3]["dt"].double!
            let date4 = jsonf["list"][4]["dt"].double!
            let date5 = jsonf["list"][5]["dt"].double!
            
            //print(" >>> This is the Date in UTC timestamp in 3 hours\(date0!)")
            //let dateFormatter = NSDateFormatter()
            //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            //let date = NSDate(timeIntervalSince1970: (date3)!)
            
            let dateArray = NSMutableArray()
            
            dateArray[0] = date0
            dateArray[1] = date1
            dateArray[2] = date2
            dateArray[3] = date3
            dateArray[4] = date4
            dateArray[5] = date5
                
            
            
            let forecast = Forecast(dateArray: dateArray, tempArray: tempArray, iconArray: iconArray)
            
            
            
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
