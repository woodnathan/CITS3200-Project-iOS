
//  EntryViewController.swift
//  HHLRG
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit
import JGProgressHUD

let borderColor = UIColor(red: 141/255, green: 217/255, blue: 179/255, alpha: 1)

protocol EntryViewControllerDelegate: class {
    func didCreateOrUpdateFeed(entryViewController: EntryViewController, feed: Feed)
    func didDeleteFeed(entryViewController: EntryViewController, feed: Feed)
}

class EntryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    weak var delegate: EntryViewControllerDelegate?
    
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
    @IBOutlet var contentView: UIView!
    @IBOutlet var commentTextView: UITextView!
    
    private let dateFormatter = NSDateFormatter()
    private let timeFormatter = NSDateFormatter()
    
    @IBOutlet var breastOrSupButtons: [UIButton]!
    @IBOutlet var typeButtons: [UIButton]!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBOutlet weak var scrollViewBottomLayoutConstaint: NSLayoutConstraint!
    
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
    func handleDatePicker(sender:UIDatePicker) {
        let date = sender.date
        
        let isBefore = (selectedTextField == startDateTextField || selectedTextField == startTimeTextField)
        let isDateField = (selectedTextField == startDateTextField || selectedTextField == endDateTextField)
        
        let dateUnitFlags: NSCalendarUnit = [ .Year, .Month, .Day ]
        let timeUnitFlags: NSCalendarUnit = [ .Hour, .Minute ]
        
        let calendar = NSCalendar.currentCalendar()
        
        let feedDate = isBefore ? feed.before.date : feed.after.date
        let components = feedDate != nil ? calendar.components(dateUnitFlags.union(timeUnitFlags), fromDate: feedDate!) : NSDateComponents()
        
        if isDateField {
            selectedTextField.text = dateFormatter.stringFromDate(date)
            
            let newComponents = calendar.components(dateUnitFlags, fromDate: date)
            components.year = newComponents.year
            components.month = newComponents.month
            components.day = newComponents.day
        } else {
            selectedTextField.text = timeFormatter.stringFromDate(date)
            
            let newComponents = calendar.components(timeUnitFlags, fromDate: date)
            components.hour = newComponents.hour
            components.minute = newComponents.minute
        }
        
        if let newDate = calendar.dateFromComponents(components) {
            if isBefore {
                feed.before.date = newDate
            } else {
                feed.after.date = newDate
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        expressedSupButton.hidden = true
        formulaSupButton.hidden = true
        
        if let type = feed.type {
            switch type {
            case .Breastfeed:
                typeButtonSelected(breastfeedTypeButton)
                break;
            case .Expression:
                typeButtonSelected(expressedButton)
                break;
            case .Supplementary:
                typeButtonSelected(supplementaryButton)
                break;
            }
        }
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        if let date = feed.before.date {
            startDateTextField.text = dateFormatter.stringFromDate(date)
            startTimeTextField.text = timeFormatter.stringFromDate(date)
        }
        if let date = feed.after.date {
            endDateTextField.text = dateFormatter.stringFromDate(date)
            endTimeTextField.text = timeFormatter.stringFromDate(date)
        }
        
        if let weight = feed.before.weight {
            weightBefore.text = String(weight)
        }
        if let weight = feed.after.weight {
            weightAfter.text = String(weight)
        }
        
//        for textField in textFieldCollection {
            
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
        
        deleteButton.layer.backgroundColor = borderColor.CGColor
        deleteButton.hidden = feed.new
        
        registerForKeyboardNotifications()
    }
    
    deinit {
        unregisterFromKeyboardNotifications()
    }
    
    
    
    
    let selectedColor = UIColor(red: 49/255, green: 91/255, blue: 131/255, alpha: 1)
    
    //Breastfeed, Expression or Supplementary button selected
    @IBAction func typeButtonSelected(sender: UIButton) {
        
        for button in typeButtons {
            
            if button == sender {
                button.selected = true
                button.layer.backgroundColor = selectedColor.CGColor
                button.titleLabel?.textColor = UIColor.whiteColor()
                
                switch button {
                case breastfeedTypeButton:
                    feed.type = Feed.FeedType.Breastfeed
                    break
                case expressedButton:
                    feed.type = Feed.FeedType.Expression
                    break
                case supplementaryButton:
                    feed.type = Feed.FeedType.Supplementary
                    break
                default:
                    break
                }
                
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
            if button == sender {
                button.selected = true
                button.layer.backgroundColor = selectedColor.CGColor
                button.titleLabel?.textColor = UIColor.whiteColor()
                
                switch button {
                case leftUsedButton:
                    feed.side = Feed.Side.Left
                    break
                case rightUsedButton:
                    feed.side = Feed.Side.Right
                    break
                case expressedSupButton:
                    feed.subtype = Feed.Subtype.Expressed
                    break
                case formulaSupButton:
                    feed.subtype = Feed.Subtype.Formula
                    break
                default:
                    break
                }
                
                
            } else {
                
                button.selected = false
                button.layer.backgroundColor = UIColor.clearColor().CGColor
                button.titleLabel?.textColor = UIColor.blackColor()
            }
        }
    }
    
    @IBAction func beforeWeightChanged(sender: AnyObject?) {
        if let weight = weightBefore.text {
            feed.before.weight = Int(weight)
        }
    }
    @IBAction func afterWeightChanged(sender: AnyObject?) {
        if let weight = weightAfter.text {
            feed.after.weight = Int(weight)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        feed.comment = String(commentTextView.text)
    }

   
    @IBAction func deleteFeed(sender: AnyObject) {
        
        let confirm = UIAlertController(title: nil, message: "Are you sure you want to delete this feed?", preferredStyle: .ActionSheet)
        confirm.addAction(UIAlertAction(title: "Delete Feed", style: .Destructive, handler: { (action) -> Void in
            self.feed.comment = "delete"
            
            self.client.updateFeed(self.feed) { (feeds, error) -> Void in
                if error == nil {
                    self.delegate?.didDeleteFeed(self, feed: self.feed)
                    confirm.dismissViewControllerAnimated(true, completion: nil)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }))
        
        confirm.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(confirm, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "deleteFeed" {
            if let listViewController = segue.destinationViewController as? ViewController {
                listViewController.client = self.client
            }
        }
    }
    
    @IBAction func doneAction(sender: AnyObject?) {
        self.view.endEditing(false)
        
        let createOrUpdate = {
            let hud = JGProgressHUD(style: .Dark)
            hud.textLabel.text = "Loading"
            hud.showInView(self.view)
            
            self.client.createOrUpdateFeed(self.feed) { (feeds, error) -> Void in
                hud.dismissAnimated(true)
                
                if let e = error {
                    let alert = UIAlertController(title: "Error",
                        message: e.localizedDescription,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.delegate?.didCreateOrUpdateFeed(self, feed: self.feed)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
        if let validationError = client.validateFeed(feed) {
            let alert = UIAlertController(title: nil,
                message: validationError.message,
                preferredStyle: UIAlertControllerStyle.Alert)
            
            switch validationError.level {
            case .Error:
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                break
            case .Warning:
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    createOrUpdate()
                }))
                break
            }
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            createOrUpdate()
        }
    }
    
  
    //toggle keyboard

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let textFieldFrame = contentView.convertRect(textField.frame, toView: scroller)
        scroller.scrollRectToVisible(textFieldFrame, animated: true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        let textViewFrame = contentView.convertRect(textView.frame, toView: scroller)
        scroller.scrollRectToVisible(textViewFrame, animated: true)
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChangeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    
    func unregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func cancelAction(sender: AnyObject?)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let frameInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue, durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                let keyboardFrame = self.view.convertRect(frameInfo.CGRectValue(), fromView: nil)
                let duration = durationValue.doubleValue as NSTimeInterval
                
                let keyboardHeight = CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(keyboardFrame)
                
                self.scrollViewBottomLayoutConstaint.constant = (keyboardFrame.origin.y < 0.0) ? 0.0 : keyboardHeight
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
}
