//
//  ListViewController.swift
//  HHLRG
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit
import JGProgressHUD


//var feeds = [(String,String)]()


class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LoginViewControllerDelegate {
    
    private let client = Client(baseURL: Client.ProductionBaseURL)
    private let fullDateFormatter: NSDateFormatter = NSDateFormatter()
    private let dateFormatter: NSDateFormatter = NSDateFormatter()
    private let timeFormatter: NSDateFormatter = NSDateFormatter()
    
    
    @IBOutlet var feedsTable: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return client.feeds.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell") as UITableViewCell!
        
        let feed = client.feeds[indexPath.row]
        
        if let beforeDate = feed.before.date, afterDate = feed.after.date {
            let calendar = NSCalendar.currentCalendar()
            calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
            
            let beforeComps = calendar.components([ .Year, .Month, .Day ], fromDate: beforeDate)
            let afterComps = calendar.components([ .Year, .Month, .Day ], fromDate: afterDate)
            
            // Is the dates are different days (ie. crossover midnight)
            if beforeComps.isEqual(afterComps) {
                let dateString = dateFormatter.stringFromDate(beforeDate)
                let beforeTime = timeFormatter.stringFromDate(beforeDate)
                let afterTime = timeFormatter.stringFromDate(afterDate)
                
                cell.textLabel?.text = "\(beforeTime) - \(afterTime)"
                cell.detailTextLabel?.text = dateString
            } else {
                cell.textLabel?.text = fullDateFormatter.stringFromDate(beforeDate)
                cell.detailTextLabel?.text = fullDateFormatter.stringFromDate(afterDate)
            }
        }
        
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
        
        feedsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullDateFormatter.dateStyle = .MediumStyle;
        fullDateFormatter.timeStyle = .ShortStyle;
        dateFormatter.dateStyle = .MediumStyle;
        dateFormatter.timeStyle = .NoStyle;
        timeFormatter.dateStyle = .NoStyle;
        timeFormatter.timeStyle = .ShortStyle;
        
        restoreCredential()
        dispatch_async(dispatch_get_main_queue(), {
            if self.client.credential == nil {
                self.performSegueWithIdentifier("showLogin", sender: self)
            } else {
                self.reload()
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.feedsTable.reloadData()
    }
    
    private func reload() {
        let hud = JGProgressHUD(style: .Dark)
        hud.textLabel.text = "Loading"
        hud.showInView(self.view)
        
        client.fetchFeeds({ (feeds, error) -> Void in
            hud.dismissAnimated(true)
            
            if let e = error {
                let alert = UIAlertController(title: "Error Fetching Feeds",
                    message: e.localizedDescription,
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.feedsTable.reloadData()
            }
        })
    }
    
    func didLogin(viewController: ViewController) {
        if client.credential != nil {
            saveCredential()
            
            reload()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLogin" {
            if let loginViewController = segue.destinationViewController as? ViewController {
                loginViewController.delegate = self
                loginViewController.client = self.client
            }
        } else if segue.identifier == "showDetail" {
            if let detailViewController = segue.destinationViewController as? DetailViewController {
                detailViewController.client = self.client
                detailViewController.feed = client.feeds[self.feedsTable.indexPathForSelectedRow!.row]
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
