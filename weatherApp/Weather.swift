//
//  Weather.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-01-28.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation

struct Weather {
    let cityName: String
    let temperature: Double
    let description: String
    let icon: String
    
    init(cityName: String, temperature: Double, description: String, icon: String){
        
        self.cityName = cityName
        self.temperature = temperature
        self.description = description
        self.icon = icon
    }
} 