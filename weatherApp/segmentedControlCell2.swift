//
//  segmentedControlCell2.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2017-02-11.
//  Copyright © 2017 ratatat. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class segmentedControlCell2: UITableViewCell {
    @IBOutlet weak var segmentedCell2Control: BetterSegmentedControl!

    @IBOutlet weak var selectCityButton: UIButton!
    
    
    @IBAction func clickSelectCity(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "revealCitySelectPage"), object: nil)
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
