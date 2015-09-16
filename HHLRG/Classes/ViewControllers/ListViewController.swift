//
//  ListViewController.swift
//  breastfeeding3
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    let am = [
        ("1st feed", "info for 1st feed"),
        ("2nd feed","info for 2nd feed"),
        ("3rd feed","info for 3rd feed")
    ]
    
    let pm = [
        ("5th feed", "feed info 5"),
        ("6th feed","feed info 6"),
        ("7th feed","feed info 7")
    ]
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if section == 0 {
            return am.count
        }
        else {
            return pm.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCellWithIdentifier("feedCell") as! UITableViewCell
        
        if indexPath.section == 0 {
            var (amfeedindex, amfeedinfo) = am[indexPath.row]
            cell.textLabel?.text = amfeedindex
            cell.detailTextLabel?.text = amfeedinfo
            
        }else{
            
            var (pmfeedindex, pmfeedinfo) = pm[indexPath.row]
            cell.textLabel?.text = pmfeedindex
            cell.detailTextLabel?.text = pmfeedinfo
            
        }
        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                
        
        if section == 0 {
        
            return "Morning feeds"
            
        }
        else {
            
            return "Afternoon feeds"
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    
    
}
