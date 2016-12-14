//
//  Message.swift
//  Baldr
//
//  Created by Thomas Emilsson on 12/14/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import Foundation

class Message {
    
    var topic: String
    var message: String
    
    init(forMood: CoreLightCell){
        self.topic = "lightcontrol/home/\(DATA.homeID)/light/\(forMood.lightID)/commands"
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"color\":\"\(forMood.color)\", \"state\":\"\(forMood.state ? "on" : "off")\"}}"
    }
    
    init(forRoom: CoreLightCell, room: String){
        self.topic = "lightcontrol/home/\(DATA.homeID)/light/\(forRoom.lightID)/commands"
        
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"room\":\"\(room)\"}}"
        
    }
    
//    init(forRoom: CoreLightCell){
//        
//    }
    
    
}
