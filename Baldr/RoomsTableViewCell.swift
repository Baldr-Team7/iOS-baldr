//
//  RoomsTableViewCell.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/16/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

class RoomsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var roomSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
