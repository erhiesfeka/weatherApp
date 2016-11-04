//
//  DecisionStruct.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-11-01.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation

struct DecisionStruct {
  
    let clothesDecision:[String]
    let precipDecision:[String]
    
    
    init(clothesDecision:[String], precipDecision:[String]){
        
        self.clothesDecision = clothesDecision
        self.precipDecision = precipDecision
    }
}
