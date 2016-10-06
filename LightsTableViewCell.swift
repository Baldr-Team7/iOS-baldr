//
//  LightsTableViewCell.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/2/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

class LightsTableViewCell: UITableViewCell {

    
    // TODO:
    //      Add Outlet for Switch
    //      Fix Fonts and create Special Cell for MASTER
    //      Create Cells for Rooms and Moods
    
    
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var lightSwitch: UISwitch!
    
    @IBAction func switchLight(_ sender: AnyObject) {
        print("\(mainLabel) pressed")
    }

    // consider having an ID var
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
