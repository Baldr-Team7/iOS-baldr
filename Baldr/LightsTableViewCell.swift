//
//  LightsTableViewCell.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/20/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit


protocol LightCellDelegate {
    func toggleLight(main: String, state: Bool, lightID: String)
    func reload()
}

class LightsTableViewCell: UITableViewCell {

    var delegate: LightCellDelegate?
    var expand = false
    var ID: String = ""
    var name: String = ""
    var room: String = ""
    
    //let inset = 15.0
    
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var mainLabel: UILabel!
    
    
    @IBAction func toggleLight(_ sender: AnyObject) {
        //delegate?.reload()
        delegate?.toggleLight(main: mainLabel.text!, state: lightSwitch.isOn, lightID: ID)
        // print("\(self.ID) + \(lightSwitch.isOn)")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func expandCell(_ sender: Any) {
        self.expand = true
        print("asdfasd \(expand)")
        self.setNeedsLayout()
        delegate?.reload()
    }
    
}
