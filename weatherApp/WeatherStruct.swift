//
//  WeatherStruct.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-10-13.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation

struct WeatherStruct {
    let hourlyTemp:[(time: String, tempForhour: Int)]
    let minMaxDailyTemp:[(min: Int, max: Int)]
    let iconDaily:[String]
    let iconHourly:[String]
    let dailyDate:[String]
    let hourlySummary:[String]
    let minMaxDailyApparentTemp:[(min: Int, max: Int)]
    let avgApparentTemp:[Int]
    let unit:String
    let precipitationType:[String]
    let precipitationIntensity:[Float]
    let precipitationProbability:[Float]
    
    init(hourlyTemp:[(time: String, tempForhour: Int)], minMaxDailyTemp:[(min: Int, max: Int)], iconDaily:[String],iconHourly:[String],dailyDate: [String], minMaxDailyApparentTemp:[(min: Int, max: Int)],avgApparentTemp:[Int], unit:String, precipitationType:[String], precipitationIntensity:[Float],precipitationProbability:[Float], hourlySummary:[String]){
        
        self.hourlyTemp = hourlyTemp
        self.minMaxDailyTemp = minMaxDailyTemp
        self.iconDaily = iconDaily
        self.iconHourly = iconHourly
        self.dailyDate = dailyDate
        self.minMaxDailyApparentTemp = minMaxDailyApparentTemp
        self.avgApparentTemp = avgApparentTemp
        self.unit = unit
        self.precipitationType = precipitationType
        self.precipitationIntensity = precipitationIntensity
        self.precipitationProbability = precipitationProbability
        self.hourlySummary = hourlySummary
        
        
    }
}
