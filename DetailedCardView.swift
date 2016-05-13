//
//  DetailedCardView.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2016-04-25.
//  Copyright © 2016 ratatat. All rights reserved.
//

import Foundation
import UIKit

class DetailedCardView: UIViewController{

    @IBOutlet weak var label: UILabel!
    
    @IBAction func button(sender: AnyObject) {
        
       
        
    }
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
 

}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
    
    override func viewWillAppear(animated: Bool) {
        
        let tempy = tempArray[selectedItem]
        
        if selectedItem == 0 {
            
            
     //       label.text = "Here is the For selected Item: \(ForecastWeather.sharedInstance.getForecast("ottawa"))"
            
            
        }else{
            
            label.text = "Here is the For selected Item: \(tempy)"
            
        }
      
        
    }
    
}