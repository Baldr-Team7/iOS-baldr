//
//  AddRoomViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/6/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

class AddRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var noRoomLights = [CoreLightCell]()
    
    @IBAction func saveRoom(_ sender: Any) {
        //tableView.reloadData()
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        //    print(noRoomLights)
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getLights()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
//        self.tableView.clipsToBounds = true
//        self.tableView.layer.masksToBounds = false
//        self.tableView.layer.borderColor = UIColor.black.cgColor
//        self.tableView.layer.borderWidth = 2.0
        
       
        // Do any additional setup after loading the view.
        
    }
    
    func getLights(){
        for index in myLights.lights {
            if index.room == "undefined" {
                noRoomLights.append(index)
            }
        }
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
            cell.accessoryType = .none
            
        }
    
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            
            
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
