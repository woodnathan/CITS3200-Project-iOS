//
//  ListViewController.swift
//  HHLRG
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit


//var feeds = [(String,String)]()


class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private let client = Client(baseURL: Client.DevelopmentBaseURL)
    private var feeds: [Feed] = []
    private let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    
    @IBOutlet var feedsTable: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return feeds.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell") as UITableViewCell!
        
        let feed = feeds[indexPath.row]
        cell.textLabel?.text = dateFormatter.stringFromDate(feed.before.date)
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(feed.after.date)
        
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .ShortStyle;
        dateFormatter.timeStyle = .ShortStyle;
        
        dispatch_async(dispatch_get_main_queue(), {
            if self.client.credential == nil {
                self.performSegueWithIdentifier("showLogin", sender: self)
            }
        })
        
//        if (NSUserDefaults.standardUserDefaults().objectForKey("feeds") != nil) {
//            
//            feeds = NSUserDefaults.standardUserDefaults().objectForKey("feeds") as! [(String, String)]
//        
//        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if client.credential != nil {
            client.fetchFeeds({ (feeds, error) -> Void in
                if let f = feeds {
                    self.feeds = f
                    self.feedsTable.reloadData()
                } else if let e = error {
                    let alert = UIAlertController(title: "Error Fetching Feeds",
                        message: e.localizedDescription,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLogin" {
            if let loginViewController = segue.destinationViewController as? ViewController {
                loginViewController.client = self.client
            }
        }
    }
    
     
   
    
    
    
}
