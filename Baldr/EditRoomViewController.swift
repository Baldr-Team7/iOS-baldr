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
            
            if nameRoomField.text != "" && nameRoomField.text!.characters.first != " " {
                
                let name = nameRoomField.text
                delegate?.userEditedRoomData(room: name!)
                // exit page
                
                for index in 0...(myRoomLights.count - 1) {
                    let indexPath = IndexPath(row: index, section: 0)
                    //print(tableView.cellForRow(at: indexPath)!)//{
                    if (tableView.cellForRow(at: indexPath)?.isSelected)! {
                        //print("hello")
                        updateRoomForLight(light: myRoomLights[index], room: name!)
                        print((tableView.cellForRow(at: indexPath)?.isSelected)!)
                    } else {
                        setRoomToUndefined(light: myRoomLights[index])
                    }
                
                }
                
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func updateRoomForLight(light: CoreLightCell, room: String){
        
        let topic = "lightcontrol/home/\(DATA.homeID)/light/\(light.lightID)/commands"
        
        
        DATA.mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"room\":\"\(room)\"}}")
        
    }
    
    
    func setRoomToUndefined(light: CoreLightCell) {
        
        let topic = "lightcontrol/home/\(DATA.homeID)/light/\(light.lightID)/commands"
        
        
        DATA.mqtt!.publish("\(topic)", withString: "{\"version\": 1, \"protocolName\": \"baldr\", \"lightCommand\" : { \"room\":\"undefined\"}}")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLights()
        self.hideKeyboardWhenTappedAround()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        nameRoomField.text = roomName
        
        // Do any additional setup after loading the view.
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
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // show only lights without rooms
        
        return myRoomLights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        // let cell = UITableViewCell()
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let light = myRoomLights[indexPath.row]
        
        cell.textLabel?.text = light.name
        
        if (light.room == roomName) {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        } else {
            cell.accessoryType = .none
            //cell.isSelected = false
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
