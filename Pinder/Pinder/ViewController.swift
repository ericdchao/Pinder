//
//  ViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/3/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import UIKit
import Firebase

var curUser = ""

var ref: FIRDatabaseReference! = FIRDatabase.database().reference()

class ViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBAction func registerClicked(_ sender: Any) {
        if let username = usernameField.text {
            if let password = passwordField.text {
                saveNewUser(username: username, password: password)
                curUser = username
                self.performSegue(withIdentifier: "registerSeg", sender: nil)
            }
            
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

