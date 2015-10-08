//
//  DetailViewController.swift
//  HHLRG
//
//  Created by truicong on 9/09/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var client: Client!
    var feed = Feed()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editFeed" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let entryViewController = navController.topViewController as? EntryViewController {
                    entryViewController.client = self.client
                    entryViewController.feed = self.feed
                }
            }
        }
    }
    
    @IBOutlet var startDateTextField: UITextField!
    
    @IBOutlet var endDateTextField: UITextField!
    
    @IBOutlet var startTimeTextField: UITextField!
    
    @IBOutlet var endTimeTextField: UITextField!
    
    @IBOutlet var weightBefore: UITextField!
    
    @IBOutlet var weightAfter: UITextField!
    
    @IBOutlet var textFieldCollection: [UITextField]!
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBOutlet var commentTextView: UITextView!
    
    @IBOutlet var sideOrSubtypeLabel: UILabel!
    
    @IBOutlet var typeLabel: UILabel!
    
    private let dateFormatter = NSDateFormatter()
    private let timeFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateFormatter.dateStyle = .ShortStyle
        timeFormatter.timeStyle = .ShortStyle
        
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
        typeLabel.text = String(feed.type)
        
        if let side = feed.side {
            sideOrSubtypeLabel.text = String(side)
        } else if let subtype = feed.subtype {
            sideOrSubtypeLabel.text = String(subtype)
        }
        
        
        for textFields in textFieldCollection{
            
            textFields.userInteractionEnabled = false
            
            let bottomBorder = CALayer()
            
            bottomBorder.frame = CGRectMake(0.0, textFields.frame.size.height - 1, textFields.frame.size.width, 1.0)
            
            bottomBorder.backgroundColor = borderColor.CGColor
                
            textFields.layer.addSublayer(bottomBorder)
            
        }
        
        for buttons in buttonCollection {
//            
//            buttons.layer.borderColor = borderColor.CGColor
//            
//            buttons.layer.borderWidth = 2.0
//            
//            buttons.titleLabel?.adjustsFontSizeToFitWidth = true
//            
            buttons.hidden = true
//
        }
        
        commentTextView.userInteractionEnabled = false
    }
}
