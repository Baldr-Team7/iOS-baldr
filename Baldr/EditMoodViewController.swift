//
//  EditMoodViewController.swift
//  Baldr
//
//  Created by LiangZhanou on 2016-12-11.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

protocol editMoodCellDelegate {
    func userEditedData(mood: String)
    
}

class EditMoodViewController: UIViewController {

    
    var delegate: editMoodCellDelegate? = nil
    
    var currentMoodName: String?
    @IBOutlet weak var nameMoodField: UITextField!
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveMood(_ sender: Any) {
        if delegate != nil{
            if nameMoodField.text != "" && nameMoodField.text!.characters.first != " "{
                let name = nameMoodField.text
                delegate?.userEditedData(mood: name!)
                //exit the current page
                dismiss(animated: true, completion: nil)
        }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameMoodField.text = currentMoodName

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
