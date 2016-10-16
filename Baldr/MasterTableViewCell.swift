//
//  MasterTableViewCell.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/6/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

    @IBOutlet weak var masterSwitch: UISwitch!
    @IBOutlet weak var mainLabel: UILabel!
    
    
    @IBAction func switchMaster(_ sender: AnyObject) {
        
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
