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
}
