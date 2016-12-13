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

// Struct that holds the core data for the lights
// accessible globally 
struct myLights {
    static var lights: [CoreLightCell] = []
}

struct DATA {
    static var mqtt: CocoaMQTT!
    static var homeID = "asdf"
}

class LightsTableViewController: UITableViewController, AddLightCellDelegate, LightCellDelegate, EditLightCellDelegate, SettingsDelegate {
    
    @IBOutlet var LightsTable: UITableView!

    
    //var mqtt : CocoaMQTT! // change to '?' maybe
    var container: NSPersistentContainer!
    var editIndex: Int = 0
    
    
    // Hard coded Data, temporary
    var lightsArrayData =  [lightsCellData(main: "Light", onOff: false),
                            lightsCellData(main: "Light2", onOff: false)]
    

     // ---------------------------------------------------------------------------------------------
    
    
    // toggle the light, send the appropriate message to the broker
    func toggleLight(main: String, state: Bool, lightID: String){
        print("Hello")
        
        //print("\(main) is \(state)")
        
        let topic: String?
        
        topic = "lightcontrol/home/\(DATA.homeID)/light/\(lightID)/commands"

        if (state == true){
            turnLightOn(topic: topic!)
        }
        else {
            turnLightOff(topic: topic!)
        }
        
        print(topic!)
    }

    func reload() {
        
        //print("reload")
        LightsTable.beginUpdates()
        LightsTable.endUpdates()
    }
    
  
    func userUpdatedHomeID(){
        
        for index in myLights.lights{
            container.viewContext.delete(index)
        }
        
        
        myLights.lights = []
        
        
        saveContext()
        
        LightsTable.reloadData()
        
    }
    // ---------------------------------------------------------------------------------------------
    
    // Delegate Methods
    // Get message from recieved
    
    
//    func getMessage() -> String{
//        return receievedMessage!
//    }
    
    // Receive Data Light Cell

    
    func userEnteredLightData(discoveryCode code: String) {
    
        DATA.mqtt!.publish("lightcontrol/discovery", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"discovery\" : {\"discoveryCode\":\"\(code)\", \"home\": \"\(DATA.homeID)\"}}")
        
    }
    
    func userEditedData(name: String, color: String) {
        
        print("\(name) = \(color)")
        
        let lightID = myLights.lights[editIndex].lightID
        
        print("\(lightID)")
        
        let topic = "lightcontrol/home/asdf/light/\(lightID)/commands"
        changeNameAndColor(topic: topic, hex: color, name: name)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(segue.identifier!)
        // Set Delegate
        if segue.identifier == "showAddLight" {
            
            // AddLightVC has a UINavigationController attached to it; need to access the UINC first to get to the AddLightVC
            let destination = segue.destination as! UINavigationController
            
            let addLightViewController: AddLightViewController = destination.topViewController as! AddLightViewController
            //            let addLightViewController: AddLightViewController = segue.destination as! AddLightViewController
            
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
    
    
    // ---------------------------------------------------------------------------------------------
    
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
        
        //print(container.name)
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        
        }
        
        self.reload()
        // self.tableView.reloadData()
        
        
        // Add Edit Button to nagivation bar programmatically
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        // Only allow selection during Edit
        LightsTable.allowsSelectionDuringEditing = true
         // Cells unselectable (only selectable during Editing
        tableView.allowsSelection = false
        
    
        // test usage of hex to UIColor converter
        //self.view.backgroundColor = UIColor(hexString: "#ffe700")
        
        // test usage of UIColor to hex converter
        //let green = UIColor.green.toHex()
        //print(green)
        
        //self.view.backgroundColor = UIColor(hexString: green)

       
     
        settingMQTT()
        DATA.mqtt!.connect()
    
        //getData()
        loadSavedData()
    
    }

