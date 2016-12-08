//
//  MoodsTableViewCell.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/16/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

protocol MoodCellDelegate {
    func userdidEnterName(main: String)
    
    
}
class MoodsTableViewCell: UITableViewCell {

  
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var moodSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
