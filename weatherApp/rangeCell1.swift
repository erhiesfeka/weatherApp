//
//  rangeCell1.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2017-02-20.
//  Copyright © 2017 ratatat. All rights reserved.
//

import UIKit

class rangeCell1: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var heavyJacketTemperature: UISlider!
    @IBAction func sliderValueChanged(_ sender: Any) {
        var unit:String = String()
        
        switch selectedUnit {
            
        case .farenheit:
            
            unit = "°F"
            
        case .celsius:
            
            unit = "°C"
            
        default:
            unit = "°C"
            
        }
        
       
        label.text = "\(Int(round(heavyJacketTemperature.value))) \(unit)"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
