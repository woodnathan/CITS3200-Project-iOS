//
//  DetailViewController.swift
//  HHLRG
//
//  Created by truicong on 9/09/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, EntryViewControllerDelegate {
    
    var client: Client!
    var feed = Feed()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editFeed" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let entryViewController = navController.topViewController as? EntryViewController {
                    entryViewController.delegate = self
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
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var sideOrSubtypeLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var breastOrSupTextLabel: UILabel!
    
    private let dateFormatter = NSDateFormatter()
    private let timeFormatter = NSDateFormatter()
    
    func updateFields() {
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
        
        commentTextView.text = feed.comment
        typeLabel.text = String(feed.type)
        
        if let side = feed.side {
            sideOrSubtypeLabel.text = String(side)
        } else if let subtype = feed.subtype {
            breastOrSupTextLabel.text = "Supplementary Type"
            sideOrSubtypeLabel.text = String(subtype)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .MediumStyle
        timeFormatter.timeStyle = .ShortStyle
        
        updateFields()
        
        
        for textFields in textFieldCollection{
            
            textFields.userInteractionEnabled = false
            
            let bottomBorder = CALayer()
            
            bottomBorder.frame = CGRectMake(0.0, textFields.frame.size.height - 1, textFields.frame.size.width, 1.0)
            
            bottomBorder.backgroundColor = borderColor.CGColor
                
            textFields.layer.addSublayer(bottomBorder)
            
        }
        
        commentTextView.userInteractionEnabled = false
    }
    
    func didDeleteFeed(entryViewController: EntryViewController, feed: Feed) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didCreateOrUpdateFeed(entryViewController: EntryViewController, feed: Feed) {
        self.feed = feed
        updateFields()
    }
}
