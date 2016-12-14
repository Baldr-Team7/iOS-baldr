//
//  LightsTableViewCell.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/20/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit


protocol LightCellDelegate {
    //func toggleLight(main: String, state: Bool, lightID: String)
    func toggleLight(lightID: String, state: Bool)
    func reload()
}

class LightsTableViewCell: UITableViewCell {

    var delegate: LightCellDelegate?
    var expand = false
    var ID: String = ""
    var name: String = ""
    var room: String = ""
    var color: String = ""
    
    //let inset = 15.0
    
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBAction func toggleLight(_ sender: AnyObject) {
        delegate?.toggleLight(lightID: ID, state: lightSwitch.isOn)

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
