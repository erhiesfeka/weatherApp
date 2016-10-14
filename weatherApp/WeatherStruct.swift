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
    let minMaxDailyApparentTemp:[(min: Int, max: Int)]
    let avgApparentTemp:[Int]
    let unit:String
    
    init(hourlyTemp:[(time: String, tempForhour: Int)], minMaxDailyTemp:[(min: Int, max: Int)], iconDaily:[String],iconHourly:[String],dailyDate: [String], minMaxDailyApparentTemp:[(min: Int, max: Int)],avgApparentTemp:[Int], unit:String ){
        
        self.hourlyTemp = hourlyTemp
        self.minMaxDailyTemp = minMaxDailyTemp
        self.iconDaily = iconDaily
        self.iconHourly = iconHourly
        self.dailyDate = dailyDate
        self.minMaxDailyApparentTemp = minMaxDailyApparentTemp
        self.avgApparentTemp = avgApparentTemp
        self.unit = unit
        
        
    }
}
