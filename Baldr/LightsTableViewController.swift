//
//  LightsTableViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 9/23/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit
import CocoaMQTT



// TODO:
//      Have master turn off all lights
//      Don't handle light switched on viewDidLoad(), they automatically turn on
//          -- follow up, work with Cache to store data, or a Dictionary
//      Add Delegate that receives information from Adding a Light as well - DONE
//      Add Delegate that passes information to Edit Light Page and updates changes to it afterwards
//      Store Index ID in the lightsCellData struct for testing.


struct lightsCellData {
    let main: String!
    let onOff: Bool!
}


class LightsTableViewController: UITableViewController, LightCellDelegate {

    
    @IBOutlet var LightsTable: UITableView!

    var mqtt : CocoaMQTT?
    
    // Delegate Methods
    // Receive Data Light Cell
    func userEnteredLightData(main: String) {
        
        let newLight = lightsCellData(main: main, onOff: false)
        //print(newLight)
        lightsArrayData.append(newLight)
        //print(lightsArrayData)
        self.LightsTable.reloadData()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Set Delegate
        if segue.identifier == "showAddLight" {
            
            // AddLightVC has a UINavigationController attached to it; need to access the UINC first to get to the AddLightVC
            let destination = segue.destination as! UINavigationController
            
            let addLightViewController: AddLightViewController = destination.topViewController as! AddLightViewController
            //            let addLightViewController: AddLightViewController = segue.destination as! AddLightViewController
            
            addLightViewController.delegate = self
        }
    }
    
    
    
    
    //var lightsArrayData = [lightsCellData]()
    
    var lightsArrayData =  [lightsCellData(main: "MASTER", onOff: false),
                        lightsCellData(main: "MY LIGHT", onOff: false),
                        lightsCellData(main: "Ceiling Light", onOff: false),
                        lightsCellData(main: "Kitchen Light Main", onOff: false)]
    
    func settingMQTT() {
        // message = "Hi"
        let clientIdPid = "CocoaMQTT" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientId: clientIdPid, host: "tann.si", port: 8883)
        if let mqtt = mqtt {
            mqtt.username = "test"
            mqtt.password = "public"
            mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
            mqtt.keepAlive = 90
            mqtt.delegate = self
            
        }
    }

    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        
        // Cells unselectable
        // Set this to true when edit button is pressed.
        tableView.allowsSelection = false
        settingMQTT()
        mqtt!.connect()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Adding a Light to the TableView
    func addLight(light : lightsCellData){
        lightsArrayData.append(light)
    }
    
    
    // Removal of a light from the TableView
    func removeLight(light :lightsCellData){
        
        // Run through each individual index, check if it satisfies the given predicate
        // return that index
        let index =    lightsArrayData.index { (lights) -> Bool in
                light.main == lights.main
        }
        
        lightsArrayData.remove(at: index!)
        
        // convert index to indexPath to delete the specific Row
        let indexPath = IndexPath(row: index!, section: 0)
        LightsTable.deleteRows(at: [indexPath], with: .fade)
        //LightsTable.deleteRows(at: index!, with: .fade)
        
        
    }
    
    @IBAction func temporaryMQTTMessage(_ sender: AnyObject) {
        mqtt!.publish("baldr-test", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"clientToken\": \"FFFFFFFFFFFFFFF\", \"state\":\"on\"}}")
        print("{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"clientToken\": \"FFFFFFFFFFFFFFF\", \"state\":\"on\"}}")
    }
    
//    {
//    “version”: 1,
//    
//    “protocolName”:”baldr”,
//    
//    “lightCommand” :{
//    
//    “clientToken”:”FFFFFFFFFFFFFFF”,
//    
//    “state”:”on”
//}

    // Set the cell to be used when creating the list of lightCells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("MasterTableViewCell", owner: self, options: nil)?.first as! MasterTableViewCell
            
            cell.mainLabel.text = lightsArrayData[indexPath.row].main
            cell.masterSwitch.setOn(lightsArrayData[indexPath.row].onOff, animated: false)
            
            return cell
            
        } else {
        
        let cell = Bundle.main.loadNibNamed("LightsTableViewCell", owner: self, options: nil)?.first as! LightsTableViewCell
        
        
        cell.mainLabel.text = lightsArrayData[indexPath.row].main
            //cell.secondaryLabel.text = lightsArrayData[indexPath.row].secondary
        //    cell.lightSwitch.isOn = lightsArrayData[indexPath.row].onOff
        cell.lightSwitch.setOn(lightsArrayData[indexPath.row].onOff, animated: false)
        
        return cell
        
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // Keep track of the number of rows in the view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lightsArrayData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove Row at specific index pressed
            // Deletes from array of lights as well
            lightsArrayData.remove(at: indexPath.row)
            LightsTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}



extension LightsTableViewController: CocoaMQTTDelegate {
    
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
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

