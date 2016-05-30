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
    var latitude: Double = 45.42
    var longitude: Double = -75.69
    var hourlyTemp:[(time: NSDate, tempForhour: Float)] = [] // hourly temp for 2 days in the future/ every three hours
    var apparentMaxTemp: Double = Double()
    var apparentMinTemp: Double = Double()
    var minMaxDailyTemp:[(min: Float, max: Float)] = []// plus 7 days
    var icon = []
    
    
    
   // let unit: Units = .SI
 

    func getweather(/*latitude:Double, longitude: Double*/){
        
        forecastIOClient.getForecast(latitude: latitude, longitude: longitude) { (currentForecast, error) -> Void in
            if let currentForecast = currentForecast {
                //  We got the current forecast!
                
                var thirdCounter = 0
                
                for index in 0...6 {
                    
                   
                    self.hourlyTemp.append((time: (currentForecast.hourly?.data![thirdCounter].time)!, tempForhour: (currentForecast.hourly?.data![thirdCounter].temperature)!))
                    
                        
                    self.minMaxDailyTemp.append((min: (currentForecast.daily?.data![index].temperatureMin)!, max: (currentForecast.daily?.data![index].temperatureMax)!))
                        
                    thirdCounter += 3
                }
                
                print(currentForecast.hourly?.data![0].apparentTemperatureMax)
                print(self.hourlyTemp)
                
                
            } else if let error = error {
                
                print(error)
            
            }
        }
        
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}