//
//  LightsTableViewCell.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/20/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit


protocol LightCellDelegate {
    func toggleLight(main: String)
    
    
    
}

class LightsTableViewCell: UITableViewCell {

    var delegate: LightCellDelegate?
    
    
    @IBAction func toggleLight(_ sender: AnyObject) {
        delegate?.toggleLight(main: mainLabel.text!)
    }

    
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
