//
//  RoomsTableViewCell.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/16/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

protocol RoomCellDelegate {
    func toggleRoom(room: String, state: Bool)

}

class RoomsTableViewCell: UITableViewCell {

    var delegate: RoomCellDelegate?
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var roomSwitch: UISwitch!
    
    
    @IBAction func toggleRoom(_ sender: Any) {
        delegate?.toggleRoom(room: mainLabel.text!, state: roomSwitch.isOn)
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
