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


// Struct that holds the core data for the lights
// accessible globally 
struct myLights {
    static var lights: [CoreLightCell] = []
}

struct DATA {
    static var mqtt: CocoaMQTT!
    static var homeID = "asdf"
    static var lightPageWillUpdate = false
    static var roomPageWillUpdate = false
    static var moodPageWillUpdate = false
    static var oldHomeID = ""
}

class LightsTableViewController: UITableViewController, AddLightCellDelegate, LightCellDelegate, EditLightCellDelegate {
    
    @IBOutlet var LightsTable: UITableView!

    //var mqtt : CocoaMQTT! // change to '?' maybe
    var container: NSPersistentContainer!
    var editIndex: Int = 0
    
    // toggle the light, send the appropriate message to the broker
    func toggleLight(lightID: String, state: Bool) {
        
        _ = Message(forLight: lightID, toggle: state)
 
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (DATA.lightPageWillUpdate == true) {
            DATA.mqtt!.unsubscribe("lightcontrol/home/\(DATA.oldHomeID)/light/+/info")
            DATA.mqtt!.subscribe("lightcontrol/home/\(DATA.homeID)/light/+/info")
           
            
            for index in myLights.lights {
                container.viewContext.delete(index)
            }
            
            
            saveContext()
            
            myLights.lights = []
            
            self.LightsTable.reloadData()
            
            DATA.lightPageWillUpdate = false
        }
        
    }
    
    
    
    func reload() {
        
        LightsTable.beginUpdates()
        LightsTable.endUpdates()
    }
    
    func userEnteredLightData(discoveryCode: String) {
    
        _ = Message(forDiscovery: discoveryCode)
        
    }
    
    func userEditedData(name: String, color: String) {
        
        let lightID = myLights.lights[editIndex].lightID
        
        _ = Message(forLight: lightID, name: name, color: color)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(segue.identifier!)
        // Set Delegate
        if segue.identifier == "showAddLight" {
            
            // AddLightVC has a UINavigationController attached to it; 
            // needed to access the UINC first to get to the AddLightVC
            let destination = segue.destination as! UINavigationController
            
            let addLightViewController: AddLightViewController = destination.topViewController as! AddLightViewController
            
            addLightViewController.delegate = self
            
            
        } else if segue.identifier == "showEditLight" {
            
            let destination = segue.destination as! UINavigationController
            
            let editLightViewController: EditLightViewController = destination.topViewController as! EditLightViewController
            
            let newColor = UIColor(hexString: myLights.lights[editIndex].color)
            editLightViewController.myColor = newColor
            print("\(newColor)")
            var hue: CGFloat = 0
            newColor!.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
            
            let value = Float(hue)
          
            editLightViewController.mySlider = value
            
            editLightViewController.myName = myLights.lights[editIndex].name
            
            editLightViewController.delegate = self
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        editIndex = indexPath.row
        performSegue(withIdentifier: "showEditLight", sender: self)
    
        setEditing(false, animated: true)
    
        
    }
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)

