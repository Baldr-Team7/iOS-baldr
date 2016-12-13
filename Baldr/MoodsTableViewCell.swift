//
//  MoodsTableViewCell.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/16/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

protocol MoodCellDelegate {
    func applyMood(moodName: String, jsonMessage: String?)
    
    
}
class MoodsTableViewCell: UITableViewCell {

    
    var delegate: MoodCellDelegate?
    var jsonMessage: String?
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var applyButton: UIButton!
    
    
    
    @IBAction func applyMood(_ sender: Any) {
        delegate?.applyMood(moodName: mainLabel.text!, jsonMessage: jsonMessage)
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
