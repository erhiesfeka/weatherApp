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
 

    func getweather(/*latitude:Double, longitude: Double*/){
        
        forecastIOClient.getForecast(latitude: latitude, longitude: longitude) { (currentForecast, error) -> Void in
            if let currentForecast = currentForecast {
                //  We got the current forecast!
              
                
                print(currentForecast.daily?.data![1])
                
            } else if let error = error {
                
                print(error)
            }
        }
        
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}