    func handleRefresh(refreshControl: UIRefreshControl) {

    
        myLights.lights.sort() { $0.room < $1.room }
        
        self.reload()
        //        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
//        getData()
//        tableView.reloadData()
    
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
    
    
    // Working
    func getData() {
        let context = container.viewContext
        
        do {
            myLights.lights = try context.fetch(CoreLightCell.createFetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    
    // TODO: Fix sorting
    // Figure out key for "room" as it is inside lightInfo
    
    
    func loadSavedData() {
        let request = CoreLightCell.createFetchRequest()
        //  let sort = NSSortDescriptor(key: "room", ascending: false)
        //request.sortDescriptors = [sort]
    
        do {
            myLights.lights = try container.viewContext.fetch(request)
            print("Got \(myLights.lights.count) lights")
            self.reload()
            //tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    
    // Unused, consider removing
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
                self.loadSavedData()
            }
        }
    }
    
    
    
    // Working CoreLightCell initializer
    func createCoreLight(message: String) {
        
        DispatchQueue.main.async { [unowned self] in
            print(self.container.name)
            //      print(container.name)
            let light = NSEntityDescription.insertNewObject(forEntityName: "CoreLightCell", into: self.container.viewContext) as! CoreLightCell
            let json = message.data(using: .utf8)
            let jsonData = JSON(data: json!)
            self.configure(coreLightCell: light, usingJSON: jsonData)

            // var indexPath = 0
            var duplicate = false
            
            for index in myLights.lights {
                // should be replaced with id checking

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
    
    // intricacies of the coreLightCell creation
    func configure(coreLightCell: CoreLightCell, usingJSON json: JSON){
        
        coreLightCell.version = json["version"].stringValue
        //        coreLightCell.name = json["protocolName"].stringValue
        coreLightCell.name = json["lightInfo"]["name"].stringValue
        coreLightCell.state = json["lightInfo"]["state"].stringValue.lowercased() == "on"
        coreLightCell.color = json["lightInfo"]["color"].stringValue
        coreLightCell.expanded = json["lightInfo"]["room"].stringValue.lowercased() == "on"
        coreLightCell.protocolName = json["protocolName"].stringValue
        coreLightCell.lightID = json["lightInfo"]["id"].stringValue
        coreLightCell.room = json["lightInfo"]["room"].stringValue
        
        // Notification message to update room
        NotificationCenter.default.post(name: .reload, object: nil)
                
    }
    
    // When Edit button is pressed, do stuff
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
    }
    
    
    // Set up the MQTT connection
    func settingMQTT() {
        // message = "Hi"
        let clientIdPid = "CocoaMQTT" + String(ProcessInfo().processIdentifier)
        DATA.mqtt = CocoaMQTT(clientId: clientIdPid, host: "tann.si", port: 8883)
        if let mqtt = DATA.mqtt {
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
    // Not used; append is better
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
        
//        cell.mainLabel.text = lightsArrayData[indexPath.row].main
//       cell.lightSwitch.setOn(lightsArrayData[indexPath.row].onOff, animated: false)
//        cell.delegate = self
        
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
            //           lightsArrayData.remove(at: indexPath.row)
            let light = myLights.lights[indexPath.row]
            container.viewContext.delete(light)
            myLights.lights.remove(at: indexPath.row)
            LightsTable.deleteRows(at: [indexPath], with: .fade)
            
            saveContext()
            
        } else if editingStyle == .insert {
            
        }
    }
    
    func getMessage(topic: String){
        DATA.mqtt!.subscribe("\(topic)")
    }
    // Turn Light on Message
    func turnLightOn(topic: String){
         DATA.mqtt!.publish("\(topic)", withString:"{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"state\":\"on\"}}")
        
    }
    
    // Turn Light Off Message
    func turnLightOff(topic: String){
        DATA.mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"state\":\"off\"}}")

    }
    
    // Change Color Message, with parameter as a UIColor
    func changeNameAndColor(topic: String, color: UIColor, name: String){
        let hex = color.toHex()
        DATA.mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"color\":\"\(hex)\"}}")
    }

    // Change Color Message, with parameter as a hexadecimal String
    func changeNameAndColor(topic: String, hex: String, name: String){
        DATA.mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"color\":\"\(hex)\", \"name\":\"\(name)\"}}")
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

