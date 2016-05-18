//
//  Forecast.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-01-31.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation

struct Forecast {
 
    let iconArray, dateArray, descArray: NSMutableArray
    
    let tempArray: [Int]
 
    //static let sharedInstance = Forecast()

    init(dateArray: NSMutableArray, tempArray: [Int], iconArray: NSMutableArray, descArray: NSMutableArray){
        
        self.dateArray = dateArray
        self.tempArray = tempArray
        self.iconArray = iconArray
        self.descArray = iconArray
        
    }
}