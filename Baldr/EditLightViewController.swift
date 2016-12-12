//
//  EditLightViewController.swift
//  Baldr
//
//  Created by Thomas Emilsson on 12/1/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit

protocol EditLightCellDelegate {
    func userEditedData(name: String, color: String)
    
}

class EditLightViewController: UIViewController {

    var delegate: EditLightCellDelegate? = nil
    
    var myColor: UIColor?
    
    var mySlider: Float?
    
    var myName: String?
    
    @IBOutlet weak var nameLightField: UITextField!
    
    @IBOutlet weak var displayColorView: UIView!
    
    @IBOutlet weak var colorIndicator: UIImageView!
    
    @IBOutlet weak var colorSlider: UISlider!
    
    
    @IBAction func changeColors(_ sender: Any) {
        
        displayColorView.backgroundColor = UIColor(hue: round(CGFloat((colorSlider.value)))/100.0,saturation: 1, brightness: 1, alpha: 1.0)
        
        myColor = UIColor(hue: round(CGFloat((colorSlider.value))) / 100, saturation: 1, brightness: 1, alpha: 1)
        
        
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveLight(_ sender: Any) {
        
        if delegate != nil {
            
            if nameLightField.text != "" && nameLightField.text!.characters.first != " " {
                
                let name = nameLightField.text
                delegate?.userEditedData(name: name!, color: (myColor?.toHex())!)
                // exit page
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorIndicator.image = UIImage(named: "ColorSpectrum")
        displayColorView.backgroundColor = myColor
        colorSlider?.setValue(mySlider! * 100, animated: true)
        nameLightField.text = myName
        
        
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
