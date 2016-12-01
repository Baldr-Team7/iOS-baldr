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
    func userEnteredLightData(main: String)
}



class AddLightViewController: UIViewController {
    
    var delegate: AddLightCellDelegate? = nil
    var myColor: UIColor?
    
    
    // Name of the Light
    @IBOutlet weak var nameLightField: UITextField!
    @IBOutlet weak var displayColorView: UIView!
    @IBOutlet weak var colorSlider: UISlider!
    @IBOutlet weak var colorIndicator: UIImageView!
    @IBAction func changeColors(_ sender: Any) {
        
        displayColorView.backgroundColor = UIColor(hue: round(CGFloat(colorSlider.value))/100.0,saturation: 1, brightness: 1, alpha: 1.0)
        
        myColor = UIColor(hue: round(CGFloat(colorSlider.value)) / 100, saturation: 1, brightness: 1, alpha: 1)
        

    }
    @IBAction func printHex(_ sender: Any) {
        print(myColor!.toHex())
    }
    
    
        
    
    // Save the Light
    @IBAction func saveLight(_ sender: AnyObject) {
        
        
        // Get the Data Entered, send it to previous page
        if delegate != nil {
            if nameLightField.text != "" && nameLightField.text!.characters.first != " " {
                let name = nameLightField.text
                delegate?.userEnteredLightData(main: name!)
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
        self.colorIndicator.image = UIImage(named: "ColorSpectrum")
        displayColorView.backgroundColor = UIColor(hue: 1 ,saturation: 1, brightness: 1, alpha: 1.0)
        print(delegate!)
        
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


