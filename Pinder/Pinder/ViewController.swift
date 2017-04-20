//
//  ViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/3/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

//font help from http://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/

import UIKit
import Firebase

var curUser = ""
var curPass = ""
var userType = ""
var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
let storage = FIRStorage.storage()
let storageRef = storage.reference()
class ViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBAction func registerClicked(_ sender: Any) {
       curUser = usernameField.text!
        curPass =  passwordField.text!
        self.performSegue(withIdentifier: "registerSeg", sender: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
       // curUser = username
        print("1 ========")
        var userField = usernameField.text ?? "blank"
        var passField = passwordField.text ?? "blank"
        let userTypeTemp = login(username: userField, password: passField)
        print("2 ========")
        print(userTypeTemp)
        if userTypeTemp != userPassDoesNotExist {
            print("2.5 ========")
            curUser = usernameField.text ?? " "
            if userTypeTemp == isPet{
                userType = "pets"
            } else {
                userType = "users"
            }
            print("3 ========")
            //self.performSegue(withIdentifier: "login", sender: nil)
            print("4 ========")
        }
       print("User Login Failed")
    }

    
    override func viewDidLoad() {
        
        //might need to check font names

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class Register1VC: ViewController {
    @IBAction func humanReg(_ sender: Any) {
        saveNewPet(username: curUser, password: curPass)
        userType = "pets"            
        performSegue(withIdentifier: "regToEdit", sender: "human")
    }
    @IBAction func petReg(_ sender: Any) {
        saveNewUser(username: curUser, password: curPass)
        userType = "users"
        performSegue(withIdentifier: "regToEdit", sender: "pet")
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

