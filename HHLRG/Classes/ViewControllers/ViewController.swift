//
//  ViewController.swift
//  breastfeeding3
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let client = Client(baseURL: Client.DevelopmentBaseURL)
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var hhlrgLabel: UILabel!
    
    @IBOutlet var usernameTextField: UITextField!
   
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 15
        
        usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);

        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        
        client.credential = Credential(username: "p028", password: "studen")
        client.fetchUserInfo { (userInfo, error) -> Void in
            print(userInfo, error)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

