//
//  EntryViewController.swift
//  HHLRG
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    
    var client: Client!
    var feed = Feed()
    
    
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
    
    private let dateFormatter = NSDateFormatter()
    private let timeFormatter = NSDateFormatter()
    
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
        
        dateFormatter.dateStyle = .ShortStyle;
        dateFormatter.timeStyle = .NoStyle;
        timeFormatter.dateStyle = .NoStyle;
        timeFormatter.timeStyle = .ShortStyle;
        
        let borderColor = UIColor(red: 141/255, green: 217/255, blue: 179/255, alpha: 1)
        
        expressedSupButton.hidden = true
        expressedSupButton.enabled = false
        
        formulaSupButton.hidden = true
        formulaSupButton.enabled = false
        
        if let date = feed.before.date {
            startDateTextField.text = dateFormatter.stringFromDate(date)
            startTimeTextField.text = timeFormatter.stringFromDate(date)
        }
        if let date = feed.after.date {
            endDateTextField.text = dateFormatter.stringFromDate(date)
            endTimeTextField.text = timeFormatter.stringFromDate(date)
        }
        

        for subviews in self.view.subviews {
            
            if let scrollview = subviews as? UIScrollView {
                
                for contentViews in scrollview.subviews {
                
                    for content in contentViews.subviews {
                    
                        if let textField = content as? UITextField{
                            
                            
                            textField.layer.borderColor = borderColor.CGColor
                            
                            textField.layer.borderWidth = 2.0
                            
                            textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
                            
                            textField.adjustsFontSizeToFitWidth = true
                            
                        }
                            
                        else if let textview = content as? UITextView {
                            
                            textview.layer.borderColor = borderColor.CGColor
                            
                            textview.layer.borderWidth = 2.0
                            
                            
                            //textview.layer
                            
                        }
                        // change button border color
                        else if let button = content as? UIButton {
                            
                            button.layer.borderColor = borderColor.CGColor
                            
                            button.layer.borderWidth = 2.0
                            
                            button.titleLabel?.adjustsFontSizeToFitWidth = true
                        
                        }
                        
                    }
                }
                
            }
            
        }
              
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        
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
    
    @IBAction
    func cancelAction(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
}
