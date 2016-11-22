//
//  LightsTableViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 9/23/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit
import CocoaMQTT
import CoreData
import SwiftyJSON

// TODO:
//      Don't handle light switched on viewDidLoad(), they automatically turn on
//          -- follow up, work with Cache to store data, or a Dictionary
//      Add Delegate that receives information from Adding a Light as well - DONE
//      Add Delegate that passes information to Edit Light Page and updates changes to it afterwards


struct lightsCellData {
    let main: String!
    let onOff: Bool!
}

class LightsTableViewController: UITableViewController, AddLightCellDelegate, LightCellDelegate {

    
    @IBOutlet var LightsTable: UITableView!

    
    var mqtt : CocoaMQTT! // change to '?' maybe
    var container: NSPersistentContainer!
 
    
    
     // ---------------------------------------------------------------------------------------------
    
    
    // toggle the light, send the appropriate message to the broker
    func toggleLight(main: String, state: Bool){
        print("\(main) is \(state)")
        let topic: String?
        
        if (main == "Light"){
            topic = "home/FF/Light/FF"
        } else {
            topic = "home/AA/Light2/AA"
        }
        
        if (state == true){
            turnLightOn(topic: topic!)
        }
        else {
            turnLightOff(topic: topic!)
        }
        
        print(topic!)
    }

    func reload() {
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        //self.LightsTable.beginUpdates()
        //self.LightsTable.updates
        
    }
    
    // ---------------------------------------------------------------------------------------------
    
    // Delegate Methods
    // Get message from recieved
    
    
//    func getMessage() -> String{
//        return receievedMessage!
//    }
    
    // Receive Data Light Cell

    func userEnteredLightData(main: String) {
    
        let newLight = lightsCellData(main: main, onOff: false)
        lightsArrayData.append(newLight)
        
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
    
    
    // ---------------------------------------------------------------------------------------------
    
    
    // Hard coded Data, temporary
    var lightsArrayData =  [lightsCellData(main: "Light", onOff: false),
                            lightsCellData(main: "Light2", onOff: false)]
    
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        

        let container = NSPersistentContainer(name: "Baldr")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        
        }
        // Add Edit Button to nagivation bar programmatically
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        // Only allow selection during Edit
        LightsTable.allowsSelectionDuringEditing = true
         // Cells unselectable (only selectable during Editing
        tableView.allowsSelection = false
        
    
        // test usage of hex to UIColor converter
        self.view.backgroundColor = UIColor(hexString: "#ffe700")
        
        // test usage of UIColor to hex converter
        let green = UIColor.green.toHex()
        print(green)
        self.view.backgroundColor = UIColor(hexString: green)

       
     
        settingMQTT()
        mqtt!.connect()
        
      
        // GATHER ALL LIGHTS FROM BROKER
        performSelector(inBackground: #selector(fetchLights), with: nil)
        
    
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }
    
    
    func fetchLights() {
        if let data = try? Data(contentsOf: URL(string: "fix")!) {
            let jsonData = JSON(data: data)
            let jsonDataArray = jsonData.arrayValue
            
            print("Received \(jsonDataArray.count) lights")
            
            DispatchQueue.main.async { [unowned self] in
                for jsonData in jsonDataArray {
                    // Handling each individual light
                    
                    let light = CoreLightCell(context: self.container.viewContext)
                    self.configure(coreLightCell: light, usingJSON: jsonData)
                }
                
                self.saveContext()
            }
        }
    }
    
    
    
    func configure(coreLightCell: CoreLightCell, usingJSON json: JSON){
        
        coreLightCell.version = json["version"].stringValue
        coreLightCell.name = json["protocolName"].stringValue
        coreLightCell.state = json["lightCommand"]["state"].stringValue.lowercased() == "true"
        coreLightCell.color = json["lightCommand"]["color"].stringValue
        coreLightCell.expanded = json["lightCommand"]["room"].stringValue.lowercased() == "true"
       
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        
       // print("The JSON MESSAGE is \(light?.message)")
    }
    // Set up the MQTT connection
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
    
    // Set the cell to be used when creating the list of lightCells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = Bundle.main.loadNibNamed("LightsTableViewCell", owner: self, options: nil)?.first as! LightsTableViewCell
            //let cell = tableView.dequeueReusableCell(withIdentifier: "lightsCell", for: indexPath) as! LightsTableViewCell
        cell.mainLabel.text = lightsArrayData[indexPath.row].main
        cell.lightSwitch.setOn(lightsArrayData[indexPath.row].onOff, animated: false)
        cell.delegate = self
        
        cell.accessoryType = .none
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    // Keep track of the number of rows in the view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lightsArrayData.count
    }
    
    //  Force height to be 80 for the rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        
        //  let cell = self.LightsTable.cellForRow(at: indexPath) as? LightsTableViewCell
        //  let cell = self.LightsTable.cellForRow(at: indexPath)
        // let cell = lightsArrayData[indexPath]
        // print(cell.expand)
        //  print(cell?.expand as Any)
        
        
        //  if cell?.expand == true{
        //    return 120
        // }
        // else {
            return 80
        // }
    
        
    }
    
    // Specify what happens when a cell is edited in some way
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove Row at specific index pressed
            // Deletes from array of lights as well
            lightsArrayData.remove(at: indexPath.row)
            LightsTable.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    func getMessage(topic: String){
        mqtt!.subscribe("\(topic)")
    }
    // Turn Light on Message
    func turnLightOn(topic: String){
         mqtt!.publish("\(topic)", withString:"{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"clientToken\": \"FFFFFFFFFFFFFFF\", \"state\":\"on\"}}")
        
        
    }
    
    // Turn Light Off Message
    func turnLightOff(topic: String){
        mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"clientToken\": \"FFFFFFFFFFFFFFF\", \"state\":\"off\"}}")

    }
    
    // Change Color Message, with parameter as a UIColor
    func changeColor(topic: String, color: UIColor){
        let hex = color.toHex()
        mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"clientToken\": \"FFFFFFFFFFFFFFF\", \"color\":\"\(hex)\"}}")
    }

    // Change Color Message, with parameter as a hexadecimal String
    func changeColor(topic: String, hex: String){
        mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"clientToken\": \"FFFFFFFFFFFFFFF\", \"color\":\"\(hex)\"}}")
    }
}


extension UIColor {
    public convenience init?(hexString: String){
        let red, green, blue: CGFloat
        
        if hexString.hasPrefix("#"){
            // remove the prefix '#'
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            // specify the hex part of the string
            let hexColor = hexString.substring(from: start)
            
            
            // Can be modified to accept 8 hexadecimal characters to be able to 
            // accept alpha as a part of the entered string (change to UInt64)
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0

                
                if scanner.scanHexInt32(&hexNumber){
                    // check first pair of values
                    red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    // check second pair of values
                    green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    // check third pair of values
                    blue = CGFloat((hexNumber & 0x0000ff)) / 255
                    
                    // initialize the number with alpha set to 1.0 always
                    self.init(red: red, green: green, blue: blue, alpha: 1.0)
                    return
                }
            }
        }
        
        return nil
    }
    
    
    func toHex() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        
        let rgb:Int = (Int)(red*255) << 16 | (Int)(green*255) << 8 | (Int)(blue*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
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

