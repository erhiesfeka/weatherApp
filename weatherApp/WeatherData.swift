//
//  WeatherData.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-05-27.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation
import ForecastIO

class WeatherData {
    
    var forecastIOClient = APIClient(apiKey: "14d701ee5e2ba63179528de2bee40348")
    var hourlyTemp:[(time: String, tempForhour: Int)] = [] // hourly temp for 2 days in the future/ every three hours
    var minMaxDailyTemp:[(min: Int, max: Int)] = []// plus 7 days
    var iconDaily:[String] = []
    var iconHourly:[String] = []
    var timezone = ""
    var dailyDate: [String] = []
 

    func getweather(){
        
        forecastIOClient.units = .Auto
        
        func ltzAbbrev() -> String { return NSTimeZone.localTimeZone().abbreviation ?? "" }
        timezone = ltzAbbrev()
        
        forecastIOClient.getForecast(latitude: 45.4, longitude: -75.6) { (currentForecast, error) -> Void in
            if let currentForecast = currentForecast {
                //  We got the current forecast!
                // purge all values
                self.hourlyTemp.removeAll()
                self.minMaxDailyTemp.removeAll()
                self.iconHourly.removeAll()
                self.dailyDate.removeAll()
                
                
                
                var thirdCounter = 0
                
                for index in 0...6 {
                    
                    let hourlyDateFormatter = NSDateFormatter()
                    hourlyDateFormatter.dateFormat = "EEEE , HH:mm"
                    hourlyDateFormatter.timeZone = NSTimeZone(abbreviation: self.timezone)
                    
                    let dailyDateFormatter = NSDateFormatter()
                    dailyDateFormatter.dateFormat = "EEEE"
                    dailyDateFormatter.timeZone = NSTimeZone(abbreviation: self.timezone)
                    
                    if index == 0 {
                        
                       self.hourlyTemp.append((time:"Now" , tempForhour: (Int(round((currentForecast.currently!.temperature)!)))))
                        
                       self.dailyDate.append("Today")
                        
                       self.iconHourly.append("\(currentForecast.currently!.icon!)")
                        
                    }else{
                        
                        self.hourlyTemp.append((time: hourlyDateFormatter.stringFromDate((currentForecast.hourly?.data![thirdCounter].time)!), tempForhour: (Int(round((currentForecast.hourly?.data![thirdCounter].temperature)!)))))
                        self.dailyDate.append(dailyDateFormatter.stringFromDate((currentForecast.daily?.data![index].time)!))
                        self.iconHourly.append("\((currentForecast.hourly?.data![thirdCounter].icon)!)")
                    }
                    
                    self.iconDaily.append("\(currentForecast.daily!.data![index].icon!)")
                    self.minMaxDailyTemp.append((min: (Int(round((currentForecast.daily?.data![index].temperatureMin)!))), max: (Int(round((currentForecast.daily?.data![index].temperatureMax)!)))))
                    
                    
                        
                    thirdCounter += 3
                }
                
              //  print(currentForecast.hourly?.data![0].apparentTemperatureMax)
                
               print(self.minMaxDailyTemp)
               print(self.hourlyTemp)
               print(self.dailyDate)
               print(self.iconHourly)
               print(self.iconDaily)    
                
                
            } else if let error = error {
                
                print(error)
            
            }
        }
        
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}