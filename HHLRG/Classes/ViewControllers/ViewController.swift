//
//  ViewController.swift
//  HHLRG
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var client: Client!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var hhlrgLabel: UILabel!
    
    @IBOutlet var usernameTextField: UITextField!
   
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 15
        
        usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);

        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
    }
    
    @IBAction func login(sender: UIButton) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        client.credential = Credential(username: username, password: password)
        
        client.fetchUserInfo { (userInfo, error) -> Void in
            if error != nil {
                let alert = UIAlertController(title: "Login Error",
                                              message: error!.localizedDescription,
                                              preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else if userInfo?.collectingSamples == false {
                // Should probably do something when userInfo.collectingSamples is false
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    

}

