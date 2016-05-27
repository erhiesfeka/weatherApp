//
//  Decider.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-01-31.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation



class Decider {

var clothesDecision = [String]()

 
func decideClothes() -> String {
// Decides what clothes to wear based on temperature
    
    for index in tempArray{
        
        if (index  < 0 ) {
        
        clothesDecision.append(" It will be \(index) degrees at. Have a winter jacket handy today")
        
        }else if (index > 0 && index < 10 ) {
        
        clothesDecision.append(" It will be \(index) degrees. Have a jacket handy today")
        
        } else if (index > 13 && index < 20){
        
        clothesDecision.append(" It will be \(index) degrees . Have a sweater handy")
        
        
        } else if (index > 20 && index < 25) {
        
        clothesDecision.append("It will be \(index) degrees . Wear a T shirt and shorts")
        
        } else {
        
        clothesDecision.append ("It will be \(index) degrees . Carry a water bottle, Fucking hot")
        
        }
        
    }
   
   
  // print(clothesDecision)
   return(clothesDecision[0])
 }
    
func decideWeatherGear(){
// Decides what kind of weather gear to wear based on Weather conditions. For example: wear winter boots because it will snow
    
    
    
}
    
func getAverageWeather(){
// gets the averageweather for the day
    
        
}
    
    
    
    
    
    
    
}




