//
//  AddRoomViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/6/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

protocol AddRoomCellDelegate {
    func userEnteredRoomData(room: String)
}

class AddRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: AddRoomCellDelegate? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameRoomField: UITextField!
    
    // holds all lights with no rooms
    var noRoomLights = [CoreLightCell]()
    
    @IBAction func saveRoom(_ sender: Any) {
        //tableView.reloadData()
        
        if delegate != nil {
            if nameRoomField.text != "" && nameRoomField.text!.characters.first != " " {
                let name = nameRoomField.text
                delegate?.userEnteredRoomData(room: name!)
                print(name!)
                for index in 0...(noRoomLights.count - 1) {
                    // let indexPath = IndexPath(row: index, section: 0)
                    //print(tableView.cellForRow(at: indexPath)!)//{
                    if (tableView.cellForRow(at: IndexPath(row: index, section: 0))?.isSelected)! {
                        //print("hello")
                        updateRoomForLight(light: noRoomLights[index], room: name!)
                    }
                }
                dismiss(animated: true, completion: nil)
            }
            
            // go through all lights in the table and update selected lights
            
            // exit page
            
        }
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getLights()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.hideKeyboardWhenTappedAround()

    }
    
  
    
    func getLights(){
        for index in myLights.lights {
            if index.room == "undefined" {
                noRoomLights.append(index)
            }
        }
    }
    
    func updateRoomForLight(light: CoreLightCell, room: String){
        
        let topic = "lightcontrol/home/\(DATA.homeID)/light/\(light.lightID)/commands"
        
        
        DATA.mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"room\":\"\(room)\"}}")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // show only lights without rooms
        
        return noRoomLights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        // let cell = UITableViewCell()
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        let light = noRoomLights[indexPath.row]
        cell.textLabel?.text = light.name
        
        print(light.name)
        cell.accessoryType = .none
        cell.selectionStyle = .none
    
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            //cell.isSelected = true
            
        }
    
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            // cell.isSelected = false
            
            
            
        }
    }
 

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
