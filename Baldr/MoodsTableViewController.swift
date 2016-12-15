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

class MoodsTableViewController: UITableViewController, AddMoodCellDelegate, EditMoodCellDelegate, MoodCellDelegate {
    
    var container2: NSPersistentContainer!
    //var moodsArrayData = [moodsCellData]()
    
    //Temporary cells testing
    @IBOutlet var MoodsTable: UITableView!
    var editIndex: Int = 0
    
    var moodsArray = [CoreMoodCell]()
    
    //when user entered new mood, save the input and pass it to the protocol func
    func userEnteredMoodData(moodName: String) {
        
        createCoreMood(moodName: moodName)
        
    }
    
    func userEditedData(moodName: String) {
        
        moodsArray[editIndex].moodName = moodName
        
        saveContext()
        
        self.MoodsTable.reloadData()
       
        
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
            
            editMoodViewController.currentMoodName = moodsArray[editIndex].moodName
            
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

            let mood = moodsArray[indexPath.row]
            
            container2.viewContext.delete(mood)
            moodsArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveContext()
            
        } else if editingStyle == .insert {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        container2 = NSPersistentContainer(name: "Baldr")

        container2.loadPersistentStores { storeDescription, error in
            self.container2.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }

        
        navigationItem.leftBarButtonItem = editButtonItem
        MoodsTable.allowsSelectionDuringEditing = true
        tableView.allowsSelection = false
        
        loadSavedData()
        print(moodsArray)
        
        
        self.MoodsTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DATA.moodPageWillUpdate {
            moodsArray = []
            self.MoodsTable.reloadData()
            DATA.moodPageWillUpdate = false
        }
    }
    func saveContext() {
        if container2.viewContext.hasChanges {
            do {
                try container2.viewContext.save()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request = CoreMoodCell.createFetchRequest()
        
        do {
            moodsArray = try container2.viewContext.fetch(request)
            print("Got \(moodsArray.count) moods")
            self.reload()
        } catch {
            print("Fetch failed")
        }
    }
    
    
    
    func reload() {
        MoodsTable.beginUpdates()
        MoodsTable.endUpdates()
    }
    
    func createCoreMood(moodName: String) {
        DispatchQueue.main.async { [unowned self] in

            let mood = NSEntityDescription.insertNewObject(forEntityName: "CoreMoodCell", into: self.container2.viewContext) as! CoreMoodCell
            
            self.configure(coreMoodCell: mood, moodName: moodName)
            
            self.MoodsTable.reloadData()
            
            self.saveContext()
            
        }
    }
    
    func applyMood(moodName: String, jsonMessage: String?){
        
        //print(jsonMessage!)
        
        let json = jsonMessage?.data(using: .utf8)
        let jsonData = JSON(data: json!)
        
        for (key,value):(String, JSON) in jsonData {
            
            DATA.mqtt.publish(key, withString: value.stringValue)
            
        }

        
    }
    
    
    func configure(coreMoodCell: CoreMoodCell, moodName: String){
        
        coreMoodCell.moodName = moodName

        var dictionary: Dictionary<String, String> = [:]
        
        for index in myLights.lights {
            
            let message = Message(forMood: index)
            dictionary[message.topic] = message.message
            
        }
        
        
        let jsonObject = JSON(dictionary)
        
        coreMoodCell.lightsJSON = jsonObject.rawString()!
        
        moodsArray.append(coreMoodCell)
        
        self.MoodsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = Bundle.main.loadNibNamed("MoodsTableViewCell", owner: self, options: nil)?.first as! MoodsTableViewCell
        
        let coreMoodCell = moodsArray[indexPath.row]
        
        cell.mainLabel.text = coreMoodCell.moodName
        cell.accessoryType = .none
        cell.applyButton.layer.borderColor = UIColor.black.cgColor
        cell.applyButton.layer.borderWidth = 0.5
        
        cell.jsonMessage = coreMoodCell.lightsJSON
        
        cell.delegate = self
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
