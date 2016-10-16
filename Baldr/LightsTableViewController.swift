//
//  FirstViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 9/23/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit



// TODO:
//      Have master turn off all lights
//      Don't handle light switched on viewDidLoad(), they automatically turn on
//      Make the Cells unclickable

struct lightsCellData {
    
    let main: String!
    let secondary: String!
    let onOff: Bool!

}

class LightsTableViewController: UITableViewController {

    @IBOutlet var LightsTable: UITableView!
    
    var lightsArrayData = [lightsCellData]()
    
    @IBAction func goToAddLight(_ sender: AnyObject) {
        
    }
    
    
    
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        
        // Cells unselectable
        tableView.allowsSelection = false
     
        lightsArrayData =  [lightsCellData(main: "MASTER", secondary: "", onOff: false),
                            lightsCellData(main: "MY LIGHT", secondary: "Kitchen", onOff: false),
                            lightsCellData(main: "Ceiling Light", secondary: "Living Room", onOff: false),
                            lightsCellData(main: "Kitchen Light Main", secondary: "Kitchen", onOff: false),
                            lightsCellData(main: "ASDFASDFASDF", secondary: "asdfjlaksdf", onOff: false),
                            lightsCellData(main: "rweqrqwerqwer", secondary: "rqwerqwerqwer", onOff: false),
                            lightsCellData(main: "zxdscvzxcvzxcvzxcv", secondary: "qwerqwerqwerqwer", onOff: false),
                            lightsCellData(main: "zxcv", secondary: "qwerqwerqwer", onOff: false),
                            lightsCellData(main: "qwerqwer", secondary: "qwerqwerqwer", onOff: false),
                            lightsCellData(main: "rqwerqwer", secondary: "qwerqwerqwer", onOff: false)]
        
 
        lightsArrayData.append(lightsCellData(main: "test", secondary: "test", onOff: false))
        
        
        let light = lightsCellData(main: "boop", secondary: "boop", onOff: false)
        addLight(light: light)
        
        
//        let light2 = lightsCellData(main: "MY LIGHT", secondary: "Kitchen", onOff: false)
//        removeLight(light: light2)

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
                light.main == lights.main && light.secondary == lights.secondary
        }
        
        lightsArrayData.remove(at: index!)
        
        // convert index to indexPath to delete the specific Row
        let indexPath = IndexPath(row: index!, section: 0)
        LightsTable.deleteRows(at: [indexPath], with: .fade)
        //LightsTable.deleteRows(at: index!, with: .fade)
        
        
    }
    
    
    // Set the cell to be used
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("MasterTableViewCell", owner: self, options: nil)?.first as! MasterTableViewCell
            
            cell.mainLabel.text = lightsArrayData[indexPath.row].main
            
            return cell
            
        } else {
        
        let cell = Bundle.main.loadNibNamed("LightsTableViewCell", owner: self, options: nil)?.first as! LightsTableViewCell
        
        
        cell.mainLabel.text = lightsArrayData[indexPath.row].main
        cell.secondaryLabel.text = lightsArrayData[indexPath.row].secondary
        //    cell.lightSwitch.isOn = lightsArrayData[indexPath.row].onOff
        cell.lightSwitch.setOn(lightsArrayData[indexPath.row].onOff, animated: false)
        
        return cell
        
        }
        
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

