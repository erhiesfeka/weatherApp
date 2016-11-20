//
//  Decider.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-01-31.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation

protocol decideWeatherDelegate {
    
    func decideWeather(decision: DecisionStruct)
}

class Decider: weatherDataDelegate {
    
    
    var myWeatherData:WeatherData = WeatherData()
    var avgTempArray:[Int] = []
    var delegate: decideWeatherDelegate?
    var precipIntensityArray:[Float] = []
    var precipTypeArray:[String] = []
    var precipProbabilityArray:[Float] = []
    
    func addObserver() {
        self.myWeatherData.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(Decider.startDeciding), name: NSNotification.Name(rawValue: "startDeciding"), object: nil)
    }
    
    @objc func startDeciding() {
        self.myWeatherData.getweather()
    }
    
    
    func decideClothes() -> [String] {
        // Decides what clothes to wear based on temperature
        var clothesDecision = [String]()
        
        if avgTempArray.count == 7 {
            
            for index in 0...6{
                
                if (avgTempArray[index]  < 0 ) {
                    
                    clothesDecision.append(" It will be extremely cold, have a heavy jacket handy")
                    
                }else if (avgTempArray[index] >= 0 && avgTempArray[index] <= 11 ) {
                    
                    clothesDecision.append("It will be cold, have a jacket handy today")
                    
                } else if (avgTempArray[index] >= 12 && avgTempArray[index] <= 18){
                    
                    clothesDecision.append(" It will be chilly, have a sweater handy")
                    
                    
                } else if (avgTempArray[index] > 18 && avgTempArray[index] < 25) {
                    
                    clothesDecision.append("Comfortable temperature, dress comfy")
                    
                } else {
                    
                    clothesDecision.append ("Stay home! its burning outside")
                    
                }
                
            }
        }
        
        
        // print(clothesDecision)
        return(clothesDecision)
    }
    
    func decideWeatherGear() {
        // Decides what kind of weather gear to wear based on Weather conditions. For example: wear winter boots because it will snow
        
        
    }
    
    func decidePrecipIntensity() -> [String]{
        
        var precipIntensity = [String]()
        
        if avgTempArray.count == 7 {
            
            for index in 0...6{
                
                if precipIntensityArray[index] > 0 && precipIntensityArray[index] <= 0.017 {
                    precipIntensity.append("Very light")
                    
                } else if precipIntensityArray[index] > 0.017 && precipIntensityArray[index] <= 0.1{
                    precipIntensity.append("Light")
                }else if precipIntensityArray[index] > 0.1 && precipIntensityArray[index] <= 0.4{
                    precipIntensity.append("Moderate")
                }else  {
                    precipIntensity.append("Heavy")
                }
            }
            
        }
        return precipIntensity
    }
    
    func concantenateDecision() -> [String] {
        
        var finalDecision = [String]()
        
        
        
        return finalDecision
    }
    
    
    
    func setWeather(weather: WeatherStruct) {
        //Set the fucking weather
        
        self.precipTypeArray.removeAll()
        self.precipProbabilityArray.removeAll()
        
        
        self.precipTypeArray = weather.precipitationType
        self.precipProbabilityArray = weather.precipitationProbability
        self.avgTempArray = weather.avgApparentTemp
        self.precipIntensityArray = weather.precipitationIntensity
        
       // print("$$$$$$ Average apparent temp Array \(avgTempArray)")
        
        let clothesDecision = decideClothes()
        let intensityDecision = decidePrecipIntensity()
        var finalDecision :[String] = []
        
      //  print ("intensity decision **** \(intensityDecision)")
            
        if precipProbabilityArray.count == 7 && precipTypeArray.count == 7 && intensityDecision.count == 7 {
            
        
        for index in 0 ... 6 {
            
            if precipProbabilityArray[index] < 0.5 {
                finalDecision.append("")
            }else{
                finalDecision.append("\(intensityDecision[index]) \(precipTypeArray[index]) expected")
            }
        }
        
        let myDecision = DecisionStruct(clothesDecision: clothesDecision, precipDecision: intensityDecision, finalDecision: finalDecision)
        
        
        
        if delegate != nil {
            self.delegate?.decideWeather(decision: myDecision)
        }
        
        }
    }
    
    
    
    
    
    
    
    
    
}


