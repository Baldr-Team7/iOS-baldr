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


class RoomsTableViewController: UITableViewController, AddRoomCellDelegate {
    
    
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
        //print(myRooms[0])
        
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
    
    func setRoomToUndefined(light: CoreLightCell){
        
        let topic = "lightcontrol/home/\(DATA.homeID)/light/\(light.lightID)/commands"
        
        
        DATA.mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"room\":\"undefined\"}}")
        
    }
    
    
    func userEnteredRoomData(main: String) {
        
            myRooms.append("\(main)")
            
            self.RoomsTable.reloadData()
        
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove at specific index pressed
            // update rooms of all lights with same room to 'undefined'
            
            let room = myRooms[indexPath.row]
            myRooms.remove(at: indexPath.row)
            
            for index in myLights.lights {
                if index.room == room {
                    // change to undefined
                    setRoomToUndefined(light: index)
                }
                
            }
            
            myLights.lights.remove(at: indexPath.row)
            RoomsTable.deleteRows(at: [indexPath], with: .fade)
            
            
        } else if editingStyle == .insert {
            
        }
    }
}
