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
    
    var client: Client!
    var feed = Feed()
    
    
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var endTimeTextField: UITextField!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var endDateTextField: UITextField!
    @IBOutlet var weightBefore: UITextField!
    @IBOutlet var weightAfter: UITextField!
    
    @IBOutlet var breastLabel: UILabel!
    
    @IBOutlet var leftUsedButton: UIButton!
    @IBOutlet var rightUsedButton: UIButton!
    @IBOutlet var breastfeedTypeButton: UIButton!
    @IBOutlet var expressedButton: UIButton!
    @IBOutlet var supplementaryButton: UIButton!
    
    @IBOutlet var expressedSupButton: UIButton!
    @IBOutlet var formulaSupButton: UIButton!
    @IBOutlet var deleteButton: UIButton!

    @IBOutlet var scroller: UIScrollView!
    @IBOutlet var commentTextView: UITextView!
    
    private let dateFormatter = NSDateFormatter()
    private let timeFormatter = NSDateFormatter()
    
    @IBOutlet var breastOrSupButtons: [UIButton]!
    @IBOutlet var typeButtons: [UIButton]!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet var buttonCollection: [UIButton]!
    
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
            //expressedSupButton.enabled = false
            
            formulaSupButton.hidden = true
            //formulaSupButton.enabled = false
            
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            if let date = feed.before.date {
                startDateTextField.text = dateFormatter.stringFromDate(date)
                startTimeTextField.text = timeFormatter.stringFromDate(date)
                weightBefore.text = String(feed.before.weight)
                
            }
            if let date = feed.after.date {
                endDateTextField.text = dateFormatter.stringFromDate(date)
                endTimeTextField.text = timeFormatter.stringFromDate(date)
                weightAfter.text = String(feed.after.weight)

            }
            
            commentTextView.text = feed.comment

            for textField in textFieldCollection {
                textField.layer.borderColor = borderColor.CGColor
                textField.layer.borderWidth = 2.0
                textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
                textField.adjustsFontSizeToFitWidth = true
            }
            
            commentTextView.layer.borderColor = borderColor.CGColor
            commentTextView.layer.borderWidth = 2.0
            //commentTextView.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
                                
            
            // change button border color
            
            for button in buttonCollection {
                
                if let type = feed.type {
                    if button.titleLabel?.text == String(type) {
                        typeButtonSelected(button)
                    }
                }
                
                if let side = feed.side {
                    if button.titleLabel?.text == String(side) {
                        breastUsedButtonSelected(button)
                    }
                }
                
                if let subtype = feed.subtype {
                    if button.titleLabel?.text == String(subtype) {
                        breastUsedButtonSelected(button)
                    }
                }
                
                button.layer.borderColor = borderColor.CGColor
                button.layer.borderWidth = 2.0
                button.titleLabel?.adjustsFontSizeToFitWidth = true
            }
        
        deleteButton.hidden = true
        if feed.before.date != nil {
            deleteButton.hidden = false
            deleteButton.layer.backgroundColor = borderColor.CGColor
        }
    }
    
    
    let selectedColor = UIColor(red: 49/255, green: 91/255, blue: 131/255, alpha: 1)
    
    //Breastfeed, Expression or Supplementary button selected
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
                
                leftUsedButton.hidden = true
                rightUsedButton.hidden = true
                breastLabel.text = "SUPPLEMENTARY TYPE"
                
            } else {
                leftUsedButton.hidden = false
                rightUsedButton.hidden = false
                
                expressedSupButton.hidden = true
                formulaSupButton.hidden = true
                breastLabel.text = "BREAST"
            }
        }
    }
    
    
    /* Left/Right side button selected, or Expressed/Formula button selected*/
    @IBAction func breastUsedButtonSelected(sender: UIButton) {
        
        for button in breastOrSupButtons {
            if button == sender && button.selected == false {
                button.selected = true
                button.layer.backgroundColor = selectedColor.CGColor
                button.titleLabel?.textColor = UIColor.whiteColor()
            }
            else {
                button.selected = false
                button.layer.backgroundColor = UIColor.clearColor().CGColor
                button.titleLabel?.textColor = UIColor.blackColor()
            }
        }
    }
   
    @IBAction func deleteFeed(sender: AnyObject) {
        commentTextView.text = "Deleted"
        feed.comment = "Deleted"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "deleteFeed" {
            if let listViewController = segue.destinationViewController as? ViewController {
                listViewController.client = self.client
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
