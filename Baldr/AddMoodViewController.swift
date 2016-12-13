//
//  AddMoodViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 10/6/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit


// protocol that pass the name user entered for every new Mood

protocol AddMoodCellDelegate{
    func userEnteredMoodData(moodName: String)
}

class AddMoodViewController: UIViewController {

    
    @IBOutlet weak var nameMoodField: UITextField!
    
    var delegate: AddMoodCellDelegate? = nil
    
    //Get the data user entered then sedn it to the previous page
    
    @IBAction func saveMood(_ sender: Any) {
        
        if delegate != nil{
            if nameMoodField.text != "" && nameMoodField.text!.characters.first != " " {
                let name = nameMoodField.text
                delegate?.userEnteredMoodData(moodName: name!)
                dismiss(animated: true, completion: nil)
            
            }
        }
    }
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
