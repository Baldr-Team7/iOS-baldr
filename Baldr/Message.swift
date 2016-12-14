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
    
    
    // Message for Turning a Light On/Off
    init(forLight: String, toggle: Bool){
        self.topic = "lightcontrol/home/\(DATA.homeID)/light/\(forLight)/commands"
        
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"state\":\"\(toggle ? "on" : "off")\"}}"
    
    }
    
    // Message for Editing a Light's Name/Color
    init(forLight: String, name: String, color: String){
        self.topic = "lightcontrol/home/\(DATA.homeID)/light/\(forLight)/commands"
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"color\":\"\(color)\", \"name\":\"\(name)\"}}"
    }
    
    
    
    // Message for Changing a Light's Room
    init(forRoom: CoreLightCell, room: String){
        self.topic = "lightcontrol/home/\(DATA.homeID)/light/\(forRoom.lightID)/commands"
        
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"room\":\"\(room)\"}}"
    }
    
    // Message for Saved Lights in a Mood
    init(forMood: CoreLightCell){
        self.topic = "lightcontrol/home/\(DATA.homeID)/light/\(forMood.lightID)/commands"
        
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"color\":\"\(forMood.color)\", \"state\":\"\(forMood.state ? "on" : "off")\"}}"
    }
    
    init(forDiscovery: String){
        
        self.topic = "lightcontrol/discovery"
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"discovery\" : {\"discoveryCode\":\"\(forDiscovery)\", \"home\": \"\(DATA.homeID)\"}}"
        
        
    }
    
}
