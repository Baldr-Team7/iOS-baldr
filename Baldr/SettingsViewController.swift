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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.hideKeyboardWhenTappedAround()
        homeIDTextField.text = DATA.homeID
    }

    @IBAction func updateHomeID(_ sender: Any) {
            if homeIDTextField.text != "" && homeIDTextField.text!.characters.first != " " {
            
                let homeID = homeIDTextField.text

                DATA.homeID = homeID!
                
                print(DATA.homeID)
                
                self.dismissKeyboard()
                
                tabBarController?.selectedIndex = 0
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
