//
//  SegmentedControlCell.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2017-02-10.
//  Copyright © 2017 ratatat. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class SegmentedControlCell: UITableViewCell {

    @IBOutlet weak var SegmentedCellLabel: UILabel!
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