        container = NSPersistentContainer(name: "Baldr")
        
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        
        }
        
        self.reload()
        
        // Add Edit Button to nagivation bar programmatically
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        // Only allow selection during Edit
        LightsTable.allowsSelectionDuringEditing = true
         // Cells unselectable (only selectable during Editing
        tableView.allowsSelection = false

        settingMQTT()
        DATA.mqtt!.connect()

        loadSavedData()
        
        
    
    }

    func handleRefresh(refreshControl: UIRefreshControl) {

    
        myLights.lights.sort() { $0.room < $1.room }
        
        self.reload()
        //        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
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
    
    func loadSavedData() {
        let request = CoreLightCell.createFetchRequest()
    
        do {
            myLights.lights = try container.viewContext.fetch(request)
            print("Got \(myLights.lights.count) lights")
            self.reload()
        } catch {
            print("Fetch failed")
        }
    }
    
    // Working CoreLightCell initializer
    func createCoreLight(message: String) {
        
        DispatchQueue.main.async { [unowned self] in
            let light = NSEntityDescription.insertNewObject(forEntityName: "CoreLightCell", into: self.container.viewContext) as! CoreLightCell
            let json = message.data(using: .utf8)
            let jsonData = JSON(data: json!)
            self.configure(coreLightCell: light, usingJSON: jsonData)

            var duplicate = false
            
            for index in myLights.lights {
                if light.lightID == index.lightID {
                    duplicate = true
                    
                    self.configure(coreLightCell: index, usingJSON: jsonData)
                    self.container.viewContext.delete(light)
                } 
            }

            if (duplicate == false){
                myLights.lights.append(light)
                
            }
            
            self.LightsTable.reloadData()
            self.saveContext()
            
        }
    }
    
    // Create CoreLightCell by parsing JSON
    func configure(coreLightCell: CoreLightCell, usingJSON json: JSON){
        
        coreLightCell.version = json["version"].stringValue
        coreLightCell.name = json["lightInfo"]["name"].stringValue
        coreLightCell.state = json["lightInfo"]["state"].stringValue.lowercased() == "on"
        coreLightCell.color = json["lightInfo"]["color"].stringValue
        coreLightCell.expanded = json["lightInfo"]["room"].stringValue.lowercased() == "on"
        coreLightCell.protocolName = json["protocolName"].stringValue
        coreLightCell.lightID = json["lightInfo"]["id"].stringValue
        coreLightCell.room = json["lightInfo"]["room"].stringValue
        
        // Notification message to update room
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    // When Edit button is pressed, do stuff
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
    }
    
    // Set up the MQTT connection
    func settingMQTT() {
        // message = "Hi"
        let clientIdPid = "CocoaMQTT" + String(ProcessInfo().processIdentifier)
        DATA.mqtt = CocoaMQTT(clientId: clientIdPid, host: "prata.technocreatives.com", port: 1883)
        //prata.technocreatives.com 1883
        
        if let mqtt = DATA.mqtt {
            mqtt.username = "test"
            mqtt.password = "public"
            mqtt.willMessage = CocoaMQTTWill(topic: "presence/\(clientIdPid)", message: "")
            mqtt.keepAlive = 90
            mqtt.delegate = self
        
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set the cell to be used when creating the list of lightCells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = Bundle.main.loadNibNamed("LightsTableViewCell", owner: self, options: nil)?.first as! LightsTableViewCell
        
        let coreLightCell = myLights.lights[indexPath.row]
        cell.mainLabel?.text = coreLightCell.name
        
        
        if (coreLightCell.room != "undefined"){
            cell.roomLabel?.text = coreLightCell.room
        }
        
        cell.expand = coreLightCell.expanded
        cell.lightSwitch.setOn(coreLightCell.state, animated: false)
        cell.ID = coreLightCell.lightID
        cell.name = coreLightCell.name
        cell.room = coreLightCell.room
        cell.color = coreLightCell.color
        cell.delegate = self
        cell.accessoryType = .none
        
        return cell

    }
    
    // Keep track of the number of rows in the view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLights.lights.count
    }
    
    //  Force height to be 80 for the rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 80
    
    }
    
    // Specify what happens when a cell is edited in some way
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove Row at specific index pressed
            // Deletes from array of lights as well
            //           lightsArrayData.remove(at: indexPath.row)
            let light = myLights.lights[indexPath.row]
            container.viewContext.delete(light)
            myLights.lights.remove(at: indexPath.row)
            LightsTable.deleteRows(at: [indexPath], with: .fade)
            
            saveContext()
            
        } else if editingStyle == .insert {
            
        }
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
        mqtt.subscribe("lightcontrol/home/\(DATA.homeID)/light/+/info")
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
        createCoreLight(message: message.string!)
       
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
        
        
         _ = Message(forPresence: DATA.mqtt!.clientId)
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

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UITableViewController {
    override func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
}



