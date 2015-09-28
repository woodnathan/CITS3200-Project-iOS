//
//  ListViewController.swift
//  HHLRG
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit


var feeds = [(String,String)]()


class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var feedsTable: UITableView!
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return feeds.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell") as UITableViewCell!
        
        
            let (feedStartDate, feedStartTime) = feeds[indexPath.row]
            cell.textLabel?.text = feedStartDate
            cell.detailTextLabel?.text = feedStartTime
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                
        
       return "Feeds"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("feeds") != nil) {
            
            feeds = NSUserDefaults.standardUserDefaults().objectForKey("feeds") as! [(String, String)]
        
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     
   
    
    
    
}
