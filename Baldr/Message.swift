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
        
        handleMessage(message: self)
    
    }
    
    // Message for Editing a Light's Name/Color
    init(forLight: String, name: String, color: String){
        self.topic = "lightcontrol/home/\(DATA.homeID)/light/\(forLight)/commands"
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"color\":\"\(color)\", \"name\":\"\(name)\"}}"
        
        handleMessage(message: self)
    }
    
    
    
    // Message for Changing a Light's Room
    init(forRoom: CoreLightCell, room: String){
        self.topic = "lightcontrol/home/\(DATA.homeID)/light/\(forRoom.lightID)/commands"
        
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"room\":\"\(room)\"}}"
        
        handleMessage(message: self)
    }
    
    // Message for Saved Lights in a Mood
    init(forMood: CoreLightCell){
        self.topic = "lightcontrol/home/\(DATA.homeID)/light/\(forMood.lightID)/commands"
        
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"color\":\"\(forMood.color)\", \"state\":\"\(forMood.state ? "on" : "off")\"}}"
        
        handleMessage(message: self)
    }
    
    init(forDiscovery: String){
        
        self.topic = "lightcontrol/discovery"
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"discovery\" : {\"discoveryCode\":\"\(forDiscovery)\", \"home\": \"\(DATA.homeID)\"}}"
        
        handleMessage(message: self)
    }
    
}

extension Message {
    
    func handleMessage(message: Message){
        DATA.mqtt!.publish(message.topic, withString: message.message)
    }
}
