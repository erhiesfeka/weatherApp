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

protocol weatherDataDelegate {
    
    func setWeather(weather: WeatherStruct)
}

class WeatherData {
    
    var forecastIOClient = APIClient(apiKey: "14d701ee5e2ba63179528de2bee40348")
    var hourlyTemp:[(time: String, tempForhour: Int)] = [] // hourly temp for 2 days in the future/ every three hours
    var minMaxDailyTemp:[(min: Int, max: Int)] = []// plus 7 days
    var iconDaily:[String] = []
    var iconHourly:[String] = []
    var precipitationType:[String] = []
    var precipitationIntensity:[Float] = []
    var precipitationProbability:[Float] = []
    var timezone = ""
    var dailyDate: [String] = []
    var region:String = String()
    var unit:String = String()
    var minMaxDailyApparentTemp:[(min: Int, max: Int)] = []//minmax temp for daily based on how it feels like
    var avgApparentTemp:[Int] = []
    var delegate:weatherDataDelegate?
   
    
    
    
    func averageOf(numbers: Int...) -> Float {
        
       let numberTotal = numbers.count
        if numberTotal == 0 {
            return 0
        }
        var sum = 0
        
        for number in numbers {
            sum += number
        }
        return Float(sum)/Float(numberTotal)
    }
    
    
    
    func getweather(){
        print("%%%%% Get WEATHER CALLED")
        if userDefaults.object(forKey: "savedUnit") != nil {
            
            selectedUnit = tempUnit(rawValue: userDefaults.string(forKey: "savedUnit")!)!
        }
        
        switch selectedUnit {
            
        case .farenheit:
            
            forecastIOClient.units = .US
            
        case .celsius:
            
            forecastIOClient.units = .SI
            
        default:
            forecastIOClient.units = .Auto
            
        }
        
        
        
        func ltzAbbrev() -> String { return NSTimeZone.local.abbreviation() ?? "" }
        timezone = ltzAbbrev()
        
        forecastIOClient.getForecast(latitude: latitude, longitude: longitude) { (currentForecast, error) -> Void in
            if let currentForecast = currentForecast {
                
                
                // purge all old values
                self.hourlyTemp.removeAll()
                self.minMaxDailyTemp.removeAll()
                self.iconHourly.removeAll()
                self.dailyDate.removeAll()
                self.iconDaily.removeAll()
                self.avgApparentTemp.removeAll()
                self.minMaxDailyApparentTemp.removeAll()
                self.precipitationProbability.removeAll()
                self.precipitationIntensity.removeAll()
                self.precipitationType.removeAll()
                
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
                    
                    //Aparent temp stuff for what to wear
                    self.minMaxDailyApparentTemp.append((min:(Int(round((currentForecast.daily?.data![index].apparentTemperatureMin)!))) , max: (Int(round((currentForecast.daily?.data![index].apparentTemperatureMax)!)))))
                    let minApparentTemp = self.minMaxDailyApparentTemp[index].min
                    let maxApparentTemp = self.minMaxDailyApparentTemp[index].max
                    self.avgApparentTemp.append(Int(round((self.averageOf(numbers: minApparentTemp, maxApparentTemp)))))
                    
                    //Precipitation array to decide weather gear
                    if currentForecast.daily?.data![index].precipType == nil {
                        self.precipitationType.append("none")
                        self.precipitationIntensity.append(0)
                        self.precipitationProbability.append(0)
                    }else{
                    self.precipitationType.append("\((currentForecast.daily?.data![index].precipType)!)")
                    self.precipitationIntensity.append((currentForecast.daily?.data![index].precipIntensity)!)
                    self.precipitationProbability.append((currentForecast.daily?.data![index].precipProbability)!)
                    }
                    
                    thirdCounter += 3
                }
                
                self.region = currentForecast.flags!.units!
                /*
                 print(self.minMaxDailyTemp)
                 print(self.hourlyTemp)
                 print(self.dailyDate)
                 print(self.iconHourly)
                 print(self.iconDaily)
                 print( ">>>heres the appparent min max temp \(self.minMaxDailyApparentTemp)")
                 print( ">>>heres the appparent average temp \(self.avgApparentTemp)")
                 
                 print(unit)
                 
                 print("This is the precipitationt Type %%% \(self.precipitationType)")
                 print("This is the precipitationt Intensity %%% \(self.precipitationIntensity)")
                 print("This is the precipitationt Probability %%% \(self.precipitationProbability)")
                 */
                 print("This is the precipitationt Probability %%% \(self.precipitationProbability)")
                 print("Icondaily \(self.iconHourly)")
                
                 print("This is the precipitationt Intensity %%% \(self.precipitationIntensity)")
                
                
                if self.region == "us"{
                    
                    self.unit = "°F"
                    selectedUnit = .farenheit
                    
                    
                }else{
                    self.unit = "°C"
                    selectedUnit = .celsius
                }
                
                
                
            } else if let error = error {
                
                print(error)
                
            }
        }
        
        let weather = WeatherStruct(hourlyTemp: self.hourlyTemp, minMaxDailyTemp: self.minMaxDailyTemp, iconDaily: self.iconDaily, iconHourly: self.iconHourly, dailyDate: self.dailyDate, minMaxDailyApparentTemp: self.minMaxDailyApparentTemp, avgApparentTemp: self.avgApparentTemp, unit: self.unit, precipitationType: self.precipitationType, precipitationIntensity: self.precipitationIntensity, precipitationProbability: self.precipitationProbability)
        
        if delegate != nil  {
            
            self.delegate!.setWeather(weather: weather)
            
        }
    }
    
    
    
    
}
