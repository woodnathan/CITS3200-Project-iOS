//
//  EntryViewController.swift
//  breastfeeding3
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    
    
    @IBOutlet var startTimeTextField: UITextField!
   
    @IBOutlet var endTimeTextField: UITextField!
    
    
    @IBOutlet var leftUsedButton: UIButton!
    
    @IBOutlet var rightUsedButton: UIButton!
    
    @IBOutlet var breastfeedTypeButton: UIButton!

    @IBOutlet var expressedButton: UIButton!
    
    @IBOutlet var supplementaryButton: UIButton!
    
    
    /*time field onclick, activate timepicker*/
    
    
    @IBAction func startTimeEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
       
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        startTimeTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    /*end time field onclick*/
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for view in self.view.subviews {
            
            var border = CALayer()
            let color = UIColor(red: 141/255, green: 217/255, blue: 179/255, alpha: 1)

            //change textfield border color
            if let textField = view as? UITextField{
                
                textField.layer.borderColor = color.CGColor
                
                textField.layer.borderWidth = 2.0
                
                textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
                
            }
            // change button border color
            else if let button = view as? UIButton {
                
                button.layer.borderColor = color.CGColor
                
                button.layer.borderWidth = 2.0;
        
            }
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    //toggle keyboard
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }

    
    
}
