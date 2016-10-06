//
//  WeatherData.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-05-27.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation
import ForecastIO

let userDefaults = UserDefaults.standard


class WeatherData {
    
    var forecastIOClient = APIClient(apiKey: "14d701ee5e2ba63179528de2bee40348")
    var hourlyTemp:[(time: String, tempForhour: Int)] = [] // hourly temp for 2 days in the future/ every three hours
    var minMaxDailyTemp:[(min: Int, max: Int)] = []// plus 7 days
    var iconDaily:[String] = []
    var iconHourly:[String] = []
    var timezone = ""
    var dailyDate: [String] = []
    var unit:String = String()
  

    func getweather(){
        
        if userDefaults.object(forKey: "defaultUnit") != nil {
            
            tempFaren = userDefaults.object(forKey: "defaultUnit") as! Int
        }
        
        switch tempFaren {
            
        case 1:
            
            forecastIOClient.units = .US
            
        case 2:
            
             forecastIOClient.units = .SI
            
        default:
            forecastIOClient.units = .Auto
            
        }
        
        
        
        func ltzAbbrev() -> String { return NSTimeZone.local.abbreviation() ?? "" }
        timezone = ltzAbbrev()
        
        forecastIOClient.getForecast(latitude: latitude, longitude: longitude) { (currentForecast, error) -> Void in
            if let currentForecast = currentForecast {
                //  We got the current forecast!
                // purge all values
                self.hourlyTemp.removeAll()
                self.minMaxDailyTemp.removeAll()
                self.iconHourly.removeAll()
                self.dailyDate.removeAll()
                
                var thirdCounter = 0
                
                for index in 0...6 {
                    
                    let hourlyDateFormatter = DateFormatter()
                    hourlyDateFormatter.dateFormat = "EEEE , HH:mm"
                    hourlyDateFormatter.timeZone = TimeZone(abbreviation: self.timezone)
                    
                    let dailyDateFormatter = DateFormatter()
                    dailyDateFormatter.dateFormat = "EEEE"
                    dailyDateFormatter.timeZone = TimeZone(abbreviation: self.timezone)
                    
                    if index == 0 {
                        
                       self.hourlyTemp.append((time:"Now" , tempForhour: (Int(round((currentForecast.currently!.temperature)!)))))
                        
                       self.dailyDate.append("Today")
                        
                       self.iconHourly.append("\(currentForecast.currently!.icon!)")
                        
                    }else{
                        
                        self.hourlyTemp.append((time: hourlyDateFormatter.string(from: (currentForecast.hourly?.data![thirdCounter].time)!), tempForhour: (Int(round((currentForecast.hourly?.data![thirdCounter].temperature)!)))))
                        self.dailyDate.append(dailyDateFormatter.string(from: (currentForecast.daily?.data![index].time)!))
                        self.iconHourly.append("\((currentForecast.hourly?.data![thirdCounter].icon)!)")
                    }
                    
                    self.iconDaily.append("\(currentForecast.daily!.data![index].icon!)")
                    self.minMaxDailyTemp.append((min: (Int(round((currentForecast.daily?.data![index].temperatureMin)!))), max: (Int(round((currentForecast.daily?.data![index].temperatureMax)!)))))
                    
                    
                        
                    thirdCounter += 3
                }
                

                
               print(self.minMaxDailyTemp)
               print(self.hourlyTemp)
               print(self.dailyDate)
               print(self.iconHourly)
               print(self.iconDaily)
               let unit = currentForecast.flags!.units!
               print(unit)
                
                
                if unit == "us"{
                    
                    self.unit = "°F"
                    tempFaren = 1
                    
                }else{
                    self.unit = "°C"
                    tempFaren = 2
                }
               
               
                
                
            } else if let error = error {
                
                print(error)
            
            }
        }
        
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
