//
//  ViewController.swift
//  HHLRG
//
//  Created by truicong on 19/08/2015.
//  Copyright (c) 2015 truicong. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginViewControllerDelegate: class {
    func didLogin(viewController: ViewController)
}

class ViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    
    var client: Client!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var hhlrgLabel: UILabel!
    
    @IBOutlet var usernameTextField: UITextField!
   
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var closeAboutButton: UIButton!
    
    @IBOutlet var aboutView: UIView!
    
    @IBAction func closeAbout(sender: AnyObject) {
        aboutView.hidden = true
        closeAboutButton.hidden = true
    }
    
    
    @IBAction func showAbout(sender: AnyObject) {
        aboutView.hidden = false
        closeAboutButton.hidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutView.hidden = true
        closeAboutButton.hidden = true
        
        loginButton.layer.cornerRadius = 15
        
        usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);

        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
    }
    
    @IBAction func login(sender: UIButton) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        client.credential = Credential(username: username, password: password)
        
        let hud = JGProgressHUD(style: .Dark)
        hud.textLabel.text = "Loading"
        hud.showInView(self.view)
        
        client.fetchUserInfo { (userInfo, error) -> Void in
            hud.dismissAnimated(true)
            
            if error != nil {
                let alert = UIAlertController(title: "Login Error",
                                              message: error!.localizedDescription,
                                              preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            //} else if userInfo?.collectingSamples == false {
            //    // Should probably do something when userInfo.collectingSamples is false
            ///    self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.delegate?.didLogin(self)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
    //toggle keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func  keyboardWasShown(notification: NSNotification)
    {
        
        print("Keyboard was shown")
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        print("Keyboard hidden")
    }
    

    

}

