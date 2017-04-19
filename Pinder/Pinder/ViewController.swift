//
//  ViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/3/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

//font help from http://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/
//dismiss keyboard with tap http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift

import UIKit
import Firebase

var curUser = ""
var curPass = ""
var userType = ""
var ref: FIRDatabaseReference! = FIRDatabase.database().reference()

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
        
        let userTypeTemp = login(username: usernameField.text!, password: passwordField.text!)
        if userTypeTemp != 0 {
            curUser = usernameField.text!
            if userTypeTemp == isPet{
                userType = "pets"
            } else {
                userType = "users"
            }
             self.performSegue(withIdentifier: "login", sender: nil)
        }
       
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        //might need to check font names

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
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

