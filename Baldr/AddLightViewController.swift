//
//  AddLightViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/5/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit


// Naming Delegate
protocol DataSendDelegate {
    func light(data: String)
}


class AddLightViewController: UIViewController {

    var delegate: DataSendDelegate? = nil
    
  
    @IBAction func goBack(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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
