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
    // let onOff: Bool!
}



class LightsTableViewController: UITableViewController {

    
    var lightsArrayData = [lightsCellData]()
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        lightsArrayData = [lightsCellData(main: "MASTER", secondary: ""),
                           lightsCellData(main: "MY LIGHT", secondary: "Kitchen"),
                           lightsCellData(main: "Ceiling Light", secondary: "Living Room"),
                           lightsCellData(main: "Kitchen Light Main", secondary: "Kitchen"),
                           lightsCellData(main: "ASDFASDFASDF", secondary: "asdfjlaksdf"),
                           lightsCellData(main: "rweqrqwerqwer", secondary: "rqwerqwerqwer"),
                           lightsCellData(main: "zxdscvzxcvzxcvzxcv", secondary: "qwerqwerqwerqwer"),
                           lightsCellData(main: "zxcv", secondary: "qwerqwerqwer"),
                           lightsCellData(main: "qwerqwer", secondary: "qwerqwerqwer"),
                           lightsCellData(main: "rqwerqwer", secondary: "qwerqwerqwer")]
        
        

    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Set the cell to be used
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = Bundle.main.loadNibNamed("LightsTableViewCell", owner: self, options: nil)?.first as! LightsTableViewCell
        
        cell.mainLabel.text = lightsArrayData[indexPath.row].main
        cell.secondaryLabel.text = lightsArrayData[indexPath.row].secondary
        //    cell.lightSwitch.isOn = lightsArrayData[indexPath.row].onOff
        
    
        return cell
        
        
    }
    
    
    // Keep track of the number of rows in the view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lightsArrayData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
   
    

}

