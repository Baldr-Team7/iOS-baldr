//
//  SettingsViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 12/13/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

protocol SettingsDelegate{
    func userUpdatedHomeID()
}

class SettingsViewController: UIViewController {
    

    @IBOutlet weak var homeIDTextField: UITextField!
    var delegate: SettingsDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    @IBAction func updateHomeID(_ sender: Any) {
        
        if delegate != nil{
            if homeIDTextField.text != "" && homeIDTextField.text!.characters.first != " " {
                let homeID = homeIDTextField.text
                delegate?.userUpdatedHomeID()
                DATA.homeID = homeID!
                
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

}
