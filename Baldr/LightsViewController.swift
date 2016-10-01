//
//  FirstViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 9/23/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

class LightsViewController: UIViewController {

    
    // temporary
    @IBOutlet weak var addLight: UIBarButtonItem!
    
    // check when pressed to add effect to cell
    @IBOutlet weak var editLight: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addLight(_ sender: AnyObject) {
        
    
        // TODO: connect to another view controller
        tabBarController?.selectedIndex = 2
    
    
    }

    @IBAction func editLight(_ sender: AnyObject) {
    }
}

