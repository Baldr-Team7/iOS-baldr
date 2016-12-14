//
//  EditRoomViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 12/12/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

protocol EditRoomCellDelegate {
    func userEditedRoomData(room: String)
}

class EditRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: EditRoomCellDelegate? = nil
    
    var roomName: String?
    var myRoomLights = [CoreLightCell]()
    
    @IBOutlet weak var nameRoomField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    // Save the Edited Room
    @IBAction func saveRoom(_ sender: Any) {
        if delegate != nil {
            
            if nameRoomField.text != "" && nameRoomField.text!.characters.first != " " && nameRoomField.text != "undefined" {
                
                let room = nameRoomField.text
                delegate?.userEditedRoomData(room: room!)
                
                for index in 0...(myRoomLights.count - 1) {
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    if (tableView.cellForRow(at: indexPath)?.isSelected)! {
                        
                        // Change the assigned Room of a Light
                        _ = Message(forRoom: myRoomLights[index], room: room!)
                        
                    } else {
                        
                        // Set Light to have no room
                        _ = Message(forRoom: myRoomLights[index], room: "undefined")
                    }
                
                }
                
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLights()
        self.hideKeyboardWhenTappedAround()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        nameRoomField.text = roomName
        
    }

    
    func getLights(){
        for index in myLights.lights {
            if (index.room == "undefined") || (index.room == roomName) {
                myRoomLights.append(index)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // show only lights without rooms
        return myRoomLights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let light = myRoomLights[indexPath.row]
        
        cell.textLabel?.text = light.name
        
        if (light.room == roomName) {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        } else {
            cell.accessoryType = .none
        }
        cell.selectionStyle = .none
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
