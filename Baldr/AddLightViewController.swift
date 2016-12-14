//
//  AddLightViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/5/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit


// Naming Delegate

protocol AddLightCellDelegate {
    func userEnteredLightData(discoveryCode: String)
}



class AddLightViewController: UIViewController {
    
    var delegate: AddLightCellDelegate? = nil
    var myColor: UIColor?
    
    
    @IBOutlet weak var discoveryCode: UITextField!
    
    // Save the Light
    @IBAction func saveLight(_ sender: AnyObject) {
        
        
        // Get the Data Entered, send it to previous page
        if delegate != nil {
            if discoveryCode.text != "" && discoveryCode.text!.characters.first != " " {
                let code = discoveryCode.text
                delegate?.userEnteredLightData(discoveryCode: code!)
                // exit page
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


