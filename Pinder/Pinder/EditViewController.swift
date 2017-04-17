//
//  EditViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/17/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import UIKit
import Firebase


class EditViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var interestsField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var timesField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    @IBAction func pictureButton(_ sender: Any) {
        
    }
    @IBAction func saveButton(_ sender: Any) {
        
        
        var dic : Dictionary<String, userProfileElement> = [:]
        
        dic["name"] = nameField.text!
        dic["age"] = ageField.text!
        dic["email"] = emailField.text!
        dic["password"] = passwordField.text!
        dic["interests"] = interestsField.text!
        dic["location"] = locationField.text!
        dic["times"] = timesField.text!
        dic["phone"] = phoneField.text!
        
        
        changeUserProfile(username: curUser, userType: userType, dictionary: dic)
        if passwordField.text! != "" {
           changePassword(oldPassword: curPass, newPassword: passwordField.text!, userType: userType)
        }
        
        if nameField.text != "" {
            changeUserName(oldUsername: curUser, newUsername: nameField.text!, userType: userType)
        }
        performSegue(withIdentifier: "editToMatch", sender: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "editToMatch", sender: nil)
    }
    
    override func viewDidLoad() {
        var prof = retrieveUserProfile(username: curUser, userType: userType)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
