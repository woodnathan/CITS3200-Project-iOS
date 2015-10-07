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
        cell.textLabel?.text = dateFormatter.stringFromDate(feed.before.date!)
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(feed.after.date!)
        
        return cell
        
    }
    
    private func restoreCredential() {
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String
        let password = NSUserDefaults.standardUserDefaults().objectForKey("password") as? String // Place in Keychain
        if let u = username, p = password {
            client.credential = Credential(username: u, password: p)
        }
    }
    private func saveCredential() {
        if let username = client.credential?.username, password = client.credential?.password {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(username, forKey: "username")
            defaults.setObject(password, forKey: "password") // Place in Keychain
            defaults.synchronize()
        }
    }
    private func deleteCredential() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("username")
        defaults.removeObjectForKey("password")
        
        client.credential = nil
        
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
    
    @IBAction func logout(sender: AnyObject?) {
        deleteCredential()
        
        feeds = []
        feedsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .ShortStyle;
        dateFormatter.timeStyle = .ShortStyle;
        
        restoreCredential()
        dispatch_async(dispatch_get_main_queue(), {
            if self.client.credential == nil {
                self.performSegueWithIdentifier("showLogin", sender: self)
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if client.credential != nil {
            saveCredential()
            
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLogin" {
            if let loginViewController = segue.destinationViewController as? ViewController {
                loginViewController.client = self.client
            }
        } else if segue.identifier == "showDetail" {
            if let detailViewController = segue.destinationViewController as? DetailViewController {
                detailViewController.client = self.client
                detailViewController.feed = self.feeds[self.feedsTable.indexPathForSelectedRow!.row]
            }
        } else if segue.identifier == "addFeed" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let entryViewController = navController.topViewController as? EntryViewController {
                    entryViewController.client = self.client
                }
            }
        }
    }
    
     
   
    
    
    
}