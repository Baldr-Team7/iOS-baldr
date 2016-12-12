//
//  EditRoomViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 12/12/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

class EditRoomViewController: UIViewController {

    
    
    var roomName: String?
    
    @IBOutlet weak var nameRoomField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func goBack(_ sender: Any) {
    
    }
   
    // Save the Edited Room
    @IBAction func saveRoom(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
