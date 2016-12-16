//
//  Message.swift
//  Baldr
//
//  Created by Thomas Emilsson on 12/14/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import Foundation
import CocoaMQTT

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
    
    // Message for Discovering New Lights
    init(forDiscovery: String){
        
        self.topic = "lightcontrol/discovery"
        self.message = "{\"version\": 1, \"protocolName\": \"baldr\", \"discovery\" : {\"discoveryCode\":\"\(forDiscovery)\", \"home\": \"\(DATA.homeID)\"}}"
        
        handleMessage(message: self)
    }
    
    init(forPresence: String){
        self.topic = "presence/\(forPresence)"
        
        let timeInterval = NSDate().timeIntervalSince1970
        

            
        self.message = "{\"version\": 1, \"groupName\": \"baldr\", \"groupNumber\" : \"7\", \"connectedAt\": \"\(timeInterval)\", \"rfcs\": \"[RFC 1, RFC 17, RFC 18]\", \"clientVersion\": \"1.0\", \"clientSoftware\": \"Baldr-iOS-Client\""
            
        retainMessage(message: self)
            
    
       
        
    }
    
}

// Extension that publishes the Message when initialized
extension Message {
    
    func handleMessage(message: Message){
        DATA.mqtt!.publish(message.topic, withString: message.message)
    }
    
    func retainMessage(message: Message){
        DATA.mqtt!.publish(message.topic, withString: message.message, qos: .qos1, retained: true, dup: false)
    }
    
}
