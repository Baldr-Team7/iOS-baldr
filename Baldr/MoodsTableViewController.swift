//
//  MoodsViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/1/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import CocoaMQTT

struct moodsCellData{
    var mood: String!
//    let moodOnOff: Bool!
//    let lightsOn: Int!
//    let lightsOff: Int!
}

class MoodsTableViewController: UITableViewController, AddMoodCellDelegate, EditMoodCellDelegate {
    
    
    //var moodsArrayData = [moodsCellData]()
    
    //Temporary cells testing
    @IBOutlet var MoodsTable: UITableView!
    var editIndex: Int = 0
    
    var moodsArrayData = [moodsCellData(mood: "Pissed"),
                          moodsCellData(mood: "Happy"),
                          moodsCellData(mood: "Depressed ")]
    
    
    //when user entered new mood, save the input and pass it to the protocol func
    func userEnteredMoodData(mood: String) {
        let newMood = moodsCellData(mood: mood)
        moodsArrayData.append(newMood)
        
        UIView.performWithoutAnimation {
            self.MoodsTable.reloadData()
        }
    }
    
    func userEditedData(mood: String) {
        
        print(mood)
        moodsArrayData[editIndex].mood = mood
        UIView.performWithoutAnimation {
            self.MoodsTable.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //set Delegate 
        if segue.identifier == "showAddMood" {
            let destination = segue.destination as! UINavigationController
            
            let addMoodViewController: AddMoodViewController = destination.topViewController as! AddMoodViewController
            
            addMoodViewController.delegate = self
        }else if segue.identifier == "showEditMood"{
            let destination = segue.destination as! UINavigationController
            
            let editMoodViewController: EditMoodViewController = destination.topViewController as! EditMoodViewController
            
            editMoodViewController.currentMoodName = moodsArrayData[editIndex].mood
            
            editMoodViewController.delegate = self
            
        
        
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editIndex = indexPath.row
        performSegue(withIdentifier: "showEditMood", sender: self)
        setEditing(false, animated: true)
        
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    // Specify what happens when a cell is edited in some way
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove Row at specific index pressed
            // Deletes from array of lights as well
            //           lightsArrayData.remove(at: indexPath.row)
//            let light = myLights.lights[indexPath.row]
//            container.viewContext.delete(light)
//            myLights.lights.remove(at: indexPath.row)
//            LightsTable.deleteRows(at: [indexPath], with: .fade)
            
//            saveContext()/
            
         //   let mood = moodsArrayData[indexPath.row]
            moodsArrayData.remove(at: indexPath.row)
            
            MoodsTable.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.leftBarButtonItem = editButtonItem
        MoodsTable.allowsSelectionDuringEditing = true
        tableView.allowsSelection = false
        
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodsArrayData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("MoodsTableViewCell", owner: self, options: nil)?.first as! MoodsTableViewCell
        cell.mainLabel.text = moodsArrayData[indexPath.row].mood
        //cell.moodSwitch.setOn(moodsArrayData[indexPath.row].moodOnOff, animated:false)
        //cell.delegate = self
        
        //cell.delegate = self
        cell.accessoryType = .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func addMood(mood : moodsCellData){
        moodsArrayData.append(mood)
    }
//    func toggleMood()
//    
//}
}
extension MoodsTableViewController: CocoaMQTTDelegate {
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

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }*/
