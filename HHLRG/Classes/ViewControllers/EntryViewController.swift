//
//  EntryViewController.swift
//  HHLRG
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit

let borderColor = UIColor(red: 141/255, green: 217/255, blue: 179/255, alpha: 1)

class EntryViewController: UIViewController {
    
    
    @IBOutlet var startTimeTextField: UITextField!
   
    @IBOutlet var endTimeTextField: UITextField!
    
    @IBOutlet var startDateTextField: UITextField!
    
    @IBOutlet var endDateTextField: UITextField!
    
    @IBOutlet var typeButtons: [UIButton]!
    
    @IBOutlet var breastOrSupButtons: [UIButton]!
    
    @IBOutlet var breastLabel: UILabel!
    
    @IBOutlet var leftUsedButton: UIButton!
    
    @IBOutlet var rightUsedButton: UIButton!
    
    @IBOutlet var breastfeedTypeButton: UIButton!

    @IBOutlet var expressedButton: UIButton!
    
    @IBOutlet var supplementaryButton: UIButton!
    
    @IBOutlet var scroller: UIScrollView!
    
    @IBOutlet var expressedSupButton: UIButton!
    
    @IBOutlet var formulaSupButton: UIButton!
    
    @IBOutlet var textFieldCollection: [UITextField]!
    
    @IBOutlet var commentTextView: UITextView!
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBOutlet var weightBefore: UITextField!
    
    @IBOutlet var weightAfter: UITextField!
    
    @IBOutlet var leftRightBreast: [UIButton]!
    
    
    
    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!) {
        
                
        feeds.append((startDateTextField.text!, startTimeTextField.text!))
        
        //NSUserDefaults.standardUserDefaults().setObject(feeds, forKey: "feeds")  
        
        
    }
    
    
    /*editing start/end DATE text fields*/
    
    var selectedTextField: UITextField!
    
    
    @IBAction func dateEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        selectedTextField = sender
        
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView)
        
    }
    
    
    /*editing start/end TIME text fields*/
    
    
    
    @IBAction func timeEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()

        datePickerView.datePickerMode = UIDatePickerMode.Time
        
        sender.inputView = datePickerView
    
        selectedTextField = sender
        
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView)
        
    }
    
    
    /*change DATE/TIME text field value*/
    func handleDatePicker(sender:UIDatePicker){
        
        let dateFormatter = NSDateFormatter()
        
        if selectedTextField == startDateTextField || selectedTextField == endDateTextField
        {
        
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        }
            
        else
        {
            
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
        }
        
        selectedTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        expressedSupButton.hidden = true
        expressedSupButton.enabled = false
        
        formulaSupButton.hidden = true
        formulaSupButton.enabled = false
        
        

      
        for textField in textFieldCollection {
            
            textField.layer.borderColor = borderColor.CGColor
            
            textField.layer.borderWidth = 2.0
            
            textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
            
            textField.adjustsFontSizeToFitWidth = true
            
        }
        
        commentTextView.layer.borderColor = borderColor.CGColor
        
        commentTextView.layer.borderWidth = 2.0
        
        
                            
            //commentTextView.layer.borderWidth = 2.0
        
            //commentTextView.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
                            
        
        // change button border color
        
        for button in buttonCollection {
        
            button.layer.borderColor = borderColor.CGColor

            button.layer.borderWidth = 2.0

            button.titleLabel?.adjustsFontSizeToFitWidth = true
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
            
            
            if supplementaryButton.selected{
                
                expressedSupButton.hidden = false
                formulaSupButton.hidden = false
                
                expressedSupButton.enabled = true
                formulaSupButton.enabled = true
                
                leftUsedButton.enabled = false
                rightUsedButton.enabled = false
                
                leftUsedButton.hidden = true
                rightUsedButton.hidden = true
                
                breastLabel.text = "SUPPLEMENTARY TYPE"
                
                
                
                
            } else {
                
                leftUsedButton.hidden = false
                rightUsedButton.hidden = false
                
                leftUsedButton.enabled = true
                rightUsedButton.enabled = true
                
                breastLabel.text = "BREAST"
                
                expressedSupButton.hidden = true
                formulaSupButton.hidden = true
                
                expressedSupButton.enabled = false
                formulaSupButton.enabled = false

                
            }

            
        }
        
        
        
    }
    
    
    @IBAction func breastUsedButtonSelected(sender: UIButton) {
        
        for button in breastOrSupButtons {
            
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
    
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

//
//    func keyboardWasShown(notification: NSNotification) {
//        var info = notification.userInfo!
//        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        
//        UIView.animateWithDuration(0.1, animations: { () -> Void in
//            self.bottomConstraint.constant = keyboardFrame.size.height + 20
//        })
//    }
    
}
