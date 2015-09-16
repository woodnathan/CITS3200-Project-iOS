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
        
        var datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
       
    func datePickerValueChanged(sender:UIDatePicker) {
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        startTimeTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    /*end time field onclick*/
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
   //change button border color
        
        let buttons = [leftUsedButton, rightUsedButton, breastfeedTypeButton, expressedButton, supplementaryButton]
        
        
        for button in buttons {
            button.layer.borderWidth = 1.5
            //button.layer.cornerRadius = 5
            button.layer.borderColor = UIColor.grayColor().CGColor
        }
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    //toggle keyboard
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }

    
    
}
