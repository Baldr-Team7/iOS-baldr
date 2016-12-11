//
//  SecondViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 9/23/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit
//import SwiftyJSON
import CocoaMQTT
import CoreData


class RoomsTableViewController: UITableViewController {
    
    
    @IBOutlet var RoomsTable: UITableView!
    var myRooms = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRooms()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        // Only allow selection during Edit
        RoomsTable.allowsSelectionDuringEditing = true
        // Cells unselectable (only selectable during Editing
        tableView.allowsSelection = false

        
        print("rooms: \(myRooms) ")
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        print(myRooms[0])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func updateRooms(){
        
        
        var rooms = [String]()
        for index in myLights.lights {
            //if (index.room != "undefined"){
                rooms.append(index.room)
            //}
        }
        
        // create an array of only the unique rooms in the list of rooms
        myRooms = Array(Set(rooms))
    }
    
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("RoomsTableViewCell", owner: self, options: nil)?.first as! RoomsTableViewCell

        let roomCell = myRooms[indexPath.row]
        cell.mainLabel.text = roomCell
        cell.roomSwitch.isOn = false
        
        cell.accessoryType = .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRooms.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    
}


extension RoomsTableViewController: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
        mqtt.subscribe("lightcontrol/home/asdf/light/+/info")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string)")
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceivedMessage: \(message.string) with id \(id)")
        
        //createCoreLight(message: message.string!)
        updateRooms()
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("didPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        _console("didReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        _console("mqttDidDisconnect")
    }
    
    func _console(_ info: String) {
        print("Delegate: \(info)")
    }
    
    
}

