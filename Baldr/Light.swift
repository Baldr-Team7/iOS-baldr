//
//  Light.swift
//  Baldr
//
//  Created by LiangZhanou on 2016-11-14.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import Foundation
import SwiftyJSON

class Light{
    
    // identify classes to get messages
    
    var message: String
    var protocolName: String
    var color: String
    var state: String
    var room: String
    
    //lightCommand:(color: String,state: String,room: String)
    //var json: Data
    
    init(message: String, protocolName: String, color: String,state: String, room:String) {
        self.message = message
        self.protocolName = protocolName
        self.color = color
        self.state = state
        self.room = room
    
    }
    
    // Parsing JSON message so the value can be extracted
    init(message: String){
        self.message = message
        let jsonData = message.data(using: .utf8)
        let json = JSON(data: jsonData!)
        self.protocolName = json["protocolName"].stringValue
        self.color = json["lightCommand"] ["color"].stringValue
        self.state = json["lightCommand"]["state"].stringValue
        self.room = json["lightCommand"]["room"].stringValue
        
        print("the JSON DATA is \(protocolName) \(color) \(state) \(room)")
    }
}


