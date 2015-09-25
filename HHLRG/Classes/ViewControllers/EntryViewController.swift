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
    
    @IBOutlet var startDateTextField: UITextField!
    
    @IBOutlet var endDateTextField: UITextField!
    
    @IBOutlet var typeButtons: [UIButton]!
    
    @IBOutlet var breastUsedButtons: [UIButton]!
    
    
    @IBOutlet var leftUsedButton: UIButton!
    
    @IBOutlet var rightUsedButton: UIButton!
    
    @IBOutlet var breastfeedTypeButton: UIButton!

    @IBOutlet var expressedButton: UIButton!
    
    @IBOutlet var supplementaryButton: UIButton!
    
    
    
    /*editing start/end DATE text fields*/
    
    var selectedTextField: UITextField!
    
    
    @IBAction func dateEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        selectedTextField = sender
        
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        
    }
    
    
    /*editing start/end TIME text fields*/
    
    
    
    @IBAction func timeEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()

        datePickerView.datePickerMode = UIDatePickerMode.Time
        
        sender.inputView = datePickerView
    
        selectedTextField = sender
        
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    /*change DATE/TIME text field value*/
    func handleDatePicker(sender:UIDatePicker){
        
        let dateFormatter = NSDateFormatter()
        
        if selectedTextField.tag == 0 || selectedTextField.tag == 1 {
            
            /* tag 0, 1 for start/end DATE fields*/
        
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        }
        else
        {
            /*tag 2, 3 for start/end TIME fields*/
            
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
        }
        
        selectedTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        for view in self.view.subviews {
            
            let borderColor = UIColor(red: 141/255, green: 217/255, blue: 179/255, alpha: 1)
            
            var border = CALayer()
                       //change textfield border color
            if let textField = view as? UITextField{
                
                
                textField.layer.borderColor = borderColor.CGColor
                
                textField.layer.borderWidth = 2.0
                
                textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
                
            }
            // change button border color
            else if let button = view as? UIButton {
                
                button.layer.borderColor = borderColor.CGColor
                
                button.layer.borderWidth = 2.0
                
            }
            
            
            
        }
        
    }
    
    
    let selectedColor = UIColor(red: 49/255, green: 91/255, blue: 131/255, alpha: 1)

    @IBAction func typeButtonSelected(sender: UIButton) {
        
        for button in typeButtons {
            
            if button == sender && button.selected == false {
                
                    button.selected = true
                    
                    button.layer.backgroundColor = selectedColor.CGColor
                    
                    button.titleLabel?.textColor = UIColor.whiteColor()
                    
                
                    
            } else {
                    
                button.selected = false
                
                button.layer.backgroundColor = UIColor.clearColor().CGColor
                
                button.titleLabel?.textColor = UIColor.blackColor()

                    
            }
            
        }
        
        
        
    }
    
    
    @IBAction func breastUsedButtonSelected(sender: UIButton) {
        
        for button in breastUsedButtons {
            
            if button == sender && button.selected == false {
                
                button.selected = true
                
                button.layer.backgroundColor = selectedColor.CGColor
                
                button.titleLabel?.textColor = UIColor.whiteColor()
                
                
                
            } else {
                
                button.selected = false
                
                button.layer.backgroundColor = UIColor.clearColor().CGColor
                
                button.titleLabel?.textColor = UIColor.blackColor()
                
                
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
