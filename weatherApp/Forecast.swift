//
//  Forecast.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-01-31.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation

struct Forecast {
 
    let iconArray: NSMutableArray
    let tempArray: NSMutableArray
    let dateArray: NSMutableArray

    init(dateArray: NSMutableArray, tempArray: NSMutableArray, iconArray: NSMutableArray){
        
        self.dateArray = dateArray
        self.tempArray = tempArray
        self.iconArray = iconArray
        
       
    }
}